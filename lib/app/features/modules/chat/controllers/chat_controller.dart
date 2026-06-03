import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/message_model.dart';
import '../../../data/services/socket_service.dart';

class ChatController extends GetxController {
  final SocketService _socketService = Get.find<SocketService>();
  
  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final ScrollController scrollController = ScrollController();
  final RxBool isTyping = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Connect to the socket if not already connected
    _socketService.connect();
    
    // Set up listeners
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    // Listen for incoming messages
    _socketService.on('receive_message', (data) {
      if (data != null) {
        final incomingMessage = MessageModel(
          id: data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
          text: data['text'] ?? '',
          isMe: false,
          timestamp: DateTime.now(), // Real app would parse from data['timestamp']
        );
        messages.add(incomingMessage);
        _scrollToBottom();
      }
    });

    // Listen for typing indicator
    _socketService.on('typing', (data) {
      if (data != null && data['isTyping'] != null) {
        isTyping.value = data['isTyping'];
        if (isTyping.value) {
          _scrollToBottom();
        }
      }
    });
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // 1. Create message model
    final newMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isMe: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    // 2. Add to local state immediately (Optimistic UI update)
    messages.add(newMessage);
    _scrollToBottom();

    // 3. Emit via socket
    _socketService.emit('send_message', {
      'text': text,
      'id': newMessage.id,
      'timestamp': newMessage.timestamp.toIso8601String(),
    });
    
    // 4. Also emit that we stopped typing once we send a message
    emitTypingStatus(false);
  }

  void emitTypingStatus(bool typing) {
    _socketService.emit('typing', {'isTyping': typing});
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    // Remove listeners when leaving the chat
    _socketService.off('receive_message');
    _socketService.off('typing');
    
    // Note: We don't disconnect the socket here if it's shared across the app,
    // but if it's only for chat, we could call _socketService.disconnect()
    
    scrollController.dispose();
    super.onClose();
  }
}
