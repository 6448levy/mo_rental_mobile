// core/utils/crash_reporter.dart
import 'app_logger.dart';

/// Central crash/error sink with a swappable backend.
///
/// Today it routes to [AppLogger]. When a Firebase project is configured
/// (`flutterfire configure` + google-services.json / GoogleService-Info.plist),
/// subclass this and forward to `FirebaseCrashlytics.instance.recordError(...)`,
/// then assign it to [CrashReporter.instance] in main(). No call sites change.
class CrashReporter {
  /// Swap this for a Crashlytics-backed implementation once configured.
  static CrashReporter instance = CrashReporter();

  /// Hook for backend setup (e.g. Crashlytics collection toggle). No-op here.
  Future<void> initialize() async {}

  void recordError(Object error, StackTrace? stack, {bool fatal = false}) {
    AppLogger.e(
      fatal ? 'FATAL uncaught error' : 'Uncaught error',
      error: error,
      stackTrace: stack,
    );
    // TODO(firebase): FirebaseCrashlytics.instance.recordError(error, stack, fatal: fatal);
  }

  void log(String message) => AppLogger.i(message);
}
