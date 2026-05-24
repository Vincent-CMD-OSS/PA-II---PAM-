import 'package:flutter/material.dart';
import 'package:ta_pa2_pa3_project/features/anak/pertumbuhan/data/services/pertumbuhan_api_service.dart';
import 'package:ta_pa2_pa3_project/features/anak/anak/data/models/anak_search_model.dart';
import 'package:ta_pa2_pa3_project/features/anak/pertumbuhan/data/models/master_standar_model.dart';
import 'package:ta_pa2_pa3_project/features/anak/pertumbuhan/data/models/pertumbuhan_model.dart';
import 'package:ta_pa2_pa3_project/features/anak/pertumbuhan/data/repositories/pertumbuhan_repository.dart';
import 'package:ta_pa2_pa3_project/features/anak/anak/presentation/widgets/index.dart';
import 'input_catatan_pertumbuhan_screen.dart';
import 'package:ta_pa2_pa3_project/features/anak/pemantauan/presentation/screens/perawatan/perawatan_screen_integrated.dart';

class DetailPertumbuhanScreen extends StatefulWidget {
  final AnakSearchModel anak;

  const DetailPertumbuhanScreen({
    Key? key,
    required this.anak,
  }) : super(key: key);

  @override
  State<DetailPertumbuhanScreen> createState() =>
      _DetailPertumbuhanScreenState();
}

class _DetailPertumbuhanScreenState extends State<DetailPertumbuhanScreen> {
  String _hitungUmur(String tanggalLahir) {
    try {
      final birthDate = DateTime.parse(tanggalLahir);
      final now = DateTime.now();

      int bulan =
          (now.year - birthDate.year) * 12 + (now.month - birthDate.month);

      return "$bulan bulan";
    } catch (e) {
      return "-";
    }
  }

  late PertumbuhanRepository _repository;

  List<PertumbuhanModel> _riwayatPertumbuhan = [];
  List<MasterStandarModel> _masterStandarBBU = [];
  List<MasterStandarModel> _masterStandarTBU = [];
  List<MasterStandarModel> _masterStandarBBTB = [];
  List<MasterStandarModel> _masterStandarIMTU = [];
  List<MasterStandarModel> _masterStandarLKU = [];

  bool _isLoading = true;
  String? _errorMessage;

  String _selectedTab = 'BB/U'; // Default tab

  @override
  void initState() {
    super.initState();
    _repository = PertumbuhanRepository(apiService: PertumbuhanApiService());
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final riwayat =
          await _repository.getRiwayatPertumbuhanByAnakId(widget.anak.id);

      // Mengurutkan riwayat berdasarkan tanggal ukur agar grafik selalu linear maju
      riwayat.sort((a, b) => a.tglUkur.compareTo(b.tglUkur));

      final masterBBU = await _repository.getMasterStandar(
          parameter: 'bb_u', jenisKelamin: widget.anak.jenisKelamin);
      final masterTBU = await _repository.getMasterStandar(
          parameter: 'tb_u', jenisKelamin: widget.anak.jenisKelamin);
      final masterBBTB = await _repository.getMasterStandar(
          parameter: 'bb_tb', jenisKelamin: widget.anak.jenisKelamin);
      final masterIMTU = await _repository.getMasterStandar(
          parameter: 'imt_u', jenisKelamin: widget.anak.jenisKelamin);
      final masterLKU = await _repository.getMasterStandar(
          parameter: 'lk_u', jenisKelamin: widget.anak.jenisKelamin);

      if (mounted) {
        setState(() {
          _riwayatPertumbuhan = riwayat;
          _masterStandarBBU = masterBBU;
          _masterStandarTBU = masterTBU;
          _masterStandarBBTB = masterBBTB;
          _masterStandarIMTU = masterIMTU;
          _masterStandarLKU = masterLKU;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  List<PertumbuhanModel> _getDataForTab() => _riwayatPertumbuhan;

  List<MasterStandarModel> _getMasterForTab() {
    switch (_selectedTab) {
      case 'TB/U':
        return _masterStandarTBU;
      case 'BB/TB':
        return _masterStandarBBTB;
      case 'IMT/U':
        return _masterStandarIMTU;
      case 'LK/U':
        return _masterStandarLKU;
      case 'BB/U':
      default:
        return _masterStandarBBU;
    }
  }

  double _getZScoreForTab(PertumbuhanModel data) {
    switch (_selectedTab) {
      case 'TB/U':
        return data.zScoreTBU;
      case 'BB/TB':
        return data.zScoreBBTB;
      case 'IMT/U':
        return data.zScoreIMTU;
      case 'LK/U':
        return data.zScoreLKU;
      case 'BB/U':
      default:
        return data.zScoreBBU;
    }
  }

  String _getStatusForTab(PertumbuhanModel data) {
    switch (_selectedTab) {
      case 'TB/U':
        return data.statusTBU;
      case 'BB/TB':
        return data.statusBBTB;
      case 'IMT/U':
        return data.statusIMTU;
      case 'LK/U':
        return data.statusLKU;
      case 'BB/U':
      default:
        return data.statusBBU;
    }
  }

  String _getXAxisLabel() =>
      _selectedTab == 'BB/TB' ? 'Tinggi Badan (cm)' : 'Usia (bulan)';

  String _getYAxisLabelFull() {
    switch (_selectedTab) {
      case 'TB/U':
        return 'Tinggi Badan (cm)';
      case 'IMT/U':
        return 'Indeks Massa Tubuh (kg/m²)';
      case 'LK/U':
        return 'Lingkar Kepala (cm)';
      case 'BB/U':
      case 'BB/TB':
      default:
        return 'Berat Badan (kg)';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pengganti WillPopScope menjadi PopScope
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.pop(context, _riwayatPertumbuhan.isNotEmpty);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () =>
                Navigator.pop(context, _riwayatPertumbuhan.isNotEmpty),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.anak.namaAnak,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${_hitungUmur(widget.anak.tanggalLahir)} • ${widget.anak.jenisKelamin}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          centerTitle: false,
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                    color: Color(0xFF2563EB), strokeWidth: 3),
              )
            : _errorMessage != null
                ? _buildErrorState()
                : _buildContentState(),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'Gagal memuat data',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Coba Lagi',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentState() {
    final latest =
        _riwayatPertumbuhan.isNotEmpty ? _riwayatPertumbuhan.last : null;
    final master = _getMasterForTab();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChildInfoBanner(anak: widget.anak),
            const SizedBox(height: 24),

            // Tab Bar horizontal
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['BB/U', 'TB/U', 'BB/TB', 'IMT/U', 'LK/U']
                    .map((tab) => _buildTabButton(tab))
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),

            if (latest != null && master.isNotEmpty) ...[
              /// 🔹 INFO TERAKHIR
              _buildMeasurementInfoCard(latest),
              const SizedBox(height: 16),

              /// 🔹 GRAFIK (dengan animasi saat ganti tab)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: GrowthChartWidget(
                  key: ValueKey(_selectedTab),
                  riwayatPertumbuhan: _getDataForTab(),
                  masterStandar: master,
                  yAxisLabel: _getYAxisLabelFull(),
                  selectedTab: _selectedTab,
                  xAxisLabel: _getXAxisLabel(),
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 STATUS GIZI
              ZScoreCardWidget(
                zScore: _getZScoreForTab(latest),
                statusText: _getStatusForTab(latest),
                categoryLabel: _selectedTab,
              ),
            ] else ...[
              _buildEmptyStateData(),
            ],

            const SizedBox(height: 20),

            /// 🔹 RIWAYAT (TIDAK DIUBAH)
            _buildRiwayatPengukuranCard(),
            const SizedBox(height: 24),

            /// 🔹 BUTTON TAMBAH (TIDAK DIUBAH)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: () async {
                  final updated = await Navigator.push<bool?>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InputCatatanPertumbuhanScreen(
                        anak: widget.anak,
                        repository: _repository,
                      ),
                    ),
                  );
                  if (updated ?? false) await _loadData();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                icon: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 14),
                ),
                label: const Text(
                  'Tambah data pertumbuhan',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            /// 🔹 BUTTON PERAWATAN
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PerawatanScreenIntegrated(
                        anakId: widget.anak.id,
                        anakName: widget.anak.namaAnak,
                      ),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFD97706),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                icon: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.check_circle, color: Colors.white, size: 14),
                ),
                label: const Text(
                  'Lihat perawatan & milestone',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStateData() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.bar_chart_outlined,
                size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('Belum ada data pengukuran',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementInfoCard(PertumbuhanModel data) {
    String lastValue = '';
    String lastValueUnit = '';

    switch (_selectedTab) {
      case 'TB/U':
        lastValue = data.tinggiBadan.toStringAsFixed(1);
        lastValueUnit = 'cm';
        break;
      case 'IMT/U':
        lastValue = data.imt.toStringAsFixed(1);
        lastValueUnit = 'kg/m²';
        break;
      case 'LK/U':
        lastValue = data.lingkarKepala.toStringAsFixed(1);
        lastValueUnit = 'cm';
        break;
      case 'BB/U':
      case 'BB/TB':
      default:
        lastValue = data.beratBadan.toStringAsFixed(1);
        lastValueUnit = 'kg';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pengukuran Terakhir',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600)),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: lastValue,
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2563EB))),
                    TextSpan(
                        text: ' $lastValueUnit',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600)),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Tanggal Ukur',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600)),
              const SizedBox(height: 8),
              Text(data.tglUkur,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label) {
    final isActive = _selectedTab == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = label),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2563EB) : Colors.white,
          border: Border.all(
              color: isActive ? const Color(0xFF2563EB) : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildRiwayatPengukuranCard() {
    if (_riwayatPertumbuhan.isEmpty) return const SizedBox.shrink();

    // Pastikan terurut terbaru di atas saat ditampilkan
    final reversedData = _riwayatPertumbuhan.reversed.toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Riwayat pengukuran (4 Terbaru)',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 16),
          ...reversedData.take(4).toList().asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            final isLatest =
                index == 0; // Karena sudah di reversed, 0 adalah terbaru
            return Column(
              children: [
                _buildRiwayatItem(data, isLatest),
                if (index !=
                    (reversedData.length > 4 ? 3 : reversedData.length - 1))
                  Divider(
                      color: Colors.grey.shade200, height: 16, thickness: 1),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRiwayatItem(PertumbuhanModel data, bool isLatest) {
    final dotColor = isLatest ? const Color(0xFF2563EB) : Colors.grey.shade400;
    final statusText = _getStatusForTab(data);
    final statusColors = _getStatusColor(statusText);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
                width: 12,
                height: 12,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: dotColor)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${data.tglUkur} · ${data.usiaUkurBulan} bulan',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
                const SizedBox(height: 4),
                Text(
                  'BB ${data.beratBadan.toStringAsFixed(1)} kg · TB ${data.tinggiBadan.toStringAsFixed(1)} cm\nLK ${data.lingkarKepala.toStringAsFixed(1)} cm · IMT ${data.imt.toStringAsFixed(1)}',
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade600, height: 1.4),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
                color: statusColors['bg'],
                borderRadius: BorderRadius.circular(12)),
            child: Text(statusText,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColors['text'])),
          ),
        ],
      ),
    );
  }

  Map<String, Color> _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
      case 'gizi baik':
        return {'bg': const Color(0xFFD1FAE5), 'text': const Color(0xFF059669)};
      case 'kurang':
      case 'gizi kurang':
      case 'lebih':
      case 'berisiko gizi lebih':
        return {'bg': const Color(0xFFFED7AA), 'text': const Color(0xFFD97706)};
      case 'sangat kurang':
      case 'gizi buruk':
      case 'sangat lebih':
      case 'obesitas':
        return {'bg': const Color(0xFFFECACA), 'text': const Color(0xFFDC2626)};
      default:
        return {'bg': Colors.grey.shade200, 'text': Colors.grey.shade600};
    }
  }
}
