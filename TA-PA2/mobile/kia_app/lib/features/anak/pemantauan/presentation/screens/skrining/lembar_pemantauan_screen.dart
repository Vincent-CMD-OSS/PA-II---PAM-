import 'package:flutter/material.dart';
import 'package:ta_pa2_pa3_project/core/services/auth_session.dart';
import 'package:ta_pa2_pa3_project/features/anak/pemantauan/data/services/lembar_pemantauan_api_service.dart';
import 'package:ta_pa2_pa3_project/features/anak/pemantauan/data/models/lembar_pemantauan_dynamic_model.dart';

class LembarPemantauanScreen extends StatefulWidget {
  final Map<String, dynamic>? anak;
  final String? initialRentangNama;

  const LembarPemantauanScreen({
    super.key,
    this.anak,
    this.initialRentangNama,
  });

  @override
  State<LembarPemantauanScreen> createState() => _LembarPemantauanScreenState();
}

class _LembarPemantauanScreenState extends State<LembarPemantauanScreen>
    with SingleTickerProviderStateMixin {
  final LembarPemantauanApiService _service = LembarPemantauanApiService();
  late TabController _tabController;

  int? _selectedPeriode = 1;
  final TextEditingController _namaPemeriksaController =
      TextEditingController(text: AuthSession.userName ?? 'Ibu');

  bool _loadingRentang = true;
  bool _loadingKategori = false;
  bool _submitting = false;
  bool _loadingRecords = false;

  List<RentangUsiaModel> _rentangUsia = const [];
  List<KategoriTandaSakitModel> _kategori = const [];
  List<LembarPemantauanModel> _lembarRecords = const [];
  // List<Map<String, dynamic>> _lembarRecords = const [];
  int? _selectedRentangId;
  final Map<int, bool> _checks = {};
  DateTime _tanggalPeriksa = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadRentangUsia();
    _loadLembarRecords();
  }

  @override
  void dispose() {
    _service.dispose();
    _namaPemeriksaController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadRentangUsia() async {
    setState(() {
      _loadingRentang = true;
    });

    try {
      final rentang = await _service.getRentangUsia();
      int? selectedId;
      if (rentang.isNotEmpty) {
        selectedId = rentang.first.id;
        final initialNama = widget.initialRentangNama?.toLowerCase().trim();
        if (initialNama != null && initialNama.isNotEmpty) {
          for (final item in rentang) {
            if (item.namaRentang.toLowerCase().trim() == initialNama) {
              selectedId = item.id;
              break;
            }
          }
        }
      }

      if (!mounted) return;
      setState(() {
        _rentangUsia = rentang;
        _selectedRentangId = selectedId;
        _loadingRentang = false;
      });

      if (selectedId != null) {
        await _loadKategori(selectedId);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingRentang = false;
      });
      _showError('Gagal memuat rentang usia: $e');
    }
  }

  Future<void> _loadKategori(int rentangUsiaId) async {
    setState(() {
      _loadingKategori = true;
      _kategori = const [];
      _checks.clear();
    });

    try {
      final kategori = await _service.getKategoriByRentangUsia(rentangUsiaId);
      if (!mounted) return;
      setState(() {
        _kategori = kategori;
        for (final item in kategori) {
          _checks[item.id] = false;
        }
        _loadingKategori = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingKategori = false;
      });
      _showError('Gagal memuat kategori gejala: $e');
    }
  }

  Future<void> _loadLembarRecords() async {
    setState(() {
      _loadingRecords = true;
    });

    try {
      final anakRaw = widget.anak?['id'];
      final anakId = anakRaw is int
          ? anakRaw
          : int.tryParse((anakRaw ?? '').toString()) ?? 0;

      if (anakId > 0) {
        final records = await _service.getRiwayatPemantauan(anakId);
        if (!mounted) return;
        setState(() {
          _lembarRecords = records;
        });
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Gagal memuat data riwayat pemantauan: $e');
    } finally {
      if (mounted) {
        setState(() {
          _loadingRecords = false;
        });
      }
    }
  }

  Future<void> _pickTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalPeriksa,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _tanggalPeriksa = picked;
      });
    }
  }

  Future<void> _submit() async {
    final anakRaw = widget.anak?['id'];
    final anakId = anakRaw is int
        ? anakRaw
        : int.tryParse((anakRaw ?? '').toString()) ?? 0;
    final rentangUsiaId = _selectedRentangId ?? 0;
    final periode = _selectedPeriode ?? 0;
    final namaPemeriksa = _namaPemeriksaController.text.trim();

    if (anakId <= 0) {
      _showError('Data anak tidak valid. Silakan pilih ulang anak.');
      return;
    }
    if (rentangUsiaId <= 0) {
      _showError('Rentang usia wajib dipilih.');
      return;
    }
    if (periode <= 0) {
      _showError('Periode pemeriksaan harus dipilih.');
      return;
    }
    if (namaPemeriksa.isEmpty) {
      _showError('Nama pemeriksa wajib diisi.');
      return;
    }
    if (_kategori.isEmpty) {
      _showError('Kategori gejala belum tersedia untuk rentang usia ini.');
      return;
    }

    final detailGejala = _kategori
        .map(
          (item) => {
            'kategori_tanda_sakit_id': item.id,
            'is_terjadi': _checks[item.id] ?? false,
          },
        )
        .toList();

    setState(() {
      _submitting = true;
    });

    try {
      await _service.createLembarPemantauan(
        anakId: anakId,
        rentangUsiaId: rentangUsiaId,
        periodeWaktu: periode,
        tanggalPeriksa: _formatDate(_tanggalPeriksa),
        namaPemeriksa: namaPemeriksa,
        detailGejala: detailGejala,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lembar pemantauan berhasil disimpan.')),
      );

      // Reload records
      await _loadLembarRecords();

      // Reset form
      setState(() {
        _selectedPeriode = 1;
        _checks.clear();
        _tanggalPeriksa = DateTime.now();
      });

      // Switch to records tab
      _tabController.animateTo(1);
    } catch (e) {
      _showError('Gagal menyimpan lembar pemantauan: $e');
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Color _getStatusParafColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _getStatusParafLabel(String status) {
    switch (status) {
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      default:
        return 'Menunggu';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
  title: const Text(
    'Lembar Pemantauan',
    style: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
  ),
  backgroundColor: Colors.white,
  elevation: 1, // biar ada bayangan tipis
  shadowColor: Colors.black12,
  centerTitle: false,

  iconTheme: const IconThemeData(
    color: Colors.black,
  ),

  bottom: TabBar(
    controller: _tabController,
    labelColor: Colors.black,
    unselectedLabelColor: Colors.grey,
    indicatorColor: Color(0xFF2563EB),
    indicatorWeight: 3,
    tabs: const [
      Tab(text: 'Isi Pemantauan'),
      Tab(text: 'Riwayat'),
    ],
  ),
),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFormTab(),
          _buildRecordsTab(),
        ],
      ),
    );
  }

  Widget _buildFormTab() {
    return _loadingRentang
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _loadRentangUsia,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildAnakInfoCard(),
                const SizedBox(height: 12),
                _buildFormCard(),
                const SizedBox(height: 16),
                _buildGejalaCard(),
                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Simpan Pemantauan'),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildRecordsTab() {
    return _loadingRecords
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _loadLembarRecords,
            child: _lembarRecords.isEmpty
                ? const Center(
                    child: Text('Belum ada data pemantauan'),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: _buildRecordsTable(),
                        ),
                      ),
                    ],
                  ),
          );
  }

  Widget _buildRecordsTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('No.')),
        DataColumn(label: Text('Rentang Usia')), // Tambahan info rentang usia
        DataColumn(label: Text('Periode')),
        DataColumn(label: Text('Tanggal')),
        DataColumn(label: Text('Pemeriksa')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Tgl Verifikasi')),
      ],
      rows: List<DataRow>.generate(
        _lembarRecords.length,
        (index) {
          final record = _lembarRecords[index];
          
          // Konversi status teks dari backend ('Diterima', 'Ditolak', 'Menunggu verifikasi') 
          // ke format yang sesuai dengan helper warna UI kamu
          String statusColorKey = 'pending';
          if (record.status == 'Diterima') statusColorKey = 'approved';
          if (record.status == 'Ditolak') statusColorKey = 'rejected';

          return DataRow(
            cells: [
              DataCell(Text((index + 1).toString())),
              DataCell(Text(record.rentangUsia?.namaRentang ?? '-')),
              DataCell(Text('Ke-${record.periodeWaktu}')),
              DataCell(Text(record.tanggalPeriksa)),
              DataCell(Text(record.namaPemeriksa.isNotEmpty ? record.namaPemeriksa : 'Ibu')),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusParafColor(statusColorKey).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    record.status,
                    style: TextStyle(
                      color: _getStatusParafColor(statusColorKey),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Jika statusnya sudah diubah Nakes, tampilkan tanggal update-nya
              DataCell(Text(record.status != 'Menunggu verifikasi' ? record.updatedAt : '-')),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnakInfoCard() {
  final nama = (widget.anak?['nama'] ?? 'Anak terpilih').toString();
  final usia =
      (widget.anak?['usia_teks'] ?? 'Usia belum tersedia').toString();

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        // Avatar
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFE0F2FE),
          ),
          child: const Icon(
            Icons.sentiment_satisfied_alt,
            color: Color(0xFF0284C7),
            size: 28,
          ),
        ),
        const SizedBox(width: 12),

        // Nama + usia
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nama,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),

              // Badge usia
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  usia,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1D4ED8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          DropdownButtonFormField<int>(
            value: _selectedRentangId,
            decoration: const InputDecoration(
              labelText: 'Rentang Usia',
              border: OutlineInputBorder(),
            ),
            items: _rentangUsia
                .map(
                  (item) => DropdownMenuItem<int>(
                    value: item.id,
                    child: Text(item.namaRentang),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null || value == _selectedRentangId) return;
              setState(() {
                _selectedRentangId = value;
              });
              _loadKategori(value);
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            value: _selectedPeriode,
            decoration: const InputDecoration(
              labelText: 'Periode Pemeriksaan',
              border: OutlineInputBorder(),
            ),
            items: List<int>.generate(12, (i) => i + 1)
                .map(
                  (p) => DropdownMenuItem<int>(
                    value: p,
                    child: Text('Pemeriksaan ke-$p'),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v == null) return;
              setState(() => _selectedPeriode = v);
            },
          ),
          const SizedBox(height: 12),
          // For ibu role show non-editable pemeriksa label; others can edit.
          if ((AuthSession.role ?? '').toLowerCase() == 'ibu')
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Text(
                'Pemeriksa: ${AuthSession.userName ?? 'Ibu'}',
                style: const TextStyle(color: Color(0xFF334155)),
              ),
            )
          else
            TextFormField(
              controller: _namaPemeriksaController,
              decoration: const InputDecoration(
                labelText: 'Nama Pemeriksa',
                border: OutlineInputBorder(),
              ),
            ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickTanggal,
            icon: const Icon(Icons.calendar_today),
            label: Text('Tanggal Periksa: ${_formatDate(_tanggalPeriksa)}'),
          ),
        ],
      ),
    );
  }

  Widget _buildGejalaCard() {
    if (_loadingKategori) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_kategori.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Text(
          'Belum ada kategori gejala untuk rentang usia ini.',
          style: TextStyle(color: Color(0xFF64748B)),
        ),
      );
    }

    final checkedCount = _checks.values.where((v) => v).length;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Checklist Gejala ($checkedCount dipilih)',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          ..._kategori.map(
            (item) => CheckboxListTile(
              value: _checks[item.id] ?? false,
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(item.gejala),
              subtitle: item.deskripsi.isEmpty ? null : Text(item.deskripsi),
              onChanged: (value) {
                setState(() {
                  _checks[item.id] = value ?? false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
