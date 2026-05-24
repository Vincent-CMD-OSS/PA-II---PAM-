import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ta_pa2_pa3_project/core/services/auth_session.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/services/kehamilan_api_service.dart';
import 'package:ta_pa2_pa3_project/core/constants/app_colors.dart';

class CatatanPelayananT1Screen extends StatefulWidget {
  const CatatanPelayananT1Screen({super.key});

  @override
  State<CatatanPelayananT1Screen> createState() =>
      _CatatanPelayananT1ScreenState();
}

class _CatatanPelayananT1ScreenState extends State<CatatanPelayananT1Screen> {
  final _kehamilanService = KehamilanApiService();

  bool isLoading = true;
  List<dynamic> catatan = [];

  @override
  void initState() {
    super.initState();
    _loadCatatan();
  }

  Future<void> _loadCatatan() async {
    try {
      final token = AuthSession.token;
      if (token == null || token.isEmpty) {
        throw Exception("Token tidak ditemukan");
      }

      final kehamilan = await _kehamilanService.getKehamilanAktif();

      final response = await http.get(
        Uri.parse(
          "http://localhost:8080/modul-ibu/catatan-pelayanan-t1?kehamilan_id=${kehamilan.id}",
        ),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          catatan = body["data"] ?? [];
          isLoading = false;
        });
      } else {
        throw Exception(body["message"]?.toString() ?? "Gagal mengambil data");
      }
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _dateText(dynamic value) {
    if (value == null || value.toString().isEmpty) return "-";
    return value.toString().split("T").first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text("Catatan Pelayanan T1"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : catatan.isEmpty
              ? const Center(child: Text("Belum ada catatan pelayanan T1"))
              : ListView.builder(
                  padding: const EdgeInsets.all(18),
                  itemCount: catatan.length,
                  itemBuilder: (context, index) {
                    final item = catatan[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tanggal Periksa",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _dateText(item["tanggal_periksa_stamp_paraf"]),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            "Keluhan / Pemeriksaan / Tindakan / Saran",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item["keluhan_pemeriksaan_tindakan_saran"] ?? "-",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            "Tanggal kembali: ${_dateText(item["tanggal_kembali"])}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}