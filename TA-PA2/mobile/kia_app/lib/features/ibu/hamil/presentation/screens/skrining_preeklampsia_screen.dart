import 'package:flutter/material.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/services/skrining_preeklampsia_api_service.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/models/skrining_preeklampsia_model.dart';
import 'package:ta_pa2_pa3_project/core/themes/app_colors.dart';

class SkriningPreeklampsiaScreen extends StatefulWidget {
  const SkriningPreeklampsiaScreen({super.key});

  @override
  State<SkriningPreeklampsiaScreen> createState() =>
      _SkriningPreeklampsiaScreenState();
}

class _SkriningPreeklampsiaScreenState
    extends State<SkriningPreeklampsiaScreen> {
  final _service = SkriningPreeklampsiaApiService();
  late Future<SkriningPreeklampsiaModel> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getMine();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  Color _statusColor(SkriningPreeklampsiaModel data) {
    if (data.hasRisikoTinggi) return const Color(0xFFE53935);
    if (data.hasRisikoSedang || data.hasPemeriksaanFisikBermasalah) {
      return const Color(0xFFF59E0B);
    }
    return const Color(0xFF22C55E);
  }

  IconData _statusIcon(SkriningPreeklampsiaModel data) {
    if (data.hasRisikoTinggi) return Icons.warning_amber_rounded;
    if (data.hasRisikoSedang || data.hasPemeriksaanFisikBermasalah) {
      return Icons.info_outline;
    }
    return Icons.check_circle_outline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        title: const Text("Skrining Preeklampsia"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<SkriningPreeklampsiaModel>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _EmptyState(
              title: "Data belum tersedia",
              message: snapshot.error.toString().replaceFirst('Exception: ', ''),
            );
          }

          final data = snapshot.data;
          if (data == null) {
            return const _EmptyState(
              title: "Data belum tersedia",
              message: "Belum ada data skrining preeklampsia.",
            );
          }

          final color = _statusColor(data);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _SummaryCard(
                title: data.kesimpulanText,
                color: color,
                icon: _statusIcon(data),
              ),
              const SizedBox(height: 14),
              _AnswerCard(
                title: "Faktor Risiko Sedang",
                icon: Icons.list_alt_outlined,
                items: data.risikoSedangItems,
              ),
              _AnswerCard(
                title: "Faktor Risiko Tinggi",
                icon: Icons.warning_amber_rounded,
                items: data.risikoTinggiItems,
              ),
              _AnswerCard(
                title: "Pemeriksaan Fisik",
                icon: Icons.monitor_heart_outlined,
                items: data.pemeriksaanFisikItems,
              ),
            ],
          );

        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hasil Skrining",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<SkriningAnswerItem> items;

  const _AnswerCard({
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5ECF6)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF172033),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => _AnswerRow(item: item)),
        ],
      ),
    );
  }
}

class _AnswerRow extends StatelessWidget {
  final SkriningAnswerItem item;

  const _AnswerRow({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        item.value ? const Color(0xFFE53935) : const Color(0xFF22C55E);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            item.value ? Icons.error_outline : Icons.check_circle_outline,
            size: 19,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.label,
              style: const TextStyle(
                fontSize: 13,
                height: 1.35,
                color: Color(0xFF172033),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              item.value ? "Ya" : "Tidak",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String message;

  const _EmptyState({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.health_and_safety_outlined,
                size: 60,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF172033),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF7B8798),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}