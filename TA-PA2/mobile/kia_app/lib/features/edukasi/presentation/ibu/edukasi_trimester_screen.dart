import 'package:flutter/material.dart';
import 'package:ta_pa2_pa3_project/core/constants/app_colors.dart';
import 'edukasi_trimester_kategori_screen.dart';
import 'package:ta_pa2_pa3_project/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/absensi_kelas_ibu_hamil_screen.dart';

class EdukasiTrimesterScreen extends StatefulWidget {
  const EdukasiTrimesterScreen({super.key});

  @override
  State<EdukasiTrimesterScreen> createState() => _EdukasiTrimesterScreenState();
}

class _EdukasiTrimesterScreenState extends State<EdukasiTrimesterScreen> {
  int _currentIndex = 2; // Index Edukasi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna background disesuaikan agar lebih bersih (soft greyish blue)
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: const [
            Text(
              'Edukasi',
              style: TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Sumber Buku KIA',
              style: TextStyle(color: Color(0xFF9CA3AF), fontWeight: FontWeight.normal, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _buildTrimesterCard(
            context,
            title: 'Edukasi Trimester 1',
            subtitle: 'Lihat hasil pemeriksaan ANC trimester I',
            trimester: 'TM1',
          ),
          const SizedBox(height: 16),
          _buildTrimesterCard(
            context,
            title: 'Edukasi Trimester 2',
            subtitle: 'Lihat hasil pemeriksaan dokter trimester II',
            trimester: 'TM2',
          ),
          const SizedBox(height: 16),
          _buildTrimesterCard(
            context,
            title: 'Edukasi Trimester 3',
            subtitle: 'Panduan dan informasi penting minggu 1–12',
            trimester: 'TM3',
          ),
        ],
      ),

      // Menambahkan Navbar agar konsisten
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == _currentIndex) return;
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
          } else if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AbsensiKelasIbuHamilScreen()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: 'Absensi'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), activeIcon: Icon(Icons.menu_book), label: 'Edukasi'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildTrimesterCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String trimester,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EdukasiTrimesterKategoriScreen(
              trimester: trimester,
              title: title,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)), // Border halus
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Document dengan background bulat biru muda (Sesuai Mockup)
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFEBF5FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_outlined, // Icon dokumen sesuai gambar
                size: 26,
                color: Color(0xFF3B82F6),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF), height: 1.2),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFD1D5DB), size: 20),
          ],
        ),
      ),
    );
  }
}