import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ta_pa2_pa3_project/core/constants/api_constants.dart';
import 'package:ta_pa2_pa3_project/core/services/auth_session.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/models/kehamilan_aktif_model.dart';

class KehamilanApiService {
  final http.Client _client;

  KehamilanApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<KehamilanAktifModel> getKehamilanAktif() async {
    final token = AuthSession.token;

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.kehamilanAktif}',
    );

    final response = await _client.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 404) {
      throw Exception(body['message'] ?? 'Data kehamilan aktif tidak ditemukan');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal mengambil data kehamilan (${response.statusCode})');
    }

    final data = body['data'] as Map<String, dynamic>;
    return KehamilanAktifModel.fromJson(data);
  }

  void dispose() {
    _client.close();
  }
}