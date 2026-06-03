import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/themes/app_palette.dart';
import '../controllers/fleet_controller.dart';
import '../../car_details/views/car_detail_screen.dart';

class CarListingScreen extends StatelessWidget {
  const CarListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FleetController controller = Get.find<FleetController>();

    return Scaffold(
      backgroundColor: AppPalette.pureWhite,
      appBar: AppBar(
        title: const Text("Available Cars"),
        backgroundColor: AppPalette.brandBlue,
        foregroundColor: AppPalette.pureWhite,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.fetchAllData(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.vehicleModels.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty && controller.vehicleModels.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(controller.errorMessage.value),
                TextButton(
                  onPressed: () => controller.fetchAllData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.vehicleModels.isEmpty) {
          return const Center(child: Text('No car models available.'));
        }

        return RefreshIndicator(
          onRefresh: () async => controller.fetchAllData(),
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: controller.vehicleModels.length,
            itemBuilder: (context, index) {
              final model = controller.vehicleModels[index];
              return carTile(
                context,
                model.imageUrl,
                model.fullName,
                '${model.currency} ${model.dailyRate}/day',
                model,
              );
            },
          ),
        );
      }),
    );
  }

  Widget carTile(BuildContext context, String img, String name, String price, dynamic model) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPalette.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 80,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppPalette.outline.withValues(alpha: 0.3),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: img.startsWith('http')
                ? Image.network(
                    img,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.directions_car_rounded, color: AppPalette.textDisabled),
                  )
                : Image.asset(
                    img,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.directions_car_rounded, color: AppPalette.textDisabled),
                  ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: AppPalette.textPrimary, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            price,
            style: const TextStyle(
                color: AppPalette.brandBlue, fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded,
            size: 16, color: AppPalette.textDisabled),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CarDetailsScreen(model: model),
            ),
          );
        },
      ),
    );
  }
}
