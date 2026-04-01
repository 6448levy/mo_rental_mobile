import 'package:flutter/material.dart';
import '../../../../core/themes/app_palette.dart';
import 'package:get/get.dart';
import '../controllers/driver_controller.dart';

class DocumentList extends GetView<DriverController> {
  const DocumentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Documents & Compliance",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppPalette.textPrimary),
        ),
        const SizedBox(height: 16),
        Obx(() => Column(
          children: controller.documents.map((doc) => _buildDocItem(doc)).toList(),
        )),
      ],
    );
  }

  Widget _buildDocItem(Map<String, dynamic> doc) {
    Color statusColor;
    IconData statusIcon;

    switch (doc['status']) {
      case 'Verified':
        statusColor = Colors.green.shade600;
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'Pending':
        statusColor = Colors.orange.shade700;
        statusIcon = Icons.access_time_filled_rounded;
        break;
      case 'Expired':
        statusColor = AppPalette.error;
        statusIcon = Icons.error_rounded;
        break;
      default:
        statusColor = AppPalette.textDisabled;
        statusIcon = Icons.help_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppPalette.outline),
        boxShadow: [
          BoxShadow(
            color: AppPalette.cardShadow.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.description_rounded, color: AppPalette.brandBlue.withOpacity(0.5)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppPalette.textPrimary),
                ),
                if (doc['expiry'] != null)
                  Text(
                    "Exp: ${doc['expiry']}",
                    style: TextStyle(color: AppPalette.textSecondary, fontSize: 12),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 14),
                const SizedBox(width: 4),
                Text(
                  doc['status'],
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (doc['status'] != 'Verified') 
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(Icons.chevron_right_rounded, color: AppPalette.textDisabled),
            ),
        ],
      ),
    );
  }
}
