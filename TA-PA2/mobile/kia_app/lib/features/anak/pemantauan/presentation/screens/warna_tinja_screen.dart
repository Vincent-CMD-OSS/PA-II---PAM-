import 'package:flutter/material.dart';
import 'package:ta_pa2_pa3_project/features/anak/pemantauan/data/models/warna_tinja_model.dart';
import 'package:ta_pa2_pa3_project/features/anak/pemantauan/data/services/warna_tinja_api_service.dart';

class WarnaTinjaScreen extends StatefulWidget {
  final Map<String, dynamic> anak;

  const WarnaTinjaScreen({Key? key, required this.anak}) : super(key: key);

  @override
  State<WarnaTinjaScreen> createState() => _WarnaTinjaScreenState();
}

class _WarnaTinjaScreenState extends State<WarnaTinjaScreen> {
  final WarnaTinjaApiService _api = WarnaTinjaApiService();
  final Map<String, String> _periodeLabels = {
    '2_minggu': '2 Minggu',
    '1_bulan': '1 Bulan',
    '2_4_bulan': '2 - 4 Bulan',
  };
  final Map<String, DateTime?> _tanggalByPeriode = {
    '2_minggu': null,
    '1_bulan': null,
    '2_4_bulan': null,
  };
  final Map<String, int?> _nomorWarnaByPeriode = {
    '2_minggu': null,
    '1_bulan': null,
    '2_4_bulan': null,
  };

  bool _loading = true;
  bool _saving = false;

  int get _anakId {
    final dynamic id = widget.anak['id'];
    if (id is int) return id;
    if (id is num) return id.toInt();
    return int.tryParse(id?.toString() ?? '') ?? 0;
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final List<WarnaTinjaModel> rows = await _api.getByAnakId(_anakId);
      for (final row in rows) {
        if (!_periodeLabels.containsKey(row.periodeKey)) {
          continue;
        }
        _nomorWarnaByPeriode[row.periodeKey] =
            row.nomorWarna > 0 ? row.nomorWarna : null;
        _tanggalByPeriode[row.periodeKey] = DateTime.tryParse(row.tanggalCatat);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _pickDate(String periodeKey) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalByPeriode[periodeKey] ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
    );

    if (picked != null) {
      setState(() {
        _tanggalByPeriode[periodeKey] = picked;
      });
    }
  }

  String _fmtDate(DateTime? date) {
    if (date == null) return 'Pilih tanggal';
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    return '${date.year}-$mm-$dd';
  }

  Future<void> _simpan() async {
    final keys = _periodeLabels.keys.toList(growable: false);
    final filledCount = keys
        .where((k) =>
            _tanggalByPeriode[k] != null && _nomorWarnaByPeriode[k] != null)
        .length;

    if (filledCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi minimal 1 periode terlebih dahulu.')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      for (final key in keys) {
        final tanggal = _tanggalByPeriode[key];
        final nomor = _nomorWarnaByPeriode[key];
        if (tanggal == null || nomor == null) {
          continue;
        }
        await _api.save(
          anakId: _anakId,
          periodeKey: key,
          tanggalCatat: _fmtDate(tanggal),
          nomorWarna: nomor,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data warna tinja berhasil disimpan.')),
      );
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek Warna Tinja',
            style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF596182),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Periksa warna tinja bayi setiap hari.',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Periksa warna tinja bayi setiap hari hingga berumur 4 bulan, dan catat saat berumur 2 minggu, 1 bulan dan 1-4 bulan.',
                    style: TextStyle(fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Jika menemukan warna tinja lebih pucat mendekati nomor 1 sampai 3, segera bawa bayi ke dokter karena ada kemungkinan bayi menderita sumbatan kandung empedu (Atresia Bilier).',
                    style: TextStyle(fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Table(
                          border:
                              TableBorder.all(color: const Color(0xFF9E9E9E)),
                          columnWidths: const {
                            0: FixedColumnWidth(96),
                            1: FlexColumnWidth(),
                            2: FlexColumnWidth(),
                            3: FlexColumnWidth(),
                          },
                          children: [
                            TableRow(
                              decoration:
                                  const BoxDecoration(color: Color(0xFFEDE1A7)),
                              children: [
                                _headerCell('Usia'),
                                _headerCell(_periodeLabels['2_minggu']!),
                                _headerCell(_periodeLabels['1_bulan']!),
                                _headerCell(_periodeLabels['2_4_bulan']!),
                              ],
                            ),
                            TableRow(
                              children: [
                                _rowTitle('Tanggal\n(DD/MM/YYYY)'),
                                _dateCell('2_minggu'),
                                _dateCell('1_bulan'),
                                _dateCell('2_4_bulan'),
                              ],
                            ),
                            TableRow(
                              children: [
                                _rowTitle('Nomor\nWarna Tinja'),
                                _nomorCell('2_minggu'),
                                _nomorCell('1_bulan'),
                                _nomorCell('2_4_bulan'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: List.generate(7, (i) {
                          final nomor = i + 1;
                          final shades = [
                            const Color(0xFFF7F3D8),
                            const Color(0xFFEDE5B8),
                            const Color(0xFFE6D88D),
                            const Color(0xFFEBD130),
                            const Color(0xFFD9B126),
                            const Color(0xFFC99A22),
                            const Color(0xFFA59A2C),
                          ];
                          return Container(
                            width: 46,
                            height: 30,
                            margin: const EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              color: shades[i],
                              border:
                                  Border.all(color: const Color(0xFF9E9E9E)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$nomor',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Perhatikan warna tinja bayi sampai berumur 4 bulan. Jika mata bayi masih kuning atau urin berwarna kuning keruh setelah usia 2 minggu, segera bawa bayi ke dokter.',
                    style: TextStyle(fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _simpan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEA580C),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        _saving ? 'Menyimpan...' : 'Simpan Data',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }

  Widget _rowTitle(String text) {
    return SizedBox(
      height: 68,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _dateCell(String periodeKey) {
    return InkWell(
      onTap: () => _pickDate(periodeKey),
      child: SizedBox(
        height: 68,
        child: Center(
          child: Text(
            _tanggalByPeriode[periodeKey] == null
                ? 'Pilih'
                : _fmtDate(_tanggalByPeriode[periodeKey]),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: _tanggalByPeriode[periodeKey] == null
                  ? Colors.grey.shade600
                  : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _nomorCell(String periodeKey) {
    return SizedBox(
      height: 68,
      child: Center(
        child: DropdownButton<int>(
          value: _nomorWarnaByPeriode[periodeKey],
          hint: const Text('No.', style: TextStyle(fontSize: 11)),
          underline: const SizedBox.shrink(),
          items: List.generate(
            7,
            (index) => DropdownMenuItem<int>(
              value: index + 1,
              child: Text('${index + 1}', style: const TextStyle(fontSize: 12)),
            ),
          ),
          onChanged: (val) {
            setState(() {
              _nomorWarnaByPeriode[periodeKey] = val;
            });
          },
        ),
      ),
    );
  }
}
