import 'package:flutter/material.dart';
import 'package:ta_pa2_pa3_project/core/themes/app_theme.dart';
import 'package:ta_pa2_pa3_project/features/anak/informasi_umum/data/models/informasi_umum_model.dart';
import 'package:ta_pa2_pa3_project/features/anak/informasi_umum/data/services/informasi_umum_api_service.dart';
import 'package:ta_pa2_pa3_project/features/anak/informasi_umum/presentation/screens/informasi_umum/informasi_umum_detail_screen.dart';
import 'package:ta_pa2_pa3_project/features/anak/pemantauan/presentation/screens/perawatan/pilih_perawatan_screen.dart';

import 'package:ta_pa2_pa3_project/features/anak/edukasi/presentation/screens/edukasi/pedoman/pedoman_ibu_bayi_screen.dart';
import 'package:ta_pa2_pa3_project/features/anak/edukasi/presentation/screens/edukasi/pola_asuh_screen.dart';

class EdukasiExploreScreen extends StatefulWidget {
  const EdukasiExploreScreen({Key? key}) : super(key: key);

  @override
  State<EdukasiExploreScreen> createState() => _EdukasiExploreScreenState();
}

class _EdukasiExploreScreenState extends State<EdukasiExploreScreen> {
  final InformasiUmumApiService _apiService = InformasiUmumApiService();
  late Future<List<InformasiUmumModel>> _informasiFuture;

  String _category = 'anak';
  final Color _primary = TrimesterTheme.t1Primary;

  @override
  void initState() {
    super.initState();
    _informasiFuture = _apiService.listInformasiUmum();
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    setState(() {
      _informasiFuture = _apiService.listInformasiUmum();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Edukasi',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _tabButton('anak', 'Anak'),
                    const SizedBox(width: 12),
                    _tabButton('ibu', 'Ibu'),
                  ],
                ),
                const SizedBox(height: 16),
                if (_category == 'ibu') ...[
                  _sectionCard(
                    title: 'Konten ibu tetap tersedia',
                    description:
                        'Menu ibu tetap ada untuk panduan internal. Konten hasil CRUD web ditampilkan di tab Anak.',
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PedomanIbuBayiScreen(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: _menuCard(
                      icon: Icons.menu_book_outlined,
                      title: 'Pedoman Ibu & Bayi',
                      subtitle: 'Panduan kesehatan ibu & bayi',
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PolaAsuhScreen(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: _menuCard(
                      icon: Icons.device_hub,
                      title: 'Pola Asuh',
                      subtitle: 'Metode pengasuhan positif',
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PilihPerawatanScreen(
                            anakId: null,
                            anakName: null,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: _menuCard(
                      icon: Icons.medical_services_outlined,
                      title: 'Perawatan',
                      subtitle: 'Kesehatan & nutrisi harian',
                    ),
                  ),
                ] else ...[
                  FutureBuilder<List<InformasiUmumModel>>(
                    future: _informasiFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return _emptyState(
                          title: 'Gagal memuat data',
                          message: snapshot.error.toString(),
                        );
                      }

                      final items = snapshot.data ?? const [];

                      if (items.isEmpty) {
                        return _emptyState(
                          title: 'Tidak ada konten',
                          message: 'Belum ada data web yang dipublikasikan.',
                        );
                      }

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListView.separated(
                          itemCount: items.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, idx) {
                            final item = items[idx];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => InformasiUmumDetailScreen(
                                      item: item,
                                    ),
                                  ),
                                );
                              },
                              child: _informasiCard(item),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabButton(String key, String label) {
    final bool active = _category == key;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _category = key),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active ? _primary : Colors.grey.shade300,
              width: active ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: active ? _primary : const Color(0xFF6B7280),
                fontWeight: active ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required String description}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF2563EB), size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 28),
        ],
      ),
    );
  }

  Widget _emptyState({required String title, required String message}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const Icon(Icons.info_outline, size: 42, color: Color(0xFF94A3B8)),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _informasiCard(InformasiUmumModel item) {
    final bool isVideo = item.isVideo;
    final Color accentColor =
        isVideo ? const Color(0xFF2563EB) : const Color(0xFFF97316);
    final Color chipBg =
        isVideo ? const Color(0xFFEFF6FF) : const Color(0xFFFFF7ED);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: chipBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: item.thumbnailUrl.trim().isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Icon(
                          isVideo ? Icons.play_circle : Icons.article,
                          color: accentColor,
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Icon(
                      isVideo ? Icons.play_circle : Icons.article,
                      color: accentColor,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.judul,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.tipe.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.displayDurationText,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
