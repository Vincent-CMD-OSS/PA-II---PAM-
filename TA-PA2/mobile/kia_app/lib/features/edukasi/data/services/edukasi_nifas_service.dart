import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ta_pa2_pa3_project/core/constants/api_constants.dart';

class EdukasiNifasService {
  Future<List<dynamic>> getEdukasiNifas() async {
    final response = await http.get(
      Uri.parse(
        ApiConstants.edukasiNifas,
      ),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      return result['data'];
    } else {
      throw Exception(
        'Gagal mengambil data edukasi nifas',
      );
    }
  }
}