import 'package:flutter/material.dart';
import 'package:ta_pa2_pa3_project/core/constants/app_colors.dart';
import 'package:ta_pa2_pa3_project/core/services/auth_session.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/services/kehamilan_api_service.dart';

import '../../data/models/checklist_pemantauan_ibu_nifas_model.dart';
import '../../data/repositories/checklist_pemantauan_ibu_nifas_repository.dart';
import '../../data/services/checklist_pemantauan_ibu_nifas_service.dart';

class ChecklistPemantauanIbuNifasScreen extends StatefulWidget {
  final List<int> filledDays;

  const ChecklistPemantauanIbuNifasScreen({
    super.key,
    this.filledDays = const [],
  });

  @override
  State<ChecklistPemantauanIbuNifasScreen> createState() =>
      _ChecklistPemantauanIbuNifasScreenState();
}

class _ChecklistPemantauanIbuNifasScreenState
    extends State<ChecklistPemantauanIbuNifasScreen> {
  final _kehamilanService = KehamilanApiService();

  late ChecklistPemantauanIbuNifasRepository repository;

  int? selectedHariNifas;
  bool isLoading = false;

  bool pemeriksaanNifas = false;
  bool konsumsiVitaminA = false;
  bool pemenuhanGizi = false;
  bool demamLebih38 = false;
  bool sakitKepala = false;
  bool pandanganKabur = false;
  bool nyeriUluHati = false;
  bool masalahKesehatanJiwa = false;

  bool jantungBerdebar = false;
  bool cairanJalanLahir = false;
  bool napasPendek = false;
  bool payudaraBermasalah = false;
  bool gangguanBak = false;
  bool kelaminBermasalah = false;
  bool darahNifasBerbau = false;
  bool pendarahanBerat = false;
  bool keputihan = false;

  @override
  void initState() {
    super.initState();

    repository = ChecklistPemantauanIbuNifasRepository(
      ChecklistPemantauanIbuNifasService(),
    );
  }

  Future<void> submitChecklist() async {
    if (isLoading) return;

    if (selectedHariNifas == null) {
      _showError('Pilih hari nifas terlebih dahulu');
      return;
    }

    if (widget.filledDays.contains(selectedHariNifas)) {
      _showError(
        'Hari nifas ke-$selectedHariNifas sudah diisi.',
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final token = AuthSession.token;

      if (token == null || token.isEmpty) {
        _showError('Silakan login ulang');
        return;
      }

      final kehamilan =
          await _kehamilanService.getKehamilanAktif();

      final model =
          ChecklistPemantauanIbuNifasModel(
        kehamilanId: kehamilan.id,
        hariNifas: selectedHariNifas!,

        pemeriksaanNifas:
            pemeriksaanNifas,

        konsumsiVitaminA:
            konsumsiVitaminA,

        pemenuhanGizi:
            pemenuhanGizi,

        demamLebih38:
            demamLebih38,

        sakitKepala:
            sakitKepala,

        pandanganKabur:
            pandanganKabur,

        nyeriUluHati:
            nyeriUluHati,

        masalahKesehatanJiwa:
            masalahKesehatanJiwa,

        jantungBerdebar:
            jantungBerdebar,

        cairanJalanLahir:
            cairanJalanLahir,

        napasPendek:
            napasPendek,

        payudaraBermasalah:
            payudaraBermasalah,

        gangguanBak:
            gangguanBak,

        kelaminBermasalah:
            kelaminBermasalah,

        darahNifasBerbau:
            darahNifasBerbau,

        pendarahanBerat:
            pendarahanBerat,

        keputihan:
            keputihan,
      );

      await repository.createChecklist(
        token: token,
        model: model,
      );

      if (!mounted) return;

      await _showSuccessDialog(
        'Checklist berhasil disimpan',
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      _showError(
        'Terjadi kesalahan: $e',
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _resetChecklist() {
    pemeriksaanNifas = false;
    konsumsiVitaminA = false;
    pemenuhanGizi = false;
    demamLebih38 = false;
    sakitKepala = false;
    pandanganKabur = false;
    nyeriUluHati = false;
    masalahKesehatanJiwa = false;
    jantungBerdebar = false;
    cairanJalanLahir = false;
    napasPendek = false;
    payudaraBermasalah = false;
    gangguanBak = false;
    kelaminBermasalah = false;
    darahNifasBerbau = false;
    pendarahanBerat = false;
    keputihan = false;
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _showSuccessDialog(
    String message,
  ) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  Colors.blue.shade50,
              child: Icon(
                Icons.check_rounded,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Berhasil Disimpan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: Text(
              'Kembali ke Nifas',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int get _dangerCount => [
        demamLebih38,
        sakitKepala,
        pandanganKabur,
        nyeriUluHati,
        masalahKesehatanJiwa,
        jantungBerdebar,
        cairanJalanLahir,
        napasPendek,
        payudaraBermasalah,
        gangguanBak,
        kelaminBermasalah,
        darahNifasBerbau,
        pendarahanBerat,
        keputihan,
      ].where((v) => v).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Pemantauan Ibu Nifas',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          18,
          18,
          18,
          28,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _headerCard(),
            const SizedBox(height: 16),
            _daySelector(),
            selectedHariNifas == null
                ? _emptyChecklistHint()
                : _checklistForm(),
          ],
        ),
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            Colors.blue.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
            BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.health_and_safety_outlined,
            color: Colors.white,
            size: 34,
          ),
          const SizedBox(height: 14),
          const Text(
            'Checklist Harian Masa Nifas',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            selectedHariNifas == null
                ? 'Pilih hari nifas terlebih dahulu.'
                : 'Hari nifas ke-$selectedHariNifas.',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _daySelector() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        top: 16,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
      ),
      child: DropdownButtonFormField<int>(
        value: selectedHariNifas,
        decoration: InputDecoration(
          hintText: 'Pilih hari nifas',
          prefixIcon: Icon(
            Icons.calendar_month_outlined,
            color: AppColors.primary,
          ),
          filled: true,
          fillColor: Colors.blue.shade50,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        items: List.generate(
          42,
          (index) {
            final day = index + 1;

            final isFilled =
                widget.filledDays.contains(
              day,
            );

            return DropdownMenuItem<int>(
              value: day,
              enabled: !isFilled,
              child: Text(
                isFilled
                    ? 'Hari ke-$day - Sudah diisi'
                    : 'Hari ke-$day',
              ),
            );
          },
        ),
        onChanged: isLoading
            ? null
            : (value) {
                if (value == null) return;

                setState(() {
                  selectedHariNifas =
                      value;
                  _resetChecklist();
                });
              },
      ),
    );
  }

  Widget _emptyChecklistHint() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        top: 16,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.touch_app_outlined,
            size: 40,
            color: Colors.blue,
          ),
          SizedBox(height: 12),
          Text(
            'Pilih hari nifas terlebih dahulu',
          ),
        ],
      ),
    );
  }

  Widget _checklistForm() {
    return Column(
      children: [
        const SizedBox(height: 18),

        _checkItem(
          title: 'Pemeriksaan nifas',
          value: pemeriksaanNifas,
          onChanged: (v) => setState(
            () => pemeriksaanNifas =
                v ?? false,
          ),
        ),

        _checkItem(
          title: 'Konsumsi vitamin A',
          value: konsumsiVitaminA,
          onChanged: (v) => setState(
            () => konsumsiVitaminA =
                v ?? false,
          ),
        ),

        _checkItem(
          title: 'Pemenuhan gizi',
          value: pemenuhanGizi,
          onChanged: (v) => setState(
            () => pemenuhanGizi =
                v ?? false,
          ),
        ),

        _checkItem(
          title: 'Demam > 38°C',
          value: demamLebih38,
          onChanged: (v) => setState(
            () => demamLebih38 =
                v ?? false,
          ),
        ),

        _checkItem(
          title: 'Sakit kepala',
          value: sakitKepala,
          onChanged: (v) => setState(
            () => sakitKepala =
                v ?? false,
          ),
        ),

        _checkItem(
          title: 'Pandangan kabur',
          value: pandanganKabur,
          onChanged: (v) => setState(
            () => pandanganKabur =
                v ?? false,
          ),
        ),

        _checkItem(
          title: 'Nyeri ulu hati',
          value: nyeriUluHati,
          onChanged: (v) => setState(
            () => nyeriUluHati =
                v ?? false,
          ),
        ),

        _checkItem(
          title:
              'Masalah kesehatan jiwa',
          value: masalahKesehatanJiwa,
          onChanged: (v) => setState(
            () =>
                masalahKesehatanJiwa =
                    v ?? false,
          ),
        ),

        const SizedBox(height: 22),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed:
                isLoading
                    ? null
                    : submitChecklist,
            icon:
                isLoading
                    ? const SizedBox(
                      width: 18,
                      height: 18,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Icon(
                        Icons.save_outlined,
                      ),
            label: Text(
              isLoading
                  ? 'Menyimpan...'
                  : 'Simpan Checklist',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.primary,
              foregroundColor:
                  Colors.white,
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _checkItem({
    required String title,
    required bool value,
    required ValueChanged<bool?>
        onChanged,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged:
            isLoading ? null : onChanged,
        activeColor: AppColors.primary,
        title: Text(title),
        controlAffinity:
            ListTileControlAffinity
                .leading,
      ),
    );
  }
}