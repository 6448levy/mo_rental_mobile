.// tool/api_smoke_test.dart
//
// On-demand integration smoke probe against a LIVE backend. Not part of the
// `flutter test` suite (which stays offline/fast). Run manually:
//
//   dart run tool/api_smoke_test.dart                 # dev backend (default)
//   dart run tool/api_smoke_test.dart https://my-api  # override base URL
//
// It classifies each endpoint:
//   OK        2xx success
//   WIRED     401/403 (auth-protected, reachable) or 400/422 (validates input)
//   MISSING   404  — endpoint not found
//   SERVER    5xx  — backend error
//   DOWN      timeout / connection failure
//
// Note: register creates a real user on the target backend. verify-email and
// any token-gated flow can't fully complete here because the OTP is delivered
// by email — those are probed for reachability only.
import 'dart:convert';
import 'dart:io';

import 'package:carrental/app/core/config/app_config.dart';
import 'package:http/http.dart' as http;

late final String baseUrl;
const timeout = Duration(seconds: 20);
final results = <List<String>>[];

Future<void> main(List<String> args) async {
  baseUrl = args.isNotEmpty ? args.first : AppConfig.baseUrl;
  stdout.writeln('🔎 API smoke probe -> $baseUrl\n');

  final stamp = DateTime.now().millisecondsSinceEpoch;
  final email = 'smoketest.$stamp@example.com';
  final phone = '07${stamp.toString().substring(5)}';
  const password = 'SmokeTest123!';

  // ---- Public / unauthenticated ----
  await probe('GET', '/api/v1/driver-profiles/public');
  await probe('GET', '/api/v1/promo-codes/active');
  await probe('GET', '/api/v1/rate-plans');

  // ---- Auth-protected (no token => expect 401/403) ----
  await probe('GET', '/api/v1/driver-bookings/me', expectProtected: true);
  await probe('GET', '/api/v1/driver-profiles/me', expectProtected: true);

  // ---- Auth flow ----
  await probe('POST', '/api/v1/users/register', body: {
    'full_name': 'Smoke Test',
    'email': email,
    'phone': phone,
    'password': password,
  });
  await probe('POST', '/api/v1/users/login',
      body: {'email': email, 'password': password});
  await probe('POST', '/api/v1/users/verify-email',
      body: {'email': email, 'otp': '000000'});

  _printReport();
}

Future<void> probe(
  String method,
  String path, {
  Map<String, dynamic>? body,
  bool expectProtected = false,
}) async {
  final uri = Uri.parse('$baseUrl$path');
  const headers = {'Content-Type': 'application/json', 'Accept': 'application/json'};
  try {
    final http.Response res;
    if (method == 'GET') {
      res = await http.get(uri, headers: headers).timeout(timeout);
    } else {
      res = await http
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(timeout);
    }
    results.add([method, path, '${res.statusCode}', _verdict(res.statusCode, expectProtected)]);
  } on SocketException {
    results.add([method, path, '-', 'DOWN (no connection)']);
  } on HttpException {
    results.add([method, path, '-', 'DOWN (http error)']);
  } catch (e) {
    final msg = e.toString().contains('Timeout') ? 'DOWN (timeout)' : 'ERROR ($e)';
    results.add([method, path, '-', msg]);
  }
}

String _verdict(int code, bool expectProtected) {
  if (code >= 200 && code < 300) return 'OK';
  if (code == 401 || code == 403) {
    return expectProtected ? 'WIRED (auth-protected ✅)' : 'WIRED (needs token)';
  }
  if (code == 400 || code == 422) return 'WIRED (validates input)';
  if (code == 404) return 'MISSING ❌';
  if (code >= 500) return 'SERVER ERROR ❌';
  return 'UNEXPECTED';
}

void _printReport() {
  stdout.writeln('\n${'METHOD'.padRight(7)}${'ENDPOINT'.padRight(38)}${'CODE'.padRight(6)}VERDICT');
  stdout.writeln('-' * 78);
  for (final r in results) {
    stdout.writeln('${r[0].padRight(7)}${r[1].padRight(38)}${r[2].padRight(6)}${r[3]}');
  }
  final ok = results.where((r) => r[3].startsWith('OK') || r[3].startsWith('WIRED')).length;
  stdout.writeln('-' * 78);
  stdout.writeln('$ok/${results.length} endpoints reachable & behaving as expected.');
  stdout.writeln('\nNOT covered (need a verified account / real OTP via email):');
  stdout.writeln('  • full login -> token, POST /bookings, GET /bookings, driver-profiles/me with auth');
}
