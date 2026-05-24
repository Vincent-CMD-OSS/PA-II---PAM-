import 'dart:convert';
import 'package:http/http.dart' as http;

class EdukasiTandaMelahirkanService {
  final String baseUrl;

  EdukasiTandaMelahirkanService({
    required this.baseUrl,
  });

  Future<List<dynamic>>
      getEdukasiTandaMelahirkan() async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/edukasi-tanda-melahirkan',
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Gagal mengambil data edukasi tanda melahirkan',
      );
    }
  }
}