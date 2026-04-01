import 'package:flutter/material.dart';
import '../../../../core/themes/app_palette.dart';

class MessageInputField extends StatefulWidget {
  final Function(String) onSendMessage;

  const MessageInputField({
    super.key,
    required this.onSendMessage,
  });

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final TextEditingController _controller = TextEditingController();

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 12 + MediaQuery.of(context).padding.bottom, // Account for safe area
      ),
      decoration: const BoxDecoration(
        color: AppPalette.pureWhite,
        border: Border(
          top: BorderSide(
            color: AppPalette.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {
              // Attachment action (mock for now)
            },
            icon: const Icon(Icons.attach_file),
            color: AppPalette.textSecondary,
            splashRadius: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppPalette.brandBlue.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppPalette.outline,
                ),
              ),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: AppPalette.textPrimary),
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _handleSend(),
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: AppPalette.textDisabled),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  // Override theme decor slightly for chat input
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  filled: false,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            margin: const EdgeInsets.only(bottom: 2), // Align visually with text field
            decoration: const BoxDecoration(
              color: AppPalette.brandBlue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _handleSend,
              icon: const Icon(Icons.send),
              color: AppPalette.pureWhite,
              splashRadius: 24,
            ),
          ),
        ],
      ),
    );
  }
}
