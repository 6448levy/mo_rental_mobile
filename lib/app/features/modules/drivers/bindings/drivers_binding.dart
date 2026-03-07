// lib/app/features/modules/drivers/bindings/drivers_binding.dart
import 'package:get/get.dart';
import '../controllers/drivers_controller.dart';
import '../../../data/services/driver_service.dart';
import '../../../data/services/api_service.dart';

class DriversBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure ApiService is available
    if (!Get.isRegistered<ApiService>()) {
      Get.put<ApiService>(ApiService(), permanent: true);
    }

    // Ensure DriverService is available
    if (!Get.isRegistered<DriverService>()) {
      Get.put<DriverService>(DriverService(), permanent: true);
    }

    // Register DriversController
    Get.lazyPut<DriversController>(
      () => DriversController(driverService: Get.find<DriverService>()),
    );
  }
}
