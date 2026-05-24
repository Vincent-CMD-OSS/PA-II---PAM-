// lib/features/ibu/nifas/presentation/screens/nifas_screen.dart
// ============================================================
// [MODUL: IBU - Nifas] Halaman utama modul nifas.
// Fix: warna disesuaikan ke TrimesterTheme (biru), bukan teal.
// Fix: return Scaffold agar tidak ada error No Material widget.
// Fix: endpoint menggunakan ApiConstants.checklistNifasFilledDays.
// ============================================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ta_pa2_pa3_project/core/constants/api_constants.dart';
import 'package:ta_pa2_pa3_project/core/services/auth_session.dart';
import 'package:ta_pa2_pa3_project/core/themes/app_theme.dart';
import 'package:ta_pa2_pa3_project/features/ibu/nifas/presentation/screens/checklist_pemantauan_ibu_nifas_screen.dart';
import 'package:ta_pa2_pa3_project/core/constants/app_colors.dart';

class NifasScreen extends StatefulWidget {
  const NifasScreen({super.key});

  @override
  State<NifasScreen> createState() => _NifasScreenState();
}

class _NifasScreenState extends State<NifasScreen> {
  bool isLoading = true;
  List<int> filledDays = [];

  @override
  void initState() {
    super.initState();
    _loadFilledDays();
  }

  Future<void> _loadFilledDays() async {
    setState(() => isLoading = true);
    try {
      final token = AuthSession.token;
      if (token == null || token.isEmpty) {
        setState(() { filledDays = []; isLoading = false; });
        return;
      }

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.checklistNifasFilledDays}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final body = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = body['data'] as List<dynamic>? ?? [];
        setState(() {
          filledDays = data.map((e) => int.parse(e.toString())).toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _openChecklist() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChecklistPemantauanIbuNifasScreen(filledDays: filledDays),
      ),
    );
    if (result == true) _loadFilledDays();
  }

  @override
  Widget build(BuildContext context) {
    final progress = filledDays.length / 42;

    return Scaffold(
      backgroundColor: TrimesterTheme.background,
      appBar: AppBar(
        title: const Text(
          'Menu Nifas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _summaryCard(progress),
            const SizedBox(height: 16),
            _menuCard(
              title: 'Checklist Pemantauan Ibu Nifas',
              subtitle: 'Isi checklist Nifas A dan B satu kali setiap hari',
              icon: Icons.checklist_rounded,
              onTap: _openChecklist,
            ),
            const SizedBox(height: 18),
            const Text(
              'Riwayat Pengisian',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _filledDaysView(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(double progress) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: TrimesterTheme.t1Gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pemantauan Masa Nifas',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Checklist diisi sekali sehari selama 42 hari masa nifas.',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.25),
            color: Colors.white,
            minHeight: 8,
            borderRadius: BorderRadius.circular(20),
          ),
          const SizedBox(height: 8),
          Text(
            '${filledDays.length}/42 hari sudah diisi',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _filledDaysView() {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (filledDays.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Text(
          'Belum ada checklist yang diisi.',
          style: TextStyle(color: Colors.black54, fontSize: 13),
        ),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: filledDays.map((day) => Chip(
        avatar: Icon(Icons.check_circle, color: AppColors.primary, size: 18),
        label: Text('Hari ke-$day'),
        backgroundColor: const Color(0xFFE3F2FD),
        side: const BorderSide(color: Color(0xFFBBDEFB)),
      )).toList(),
    );
  }

  Widget _menuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      elevation: 1,
      shadowColor: Colors.black12,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}