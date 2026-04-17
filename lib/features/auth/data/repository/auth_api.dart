import 'dart:convert';

import 'package:jibon_Bachan_app/core/api_core/api_client.dart';
import 'package:jibon_Bachan_app/features/auth/data/model/register_model.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> register(RegisterRequest data) async {
    return await _apiClient.post(
      '/auth/register',
      body: jsonEncode(data.toJson()),
    );
  }

  Future<dynamic> login(String loginName, String password) async {
    return await _apiClient.post(
      '/auth/login',
      body: jsonEncode({"loginName": loginName, "password": password}),
    );
  }
}
