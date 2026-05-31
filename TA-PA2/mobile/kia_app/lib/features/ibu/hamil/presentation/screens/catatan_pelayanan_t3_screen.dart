import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ta_pa2_pa3_project/core/services/auth_session.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/services/kehamilan_api_service.dart';
import 'package:ta_pa2_pa3_project/core/themes/app_colors.dart';
import 'package:ta_pa2_pa3_project/core/constants/api_constants.dart';

class CatatanPelayananT3Screen extends StatefulWidget {
  const CatatanPelayananT3Screen({super.key});

  @override
  State<CatatanPelayananT3Screen> createState() =>
      _CatatanPelayananT3ScreenState();
}

class _CatatanPelayananT3ScreenState extends State<CatatanPelayananT3Screen> {
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
        Uri.parse(ApiConstants.catatanPelayananT3(
            kehamilan.id,
          ),
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
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
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
        title: const Text("Catatan Pelayanan T3"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : catatan.isEmpty
              ? const Center(child: Text("Belum ada catatan pelayanan T3"))
              : ListView.builder(
                  padding: const EdgeInsets.all(18),
                  itemCount: catatan.length,
                  itemBuilder: (context, index) {
                    final item = catatan[index];

                    return _card(item);
                  },
                ),
    );
  }

  Widget _card(dynamic item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label("Tanggal Periksa"),
          const SizedBox(height: 4),
          Text(
            _dateText(item["tanggal_periksa_stamp_paraf"]),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 14),
          _label("Keluhan / Pemeriksaan / Tindakan / Saran"),
          const SizedBox(height: 6),
          Text(
            item["keluhan_pemeriksaan_tindakan_saran"] ?? "-",
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 14),
          Text(
            "Tanggal kembali: ${_dateText(item["tanggal_kembali"])}",
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
    );
  }
}