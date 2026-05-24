import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:ta_pa2_pa3_project/core/constants/api_constants.dart';
import 'package:ta_pa2_pa3_project/features/anak/informasi_umum/data/models/informasi_umum_model.dart';

class InformasiUmumApiService {
  final http.Client _client;

  InformasiUmumApiService({http.Client? client})
      : _client = client ?? http.Client();

  String _extractErrorMessage(String body, int statusCode) {
    try {
      final dynamic decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final dynamic message = decoded['message'];
        if (message is List && message.isNotEmpty) {
          return message.join(', ');
        }
        if (message is String && message.trim().isNotEmpty) {
          return message;
        }
      }
    } catch (_) {
      // Fall back to a generic error below.
    }
    return 'Request gagal ($statusCode)';
  }

  Future<List<InformasiUmumModel>> listInformasiUmum() async {
    final uri =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.informasiUmum}');
    final response = await _client.get(uri);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_extractErrorMessage(response.body, response.statusCode));
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final dynamic rawData = decoded['data'];

    if (rawData is List) {
      return rawData
          .whereType<Map<String, dynamic>>()
          .map(InformasiUmumModel.fromJson)
          .where((item) => item.isActive)
          .toList();
    }

    return const [];
  }

  Future<InformasiUmumModel?> getInformasiUmumById(int id) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.informasiUmumById(id)}',
    );
    final response = await _client.get(uri);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_extractErrorMessage(response.body, response.statusCode));
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final dynamic rawData = decoded['data'];

    if (rawData is Map<String, dynamic>) {
      return InformasiUmumModel.fromJson(rawData);
    }

    return null;
  }

  void dispose() {
    _client.close();
  }
}
