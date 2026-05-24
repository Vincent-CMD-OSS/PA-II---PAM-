// lib/features/ibu/hamil/presentation/screens/rujukan_detail_screen.dart
// ============================================================
// [MODUL: IBU - Hamil] Detail surat rekomendasi rujukan.
// Dipindahkan dari features/hamil/... ke features/ibu/hamil/...
// ============================================================
import 'package:ta_pa2_pa3_project/core/constants/app_colors.dart';

import 'package:flutter/material.dart';

class RujukanDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const RujukanDetailScreen({super.key, required this.data});

  String _value(String key) {
    final value = data[key];
    if (value == null || value.toString().isEmpty) return "-";
    return value.toString();
  }

  String _dateText(String key) {
    final value = data[key];
    if (value == null || value.toString().isEmpty) return "-";
    return value.toString().split("T").first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text("Detail Rujukan"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, Colors.blue.shade400],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.description_outlined, color: Colors.white, size: 34),
                SizedBox(height: 12),
                Text("Surat Rekomendasi Rujukan",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text("Detail rujukan dan rujukan balik dari tenaga kesehatan.",
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _section("Informasi Rujukan"),
          _info("Resume pemeriksaan / tatalaksana", _value("rujukan_resume_pemeriksaan_tatalaksana")),
          _info("Diagnosis akhir", _value("rujukan_diagnosis_akhir")),
          _info("Alasan dirujuk ke FKRTL", _value("rujukan_alasan_dirujuk_ke_fkrtl")),
          _section("Rujukan Balik"),
          _info("Tanggal rujukan balik", _dateText("rujukan_balik_tanggal")),
          _info("Diagnosis akhir rujukan balik", _value("rujukan_balik_diagnosis_akhir")),
          _info("Resume pemeriksaan / tatalaksana rujukan balik", _value("rujukan_balik_resume_pemeriksaan_tatalaksana")),
          _section("Anjuran"),
          _info("Rekomendasi tempat melahirkan", _value("anjuran_rekomendasi_tempat_melahirkan")),
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 10),
    child: Text(title, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15)),
  );

  Widget _info(String label, String value) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      const SizedBox(height: 6),
      Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.35)),
    ]),
  );
}