import 'dart:convert';
import 'package:http/http.dart' as http;

class EdukasiIMDService {
  final String baseUrl;

  EdukasiIMDService({
    required this.baseUrl,
  });

  Future<List<dynamic>> getEdukasiIMD() async {
    final response = await http.get(
      Uri.parse('$baseUrl/edukasi-imd'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil data edukasi IMD');
    }
  }
}