import 'dart:convert';
import 'package:http/http.dart' as http;

class EdukasiASIService {
  final String baseUrl;

  EdukasiASIService({
    required this.baseUrl,
  });

  Future<List<dynamic>> getEdukasiASI() async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/edukasi-menyusui-asi',
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Gagal mengambil data edukasi ASI',
      );
    }
  }
}