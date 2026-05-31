import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ta_pa2_pa3_project/core/constants/api_constants.dart';

class EdukasiTrimesterService {
  Future<List<dynamic>> getByTrimester(
    String trimester,
  ) async {
    final response = await http.get(
      Uri.parse(
        ApiConstants.edukasiTrimester(
          trimester,
        ),
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Gagal mengambil data trimester',
      );
    }
  }

  Future<List<dynamic>> getByKategori(
    String trimester,
    String kategori,
  ) async {
    final response = await http.get(
      Uri.parse(
        ApiConstants.edukasiTrimesterKategori(
          trimester,
          kategori,
        ),
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Gagal mengambil data kategori',
      );
    }
  }
}