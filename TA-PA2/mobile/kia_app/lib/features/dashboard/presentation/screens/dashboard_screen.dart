import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ta_pa2_pa3_project/core/themes/app_theme.dart';
import 'package:ta_pa2_pa3_project/features/anak/mpasi/presentation/screens/mpasi_menu_screen.dart';
import 'package:ta_pa2_pa3_project/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:ta_pa2_pa3_project/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';
import 'package:ta_pa2_pa3_project/features/dashboard/presentation/widgets/dashboard_menu_card.dart';
import 'package:ta_pa2_pa3_project/features/dashboard/presentation/widgets/dashboard_phase_selector.dart';
import 'package:ta_pa2_pa3_project/features/dashboard/presentation/widgets/dashboard_quick_menu.dart';
import 'package:ta_pa2_pa3_project/features/dashboard/data/dashboard_menu_data.dart';
// MODUL IBU
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/perjalanan_hamil_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/absensi_kelas_ibu_hamil_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/rujukan_list_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/pemantauan_ibu_hamil_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/catatan_pelayanan_menu_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/log_ttd_mms_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/nifas/presentation/screens/nifas_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/persalinan_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/services/kehamilan_api_service.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/rujukan_list_screen.dart';
// MODUL ANAK
import 'package:ta_pa2_pa3_project/features/anak/anak/presentation/screens/anak/pilih_anak_screen.dart';
import 'package:ta_pa2_pa3_project/features/anak/anak/presentation/screens/anak/input_profil_anak_screen.dart';
import 'package:ta_pa2_pa3_project/features/anak/edukasi/presentation/screens/edukasi/edukasi_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/grafik_evaluasi_kehamilan_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/grafik_peningkatan_bb_screen.dart';
import 'package:ta_pa2_pa3_project/features/edukasi/presentation/screens/edukasi_screen_all.dart';
import 'package:ta_pa2_pa3_project/core/themes/app_colors.dart';
import 'package:ta_pa2_pa3_project/core/services/auth_session.dart';
import 'package:ta_pa2_pa3_project/features/ibu/nifas/presentation/screens/ringkasan_persalinan_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/nifas/presentation/screens/pelayanan_ibu_nifas_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/nifas/presentation/screens/catatan_pelayanan_nifas_screen.dart';
// BLOC 
import 'package:ta_pa2_pa3_project/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:ta_pa2_pa3_project/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:ta_pa2_pa3_project/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:ta_pa2_pa3_project/features/anak/anak/data/models/ibu_anak_model.dart';
// GEO
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/emergency_faskes_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc()..add(const LoadDashboardData()),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedNavIndex = 0;

  List<dynamic> _rujukanList = [];
  bool _loadingRujukan = false;

  final KehamilanApiService _kehamilanService = KehamilanApiService();

  // Helper formater yang tetap boleh tinggal di UI
  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  void initState() {
    super.initState();

    _loadRujukan();
  }

  Future<void> _loadRujukan() async {
    try {

      final kehamilan =
          await _kehamilanService
              .getKehamilanAktif();

      final data =
          await _kehamilanService
              .getRujukanByKehamilanId(
                kehamilan.id,
              );

      if (!mounted) return;

      setState(() {
        _rujukanList = data;
      });

    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_selectedNavIndex == 0) {
      body = BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DashboardError) {
            return Center(child: Text('Gagal memuat: ${state.message}'));
          }
          if (state is DashboardLoaded) {
            return _buildHomeBody(state);
          }
          return const SizedBox.shrink();
        },
      );
    } else if (_selectedNavIndex == 1) {
      body = const AbsensiKelasIbuHamilScreen();
    } else if (_selectedNavIndex == 2) {
      body = const EdukasiScreenAll();
    } else {
      body = const Center(child: Text('Profil'));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: body,
      bottomNavigationBar: DashboardBottomNav(
        currentIndex: _selectedNavIndex,
        onTap: (i) => setState(() => _selectedNavIndex = i),
      ),
    );
  }

  Widget _buildHomeBody(DashboardLoaded state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const DashboardHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                DashboardPhaseSelector(
                  selectedPhase: state.selectedPhase,
                  onPhaseSelected: (phase) {
                    context.read<DashboardBloc>().add(DashboardPhaseChanged(phase));
                  },
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF5FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, color: Color(0xFF2F80ED), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          state.contextualGuidanceText,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A), height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                if (state.selectedPhase == 'Hamil') _buildHamilContent(state),
                if (state.selectedPhase == 'Nifas') _buildNifasShortcut(),
                if (state.selectedPhase == 'Menyusui') _buildMenyusuiShortcut(),
                if (state.selectedPhase == 'Tumbuh') _buildTumbuhContent(state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // [MODUL: IBU - Hamil]
  // ─────────────────────────────────────────────
  Widget _buildHamilContent(DashboardLoaded state) {
    final kehamilan = state.kehamilanAktif;
    final week = kehamilan?.usiaKehamilanMinggu ?? 0;
    final progress = week > 0 ? (week / 40).clamp(0.0, 1.0) : 0.0;
    final trimester = kehamilan?.trimesterLabel ?? '-';
    final hpl = _formatDate(kehamilan?.taksiranPersalinan);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _openHamilJourney(state),
          child: DashboardInfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(week > 0 ? 'Kehamilan $week Minggu' : 'Kehamilan Aktif', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
                Text('$trimester • HPL: $hpl', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 16),
                LinearProgressIndicator(value: progress, backgroundColor: Colors.blue.shade50, color: TrimesterTheme.t1Primary, minHeight: 8),
                const SizedBox(height: 8),
                const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Minggu 1', style: TextStyle(fontSize: 10, color: Colors.grey)), Text('Minggu 40', style: TextStyle(fontSize: 10, color: Colors.grey))]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        DashboardInfoCard(
          child: Row(
            children: [
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Sebesar Buah Jagung', style: TextStyle(fontWeight: FontWeight.bold)), Text('Panjang janin sekitar 30 cm dengan berat sekitar 600 gram.', style: TextStyle(fontSize: 12, color: Colors.black54))])),
              Image.network('https://cdn-icons-png.flaticon.com/512/1141/1141771.png', width: 40),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Text('Menu Hamil', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 16),
        DashboardMenuCard(title: 'Kehamilan Trimester 1–3', subtitle: 'Pantau perkembangan kehamilan', icon: Icons.favorite_outline, iconColor: Colors.pink, onTap: () => _openHamilJourney(state)),
        DashboardMenuCard(title: 'Persalinan', subtitle: 'Persiapan & proses persalinan', icon: Icons.child_care_outlined, iconColor: Colors.blue, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PersalinanScreen()))),
        DashboardMenuCard(
          title: 'Surat Rekomendasi Rujukan',

          subtitle:
              _rujukanList.isNotEmpty
                  ? '${_rujukanList.length} surat rujukan tersedia'
                  : 'Belum ada surat rekomendasi rujukan saat ini',

          icon: Icons.description_outlined,

          iconColor: AppColors.blue500,

          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const RujukanListScreen(),
            ),
          ),

          isCompact: true,

          backgroundColor:
              AppColors.blue50,

          borderColor:
              AppColors.blue200,
        ),
        const SizedBox(height: 32),
        const Text('MENU CEPAT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 16),
        DashboardQuickMenu(
          crossAxisCount: 3,
          childAspectRatio: 0.88,
          items: DashboardMenuData.hamilQuickMenuItems.map((item) {
            return {
              ...item,
              'onTap': () {
                switch (item['key']) {
                  case 'rujukan': Navigator.push(context, MaterialPageRoute(builder: (_) => const RujukanListScreen()));
                  case 'bb_ibu': Navigator.push(context, MaterialPageRoute(builder: (_) => const GrafikPeningkatanBBScreen()));
                  case 'djj_tfu': Navigator.push(context, MaterialPageRoute(builder: (_) => const GrafikEvaluasiKehamilanScreen()));
                  case 'pemantauan': Navigator.push(context, MaterialPageRoute(builder: (_) => const PemantauanIbuHamilScreen()));
                  case 'catatan': Navigator.push(context, MaterialPageRoute(builder: (_) => const CatatanPelayananMenuScreen()));
                  case 'log_ttd':
                    if (kehamilan?.hpht == null) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data kehamilan belum tersedia'))); break; }
                    Navigator.push(context, MaterialPageRoute(builder: (_) => LogTTDMMSScreen(hpht: kehamilan!.hpht!)));
                  default: ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item['label']} belum tersedia')));
                }
              },
            };
          }).toList(),
        ),
        const SizedBox(height: 20),
        
        // 🆕 TOMBOL DARURAT FASKES (TARUH DI SINI)
        GestureDetector(
        onTap: () => Navigator.push(

          context,
            MaterialPageRoute(builder: (_) => const EmergencyFaskesScreen()),
        ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.shade300),
          ),
            child: const Row(
            children: [
                Icon(Icons.local_hospital_rounded, color: Colors.red),
                SizedBox(width: 12),
                Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text('Cari RS/Klinik Terdekat (Darurat)',
                          style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold)),
                      Text('Gunakan GPS untuk menemukan faskes terdekat saat keadaan darurat',
                          style: TextStyle(fontSize: 11, color: Colors.black54)),
                  ],
                ),
              ),
                Icon(Icons.chevron_right, color: Colors.red),
            ],
    ),
  ),
),
const SizedBox(height: 40),
      ],
    );
  }

  void _openHamilJourney(DashboardLoaded state) {
    final kehamilan = state.kehamilanAktif;
    if (kehamilan == null || kehamilan.hpht == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data HPHT belum tersedia')));
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => JourneyScreen(
      currentWeek: kehamilan.ukKehamilanSaatIni,
      gravida: kehamilan.gravida,
      paritas: kehamilan.paritas,
      abortus: kehamilan.abortus,
      hplText: kehamilan.taksiranPersalinan != null ? '${kehamilan.taksiranPersalinan!.day} / ${kehamilan.taksiranPersalinan!.month} / ${kehamilan.taksiranPersalinan!.year}' : '-',
      hphtText: '${kehamilan.hpht!.day} / ${kehamilan.hpht!.month} / ${kehamilan.hpht!.year}',
      hpht: kehamilan.hpht!,
    )));
  }

  // ─────────────────────────────────────────────
  // [MODUL: IBU - Nifas & Menyusui] (Tetap sama, tidak perlu state)
  // ─────────────────────────────────────────────
  Widget _buildNifasShortcut() {
    return Column(children: [
      DashboardMenuCard(title: 'Ringkasan Pelayanan Proses Melahirkan', subtitle: 'Lihat hasil pelayanan proses melahirkan', icon: Icons.child_friendly_rounded, iconColor: AppColors.primary, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RingkasanPersalinanScreen(token: AuthSession.token ?? '')))),
      DashboardMenuCard(title: 'Pemantauan Ibu Nifas', subtitle: 'Pantau masa nifas pasca persalinan', icon: Icons.person_outline, iconColor: AppColors.primary, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NifasScreen()))),
      DashboardMenuCard(title: 'Pelayanan Ibu Nifas', subtitle: 'Lihat catatan pelayanan ibu nifas', icon: Icons.medical_services_outlined, iconColor: AppColors.primary, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PelayananIbuNifasScreen()))),
      DashboardMenuCard(title: 'Catatan Pelayanan Nifas', subtitle: 'Lihat catatan pemeriksaan dan saran nifas', icon: Icons.note_alt_outlined, iconColor: AppColors.primary, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CatatanPelayananNifasScreen()))),
    ]);
  }

  Widget _buildMenyusuiShortcut() {
    return DashboardMenuCard(title: 'Menyusui', subtitle: 'Lihat edukasi menyusui dan ASI', icon: Icons.child_care_outlined, iconColor: Colors.orange, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EdukasiScreenAll())));
  }

  // ─────────────────────────────────────────────
  // [MODUL: ANAK - Tumbuh Kembang]
  // ─────────────────────────────────────────────
  Widget _buildTumbuhContent(DashboardLoaded state) {
    final anakSaya = state.anakSaya;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (anakSaya.isEmpty)
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InputProfilAnakScreen())),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(border: Border.all(color: Colors.blue.shade200), borderRadius: BorderRadius.circular(16), color: Colors.blue.shade50),
              child: const Row(children: [Icon(Icons.person_add, color: Colors.blue, size: 28), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Request Tambah Profil Anak', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)), SizedBox(height: 4), Text('Mulai pantau tumbuh kembang si kecil', style: TextStyle(fontSize: 12, color: Colors.black54))])), CircleAvatar(radius: 14, backgroundColor: Colors.blue, child: Icon(Icons.add, size: 16, color: Colors.white))]),
            ),
          )
        else
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: anakSaya.length,
              itemBuilder: (context, index) => _buildAnakCard(anakSaya[index]),
            ),
          ),
        const SizedBox(height: 24),
        const Text('MENU CEPAT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 16),
        DashboardTumbuhQuickMenu(
          items: DashboardMenuData.tumbuhQuickMenuItems.map((item) {
            return {
              ...item,
              'onTap': () {
                switch (item['key']) {
                  case 'pertumbuhan': Navigator.push(context, MaterialPageRoute(builder: (_) => const PilihAnakScreen()));
                  case 'imunisasi': Navigator.push(context, MaterialPageRoute(builder: (_) => const PilihAnakScreen(tujuan: 'imunisasi')));
                  case 'mpasi': Navigator.push(context, MaterialPageRoute(builder: (_) => const MpasiMenuScreen()));
                  case 'edukasi': Navigator.push(context, MaterialPageRoute(builder: (_) => const EdukasiScreenAll()));
                  case 'bahaya': Navigator.push(context, MaterialPageRoute(builder: (_) => const PilihAnakScreen(tujuan: 'bahaya')));
                  case 'pemantauan': Navigator.push(context, MaterialPageRoute(builder: (_) => const PilihAnakScreen(tujuan: 'pemantauan')));
                  case 'catatan': Navigator.push(context, MaterialPageRoute(builder: (_) => const PilihAnakScreen(tujuan: 'catatan')));
                  default: ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item['label']} belum tersedia')));
                }
              },
            };
          }).toList(),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PilihAnakScreen(tujuan: 'bahaya'))),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.orange.shade200)),
            child: const Row(children: [Icon(Icons.warning_amber_rounded, color: Colors.orange), SizedBox(width: 10), Expanded(child: Text('Kenali Tanda Bahaya — Segera ke faskes jika ada gejala ini', style: TextStyle(fontSize: 12))), Icon(Icons.chevron_right, color: Colors.orange)]),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildAnakCard(IbuAnakModel anak) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))], border: Border.all(color: Colors.blue.shade100, width: 1)),
      child: Row(
        children: [
          Container(width: 60, height: 60, decoration: BoxDecoration(color: const Color(0xFF1E52A8), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.person_outline, color: Colors.white, size: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(anak.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E3A8A)), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(anak.usiaTeks, style: const TextStyle(fontSize: 13, color: Colors.black54)),
              Text(anak.jenisKelamin, style: const TextStyle(fontSize: 13, color: Colors.black54)),
            ]),
          ),
        ],
      ),
    );
  }
}