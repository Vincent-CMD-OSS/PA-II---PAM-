import 'package:flutter/material.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/services/absensi_kelas_ibu_hamil_api_service.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/models/absensi_kelas_ibu_hamil_model.dart';

class AbsensiKelasIbuHamilScreen extends StatefulWidget {
  const AbsensiKelasIbuHamilScreen({super.key});

  @override
  State<AbsensiKelasIbuHamilScreen> createState() =>
      _AbsensiKelasIbuHamilScreenState();
}

class _AbsensiKelasIbuHamilScreenState
    extends State<AbsensiKelasIbuHamilScreen> {
  static const int _maxSesi = 9;

  final _apiService = AbsensiKelasIbuHamilApiService();

  final List<TextEditingController> _tanggalControllers = List.generate(
    _maxSesi,
    (_) => TextEditingController(),
  );

  final List<TextEditingController> _kaderControllers = List.generate(
    _maxSesi,
    (_) => TextEditingController(),
  );

  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadAbsensi();
  }

  @override
  void dispose() {
    for (final controller in [..._tanggalControllers, ..._kaderControllers]) {
      controller.dispose();
    }
    _apiService.dispose();
    super.dispose();
  }

  Future<void> _loadAbsensi() async {
    setState(() => _isLoading = true);

    try {
      final list = await _apiService.getMine();

      for (final item in list) {
        final index = item.pertemuanKe - 1;

        if (index >= 0 && index < _maxSesi) {
          _tanggalControllers[index].text = item.tanggal;
          _kaderControllers[index].text = item.namaKader;
        }
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickDate(int index) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
      helpText: 'Pilih tanggal hadir sesi ${index + 1}',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );

    if (picked == null) return;

    setState(() {
      _tanggalControllers[index].text = _formatDate(picked);
    });
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<void> _saveAbsensi() async {
    setState(() => _isSaving = true);

    try {
      int savedCount = 0;

      for (int i = 0; i < _maxSesi; i++) {
        final tanggal = _tanggalControllers[i].text.trim();
        final namaKader = _kaderControllers[i].text.trim();

        if (tanggal.isEmpty && namaKader.isEmpty) continue;

        await _apiService.save(
          AbsensiKelasIbuHamilModel(
            pertemuanKe: i + 1,
            tanggal: tanggal,
            namaKader: namaKader,
            tanggalParaf: tanggal,
          ),
        );

        savedCount++;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Absensi berhasil disimpan ($savedCount/$_maxSesi sesi).'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        title: const Text('Absensi Kelas Ibu Hamil'),
        backgroundColor: const Color(0xFF2F80ED),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildInfoCard(),
                const SizedBox(height: 16),
                _buildAttendanceTable(),
                const SizedBox(height: 20),
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveAbsensi,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(
                      _isSaving ? 'Menyimpan...' : 'Simpan Absensi',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F80ED),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5ECF6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF5D6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.fact_check_outlined,
              color: Color(0xFFE0A300),
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Absensi Kehadiran Kelas Ibu Hamil',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF172033),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Diisi oleh ibu. Catat tanggal hadir setiap sesi, lalu kader mengisi nama dan paraf pada kolom kanan.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF7B8798),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD7DEE9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            _buildHeaderRow(),
            ...List.generate(_maxSesi, _buildAttendanceRow),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      color: const Color(0xFFFFF0B8),
      child: Row(
        children: const [
          _TableHeaderCell(text: 'No.', flex: 1, alignment: TextAlign.center),
          _VerticalDividerLine(),
          _TableHeaderCell(text: 'Tanggal', flex: 4),
          _VerticalDividerLine(),
          _TableHeaderCell(text: 'Tanggal, Nama & Paraf Kader', flex: 5),
        ],
      ),
    );
  }

  Widget _buildAttendanceRow(int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: index == 0
                ? const Color(0xFFD7DEE9)
                : const Color(0xFFE8EDF4),
          ),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF172033),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const _VerticalDividerLine(),
            Expanded(
              flex: 4,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: TextFormField(
                  controller: _tanggalControllers[index],
                  readOnly: true,
                  enabled: !_isSaving,
                  onTap: () => _pickDate(index),
                  decoration: const InputDecoration(
                    hintText: 'Pilih tanggal',
                    suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
            const _VerticalDividerLine(),
            Expanded(
              flex: 5,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: TextFormField(
                  controller: _kaderControllers[index],
                  enabled: !_isSaving,
                  minLines: 1,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Nama & paraf kader',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  final String text;
  final int flex;
  final TextAlign alignment;

  const _TableHeaderCell({
    required this.text,
    required this.flex,
    this.alignment = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Text(
          text,
          textAlign: alignment,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2F2F2F),
          ),
        ),
      ),
    );
  }
}

class _VerticalDividerLine extends StatelessWidget {
  const _VerticalDividerLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      color: const Color(0xFFD7DEE9),
    );
  }
}