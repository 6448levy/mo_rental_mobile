import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/themes/app_palette.dart';
import '../controllers/chat_controller.dart';
import '../models/message_model.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input_field.dart';

class ChatScreen extends GetView<ChatController> {
  final String driverName;
  final String vehicleInfo;

  const ChatScreen({
    super.key,
    this.driverName = 'Driver Match',
    this.vehicleInfo = 'Available Models',
  });

  Widget _buildTypingIndicator() {
    return Obx(() {
      if (!controller.isTyping.value) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppPalette.brandBlue.withValues(alpha: 0.05),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.pureWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false, // If it's a bottom nav item
        backgroundColor: AppPalette.brandBlue,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              driverName,
              style: const TextStyle(
                color: AppPalette.pureWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              vehicleInfo,
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
            child: Obx(() {
              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final isLast = index == controller.messages.length - 1;
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: isLast && !controller.isTyping.value ? 16.0 : 0.0),
                    child: MessageBubble(
                      message: controller.messages[index],
                    ),
                  );
                },
              );
            }),
          ),
          _buildTypingIndicator(),
          MessageInputField(
            onSendMessage: controller.sendMessage,
            onTyping: controller.emitTypingStatus, // Ensure your MessageInputField accepts this or similar
          ),
        ],
      ),
    );
  }
}
