import 'dart:convert';
import 'package:http/http.dart' as http;

class EdukasiNifasService {
  final String baseUrl;

  EdukasiNifasService({
    required this.baseUrl,
  });

  Future<List<dynamic>> getEdukasiNifas() async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/edukasi-nifas',
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