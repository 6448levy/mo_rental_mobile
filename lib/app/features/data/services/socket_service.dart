import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:carrental/app/core/constants/api_constants.dart';
import 'package:carrental/app/core/utils/logger.dart';

class SocketService extends GetxService {
  late io.Socket _socket;
  final GetStorage _storage = GetStorage();
  final RxBool isConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initSocket();
  }

  void _initSocket() {
    final String token = _storage.read('auth_token') ?? '';

    // Configure the socket but DO NOT connect automatically yet
    _socket = io.io(
      ApiConstants.baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Web
          .disableAutoConnect()
          .setAuth({'token': token}) // Standard socket.io v3+ auth payload
          .setQuery({'token': token}) // Fallback via query string
          .setExtraHeaders({'Authorization': 'Bearer $token'}) // Fallback via headers
          .build(),
    );

    // Setup global listeners
    _socket.onConnect((_) {
      Log.info('🟢 Socket Connected: ${_socket.id}');
      isConnected.value = true;
    });

    _socket.onDisconnect((_) {
      Log.info('🔴 Socket Disconnected');
      isConnected.value = false;
    });

    _socket.onConnectError((err) {
      Log.info('❌ Socket Connection Error: $err');
      isConnected.value = false;
    });

    _socket.onError((err) {
      Log.info('❌ Socket General Error: $err');
    });
  }

  /// Connects to the socket server
  void connect() {
    if (!_socket.connected) {
      Log.info('🔄 Attempting Socket Connection...');
      _socket.connect();
    }
  }

  /// Disconnects from the socket server
  void disconnect() {
    if (_socket.connected) {
      Log.info('🔄 Disconnecting Socket...');
      _socket.disconnect();
    }
  }

  /// Listen to a specific event
  void on(String event, Function(dynamic) handler) {
    _socket.on(event, handler);
  }

  /// Remove listener from a specific event
  void off(String event) {
    _socket.off(event);
  }

  /// Emit data to the server
  void emit(String event, dynamic data) {
    if (_socket.connected) {
      _socket.emit(event, data);
      Log.info('📤 Emitted [$event]: $data');
    } else {
      Log.info('⚠️ Attempted to emit [$event] but socket is not connected');
    }
  }

  @override
  void onClose() {
    disconnect();
    _socket.dispose();
    super.onClose();
  }
}
