// lib/features/ibu/hamil/presentation/screens/rujukan_list_screen.dart
// ============================================================
// [MODUL: IBU - Hamil] Daftar surat rekomendasi rujukan.
// Dipindahkan dari features/hamil/... ke features/ibu/hamil/...
// Import service dan model disesuaikan ke path baru.
// ============================================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ta_pa2_pa3_project/core/services/auth_session.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/services/kehamilan_api_service.dart';
import 'rujukan_detail_screen.dart';
import 'package:ta_pa2_pa3_project/core/constants/app_colors.dart';

class RujukanListScreen extends StatefulWidget {
  const RujukanListScreen({super.key});

  @override
  State<RujukanListScreen> createState() => _RujukanListScreenState();
}

class _RujukanListScreenState extends State<RujukanListScreen> {
  final _kehamilanService = KehamilanApiService();
  bool isLoading = true;
  List<dynamic> rujukanList = [];

  @override
  void initState() {
    super.initState();
    _loadRujukan();
  }

  Future<void> _loadRujukan() async {
    try {
      final token = AuthSession.token;
      if (token == null || token.isEmpty) throw Exception("Token tidak ditemukan");

      final kehamilan = await _kehamilanService.getKehamilanAktif();
      final response = await http.get(
        Uri.parse("http://localhost:8080/modul-ibu/rujukan?kehamilan_id=${kehamilan.id}"),
        headers: {"Authorization": "Bearer $token"},
      );

      final body = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() { rujukanList = body["data"] ?? []; isLoading = false; });
      } else {
        throw Exception(body["message"]?.toString() ?? "Gagal mengambil data rujukan");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
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
        title: const Text("Surat Rekomendasi Rujukan"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : rujukanList.isEmpty
              ? const Center(child: Text("Belum ada surat rekomendasi rujukan"))
              : ListView.builder(
                  padding: const EdgeInsets.all(18),
                  itemCount: rujukanList.length,
                  itemBuilder: (context, index) {
                    final item = rujukanList[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(18),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade50,
                          child: Icon(Icons.description_outlined, color: AppColors.primary),
                        ),
                        title: Text(
                          item["rujukan_diagnosis_akhir"]?.toString().isNotEmpty == true
                              ? item["rujukan_diagnosis_akhir"] : "Rujukan Kehamilan",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text("Tanggal balik: ${_dateText(item["rujukan_balik_tanggal"])}"),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => RujukanDetailScreen(data: item))),
                      ),
                    );
                  },
                ),
    );
  }
}