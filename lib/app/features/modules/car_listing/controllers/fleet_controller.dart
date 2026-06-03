import 'package:get/get.dart';
import '../../../data/models/fleet/vehicle_model.dart' as fleet;
import '../../../data/models/fleet/branch_model.dart';
import '../../../data/services/fleet_service.dart';
import '../../../data/services/branch_service.dart';

class FleetController extends GetxController {
  final FleetService _fleetService = Get.find<FleetService>();
  final BranchService _branchService = Get.find<BranchService>();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Observable lists
  final RxList<fleet.VehicleModel> vehicleModels = <fleet.VehicleModel>[].obs;
  final RxList<fleet.Vehicle> vehicles = <fleet.Vehicle>[].obs;
  final RxList<BranchModel> branches = <BranchModel>[].obs;

  // Selected state
  final Rxn<fleet.VehicleModel> selectedModel = Rxn<fleet.VehicleModel>();
  final Rxn<BranchModel> selectedBranch = Rxn<BranchModel>();

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Parallel fetch
      final results = await Future.wait([
        _fleetService.getVehicleModels(),
        _branchService.getBranches(),
      ]);

      final modelRes = results[0] as dynamic;
      final branchRes = results[1] as dynamic;

      if (modelRes.success) {
        vehicleModels.value = modelRes.data ?? [];
      } else {
        errorMessage.value = modelRes.message;
      }

      if (branchRes.success) {
        branches.value = branchRes.data ?? [];
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchVehiclesByModel(String modelId) async {
    isLoading.value = true;
    try {
      final res = await _fleetService.getVehicles(modelId: modelId);
      if (res.success) {
        vehicles.value = res.data ?? [];
      }
    } finally {
      isLoading.value = false;
    }
  }

  void selectModel(fleet.VehicleModel model) {
    selectedModel.value = model;
    fetchVehiclesByModel(model.id);
  }
}
