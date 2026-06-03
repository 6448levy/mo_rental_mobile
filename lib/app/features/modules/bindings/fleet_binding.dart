import 'package:get/get.dart';
import '../../data/services/fleet_service.dart';
import '../../data/services/branch_service.dart';
import '../car_listing/controllers/fleet_controller.dart';

class FleetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FleetService>(() => FleetService());
    Get.lazyPut<BranchService>(() => BranchService());
    Get.lazyPut<FleetController>(() => FleetController());
  }
}
