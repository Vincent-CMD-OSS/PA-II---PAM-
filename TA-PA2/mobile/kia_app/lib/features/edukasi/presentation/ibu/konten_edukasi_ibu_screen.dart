import 'package:flutter/material.dart';
import 'package:ta_pa2_pa3_project/core/constants/app_colors.dart';

// --- IMPORT NAVIGASI ---
import 'package:ta_pa2_pa3_project/features/dashboard/presentation/screens/dashboard_screen.dart'; 
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/absensi_kelas_ibu_hamil_screen.dart';

// --- IMPORT HALAMAN DETAIL EDUKASI ---
import 'edukasi_asi_screen.dart';
import 'edukasi_imd_screen.dart';
import 'edukasi_mental_screen.dart';
import 'edukasi_nifas_screen.dart';
import 'edukasi_tanda_melahirkan_screen.dart';

// --- IMPORT MODEL DAN REPOSITORY DATABASE (LOGIKA 100% AMAN) ---
import '../../data/models/edukasi_trimester_model.dart';
import '../../data/repositories/edukasi_trimester_repository.dart';
import '../../data/services/edukasi_trimester_service.dart';

// --- IMPORT WIDGET MODULAR ---
import '../widgets/edukasi_search_filter.dart';
import '../widgets/edukasi_card.dart'; 

class KontenEdukasiIbuScreen extends StatefulWidget {
  const KontenEdukasiIbuScreen({super.key});

  @override
  State<KontenEdukasiIbuScreen> createState() =>
      _KontenEdukasiIbuScreenState();
}

class _KontenEdukasiIbuScreenState extends State<KontenEdukasiIbuScreen> {
  String selectedCategory = 'Semua';
  String searchQuery = '';
  int _currentIndex = 2; // Posisi Tab Edukasi

  // STATE MANAGEMENT UNTUK DATA TRIMESTER DARI DATABASE
  String selectedTrimesterTab = 'TM1'; // Default awal ke Trimester 1

  // KONEKSI DATABASE ASLI (SAMA SEKALI TIDAK DIUBAH)
  final _trimesterRepository = EdukasiTrimesterRepository(
    EdukasiTrimesterService(
      baseUrl: 'http://localhost:8080',
    ),
  );

  @override
  Widget build(BuildContext context) {
    // --- DATA TOPIK UMUM NON-TRIMESTER ---
    final List<Map<String, dynamic>> edukasiUmum = [
      {
        'title': 'Inisiasi Menyusu Dini',
        'duration': '3 Menit Baca',
        'category': 'Menyusui',
        'screen': const EdukasiIMDScreen(),
      },
      {
        'title': 'Edukasi Menyusui ASI',
        'duration': '6 Menit',
        'category': 'Menyusui',
        'screen': const EdukasiASIScreen(),
      },
      {
        'title': 'Kesehatan Mental Ibu',
        'duration': '4 Menit Baca',
        'category': 'Kesehatan Mental',
        'screen': const EdukasiKesehatanMentalScreen(),
      },
      {
        'title': 'Edukasi Masa Nifas',
        'duration': '5 Menit',
        'category': 'Nifas',
        'screen': const EdukasiNifasScreen(),
      },
      {
        'title': 'Tanda-Tanda Melahirkan',
        'duration': '4 Menit Baca',
        'category': 'Trimester',
        'screen': const EdukasiTandaMelahirkanScreen(),
      },
    ];

    // Filter pencarian data lokal umum
    final filteredUmumData = edukasiUmum.where((item) {
      final matchesCategory = selectedCategory == 'Semua'
          ? true
          : item['category'] == selectedCategory;

      final matchesSearch = item['title']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), 
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          children: const [
            Text(
              'Edukasi Ibu',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Sumber Buku KIA',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Widget Area Pencarian & Filter Kategori Makro
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: EdukasiSearchFilter(
              selectedCategory: selectedCategory,
              categories: const ['Semua', 'Trimester', 'Menyusui', 'Nifas', 'Kesehatan Mental'],
              onCategorySelected: (value) {
                setState(() { selectedCategory = value; });
              },
              onSearchChanged: (value) {
                setState(() { searchQuery = value; });
              },
            ),
          ),

          // --- KONDISIKAN TAMPILAN JIKA USER MEMILIH FILTER KATEGORI TRIMESTER ---
          if (selectedCategory == 'Trimester') ...[
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: ['TM1', 'TM2', 'TM3'].map((tm) {
                  final isSelected = selectedTrimesterTab == tm;
                  String label = tm == 'TM1' ? 'Trimester I' : tm == 'TM2' ? 'Trimester II' : 'Trimester III';
                  
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() { selectedTrimesterTab = tm; });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF1F5EA8) : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            label,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF475569),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 22, 16, 12),
            child: Text(
              'Rekomendasi untuk ibu hamil dan nifas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF212529)),
            ),
          ),

          // AREA FEED DATA UTAMA (MENGGUNAKAN EDUKASICARD UNTUK KESERAGAMAN DESAIN)
          Expanded(
            child: selectedCategory == 'Trimester'
                ? FutureBuilder<List<EdukasiTrimesterModel>>(
                    future: _trimesterRepository.getByTrimester(selectedTrimesterTab),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      }

                      final databaseArticles = snapshot.data ?? [];
                      
                      // Filter lokal untuk kolom pencarian teks
                      final filteredDbArticles = databaseArticles.where((article) {
                        return article.judul.toLowerCase().contains(searchQuery.toLowerCase());
                      }).toList();

                      if (filteredDbArticles.isEmpty) {
                        return const Center(child: Text('Artikel tidak ditemukan'));
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredDbArticles.length,
                        itemBuilder: (context, index) {
                          final item = filteredDbArticles[index];
                          
                          // MEMAKAI CETAKAN EDUKASICARD ASLI AGAR TAMPILAN RAPI DAN BEBAS OVERLAY VIDEO
                          return EdukasiCard(
                            title: item.judul,
                            duration: '5 Menit', // Fallback durasi seragam
                            category: 'Trimester',
                            onTap: () {
                              // Tampilkan dialog baca atau arahkan sesuai kebutuhan proyekmu
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                ),
                                builder: (_) => Container(
                                  padding: const EdgeInsets.all(24),
                                  height: MediaQuery.of(context).size.height * 0.7,
                                  child: ListView(
                                    children: [
                                      Text(item.judul, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 16),
                                      Text(item.isi, style: const TextStyle(fontSize: 15, height: 1.6, color: Color(0xFF4B5563))),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredUmumData.length,
                    itemBuilder: (context, index) {
                      final item = filteredUmumData[index];
                      
                      // KONTEN UMUM JUGA MEMAKAI CETAKAN YANG SAMA
                      return EdukasiCard(
                        title: item['title'],
                        duration: item['duration'],
                        category: item['category'],
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (_) => item['screen'])
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary, 
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        onTap: (index) {
          if (index == _currentIndex) return;
          setState(() { _currentIndex = index; });

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
}