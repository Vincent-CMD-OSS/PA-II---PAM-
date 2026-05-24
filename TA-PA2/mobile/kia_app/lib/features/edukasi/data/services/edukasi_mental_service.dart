import 'dart:convert';
import 'package:http/http.dart' as http;

class EdukasiKesehatanMentalService {
  final String baseUrl;

  EdukasiKesehatanMentalService({
    required this.baseUrl,
  });

  Future<List<dynamic>> getEdukasiKesehatanMental() async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/edukasi-kesehatan-mental',
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Gagal mengambil data edukasi kesehatan mental',
      );
    }
  }
}