import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../pemantauan/data/models/perawatan_model.dart';
import '../../../../pemantauan/data/services/perawatan_api_service.dart';

/// PerawatanPerkembanganScreen
/// Menampilkan materi perawatan + kuesioner perkembangan anak per rentang usia
/// Mengikuti pola yang sama dengan LembarPemantauanScreen (tab Isi + Riwayat)
class PerawatanPerkembanganScreen extends StatefulWidget {
  final Map<String, dynamic>? anak;

  const PerawatanPerkembanganScreen({
    super.key,
    this.anak,
  });

  @override
  State<PerawatanPerkembanganScreen> createState() =>
      _PerawatanPerkembanganScreenState();
}

class _PerawatanPerkembanganScreenState
    extends State<PerawatanPerkembanganScreen> {
  late PerawatanApiService _apiService;

  final List<String> _ageRanges = [
    '29 hari-3 bulan',
    '3-6 bulan',
    '6-9 bulan',
    '9-12 bulan',
    '12-18 bulan',
    '18-24 bulan',
    '2-3 tahun',
    '3-4 tahun',
    '4-5 tahun',
    '5-6 tahun',
  ];
  int _selectedAgeIndex = 0;

  // State per rentang usia
  Map<String, List<KategoriCapaianModel>> _kategoriByRange = {};
  Map<String, Map<int, bool?>> _checklistByRange = {};
  Map<String, Map<int, int?>> _idsByRange = {}; // perawatan ID untuk update
  Map<String, bool> _loadingByRange = {};
  Map<String, String> _errorByRange = {};
  Map<String, bool> _submittingByRange = {};
  Map<String, bool> _submittedByRange = {}; // sudah tersimpan?
  Map<String, DateTime?> _tanggalPeriksaByRange = {}; // tanggal pengisian per range

  // Tanggal periksa (sama untuk seluruh submit)
  DateTime _tanggalPeriksa = DateTime.now();

  @override
  void initState() {
    super.initState();
    _apiService = PerawatanApiService(dio: Dio());
    _loadAllData();
  }

  int get _anakId {
    final raw = widget.anak?['id'];
    if (raw is int) return raw;
    return int.tryParse((raw ?? '').toString()) ?? 0;
  }

  String get _anakNama => widget.anak?['nama'] ?? 'Anak';
  String get _anakUsia => widget.anak?['usia_teks'] ?? '-';

  Future<void> _loadAllData() async {
    // Inisialisasi loading state semua range
    for (final range in _ageRanges) {
      _loadingByRange[range] = true;
      _errorByRange[range] = '';
    }
    if (mounted) setState(() {});

    await Future.wait([
      ..._ageRanges.map((range) => _loadRangeData(range)),
    ]);
  }

  Future<void> _loadRangeData(String range) async {
    try {
      final kategori = await _apiService.getKategoriCapaianByRentangUsia(range);
      final checklistMap = <int, bool?>{};
      final idMap = <int, int?>{};

      if (_anakId > 0) {
        try {
          final existing = await _apiService.getPerawatanByAnakIdAndRentangUsia(
              _anakId, range);
          DateTime? latestTanggal;
          for (final item in existing) {
            checklistMap[item.kategoriCapaianId] = item.jawaban;
            idMap[item.kategoriCapaianId] = item.id;
            if (item.tanggalPeriksa != null) {
              if (latestTanggal == null || item.tanggalPeriksa!.isAfter(latestTanggal)) {
                latestTanggal = item.tanggalPeriksa;
              }
            }
          }
          if (latestTanggal != null) {
            _tanggalPeriksaByRange[range] = latestTanggal;
          }
        } catch (_) {
          // belum ada data → kosong, no-op
        }
      }

      if (!mounted) return;
      setState(() {
        _kategoriByRange[range] = kategori;
        _checklistByRange[range] = checklistMap;
        _idsByRange[range] = idMap;
        _loadingByRange[range] = false;
        _submittedByRange[range] =
            checklistMap.isNotEmpty; // sudah pernah diisi
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingByRange[range] = false;
        _errorByRange[range] = e.toString();
      });
    }
  }



  Future<void> _submit(String range) async {
    final checklist = _checklistByRange[range] ?? {};
    final kategori = _kategoriByRange[range] ?? [];
    final ids = _idsByRange[range] ?? {};

    if (kategori.isEmpty) {
      _showSnack('Kuesioner belum tersedia untuk $range');
      return;
    }

    // Validasi: semua harus diisi
    final unanswered = kategori.where((k) => !checklist.containsKey(k.id));
    if (unanswered.isNotEmpty) {
      _showSnack(
          'Harap isi semua pertanyaan (${unanswered.length} belum dijawab)');
      return;
    }

    setState(() => _submittingByRange[range] = true);

    int successCount = 0;
    int failCount = 0;
    final errorMessages = <String>[];

    for (final kat in kategori) {
      final jawaban = checklist[kat.id];
      if (jawaban == null) continue;

      try {
        final existingId = ids[kat.id];
        if (existingId != null) {
          // Update
          await _apiService.updatePerawatan(
            existingId,
            UpdatePerawatanRequest(
              jawaban: jawaban,
              tanggalPeriksa: _tanggalPeriksa,
            ),
          );
        } else {
          // Create
          final result = await _apiService.createPerawatan(
            CreatePerawatanRequest(
              anakId: _anakId,
              kategoriCapaianId: kat.id,
              jawaban: jawaban,
              tanggalPeriksa: _tanggalPeriksa,
            ),
          );
          // Simpan ID untuk update berikutnya
          ids[kat.id] = result.id;
        }
        successCount++;
      } catch (e) {
        failCount++;
        errorMessages.add(e.toString());
      }
    }

    if (!mounted) return;
    setState(() {
      _submittingByRange[range] = false;
      _idsByRange[range] = ids;
      if (failCount == 0) {
        _submittedByRange[range] = true;
      }
    });

    if (failCount == 0) {
      _showSnack('✓ Data perawatan $range berhasil disimpan!', isSuccess: true);
      setState(() {
        _tanggalPeriksaByRange[range] = _tanggalPeriksa;
      });
    } else {
      final firstError = errorMessages.isNotEmpty ? errorMessages.first : 'Coba lagi.';
      _showSnack('$successCount berhasil, $failCount gagal disimpan. $firstError');
    }
  }

  Future<void> _pickTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalPeriksa,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF10B981),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() => _tanggalPeriksa = picked);
    }
  }

  void _showSnack(String msg, {bool isSuccess = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isSuccess ? const Color(0xFF10B981) : null,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  // ─────────────────────────────────────────────────────────
  // MATERI PERAWATAN (sesuai gambar referensi)
  // ─────────────────────────────────────────────────────────
  Map<String, List<_MateriSection>> get _materiByRange => {
        '0-12 Bulan': [
          const _MateriSection(
            title: 'Pelayanan Kesehatan',
            icon: Icons.local_hospital_outlined,
            color: Color(0xFF3B82F6),
            items: [
              'Bawa anak setiap bulan ke Posyandu/Puskesmas untuk mendapatkan pelayanan:',
              '• Pemantauan pertumbuhan dan perkembangan',
              '• Ibu/Ayah/Keluarga mengikuti kelas Ibu Balita',
              '• Kapsul Vitamin A (Februari atau Agustus)',
              '• Obat cacing',
            ],
          ),
          const _MateriSection(
            title: 'Perawatan Gigi',
            icon: Icons.sentiment_satisfied_alt_outlined,
            color: Color(0xFF8B5CF6),
            items: [
              'Lanjutkan perawatan gigi dengan mengingatkan anak menyikat gigi setelah makan dan sebelum tidur.',
            ],
          ),
          const _MateriSection(
            title: 'Pantau Tumbuh Kembang Anak',
            icon: Icons.child_care,
            color: Color(0xFF10B981),
            items: [
              'Dukung tumbuh kembang si kecil sesuai perkembangan anak usianya:',
              '• Main bola, lompat tali',
              '• Latih untuk dapat mengikuti aturan permainan',
              '• Kenalkan nama-nama hari',
              '• Menyebut angka berurutan',
              '• Mengajak anak sikap gigi bersama dan melatih sikap gigi sendiri',
              '• Melatih memakai pakaian sendiri',
              '• Menguatkan kepercayaan diri anak',
            ],
          ),
        ],
        '1-2 Tahun': [
          const _MateriSection(
            title: 'Pelayanan Kesehatan',
            icon: Icons.local_hospital_outlined,
            color: Color(0xFF3B82F6),
            items: [
              'Bawa anak setiap bulan ke Posyandu/Puskesmas/Fasilitas Kesehatan untuk mendapatkan pelayanan:',
              '• Pemantauan pertumbuhan dan perkembangan',
              '• Ibu/Ayah/Keluarga mengikuti kelas Ibu Balita',
              '• Obat cacing',
            ],
          ),
          const _MateriSection(
            title: 'Pantau Tumbuh Kembang Anak',
            icon: Icons.child_care,
            color: Color(0xFF10B981),
            items: [
              'Stimulasi bayi pada rentang usia 1-2 tahun:',
              '• Mengenal nama, fungsi benda-benda',
              '• Bacakan buku, tanya jawab, bercerita',
              '• Menonton TV didampingi maksimal 1 jam, menyanyai',
              '• Cuci tangan, cebok, berpakaian, rapikan mainan',
              '• Melempar, menangkap, berlari, melompat',
            ],
          ),
        ],
        '2-3 Tahun': [
          const _MateriSection(
            title: 'Pelayanan Kesehatan',
            icon: Icons.local_hospital_outlined,
            color: Color(0xFF3B82F6),
            items: [
              'Bawa anak setiap bulan ke Posyandu/Puskesmas/Fasilitas Kesehatan untuk mendapatkan pelayanan:',
              '• Pemantauan pertumbuhan dan perkembangan',
              '• Ibu/Ayah/Keluarga mengikuti kelas Ibu Balita',
              '• Obat cacing',
            ],
          ),
          const _MateriSection(
            title: 'Pantau Tumbuh Kembang Anak',
            icon: Icons.child_care,
            color: Color(0xFF10B981),
            items: [
              'Stimulasi bayi pada rentang usia 2-3 tahun:',
              '• Makan dengan sendok garpu, masak-masakan',
              '• Menggunting, menempel, menjahit',
              '• Menyusun balok, memasang puzzle, menggambar, mewarnai, menulis nama',
              '• Membuang, mengerti aturan dan urutan',
              '• Membandingkan besar kecil, banyak sedikit',
              '• Menghitung, konsep satu dan sekelompok',
              '• Mengenal angka, huruf, simbol, jam, lidi, menyanyai',
              '• Memanjat, meraya, sepeda roda 3, ayunan',
              '• Bermain berjualan, bertukang, dan mengukur',
            ],
          ),
        ],
        '3-4 Tahun': [
          const _MateriSection(
            title: 'Pelayanan Kesehatan',
            icon: Icons.local_hospital_outlined,
            color: Color(0xFF3B82F6),
            items: [
              'Bawa anak setiap bulan ke Posyandu/Puskesmas/Fasilitas Kesehatan:',
              '• Pemantauan pertumbuhan dan perkembangan',
              '• Ibu/Ayah/Keluarga mengikuti kelas Ibu Balita',
              '• Obat cacing',
            ],
          ),
          const _MateriSection(
            title: 'Pantau Tumbuh Kembang Anak',
            icon: Icons.child_care,
            color: Color(0xFF10B981),
            items: [
              'Stimulasi bayi pada rentang usia 3-4 tahun:',
              '• Bermain peran, pura-pura',
              '• Bercerita, bernyanyi, berdoa',
              '• Mengenal huruf, angka, bentuk, warna',
              '• Bermain pasir, air, tanah liat',
              '• Mengenal konsep waktu dan musim',
              '• Latih kemandirian: makan, berpakaian, mandi sendiri',
            ],
          ),
        ],
        '4-5 Tahun': [
          const _MateriSection(
            title: 'Pelayanan Kesehatan',
            icon: Icons.local_hospital_outlined,
            color: Color(0xFF3B82F6),
            items: [
              'Bawa anak setiap bulan ke Posyandu/Puskesmas/Fasilitas Kesehatan:',
              '• Pemantauan pertumbuhan dan perkembangan',
              '• Ibu/Ayah/Keluarga mengikuti kelas Ibu Balita',
              '• Obat cacing',
            ],
          ),
          const _MateriSection(
            title: 'Perawatan Gigi',
            icon: Icons.sentiment_satisfied_alt_outlined,
            color: Color(0xFF8B5CF6),
            items: [
              'Lanjutkan perawatan gigi dengan mengingatkan anak menyikat gigi setelah makan dan sebelum tidur.',
            ],
          ),
          const _MateriSection(
            title: 'Pantau Tumbuh Kembang Anak',
            icon: Icons.child_care,
            color: Color(0xFF10B981),
            items: [
              'Stimulasi bayi pada rentang usia 4-5 tahun:',
              '• Main bola, lompat tali',
              '• Latih untuk dapat mengikuti aturan permainan',
              '• Kenalkan nama-nama hari',
              '• Menyebut angka berurutan',
              '• Mengajak anak sikap gigi bersama dan melatih sikap gigi sendiri',
              '• Melatih memakai pakaian sendiri',
              '• Menguatkan kepercayaan diri anak',
            ],
          ),
        ],
        '5-6 Tahun': [
          const _MateriSection(
            title: 'Pelayanan Kesehatan',
            icon: Icons.local_hospital_outlined,
            color: Color(0xFF3B82F6),
            items: [
              'Bawa anak setiap bulan ke Posyandu/Puskesmas/Fasilitas Kesehatan:',
              '• Pemantauan pertumbuhan dan perkembangan',
              '• Ibu/Ayah/Keluarga mengikuti kelas Ibu Balita',
              '• Obat cacing',
            ],
          ),
          const _MateriSection(
            title: 'Perawatan Gigi',
            icon: Icons.sentiment_satisfied_alt_outlined,
            color: Color(0xFF8B5CF6),
            items: [
              'Lanjutkan perawatan gigi anak Anda dengan:',
              '• Gigi susu anak: sebanyak 20 buah, mulai tumbuh 2 gigi geraham 1 atap, rahang bawah pertama kiri dan kanan',
              '• Periksakan gigi secara rutin setiap 3-6 bulan sekali ke dokter gigi atau perawat gigi di Puskesmas atau fasilitas kesehatan lainnya',
            ],
          ),
          const _MateriSection(
            title: 'Pantau Tumbuh Kembang Anak',
            icon: Icons.child_care,
            color: Color(0xFF10B981),
            items: [
              'Stimulasi bayi pada rentang usia 5-6 tahun:',
              '• Makan dengan sendok garpu, masak-masakan',
              '• Menggunting, menempel, menjahit',
              '• Menyusun balok, memasang puzzle, menggambar, mewarnai, menulis nama',
              '• Membuang, mengerti aturan dan urutan',
              '• Membandingkan besar kecil, banyak sedikit',
              '• Menghitung, konsep satu dan sekelompok',
              '• Mengenal angka, huruf, simbol, jam, lidi, menyanyai',
              '• Memanjat, meraya, sepeda roda 3, ayunan',
              '• Bermain berjualan, bertukang, dan mengukur',
            ],
          ),
        ],
      };

  // ─────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Perawatan Perkembangan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            Text(
              _anakNama,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF059669), Color(0xFF34D399)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _buildKuesionerTab(),
    );
  }

  // ─────────────────────────────────────────────────────────
  // TAB 1: KUESIONER
  // ─────────────────────────────────────────────────────────
  Widget _buildKuesionerTab() {
    return Column(
      children: [
        // Anak info + tanggal bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFD1FAE5),
                child:
                    Icon(Icons.child_care, color: Color(0xFF059669), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_anakNama,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(_anakUsia,
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _pickTanggal,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF059669)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 14, color: Color(0xFF059669)),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(_tanggalPeriksa),
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF059669),
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Age range selector (horizontal scroll tabs)
        Container(
          color: Colors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: List.generate(_ageRanges.length, (i) {
                final isSelected = i == _selectedAgeIndex;
                final range = _ageRanges[i];
                final isDone = _submittedByRange[range] == true;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedAgeIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFF059669) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF059669)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isDone)
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Icon(
                                Icons.check_circle,
                                size: 13,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF059669),
                              ),
                            ),
                          Text(
                            range,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),

        const Divider(height: 1),

        Expanded(
          child: _buildRangeContent(_ageRanges[_selectedAgeIndex]),
        ),
      ],
    );
  }

  Widget _buildRangeContent(String range) {
    final isLoading = _loadingByRange[range] ?? true;
    final error = _errorByRange[range] ?? '';
    final kategori = _kategoriByRange[range] ?? [];
    final isSubmitting = _submittingByRange[range] ?? false;
    final checklist = _checklistByRange[range] ?? {};

    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF059669)),
            SizedBox(height: 12),
            Text('Memuat data...', style: TextStyle(color: Color(0xFF64748B))),
          ],
        ),
      );
    }

    if (error.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              Text('Gagal memuat data untuk $range',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.red)),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => _loadRangeData(range),
                style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF059669)),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final answeredCount = checklist.values.where((v) => v != null).length;
    final totalCount = kategori.length;

    return RefreshIndicator(
      color: const Color(0xFF059669),
      onRefresh: () => _loadRangeData(range),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Materi Perawatan ──
          _buildMateriSection(range),
          const SizedBox(height: 16),

          // ── Header Kuesioner ──
          _buildKuesionerHeader(range, answeredCount, totalCount),
          const SizedBox(height: 12),

          // ── Daftar Pertanyaan ──
          if (kategori.isEmpty)
            _buildEmptyKuesioner(range)
          else
            _buildChecklistTable(range, kategori, checklist, _submittedByRange[range] ?? false),

          const SizedBox(height: 16),

          // ── Tombol Simpan ──
          if (kategori.isNotEmpty)
            _buildSubmitButton(range, isSubmitting, answeredCount, totalCount),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Materi ──
  Widget _buildMateriSection(String range) {
    final sections = _materiByRange[range] ?? [];
    if (sections.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header materi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF059669), Color(0xFF34D399)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Icon(Icons.menu_book_outlined,
                    color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Perawatan Anak Umur $range',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        'Diisi oleh Ibu',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Sections
          ...sections.asMap().entries.map((entry) {
            final i = entry.key;
            final section = entry.value;
            return Column(
              children: [
                if (i > 0)
                  Divider(
                      height: 1,
                      color: Colors.grey.shade100,
                      indent: 16,
                      endIndent: 16),
                _buildSingleMateriSection(section),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSingleMateriSection(_MateriSection section) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: section.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(section.icon, color: section.color, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                section.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: section.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...section.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.5,
                    color: Color(0xFF374151),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  // ── Header Kuesioner ──
  Widget _buildKuesionerHeader(String range, int answered, int total) {
    final alreadySubmitted = _submittedByRange[range] ?? false;
    final lastDate = _tanggalPeriksaByRange[range];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF9C3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE047)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline,
                  size: 16, color: Color(0xFF713F12)),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Beri tanda ✓ (centang) pada kolom Ya/Tidak. Jika anak belum bisa melakukan salah satu dari hal berikut ini, segera bawa ke Puskesmas.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF713F12),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          if (total > 0) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: total > 0 ? answered / total : 0,
                minHeight: 6,
                backgroundColor: const Color(0xFFE5E7EB),
                color: const Color(0xFF059669),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$answered dari $total pertanyaan dijawab',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                ),
                if (alreadySubmitted && lastDate != null)
                  Text(
                    'Diisi: ${_formatDate(lastDate)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF059669),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyKuesioner(String range) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF94A3B8), size: 36),
          const SizedBox(height: 8),
          Text(
            'Kuesioner untuk $range belum tersedia',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  // ── Tabel Checklist Ya/Tidak ──
  Widget _buildChecklistTable(
    String range,
    List<KategoriCapaianModel> kategori,
    Map<int, bool?> checklist,
    bool isLocked,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF059669).withOpacity(0.08),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Text('No.',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF374151))),
                ),
                Expanded(
                  child: Text(
                    'Penanda Perkembangan Anak',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF374151)),
                  ),
                ),
                SizedBox(
                  width: 44,
                  child: Center(
                    child: Text('Ya',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF059669))),
                  ),
                ),
                SizedBox(
                  width: 52,
                  child: Center(
                    child: Text('Tidak',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDC2626))),
                  ),
                ),
              ],
            ),
          ),

          // Rows
          ...List.generate(kategori.length, (i) {
            final item = kategori[i];
            final jawaban = checklist[item.id];
            final isEven = i % 2 == 0;

            return Column(
              children: [
                Container(
                  color: isEven ? Colors.white : const Color(0xFFF8FAFC),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 30,
                          child: Text('${i + 1}',
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFF6B7280))),
                        ),
                        Expanded(
                          child: Text(
                            item.pertanyaanCeklist,
                            style: const TextStyle(
                              fontSize: 12.5,
                              height: 1.4,
                              color: Color(0xFF1E3A5F),
                            ),
                          ),
                        ),
                        // Ya checkbox
                        SizedBox(
                          width: 44,
                          child: Checkbox(
                            value: jawaban == true,
                            activeColor: const Color(0xFF059669),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            onChanged: isLocked ? null : (v) {
                              setState(() {
                                final map = Map<int, bool?>.from(
                                    _checklistByRange[range] ?? {});
                                map[item.id] = (v == true) ? true : null;
                                _checklistByRange[range] = map;
                              });
                            },
                          ),
                        ),
                        // Tidak checkbox
                        SizedBox(
                          width: 52,
                          child: Checkbox(
                            value: jawaban == false,
                            activeColor: const Color(0xFFDC2626),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            onChanged: isLocked ? null : (v) {
                              setState(() {
                                final map = Map<int, bool?>.from(
                                    _checklistByRange[range] ?? {});
                                map[item.id] = (v == true) ? false : null;
                                _checklistByRange[range] = map;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (i < kategori.length - 1)
                  Divider(height: 1, color: Colors.grey.shade100),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ── Tombol Simpan ──
  Widget _buildSubmitButton(
      String range, bool isSubmitting, int answered, int total) {
    final allAnswered = answered == total && total > 0;
    final alreadySubmitted = _submittedByRange[range] ?? false;
    final isDisabled = isSubmitting || alreadySubmitted;

    return Column(
      children: [
        SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed: isDisabled ? null : () => _submit(range),
            icon: isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : alreadySubmitted
                    ? const Icon(Icons.check_circle_outlined)
                    : const Icon(Icons.save_outlined),
            label: Text(
              isSubmitting
                  ? 'Menyimpan...'
                  : alreadySubmitted
                      ? 'Sudah Tersimpan ✓'
                      : allAnswered
                          ? 'Simpan Kuesioner'
                          : 'Simpan ($answered/$total)',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: alreadySubmitted
                  ? const Color(0xFF6B7280)
                  : allAnswered
                      ? const Color(0xFF059669)
                      : const Color(0xFFD1D5DB),
              foregroundColor: Colors.white,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
          ),
        ),
        if (alreadySubmitted) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF059669).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF059669).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    size: 16, color: Color(0xFF059669)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kuesioner untuk rentang usia ini sudah diisi',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF059669),
                        ),
                      ),
                      if (_tanggalPeriksaByRange[range] != null)
                        Text(
                          'Tanggal pengisian: ${_formatDate(_tanggalPeriksaByRange[range]!)}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF059669),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────
  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

// ─────────────────────────────────────────────────────────
// DATA CLASS
// ─────────────────────────────────────────────────────────
class _MateriSection {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> items;

  const _MateriSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });
}
