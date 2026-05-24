import 'package:flutter/material.dart';
import 'package:ta_pa2_pa3_project/core/constants/app_colors.dart';
import '../../data/models/edukasi_trimester_model.dart';
import '../../data/repositories/edukasi_trimester_repository.dart';
import '../../data/services/edukasi_trimester_service.dart';

class EdukasiTrimesterKategoriScreen extends StatefulWidget {
  final String trimester;
  final String title;

  const EdukasiTrimesterKategoriScreen({
    super.key,
    required this.trimester,
    required this.title,
  });

  @override
  State<EdukasiTrimesterKategoriScreen> createState() =>
      _EdukasiTrimesterKategoriScreenState();
}

class _DashboardScreenState {} // Tetap aman jika ada referensi silang kosong

class _EdukasiTrimesterKategoriScreenState
    extends State<EdukasiTrimesterKategoriScreen> {
  late Future<List<EdukasiTrimesterModel>> futureData;
  String? selectedKategori; // State penampung kategori aktif yang dipilih ibu

  @override
  void initState() {
    super.initState();
    
    // MENYAMBUNGKAN KE REPOSITORY DAN SERVICE ASLI (LOGIKA DATABASE 100% AMAN)
    final repository = EdukasiTrimesterRepository(
      EdukasiTrimesterService(
        baseUrl: 'http://localhost:8080',
      ),
    );

    // Langsung mengambil seluruh data artikel trimester aktif
    futureData = repository.getByTrimester(widget.trimester);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F5EA8),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<List<EdukasiTrimesterModel>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final allArticles = snapshot.data ?? [];

          if (allArticles.isEmpty) {
            return const Center(child: Text('Data belum tersedia'));
          }

          // Mengekstrak kategori unik secara dinamis dari database untuk dijadikan Chips
          final kategoriList = allArticles.map((e) => e.kategori).toSet().toList();

          // Mengunci kategori pertama sebagai default pilihan saat halaman dibuka
          if (selectedKategori == null && kategoriList.isNotEmpty) {
            selectedKategori = kategoriList.first;
          }

          // Menyaring data secara lokal (Instant Filter tanpa loading ulang API)
          final filteredArticles = allArticles
              .where((article) => article.kategori == selectedKategori)
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- TAMPILAN BARU: HORIZONTAL SCROLL CHIPS KATEGORI (MEMANGKAS 1 LAYER NAVIGASI) ---
              Container(
                height: 60,
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: kategoriList.length,
                  itemBuilder: (context, index) {
                    final kategoriName = kategoriList[index];
                    final isSelected = selectedKategori == kategoriName;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedKategori = kategoriName;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF1F5EA8) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            kategoriName,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : const Color(0xFF4B5563),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // LIST FEED KONTEN EDUKASI (TAMPILAN FLAT SESUAI EVALUASI GENDERMAG)
              Expanded(
                child: filteredArticles.isEmpty
                    ? const Center(child: Text('Konten kategori ini kosong'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: filteredArticles.length,
                        itemBuilder: (context, index) {
                          final item = filteredArticles[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 14,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(28),
                                  ),
                                  child: Image.network(
                                    item.gambarUrl,
                                    height: 220,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(22),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          _buildBadge(item.trimester),
                                          const SizedBox(width: 10),
                                          _buildKategoriBadge(item.kategori),
                                        ],
                                      ),
                                      const SizedBox(height: 18),
                                      Text(
                                        item.judul,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF111827),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        item.isi,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          height: 1.8,
                                          color: Color(0xFF4B5563),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1F5EA8),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildKategoriBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1FD),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF1F5EA8), fontWeight: FontWeight.w600),
      ),
    );
  }
}