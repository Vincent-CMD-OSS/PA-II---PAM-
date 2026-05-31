import 'package:flutter/material.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/services/pemantauan_ibu_hamil_api_service.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/models/pemantauan_ibu_hamil_model.dart';
import 'package:ta_pa2_pa3_project/core/themes/app_colors.dart';

class PemantauanIbuHamilScreen extends StatefulWidget {
  const PemantauanIbuHamilScreen({super.key});

  @override
  State<PemantauanIbuHamilScreen> createState() => _PemantauanIbuHamilScreenState();
}

class _PemantauanIbuHamilScreenState extends State<PemantauanIbuHamilScreen> {
  final _api = PemantauanIbuHamilApiService();

  int mingguKehamilan = 12;

  bool demamLebih2Hari = false;
  bool sakitKepala = false;
  bool cemasBerlebih = false;
  bool resikoTB = false;
  bool gerakanBayiKurang = false;
  bool nyeriPerut = false;
  bool cairanJalanLahir = false;
  bool masalahKemaluan = false;
  bool diareBerulang = false;

  bool _loading = false;
  bool _saving = false;

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

  void _showTopMessage(String text, {bool success = true}) {
    final overlay = Overlay.of(context);

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 70,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: success ? AppColors.primary : Colors.red,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  success ? Icons.check_circle_outline : Icons.error_outline,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 2), () {
      entry.remove();
    });
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    try {
      final list = await _api.getMine();

      PemantauanIbuHamilModel? data;

      for (final item in list) {
        if (item.mingguKehamilan == mingguKehamilan) {
          data = item;
          break;
        }
      }

      if (data != null) {
        setState(() {
          demamLebih2Hari = data!.demamLebih2Hari;
          sakitKepala = data.sakitKepala;
          cemasBerlebih = data.cemasBerlebih;
          resikoTB = data.resikoTB;
          gerakanBayiKurang = data.gerakanBayiKurang;
          nyeriPerut = data.nyeriPerut;
          cairanJalanLahir = data.cairanJalanLahir;
          masalahKemaluan = data.masalahKemaluan;
          diareBerulang = data.diareBerulang;
        });
      }
    } catch (e) {
      if (!mounted) return;
      _showTopMessage(e.toString(), success: false);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    try {
      await _api.save(
        PemantauanIbuHamilModel(
          mingguKehamilan: mingguKehamilan,
          demamLebih2Hari: demamLebih2Hari,
          sakitKepala: sakitKepala,
          cemasBerlebih: cemasBerlebih,
          resikoTB: resikoTB,
          gerakanBayiKurang: gerakanBayiKurang,
          nyeriPerut: nyeriPerut,
          cairanJalanLahir: cairanJalanLahir,
          masalahKemaluan: masalahKemaluan,
          diareBerulang: diareBerulang,
        ),
      );

      if (!mounted) return;

      _showTopMessage('Pemantauan berhasil disimpan');

      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) Navigator.pop(context);
      });
    } catch (e) {
      if (!mounted) return;
      _showTopMessage(e.toString(), success: false);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  int get _jumlahKeluhan => [
        demamLebih2Hari,
        sakitKepala,
        cemasBerlebih,
        resikoTB,
        gerakanBayiKurang,
        nyeriPerut,
        cairanJalanLahir,
        masalahKemaluan,
        diareBerulang,
      ].where((e) => e).length;

  bool get _adaKeluhan => _jumlahKeluhan > 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FF),
      appBar: AppBar(
        title: const Text('Pemantauan Ibu Hamil'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 16),
                _buildWeekCard(),
                const SizedBox(height: 16),
                _buildChecklistCard(),
                const SizedBox(height: 20),
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: _saving
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
                      _saving ? 'Menyimpan...' : 'Simpan Pemantauan',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

Widget _buildHeaderCard() {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xFFEFF6FF),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFBFDBFE)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.035),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: const Color(0xFFDBEAFE),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.health_and_safety_outlined,
            color: AppColors.primary,
            size: 30,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pemantauan Mingguan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 5),
              Text(
                _adaKeluhan
                    ? 'Ada $_jumlahKeluhan keluhan yang perlu diperhatikan'
                    : 'Tidak ada keluhan yang dicatat',
                style: TextStyle(
                  fontSize: 12,
                  color: _adaKeluhan ? AppColors.primary : const Color(0xFF7B8798),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildWeekCard() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE5ECF6)),
    ),
    child: Row(
      children: [
        const Icon(Icons.calendar_month_outlined, color: AppColors.primary),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Minggu Kehamilan',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ),
        DropdownButton<int>(
          value: mingguKehamilan,
          underline: const SizedBox(),
          items: List.generate(39, (index) {
            final week = index + 4;
            return DropdownMenuItem<int>(
              value: week,
              child: Text('Minggu $week'),
            );
          }),
          onChanged: _saving
              ? null
              : (value) {
                  if (value == null) return;
                  setState(() {
                    mingguKehamilan = value;
                    demamLebih2Hari = false;
                    sakitKepala = false;
                    cemasBerlebih = false;
                    resikoTB = false;
                    gerakanBayiKurang = false;
                    nyeriPerut = false;
                    cairanJalanLahir = false;
                    masalahKemaluan = false;
                    diareBerulang = false;
                  });
                  _loadData();
                },
        ),
      ],
    ),
  );
}

Widget _buildChecklistCard() {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFE5ECF6)),
    ),
    child: Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Tanda Bahaya / Keluhan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 12),
        _buildSwitch('Demam lebih dari 2 hari', 'Suhu tubuh tinggi atau tidak membaik', demamLebih2Hari, (v) => setState(() => demamLebih2Hari = v)),
        _buildSwitch('Sakit kepala', 'Sakit kepala berat atau menetap', sakitKepala, (v) => setState(() => sakitKepala = v)),
        _buildSwitch('Cemas berlebih', 'Merasa sangat gelisah atau khawatir', cemasBerlebih, (v) => setState(() => cemasBerlebih = v)),
        _buildSwitch('Risiko TB', 'Batuk lama atau gejala TB', resikoTB, (v) => setState(() => resikoTB = v)),
        _buildSwitch('Gerakan bayi berkurang', 'Gerakan janin lebih sedikit', gerakanBayiKurang, (v) => setState(() => gerakanBayiKurang = v)),
        _buildSwitch('Nyeri perut', 'Nyeri hebat atau tidak biasa', nyeriPerut, (v) => setState(() => nyeriPerut = v)),
        _buildSwitch('Keluar cairan dari jalan lahir', 'Air/lendir/cairan tidak biasa', cairanJalanLahir, (v) => setState(() => cairanJalanLahir = v)),
        _buildSwitch('Masalah pada kemaluan', 'Nyeri, gatal, luka, dll', masalahKemaluan, (v) => setState(() => masalahKemaluan = v)),
        _buildSwitch('Diare berulang', 'Diare sering atau tidak membaik', diareBerulang, (v) => setState(() => diareBerulang = v)),
      ],
    ),
  );
}

Widget _buildSwitch(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
  return InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: _saving ? null : () => onChanged(!value),
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: value ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value ? AppColors.primary : const Color(0xFFE5ECF6),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: value ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: value ? AppColors.primary : const Color(0xFFCBD5E1),
              ),
            ),
            child: value ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 11.5, color: Color(0xFF7B8798))),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}