import 'package:flutter/material.dart';
import 'package:ta_pa2_pa3_project/features/anak/catatan/presentation/screens/catatan_kesehatan_anak_screen.dart';
import 'package:ta_pa2_pa3_project/features/anak/catatan/presentation/screens/catatan_kesehatan_gigi_screen.dart';
import 'package:ta_pa2_pa3_project/features/anak/catatan/presentation/screens/catatan_lila_screen.dart';

class CatatanMenuScreen extends StatelessWidget {
  // Tambahkan parameter agar bisa diteruskan ke screen child
  final int anakId;
  final String anakName;

  const CatatanMenuScreen({
    super.key,
    required this.anakId,
    required this.anakName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Catatan Anak',
              style: TextStyle(
                color: Color(0xFF172033),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pantau kesehatan $anakName', // Dibuat dinamis
              style: const TextStyle(
                color: Color(0xFF7B8798),
                fontSize: 13,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF172033)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Jenis Catatan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF172033),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Lihat dan kelola catatan kesehatan anak Anda',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF7B8798),
              ),
            ),
            const SizedBox(height: 20),
            _buildCatatanCard(
              context,
              icon: Icons.health_and_safety_outlined,
              title: 'Catatan Kesehatan Anak',
              subtitle: 'Catat pemeriksaan kesehatan rutin',
              iconColor: const Color(0xFF2F80ED),
              iconBgColor: const Color(0xFFEAF4FF),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  // Perbaikan: Class publik dan pengiriman data ID & Nama
                  builder: (_) => CatatanKesehataanAnakScreen(
                    anakId: anakId,
                    anakName: anakName,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildCatatanCard(
              context,
              icon: Icons.medical_services_outlined,
              title: 'Catatan Kesehatan Gigi',
              subtitle: 'Pantau kesehatan gigi dan mulut anak',
              iconColor: const Color(0xFFD32F2F),
              iconBgColor: const Color(0xFFFFEBEE),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CatatanKesehataanGigiScreen(
                    anakId: anakId,
                    anakName: anakName,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildCatatanCard(
              context,
              icon: Icons.straighten_outlined,
              title: 'Lingkar Lengan Atas (LiLA)',
              subtitle: 'Catat pengukuran LiLA secara berkala',
              iconColor: const Color(0xFFF57C00),
              iconBgColor: const Color(0xFFFFE0B2),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CatatanLilaScreen(
                    anakId: anakId,
                    anakName: anakName,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF2E7D32)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Catatan kesehatan membantu Anda memantau perkembangan dan kesehatan anak secara menyeluruh.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatatanCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color iconBgColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7B8798),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF9CA3AF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}