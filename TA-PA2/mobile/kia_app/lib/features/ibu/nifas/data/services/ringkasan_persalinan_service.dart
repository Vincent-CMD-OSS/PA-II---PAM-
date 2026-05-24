import 'dart:convert';

import 'package:http/http.dart' as http;

class RingkasanPersalinanService {
  final String baseUrl;

  RingkasanPersalinanService({
    required this.baseUrl,
  });

  Future<List<dynamic>> getData(
    String token,
  ) async {

    final response = await http.get(
      Uri.parse(
        '$baseUrl/modul-ibu/ringkasan-persalinan/me',
      ),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return body['data'];
    }

    throw Exception(body['message']);
  }
}