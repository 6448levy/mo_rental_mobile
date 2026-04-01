import 'package:flutter/material.dart';
import '../../../../core/themes/app_palette.dart';
import '../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildStatusIcon() {
    if (!message.isMe) return const SizedBox.shrink();

    IconData icon;
    Color color;

    switch (message.status) {
      case MessageStatus.sent:
        icon = Icons.check;
        color = Colors.white70; // Since the bubble is now blue
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;
        color = Colors.white70;
        break;
      case MessageStatus.seen:
        icon = Icons.done_all;
        color = AppPalette.brandLightBlue; // Highlighted seen status
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Icon(
        icon,
        size: 14,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // isMe (Customer): Brand Blue background, white text
    // not isMe (Driver): Light brand blue tint background, dark text
    final bubbleColor = message.isMe ? AppPalette.brandBlue : AppPalette.brandBlue.withValues(alpha: 0.06);
    final textColor = message.isMe ? AppPalette.pureWhite : AppPalette.textPrimary;
    final timeColor = message.isMe ? AppPalette.pureWhite.withValues(alpha: 0.7) : AppPalette.textSecondary;
    final borderColor = message.isMe ? Colors.transparent : AppPalette.outline;
    
    // Bubble border radius setup for chat-like appearance
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: message.isMe ? const Radius.circular(16) : const Radius.circular(4),
      bottomRight: message.isMe ? const Radius.circular(4) : const Radius.circular(16),
    );

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: borderRadius,
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: AppPalette.cardShadow.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    color: timeColor,
                    fontSize: 11,
                  ),
                ),
                if (message.isMe) _buildStatusIcon(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
