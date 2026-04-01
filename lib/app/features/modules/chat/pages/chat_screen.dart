import 'package:flutter/material.dart';
import '../../../../core/themes/app_palette.dart';
import '../models/message_model.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input_field.dart';

class ChatScreen extends StatefulWidget {
  final String driverName;
  final String vehicleInfo;

  const ChatScreen({
    super.key,
    this.driverName = 'John Doe',
    this.vehicleInfo = 'Toyota Camry',
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<MessageModel> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Load mock initial messages
    _loadMockMessages();
  }

  void _loadMockMessages() {
    final now = DateTime.now();
    _messages.addAll([
      MessageModel(
        id: '1',
        text: 'Hi, where should I pick you up?',
        isMe: false,
        timestamp: now.subtract(const Duration(minutes: 5)),
      ),
      MessageModel(
        id: '2',
        text: "I'm waiting near the hotel entrance.",
        isMe: true,
        timestamp: now.subtract(const Duration(minutes: 4)),
        status: MessageStatus.seen,
      ),
      MessageModel(
        id: '3',
        text: "Okay, I'll arrive in 5 minutes.",
        isMe: false,
        timestamp: now.subtract(const Duration(minutes: 3)),
      ),
    ]);
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final newMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isMe: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    setState(() {
      _messages.add(newMessage);
    });

    _scrollToBottom();

    // Simulate driver typing and replying after a short delay
    _simulateDriverReply();
  }

  void _simulateDriverReply() async {
    setState(() {
      _isTyping = true;
    });

    _scrollToBottom();

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isTyping = false;
      _messages.add(
        MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: 'Got it!',
          isMe: false,
          timestamp: DateTime.now(),
        ),
      );
      // Update the previous message status to seen just to simulate read receipts
      final lastMyMessageIndex = _messages.lastIndexWhere((m) => m.isMe);
      if (lastMyMessageIndex != -1) {
        final lastMsg = _messages[lastMyMessageIndex];
        _messages[lastMyMessageIndex] = MessageModel(
          id: lastMsg.id,
          text: lastMsg.text,
          isMe: lastMsg.isMe,
          timestamp: lastMsg.timestamp,
          status: MessageStatus.seen,
        );
      }
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    // Add a slight delay to ensure the list view has updated its layout before scrolling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildTypingIndicator() {
    if (!_isTyping) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppPalette.brandBlue.withValues(alpha: 0.05), // Light brand blue for typing bubble
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppPalette.outline),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Driver is typing',
                  style: TextStyle(
                    color: AppPalette.textSecondary,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: 8),
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppPalette.brandBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.pureWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppPalette.brandBlue,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.driverName,
              style: const TextStyle(
                color: AppPalette.pureWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.vehicleInfo,
              style: const TextStyle(
                color: AppPalette.brandLightBlue,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: AppPalette.pureWhite),
            onPressed: () {
              // Action to call driver
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final isLast = index == _messages.length - 1;
                return Padding(
                  padding: EdgeInsets.only(bottom: isLast && !_isTyping ? 16.0 : 0.0),
                  child: MessageBubble(
                    message: _messages[index],
                  ),
                );
              },
            ),
          ),
          _buildTypingIndicator(),
          MessageInputField(
            onSendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }
}
