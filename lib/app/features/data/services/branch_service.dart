import 'package:get/get.dart';
import '../../../../app/core/utils/logger.dart';
import '../models/auth_models/api_response.dart';
import '../models/fleet/branch_model.dart';
import 'api_service.dart';
import '../../../core/constants/api_constants.dart';

class BranchService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  // ---------------------------------------------------------------------------
  // BRANCHES (/api/v1/branches)
  // ---------------------------------------------------------------------------

  Future<ApiResponse<List<BranchModel>>> getBranches() async {
    Log.info('\n🏢 FETCHING BRANCHES');
    return await _apiService.get<List<BranchModel>>(
      ApiConstants.BRANCHES,
      fromJson: (json) {
        final List<dynamic> data = json is List ? json : (json['data'] ?? []);
        return data.map((e) => BranchModel.fromJson(e)).toList();
      },
    );
  }

  Future<ApiResponse<BranchModel>> getBranchById(String id) async {
    Log.info('\n🏢 FETCHING BRANCH: $id');
    return await _apiService.get<BranchModel>(
      '${ApiConstants.BRANCHES}/$id',
      fromJson: (json) => BranchModel.fromJson(json),
    );
  }
}
