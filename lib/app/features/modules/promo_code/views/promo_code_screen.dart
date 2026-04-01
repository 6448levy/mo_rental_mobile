import 'package:flutter/material.dart';
import '../../../../core/themes/app_palette.dart';
import 'package:get/get.dart';
import '../controllers/promo_code_controller.dart';

class PromoCodeScreen extends StatelessWidget {
  const PromoCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // SIMPLE FIX: Initialize controller if not already done
    if (!Get.isRegistered<PromoCodeController>()) {
      Get.put(PromoCodeController());
    }
    
    final PromoCodeController controller = Get.find<PromoCodeController>();

    return Scaffold(
      backgroundColor: AppPalette.pureWhite,
      appBar: AppBar(
        title: const Text('Active Promo Codes'),
        backgroundColor: AppPalette.brandBlue,
        foregroundColor: AppPalette.pureWhite,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.fetchActivePromoCodes(printToTerminal: true);
              Get.snackbar(
                'Refreshing',
                'Fetching latest promo codes...',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppPalette.brandBlue,
                colorText: AppPalette.pureWhite,
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppPalette.brandBlue),
          );
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: AppPalette.error),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    controller.error.value,
                    style: const TextStyle(color: AppPalette.error),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: controller.refreshPromoCodes,
                  style: ElevatedButton.styleFrom(backgroundColor: AppPalette.brandBlue),
                  child: const Text('Try Again', style: TextStyle(color: AppPalette.pureWhite)),
                ),
              ],
            ),
          );
        }

        if (controller.activePromoCodes.isEmpty) {
          return const Center(
            child: Text('No active promo codes found', style: TextStyle(color: AppPalette.textSecondary)),
          );
        }

        return ListView.builder(
          itemCount: controller.activePromoCodes.length,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          itemBuilder: (context, index) {
            final promo = controller.activePromoCodes[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppPalette.pureWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppPalette.outline),
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.cardShadow.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: promo.isValid ? Colors.green.shade50 : AppPalette.outline,
                  child: Text(
                    promo.code[0].toUpperCase(),
                    style: TextStyle(
                      color: promo.isValid ? Colors.green.shade700 : AppPalette.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  promo.code,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppPalette.textPrimary),
                ),
                subtitle: Text(
                  '${promo.type} - ${promo.value}',
                  style: const TextStyle(color: AppPalette.textSecondary, fontSize: 13),
                ),
                trailing: promo.isValid 
                    ? Icon(Icons.check_circle_rounded, color: Colors.green.shade600)
                    : const Icon(Icons.close_rounded, color: AppPalette.error),
              ),
            );
          },
        );
      }),
    );
  }
}