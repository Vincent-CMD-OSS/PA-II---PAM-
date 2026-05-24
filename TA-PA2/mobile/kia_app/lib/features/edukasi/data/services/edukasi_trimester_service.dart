import 'dart:convert';
import 'package:http/http.dart' as http;

class EdukasiTrimesterService {
  final String baseUrl;

  EdukasiTrimesterService({
    required this.baseUrl,
  });

  Future<List<dynamic>> getByTrimester(
    String trimester,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/edukasi-trimester/$trimester',
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
        '$baseUrl/edukasi-trimester/$trimester/$kategori',
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