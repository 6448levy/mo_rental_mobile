import 'package:get/get.dart';
import '../../../data/services/driver_service.dart';
import '../controllers/driver_controller.dart';

class DriverBinding extends Bindings {
  @override
  void dependencies() {
    // Register DriverService if not already registered
    if (!Get.isRegistered<DriverService>()) {
      Get.put<DriverService>(DriverService(), permanent: true);
    }
    Get.lazyPut<DriverController>(
      () => DriverController(),
    );
  }
}
