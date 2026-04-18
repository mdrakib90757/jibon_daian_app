import 'package:jibon_Bachan_app/core/api_core/api_client.dart';
import 'package:jibon_Bachan_app/core/data/global_model/location_model.dart).dart';

class LocationRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<LocationModel>> getDivisions() async {
    try {
      final response = await _apiClient.get('/locations/divisions');
      if (response != null && response['success'] == true) {
        List data = response['data'];
        return data.map((json) => LocationModel.fromJson(json)).toList();
      }
    } catch (e) {
      print("Error fetching divisions: $e");
    }
    return [];
  }

  Future<List<LocationModel>> getDistricts(int divisionId) async {
    final response = await _apiClient.get('/locations/districts/$divisionId');
    if (response['success'] == true) {
      List data = response['data'];
      return data.map((json) => LocationModel.fromJson(json)).toList();
    }
    return [];
  }
}
