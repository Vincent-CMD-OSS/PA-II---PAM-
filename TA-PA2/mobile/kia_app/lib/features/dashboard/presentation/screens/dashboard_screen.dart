// import 'package:flutter/material.dart';
// import 'package:ta_pa2_pa3_project/core/themes/app_theme.dart';
// import 'package:ta_pa2_pa3_project/features/dashboard/presentation/widgets/dashboard_header.dart';
// import 'package:ta_pa2_pa3_project/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';
// import 'package:ta_pa2_pa3_project/features/dashboard/presentation/widgets/dashboard_menu_card.dart';
// import 'package:ta_pa2_pa3_project/features/dashboard/presentation/widgets/dashboard_phase_selector.dart';
// import 'package:ta_pa2_pa3_project/features/dashboard/presentation/widgets/dashboard_quick_menu.dart';
// import 'package:ta_pa2_pa3_project/features/dashboard/data/dashboard_menu_data.dart';
// // MODUL IBU
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/perjalanan_hamil_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/services/kehamilan_api_service.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/models/kehamilan_aktif_model.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/absensi_kelas_ibu_hamil_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/rujukan_list_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/pemantauan_ibu_hamil_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/catatan_pelayanan_menu_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/log_ttd_mms_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/nifas/presentation/screens/nifas_screen.dart';
// // MODUL ANAK
// import 'package:ta_pa2_pa3_project/features/anak/tumbuh_kembang/presentation/screens/anak/pilih_anak_screen.dart';
// import 'package:ta_pa2_pa3_project/features/anak/tumbuh_kembang/presentation/screens/anak/input_profil_anak_screen.dart';
// import 'package:ta_pa2_pa3_project/features/anak/tumbuh_kembang/presentation/screens/anak/cari_anak_screen.dart';
// import 'package:ta_pa2_pa3_project/features/anak/tumbuh_kembang/presentation/screens/edukasi/edukasi_screen.dart';
// import 'package:ta_pa2_pa3_project/features/anak/tumbuh_kembang/data/models/ibu_anak_model.dart';
// import 'package:ta_pa2_pa3_project/features/anak/tumbuh_kembang/data/services/ibu_api_service.dart';
// // import 'package:ta_pa2_pa3_project/features/anak/tumbuh_kembang/presentation/screens/skrining/skrining_bahaya.dart';
// // MODUL CATATAN
// import 'package:ta_pa2_pa3_project/features/anak/tumbuh_kembang/presentation/screens/catatan/index.dart';
// // import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/grafik_evaluasi_kehamilan_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/grafik_evaluasi_kehamilan_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/grafik_peningkatan_bb_screen.dart';

// // import edukasi
// import 'package:ta_pa2_pa3_project/features/edukasi/presentation/screens/edukasi_screen_all.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   String _selectedPhase = 'Hamil';
//   int _selectedNavIndex = 0;

//   final _kehamilanService = KehamilanApiService();
//   bool _loadingKehamilan = false;
//   KehamilanAktifModel? _kehamilanAktif;

//   final _ibuApiService = IbuApiService();
//   bool _loadingAnak = false;
//   List<IbuAnakModel>? _anakSaya;

//   @override
//   void initState() {
//     super.initState();
//     _loadKehamilanAktif();
//     _loadDataAnak();
//   }

//   Future<void> _loadDataAnak() async {
//     setState(() => _loadingAnak = true);
//     try {
//       final anak = await _ibuApiService.getAnakSaya();
//       if (!mounted) return;
//       setState(() {
//         _anakSaya = anak;
//         _loadingAnak = false;
//       });
//     } catch (_) {
//       if (!mounted) return;
//       setState(() => _loadingAnak = false);
//     }
//   }

//   @override
//   void dispose() {
//     _ibuApiService.dispose();
//     super.dispose();
//   }

//   Future<void> _loadKehamilanAktif() async {
//     try {
//       final kehamilan = await _kehamilanService.getKehamilanAktif();
//       if (!mounted) return;
//       setState(() => _kehamilanAktif = kehamilan);
//     } catch (_) {}
//   }

//   // Future<void> _openHamilJourney() async {
//   //   if (_loadingKehamilan) return;
//   //   setState(() => _loadingKehamilan = true);
//   //   try {
//   //     final kehamilan = await _kehamilanService.getKehamilanAktif();
//   //     if (!mounted) return;
//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder: (_) => JourneyScreen(
//   //           currentWeek: kehamilan.ukKehamilanSaatIni,
//   //           gravida: kehamilan.gravida,
//   //           paritas: kehamilan.paritas,
//   //           abortus: kehamilan.abortus,
//   //           hplText: kehamilan.taksiranPersalinan != null
//   //               ? '${kehamilan.taksiranPersalinan!.day} / ${kehamilan.taksiranPersalinan!.month} / ${kehamilan.taksiranPersalinan!.year}'
//   //               : '-',
//   //           hphtText: kehamilan.hpht != null
//   //               ? '${kehamilan.hpht!.day} / ${kehamilan.hpht!.month} / ${kehamilan.hpht!.year}'
//   //               : '-',
//   //         ),
//   //       ),
//   //     );
//   //   } catch (e) {
//   //     if (!mounted) return;
//   //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
//   //   } finally {
//   //     if (mounted) setState(() => _loadingKehamilan = false);
//   //   }
//   // }

//   Future<void> _openHamilJourney() async {
//     if (_loadingKehamilan) return;
//     setState(() => _loadingKehamilan = true);
//     try {
//       final kehamilan = await _kehamilanService.getKehamilanAktif();
//       if (!mounted) return;

//       // Safety check: pastikan hpht tidak null
//       if (kehamilan.hpht == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Data HPHT belum tersedia')),
//         );
//         return;
//       }

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => JourneyScreen(
//             currentWeek: kehamilan.ukKehamilanSaatIni,
//             gravida: kehamilan.gravida,
//             paritas: kehamilan.paritas,
//             abortus: kehamilan.abortus,
//             hplText: kehamilan.taksiranPersalinan != null
//                 ? '${kehamilan.taksiranPersalinan!.day} / ${kehamilan.taksiranPersalinan!.month} / ${kehamilan.taksiranPersalinan!.year}'
//                 : '-',
//             hphtText:
//                 '${kehamilan.hpht!.day} / ${kehamilan.hpht!.month} / ${kehamilan.hpht!.year}',
//             hpht: kehamilan.hpht!, // ✅ pakai kehamilan, bukan _kehamilanAktif
//           ),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(e.toString())));
//     } finally {
//       if (mounted) setState(() => _loadingKehamilan = false);
//     }
//   }

//   String _trimesterLabel(int week) {
//     if (week <= 12) return 'Trimester 1';
//     if (week <= 27) return 'Trimester 2';
//     return 'Trimester 3';
//   }

//   String _formatDate(DateTime? date) {
//     if (date == null) return '-';
//     const months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'Mei',
//       'Jun',
//       'Jul',
//       'Agt',
//       'Sep',
//       'Okt',
//       'Nov',
//       'Des'
//     ];
//     return '${date.day} ${months[date.month - 1]} ${date.year}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget body;
//     if (_selectedNavIndex == 0) {
//       body = _buildHomeBody();
//     } else if (_selectedNavIndex == 1) {
//       body = const AbsensiKelasIbuHamilScreen();
//       // body = const Center(
//       //   child: Padding(
//       //     padding: EdgeInsets.all(20),
//       //     child: Text(
//       //       'Menu Catatan dapat diakses dari Menu Cepat di halaman Beranda',
//       //       textAlign: TextAlign.center,
//       //       style: TextStyle(fontSize: 16),
//       //     ),
//       //   ),
//       // );
//     } else if (_selectedNavIndex == 2) {
//       body = const EdukasiScreenAll();
//     } else {
//       body = const Center(child: Text('Profil'));
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F5F9),
//       body: body,
//       bottomNavigationBar: DashboardBottomNav(
//         currentIndex: _selectedNavIndex,
//         onTap: (i) => setState(() => _selectedNavIndex = i),
//       ),
//     );
//   }

//   Widget _buildHomeBody() {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           const DashboardHeader(),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 24),
//                 // [WIDGET: DashboardPhaseSelector]
//                 DashboardPhaseSelector(
//                   selectedPhase: _selectedPhase,
//                   onPhaseSelected: (phase) =>
//                       setState(() => _selectedPhase = phase),
//                 ),
//                 const SizedBox(height: 32),
//                 if (_selectedPhase == 'Hamil') _buildHamilContent(),
//                 if (_selectedPhase == 'Nifas') _buildNifasShortcut(),
//                 if (_selectedPhase == 'Menyusui') _buildMenyusuiShortcut(),
//                 if (_selectedPhase == 'Tumbuh') _buildTumbuhContent(),
//                 if (_selectedPhase != 'Hamil' &&
//                     _selectedPhase != 'Nifas' &&
//                     _selectedPhase != 'Menyusui' &&
//                     _selectedPhase != 'Tumbuh')
//                   _buildPlaceholderContent(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNifasShortcut() {
//     return DashboardMenuCard(
//       title: 'Nifas',
//       subtitle: 'Pantau masa nifas pasca persalinan',
//       icon: Icons.person_outline,
//       iconColor: Colors.teal,
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const NifasScreen()),
//       ),
//     );
//   }

//   Widget _buildMenyusuiShortcut() {
//     return DashboardMenuCard(
//       title: 'Menyusui',
//       subtitle: 'Lihat edukasi menyusui dan ASI',
//       icon: Icons.child_care_outlined,
//       iconColor: Colors.orange,
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => const EdukasiScreenAll(),
//         ),
//       ),
//     );
//   }

//   // ─────────────────────────────────────────────
//   // [MODUL: IBU - Hamil] Konten tab Hamil
//   // Urutan sesuai desain lib_desain:
//   //   1. Card progress kehamilan
//   //   2. Card buah janin
//   //   3. MENU CEPAT (6 item, 3 kolom)
//   //   4. Menu Hamil (card navigasi)
//   //   5. Banner surat rujukan
//   // ─────────────────────────────────────────────
//   Widget _buildHamilContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Progress kehamilan — klik navigasi ke JourneyScreen
//         InkWell(
//           borderRadius: BorderRadius.circular(20),
//           onTap: _openHamilJourney,
//           child: DashboardInfoCard(
//             child: Builder(builder: (_) {
//               final week = _kehamilanAktif?.ukKehamilanSaatIni ?? 0;
//               final progress = week > 0 ? (week / 40).clamp(0.0, 1.0) : 0.0;
//               final trimester = week > 0 ? _trimesterLabel(week) : '-';
//               final hpl = _formatDate(_kehamilanAktif?.taksiranPersalinan);
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         week > 0 ? 'Kehamilan $week Minggu' : 'Kehamilan Aktif',
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 16),
//                       ),
//                       const Icon(Icons.chevron_right, color: Colors.grey),
//                     ],
//                   ),
//                   Text('$trimester • HPL: $hpl',
//                       style: const TextStyle(color: Colors.grey, fontSize: 12)),
//                   const SizedBox(height: 16),
//                   LinearProgressIndicator(
//                     value: progress,
//                     backgroundColor: Colors.blue.shade50,
//                     color: TrimesterTheme.t1Primary,
//                     minHeight: 8,
//                   ),
//                   const SizedBox(height: 8),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('Minggu 1',
//                           style: TextStyle(fontSize: 10, color: Colors.grey)),
//                       Text('Minggu 40',
//                           style: TextStyle(fontSize: 10, color: Colors.grey)),
//                     ],
//                   ),
//                 ],
//               );
//             }),
//           ),
//         ),
//         const SizedBox(height: 16),

//         // Info insight janin
//         DashboardInfoCard(
//           child: Row(
//             children: [
//               const Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Sebesar Buah Jagung',
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                     Text(
//                       'Panjang janin sekitar 30 cm dengan berat sekitar 600 gram.',
//                       style: TextStyle(fontSize: 12, color: Colors.black54),
//                     ),
//                   ],
//                 ),
//               ),
//               Image.network(
//                 'https://cdn-icons-png.flaticon.com/512/1141/1141771.png',
//                 width: 40,
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 32),

//         // [WIDGET: DashboardQuickMenu] — 6 item, 3 kolom (sesuai desain lib_desain)
//         const Text('MENU CEPAT',
//             style: TextStyle(
//                 fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
//         const SizedBox(height: 16),

//         // DISINI TADINYA YANG QUICK MENU YANG MENIMPA ITU

//         // Menu Hamil — card navigasi
//         const Text('Menu Hamil',
//             style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87)),
//         const SizedBox(height: 16),

//         DashboardMenuCard(
//           title: 'Kehamilan Trimester 1–3',
//           subtitle: 'Pantau perkembangan kehamilan',
//           icon: Icons.favorite_outline,
//           iconColor: Colors.pink,
//           onTap: _openHamilJourney,
//         ),
//         DashboardMenuCard(
//           title: 'Persalinan',
//           subtitle: 'Persiapan & proses persalinan',
//           icon: Icons.child_care_outlined,
//           iconColor: Colors.blue,
//           onTap: () {},
//         ),
//         // DashboardMenuCard(
//         //   title: 'Grafik Evaluasi Kehamilan',
//         //   subtitle: 'Pantau TFU & DJJ selama kehamilan',
//         //   icon: Icons.show_chart_outlined,
//         //   iconColor: Colors.purple,
//         //   onTap: () => Navigator.push(
//         //     context,
//         //     MaterialPageRoute(
//         //       builder: (_) => const GrafikEvaluasiKehamilanScreen(),
//         //     ),
//         //   ),
//         // ),
//         const SizedBox(height: 32),

//         const Text('MENU CEPAT',
//             style: TextStyle(
//                 fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
//         const SizedBox(height: 16),

//         // [WIDGET: DashboardQuickMenu] — Menu cepat modul ibu
//         // DashboardQuickMenu(
//         //   items: DashboardMenuData.hamilQuickMenuItems.map((item) {
//         //     return {
//         //       ...item,
//         //       'onTap': () {
//         //         if (item['key'] == 'absensi') {
//         //           Navigator.push(context,
//         //               MaterialPageRoute(builder: (_) => const AbsensiKelasIbuHamilScreen()));
//         //           return;
//         //         }
//         //         if (item['key'] == 'catatan') {
//         //           Navigator.push(context,
//         //               MaterialPageRoute(builder: (_) => const CatatanMenuScreen()));
//         //           return;
//         //         }
//         //         ScaffoldMessenger.of(context).showSnackBar(
//         //             SnackBar(content: Text('${item['label']} belum tersedia')));
//         //       },
//         //     };
//         //   }).toList(),
//         // ),
//         // const SizedBox(height: 32),

//         DashboardQuickMenu(
//           crossAxisCount: 3,
//           childAspectRatio: 1.0,
//           items: DashboardMenuData.hamilQuickMenuItems.map((item) {
//             return {
//               ...item,
//               'onTap': () {
//                 switch (item['key']) {
//                   case 'rujukan':
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const RujukanListScreen()));
//                     break;
//                   case 'bb_ibu':
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) =>
//                                 // const GrafikEvaluasiKehamilanScreen()));
//                                 const GrafikPeningkatanBBScreen()));
//                     break;
//                   case 'djj_tfu':
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) =>
//                                 const GrafikEvaluasiKehamilanScreen()));
//                     break;
//                   case 'pemantauan':
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const PemantauanIbuHamilScreen()));
//                     break;
//                   case 'catatan':
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) =>
//                                 const CatatanPelayananMenuScreen()));
//                     break;
//                   // case 'log_ttd':
//                   //   Navigator.push(context,
//                   //       MaterialPageRoute(builder: (_) => const LogTTDMMSScreen()));
//                   //   break;
//                   case 'log_ttd':
//                     // Safety: cek dulu apakah data kehamilan tersedia
//                     if (_kehamilanAktif?.hpht == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content: Text('Data kehamilan belum tersedia')),
//                       );
//                       break;
//                     }
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => LogTTDMMSScreen(
//                           hpht: _kehamilanAktif!.hpht!,
//                         ),
//                       ),
//                     );
//                     break;
//                   default:
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: Text('${item['label']} belum tersedia')));
//                 }
//               },
//             };
//           }).toList(),
//         ),
//         const SizedBox(height: 32),

//         // [MODUL: IBU] Surat rujukan
//         _buildDangerAlert(),
//         const SizedBox(height: 40),
//       ],
//     );
//   }

//   // ─────────────────────────────────────────────
//   // [MODUL: ANAK - Tumbuh Kembang] Konten tab Tumbuh
//   // ─────────────────────────────────────────────
//   Widget _buildTumbuhContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (_loadingAnak)
//           const Center(
//             child: Padding(
//               padding: EdgeInsets.all(20),
//               child: CircularProgressIndicator(),
//             ),
//           )
//         else if (_anakSaya != null && _anakSaya!.isNotEmpty)
//           SizedBox(
//             height: 100,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               clipBehavior: Clip.none, // Supaya bayangan card tidak terpotong
//               itemCount: _anakSaya!.length,
//               itemBuilder: (context, index) {
//                 return _buildAnakCard(_anakSaya![index]);
//               },
//             ),
//           )
//         else
//           // Tampilkan tombol request tambah jika belum ada data anak
//           GestureDetector(
//             onTap: () => Navigator.push(context,
//                 MaterialPageRoute(builder: (_) => const InputProfilAnakScreen())),
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.blue.shade200),
//                 borderRadius: BorderRadius.circular(16),
//                 color: Colors.blue.shade50,
//               ),
//               child: const Row(
//                 children: [
//                   Icon(Icons.person_add, color: Colors.blue, size: 28),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Request Tambah Profil Anak',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600, fontSize: 14)),
//                         SizedBox(height: 4),
//                         Text('Mulai pantau tumbuh kembang si kecil',
//                             style:
//                                 TextStyle(fontSize: 12, color: Colors.black54)),
//                       ],
//                     ),
//                   ),
//                   CircleAvatar(
//                     radius: 14,
//                     backgroundColor: Colors.blue,
//                     child: Icon(Icons.add, size: 16, color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         const SizedBox(height: 24),

//         const Text('MENU CEPAT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
//         const SizedBox(height: 16),

//         // [WIDGET: DashboardTumbuhQuickMenu] — 6 menu cepat modul anak
//         DashboardTumbuhQuickMenu(
//           items: DashboardMenuData.tumbuhQuickMenuItems.map((item) {
//             return {
//               ...item,
//               'onTap': () {
//                 switch (item['key']) {
//                   case 'pertumbuhan':
//                     // [MODUL: ANAK] Pilih anak → DetailPertumbuhanScreen
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const PilihAnakScreen()));
//                     break;
//                   case 'imunisasi':
//                     // [MODUL: ANAK] Pilih anak → ImunisasiScreen
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) =>
//                                 const PilihAnakScreen(tujuan: 'imunisasi')));
//                     break;
//                   case 'mpasi':
//                     // [MODUL: ANAK] Pilih anak → HalamanUtamaMpasiScreen
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) =>
//                                 const PilihAnakScreen(tujuan: 'mpasi')));
//                     break;
//                   case 'edukasi':
//                     // [MODUL: ANAK] Langsung ke EdukasiScreen (tidak butuh pilih anak)
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const EdukasiScreen()));
//                     break;
//                   case 'bahaya':
//                     // [MODUL: ANAK] Pilih anak → SkriningBahayaScreen
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) =>
//                                 const PilihAnakScreen(tujuan: 'bahaya')));
//                     break;
//                   case 'pemantauan':
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) =>
//                                 const PilihAnakScreen(tujuan: 'pemantauan')));
//                     break;
//                   case 'catatan':
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const PilihAnakScreen(
//                           tujuan: 'catatan', // Arahkan tujuannya ke catatan
//                         ),
//                       ),
//                     );
//                     break;
//                   default:
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: Text('${item['label']} belum tersedia')));
//                 }
//               },
//             };
//           }).toList(),
//         ),
//         const SizedBox(height: 24),

//         // [MODUL: ANAK] Banner tanda bahaya — klik langsung ke SkriningBahayaScreen
//         GestureDetector(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (_) => const PilihAnakScreen(tujuan: 'bahaya')),
//           ),
//           child: Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//                 color: const Color(0xFFFFF3E0),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.orange.shade200)),
//             child: const Row(
//               children: [
//                 Icon(Icons.warning_amber_rounded, color: Colors.orange),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     'Kenali Tanda Bahaya — Segera ke faskes jika ada gejala ini',
//                     style: TextStyle(fontSize: 12),
//                   ),
//                 ),
//                 Icon(Icons.chevron_right, color: Colors.orange),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 40),
//       ],
//     );
//   }

//   Widget _buildPlaceholderContent() {
//     return const Center(
//       child: Padding(
//           padding: EdgeInsets.all(40),
//           child: Text('Konten fase ini segera hadir!')),
//     );
//   }

//   Widget _buildAnakCard(IbuAnakModel anak) {
//     return Container(
//       margin: const EdgeInsets.only(right: 16),
//       padding: const EdgeInsets.all(16),
//       width: MediaQuery.of(context).size.width * 0.75, // Biar card berikutnya ngintip
//       decoration: BoxDecoration(
//         color: const Color(0xFFEFF6FF), // Background biru sangat muda
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         border: Border.all(color: Colors.blue.shade100, width: 1),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               color: const Color(0xFF1E52A8), // Warna biru box icon
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: const Icon(Icons.person_outline, color: Colors.white, size: 32),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   anak.nama,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Color(0xFF1E3A8A), // Biru gelap untuk teks nama
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   anak.usiaTeks,
//                   style: const TextStyle(fontSize: 13, color: Colors.black54),
//                 ),
//                 Text(
//                   anak.jenisKelamin,
//                   style: const TextStyle(fontSize: 13, color: Colors.black54),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ─────────────────────────────────────────────
//   // [MODUL: IBU - Hamil] Banner surat rujukan
//   // ─────────────────────────────────────────────
//   Widget _buildDangerAlert() {
//     return InkWell(
//       borderRadius: BorderRadius.circular(16),
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const RujukanListScreen()),
//       ),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: const Color(0xFFEFF6FF),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.blue.shade100),
//         ),
//         child: Row(
//           children: [
//             Icon(Icons.description_outlined, color: Colors.blue.shade700),
//             const SizedBox(width: 12),
//             const Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Surat Rekomendasi Rujukan',
//                       style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.blue,
//                           fontWeight: FontWeight.bold)),
//                   Text('Belum ada surat rekomendasi rujukan saat ini',
//                       style: TextStyle(fontSize: 11, color: Colors.black54)),
//                 ],
//               ),
//             ),
//             const Icon(Icons.chevron_right, color: Colors.blue),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:ta_pa2_pa3_project/core/themes/app_theme.dart';
// import 'package:ta_pa2_pa3_project/features/anak/mpasi/presentation/screens/mpasi_menu_screen.dart';
// // import 'package:ta_pa2_pa3_project/features/anak/mpasi/presentation/screens/mpasi/halaman_utama_mpasi.dart';
// import 'package:ta_pa2_pa3_project/features/dashboard/presentation/widgets/dashboard_header.dart';
// import 'package:ta_pa2_pa3_project/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';
// import 'package:ta_pa2_pa3_project/features/dashboard/presentation/widgets/dashboard_menu_card.dart';
// import 'package:ta_pa2_pa3_project/features/dashboard/presentation/widgets/dashboard_phase_selector.dart';
// import 'package:ta_pa2_pa3_project/features/dashboard/presentation/widgets/dashboard_quick_menu.dart';
// import 'package:ta_pa2_pa3_project/features/dashboard/data/dashboard_menu_data.dart';
// // MODUL IBU
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/perjalanan_hamil_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/services/kehamilan_api_service.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/models/kehamilan_aktif_model.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/absensi_kelas_ibu_hamil_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/rujukan_list_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/pemantauan_ibu_hamil_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/catatan_pelayanan_menu_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/log_ttd_mms_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/nifas/presentation/screens/nifas_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/persalinan_screen.dart';
// // MODUL ANAK
// import 'package:ta_pa2_pa3_project/features/anak/anak/presentation/screens/anak/pilih_anak_screen.dart';
// import 'package:ta_pa2_pa3_project/features/anak/anak/presentation/screens/anak/input_profil_anak_screen.dart';
// // import 'package:ta_pa2_pa3_project/features/anak/anak/presentation/screens/anak/cari_anak_screen.dart';
// import 'package:ta_pa2_pa3_project/features/anak/edukasi/presentation/screens/edukasi/edukasi_screen.dart';
// import 'package:ta_pa2_pa3_project/features/anak/anak/data/models/ibu_anak_model.dart';
// import 'package:ta_pa2_pa3_project/features/anak/anak/data/services/ibu_api_service.dart';
// import 'package:ta_pa2_pa3_project/features/anak/tumbuh_kembang/presentation/screens/anak/pilih_anak_screen.dart';
// import 'package:ta_pa2_pa3_project/features/anak/tumbuh_kembang/presentation/screens/anak/input_profil_anak_screen.dart';
// import 'package:ta_pa2_pa3_project/features/anak/tumbuh_kembang/presentation/screens/anak/cari_anak_screen.dart';
// import 'package:ta_pa2_pa3_project/features/anak/tumbuh_kembang/data/models/ibu_anak_model.dart';
// import 'package:ta_pa2_pa3_project/features/anak/tumbuh_kembang/data/services/ibu_api_service.dart';
// // import 'package:ta_pa2_pa3_project/features/anak/tumbuh_kembang/presentation/screens/skrining/skrining_bahaya.dart';
// // MODUL CATATAN
// // import 'package:ta_pa2_pa3_project/features/anak/anak/presentation/widgets/index.dart';
// // import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/grafik_evaluasi_kehamilan_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/grafik_evaluasi_kehamilan_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/grafik_peningkatan_bb_screen.dart';

// // import edukasi
// import 'package:ta_pa2_pa3_project/features/edukasi/presentation/screens/edukasi_screen_all.dart';
// import 'package:ta_pa2_pa3_project/core/constants/app_colors.dart';
// import 'package:ta_pa2_pa3_project/core/services/auth_session.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/nifas/presentation/screens/ringkasan_persalinan_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/nifas/presentation/screens/pelayanan_ibu_nifas_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/nifas/presentation/screens/catatan_pelayanan_nifas_screen.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   String _selectedPhase = 'Hamil';
//   int _selectedNavIndex = 0;

//   final _kehamilanService = KehamilanApiService();
//   bool _loadingKehamilan = false;
//   KehamilanAktifModel? _kehamilanAktif;

//   final _ibuApiService = IbuApiService();
//   bool _loadingAnak = false;
//   List<IbuAnakModel>? _anakSaya;

//   @override
//   void initState() {
//     super.initState();
//     _loadKehamilanAktif();
//     _loadDataAnak();
//   }

//   Future<void> _loadDataAnak() async {
//     setState(() => _loadingAnak = true);
//     try {
//       final anak = await _ibuApiService.getAnakSaya();
//       if (!mounted) return;
//       setState(() {
//         _anakSaya = anak;
//         _loadingAnak = false;
//       });
//     } catch (_) {
//       if (!mounted) return;
//       setState(() => _loadingAnak = false);
//     }
//   }

//   @override
//   void dispose() {
//     _ibuApiService.dispose();
//     super.dispose();
//   }

//   Future<void> _loadKehamilanAktif() async {
//     try {
//       final kehamilan = await _kehamilanService.getKehamilanAktif();
//       if (!mounted) return;
//       setState(() => _kehamilanAktif = kehamilan);
//     } catch (_) {}
//   }

//   // Future<void> _openHamilJourney() async {
//   //   if (_loadingKehamilan) return;
//   //   setState(() => _loadingKehamilan = true);
//   //   try {
//   //     final kehamilan = await _kehamilanService.getKehamilanAktif();
//   //     if (!mounted) return;
//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder: (_) => JourneyScreen(
//   //           currentWeek: kehamilan.ukKehamilanSaatIni,
//   //           gravida: kehamilan.gravida,
//   //           paritas: kehamilan.paritas,
//   //           abortus: kehamilan.abortus,
//   //           hplText: kehamilan.taksiranPersalinan != null
//   //               ? '${kehamilan.taksiranPersalinan!.day} / ${kehamilan.taksiranPersalinan!.month} / ${kehamilan.taksiranPersalinan!.year}'
//   //               : '-',
//   //           hphtText: kehamilan.hpht != null
//   //               ? '${kehamilan.hpht!.day} / ${kehamilan.hpht!.month} / ${kehamilan.hpht!.year}'
//   //               : '-',
//   //         ),
//   //       ),
//   //     );
//   //   } catch (e) {
//   //     if (!mounted) return;
//   //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
//   //   } finally {
//   //     if (mounted) setState(() => _loadingKehamilan = false);
//   //   }
//   // }

//   Future<void> _openHamilJourney() async {
//     if (_loadingKehamilan) return;
//     setState(() => _loadingKehamilan = true);
//     try {
//       final kehamilan = await _kehamilanService.getKehamilanAktif();
//       if (!mounted) return;

//       // Safety check: pastikan hpht tidak null
//       if (kehamilan.hpht == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Data HPHT belum tersedia')),
//         );
//         return;
//       }

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => JourneyScreen(
//             currentWeek: kehamilan.ukKehamilanSaatIni,
//             gravida: kehamilan.gravida,
//             paritas: kehamilan.paritas,
//             abortus: kehamilan.abortus,
//             hplText: kehamilan.taksiranPersalinan != null
//                 ? '${kehamilan.taksiranPersalinan!.day} / ${kehamilan.taksiranPersalinan!.month} / ${kehamilan.taksiranPersalinan!.year}'
//                 : '-',
//             hphtText:
//                 '${kehamilan.hpht!.day} / ${kehamilan.hpht!.month} / ${kehamilan.hpht!.year}',
//             hpht: kehamilan.hpht!, // ✅ pakai kehamilan, bukan _kehamilanAktif
//           ),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(e.toString())));
//     } finally {
//       if (mounted) setState(() => _loadingKehamilan = false);
//     }
//   }

//   String _trimesterLabel(int week) {
//     if (week <= 12) return 'Trimester 1';
//     if (week <= 27) return 'Trimester 2';
//     return 'Trimester 3';
//   }

//   String _formatDate(DateTime? date) {
//     if (date == null) return '-';
//     const months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'Mei',
//       'Jun',
//       'Jul',
//       'Agt',
//       'Sep',
//       'Okt',
//       'Nov',
//       'Des'
//     ];
//     return '${date.day} ${months[date.month - 1]} ${date.year}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget body;
//     if (_selectedNavIndex == 0) {
//       body = _buildHomeBody();
//     } else if (_selectedNavIndex == 1) {
//       body = const AbsensiKelasIbuHamilScreen();
//       // body = const Center(
//       //   child: Padding(
//       //     padding: EdgeInsets.all(20),
//       //     child: Text(
//       //       'Menu Catatan dapat diakses dari Menu Cepat di halaman Beranda',
//       //       textAlign: TextAlign.center,
//       //       style: TextStyle(fontSize: 16),
//       //     ),
//       //   ),
//       // );
//     } else if (_selectedNavIndex == 2) {
//       body = const EdukasiScreenAll();
//     } else {
//       body = const Center(child: Text('Profil'));
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F5F9),
//       body: body,
//       bottomNavigationBar: DashboardBottomNav(
//         currentIndex: _selectedNavIndex,
//         onTap: (i) => setState(() => _selectedNavIndex = i),
//       ),
//     );
//   }

//   Widget _buildHomeBody() {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           const DashboardHeader(),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 24),
//                 // [WIDGET: DashboardPhaseSelector]
//                 DashboardPhaseSelector(
//                   selectedPhase: _selectedPhase,
//                   onPhaseSelected: (phase) =>
//                       setState(() => _selectedPhase = phase),
//                 ),
//                 const SizedBox(height: 32),
//                 if (_selectedPhase == 'Hamil') _buildHamilContent(),
//                 if (_selectedPhase == 'Nifas') _buildNifasShortcut(),
//                 if (_selectedPhase == 'Menyusui') _buildMenyusuiShortcut(),
//                 if (_selectedPhase == 'Tumbuh') _buildTumbuhContent(),
//                 if (_selectedPhase != 'Hamil' &&
//                     _selectedPhase != 'Nifas' &&
//                     _selectedPhase != 'Menyusui' &&
//                     _selectedPhase != 'Tumbuh')
//                   _buildPlaceholderContent(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

// Widget _buildNifasShortcut() {
//   return Column(
//     children: [

//       DashboardMenuCard(
//         title: 'Ringkasan Pelayanan Proses Melahirkan',
//         subtitle: 'Lihat hasil pelayanan proses melahirkan',
//         icon: Icons.child_friendly_rounded,
//         iconColor: AppColors.primary,
//         onTap: () {
//           final token = AuthSession.token ?? '';

//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => RingkasanPersalinanScreen(
//                 token: token,
//               ),
//             ),
//           );
//         },
//       ),

//       const SizedBox(height: 16),

//       DashboardMenuCard(
//         title: 'Pemantauan Ibu Nifas',
//         subtitle: 'Pantau masa nifas pasca persalinan',
//         icon: Icons.person_outline,
//         iconColor: AppColors.primary,
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => const NifasScreen(),
//           ),
//         ),
//       ),

//       const SizedBox(height: 16),

//       DashboardMenuCard(
//         title: 'Pelayanan Ibu Nifas',
//         subtitle: 'Lihat catatan pelayanan ibu nifas',
//         icon: Icons.medical_services_outlined,
//         iconColor: AppColors.primary,
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => const PelayananIbuNifasScreen(),
//           ),
//         ),
//       ),

//       const SizedBox(height: 16),

//       DashboardMenuCard(
//         title: 'Catatan Pelayanan Nifas',
//         subtitle: 'Lihat catatan pemeriksaan dan saran nifas',
//         icon: Icons.note_alt_outlined,
//         iconColor: AppColors.primary,
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => const CatatanPelayananNifasScreen(),
//           ),
//         ),
//       ),

//     ],
//   );
// }

//   Widget _buildMenyusuiShortcut() {
//     return DashboardMenuCard(
//       title: 'Menyusui',
//       subtitle: 'Lihat edukasi menyusui dan ASI',
//       icon: Icons.child_care_outlined,
//       iconColor: Colors.orange,
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => const EdukasiScreenAll(),
//         ),
//       ),
//     );
//   }

//   // ─────────────────────────────────────────────
//   // [MODUL: IBU - Hamil] Konten tab Hamil
//   // Urutan sesuai desain lib_desain:
//   //   1. Card progress kehamilan
//   //   2. Card buah janin
//   //   3. MENU CEPAT (6 item, 3 kolom)
//   //   4. Menu Hamil (card navigasi)
//   //   5. Banner surat rujukan
//   // ─────────────────────────────────────────────
//   Widget _buildHamilContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Progress kehamilan — klik navigasi ke JourneyScreen
//         InkWell(
//           borderRadius: BorderRadius.circular(20),
//           onTap: _openHamilJourney,
//           child: DashboardInfoCard(
//             child: Builder(builder: (_) {
//               final week = _kehamilanAktif?.ukKehamilanSaatIni ?? 0;
//               final progress = week > 0 ? (week / 40).clamp(0.0, 1.0) : 0.0;
//               final trimester = week > 0 ? _trimesterLabel(week) : '-';
//               final hpl = _formatDate(_kehamilanAktif?.taksiranPersalinan);
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         week > 0 ? 'Kehamilan $week Minggu' : 'Kehamilan Aktif',
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 16),
//                       ),
//                       const Icon(Icons.chevron_right, color: Colors.grey),
//                     ],
//                   ),
//                   Text('$trimester • HPL: $hpl',
//                       style: const TextStyle(color: Colors.grey, fontSize: 12)),
//                   const SizedBox(height: 16),
//                   LinearProgressIndicator(
//                     value: progress,
//                     backgroundColor: Colors.blue.shade50,
//                     color: TrimesterTheme.t1Primary,
//                     minHeight: 8,
//                   ),
//                   const SizedBox(height: 8),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('Minggu 1',
//                           style: TextStyle(fontSize: 10, color: Colors.grey)),
//                       Text('Minggu 40',
//                           style: TextStyle(fontSize: 10, color: Colors.grey)),
//                     ],
//                   ),
//                 ],
//               );
//             }),
//           ),
//         ),
//         const SizedBox(height: 16),

//         // Info insight janin
//         DashboardInfoCard(
//           child: Row(
//             children: [
//               const Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Sebesar Buah Jagung',
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                     Text(
//                       'Panjang janin sekitar 30 cm dengan berat sekitar 600 gram.',
//                       style: TextStyle(fontSize: 12, color: Colors.black54),
//                     ),
//                   ],
//                 ),
//               ),
//               Image.network(
//                 'https://cdn-icons-png.flaticon.com/512/1141/1141771.png',
//                 width: 40,
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 32),

//         // [WIDGET: DashboardQuickMenu] — 6 item, 3 kolom (sesuai desain lib_desain)
//         const Text('MENU CEPAT',
//             style: TextStyle(
//                 fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
//         const SizedBox(height: 16),

//         // DISINI TADINYA YANG QUICK MENU YANG MENIMPA ITU

//         // Menu Hamil — card navigasi
//         const Text('Menu Hamil',
//             style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87)),
//         const SizedBox(height: 16),

//         DashboardMenuCard(
//           title: 'Kehamilan Trimester 1–3',
//           subtitle: 'Pantau perkembangan kehamilan',
//           icon: Icons.favorite_outline,
//           iconColor: Colors.pink,
//           onTap: _openHamilJourney,
//         ),
//         DashboardMenuCard(
//           title: 'Persalinan',
//           subtitle: 'Persiapan & proses persalinan',
//           icon: Icons.child_care_outlined,
//           iconColor: Colors.blue,
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const PersalinanScreen()),
//           ),
//         ),
//         // DashboardMenuCard(
//         //   title: 'Grafik Evaluasi Kehamilan',
//         //   subtitle: 'Pantau TFU & DJJ selama kehamilan',
//         //   icon: Icons.show_chart_outlined,
//         //   iconColor: Colors.purple,
//         //   onTap: () => Navigator.push(
//         //     context,
//         //     MaterialPageRoute(
//         //       builder: (_) => const GrafikEvaluasiKehamilanScreen(),
//         //     ),
//         //   ),
//         // ),
//         const SizedBox(height: 32),

//         const Text('MENU CEPAT',
//             style: TextStyle(
//                 fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
//         const SizedBox(height: 16),

//         // [WIDGET: DashboardQuickMenu] — Menu cepat modul ibu
//         // DashboardQuickMenu(
//         //   items: DashboardMenuData.hamilQuickMenuItems.map((item) {
//         //     return {
//         //       ...item,
//         //       'onTap': () {
//         //         if (item['key'] == 'absensi') {
//         //           Navigator.push(context,
//         //               MaterialPageRoute(builder: (_) => const AbsensiKelasIbuHamilScreen()));
//         //           return;
//         //         }
//         //         if (item['key'] == 'catatan') {
//         //           Navigator.push(context,
//         //               MaterialPageRoute(builder: (_) => const CatatanMenuScreen()));
//         //           return;
//         //         }
//         //         ScaffoldMessenger.of(context).showSnackBar(
//         //             SnackBar(content: Text('${item['label']} belum tersedia')));
//         //       },
//         //     };
//         //   }).toList(),
//         // ),
//         // const SizedBox(height: 32),

//         DashboardQuickMenu(
//           crossAxisCount: 3,
//           childAspectRatio: 1.0,
//           items: DashboardMenuData.hamilQuickMenuItems.map((item) {
//             return {
//               ...item,
//               'onTap': () {
//                 switch (item['key']) {
//                   case 'rujukan':
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const RujukanListScreen()));
//                     break;
//                   case 'bb_ibu':
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) =>
//                                 // const GrafikEvaluasiKehamilanScreen()));
//                                 const GrafikPeningkatanBBScreen()));
//                     break;
//                   case 'djj_tfu':
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) =>
//                                 const GrafikEvaluasiKehamilanScreen()));
//                     break;
//                   case 'pemantauan':
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const PemantauanIbuHamilScreen()));
//                     break;
//                   case 'catatan':
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) =>
//                                 const CatatanPelayananMenuScreen()));
//                     break;
//                   // case 'log_ttd':
//                   //   Navigator.push(context,
//                   //       MaterialPageRoute(builder: (_) => const LogTTDMMSScreen()));
//                   //   break;
//                   case 'log_ttd':
//                     // Safety: cek dulu apakah data kehamilan tersedia
//                     if (_kehamilanAktif?.hpht == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content: Text('Data kehamilan belum tersedia')),
//                       );
//                       break;
//                     }
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => LogTTDMMSScreen(
//                           hpht: _kehamilanAktif!.hpht!,
//                         ),
//                       ),
//                     );
//                     break;
//                   default:
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: Text('${item['label']} belum tersedia')));
//                 }
//               },
//             };
//           }).toList(),
//         ),
//         const SizedBox(height: 32),

//         // [MODUL: IBU] Surat rujukan
//         _buildDangerAlert(),
//         const SizedBox(height: 40),
//       ],
//     );
//   }

//   // ─────────────────────────────────────────────
//   // [MODUL: ANAK - Tumbuh Kembang] Konten tab Tumbuh
//   // ─────────────────────────────────────────────
//   Widget _buildTumbuhContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (_loadingAnak)
//           const Center(
//             child: Padding(
//               padding: EdgeInsets.all(20),
//               child: CircularProgressIndicator(),
//             ),
//           )
//         else if (_anakSaya != null && _anakSaya!.isNotEmpty)
//           SizedBox(
//             height: 100,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               clipBehavior: Clip.none, // Supaya bayangan card tidak terpotong
//               itemCount: _anakSaya!.length,
//               itemBuilder: (context, index) {
//                 return _buildAnakCard(_anakSaya![index]);
//               },
//             ),
//           )
//         else
//           // Tampilkan tombol request tambah jika belum ada data anak
//           GestureDetector(
//             onTap: () => Navigator.push(context,
//                 MaterialPageRoute(builder: (_) => const InputProfilAnakScreen())),
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.blue.shade200),
//                 borderRadius: BorderRadius.circular(16),
//                 color: Colors.blue.shade50,
//               ),
//               child: const Row(
//                 children: [
//                   Icon(Icons.person_add, color: Colors.blue, size: 28),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Request Tambah Profil Anak',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600, fontSize: 14)),
//                         SizedBox(height: 4),
//                         Text('Mulai pantau tumbuh kembang si kecil',
//                             style:
//                                 TextStyle(fontSize: 12, color: Colors.black54)),
//                       ],
//                     ),
//                   ),
//                   CircleAvatar(
//                     radius: 14,
//                     backgroundColor: Colors.blue,
//                     child: Icon(Icons.add, size: 16, color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         const SizedBox(height: 24),

//         const Text('Menu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
//         const SizedBox(height: 16),

//         // [WIDGET: DashboardTumbuhQuickMenu] — 6 menu cepat modul anak
//         DashboardTumbuhQuickMenu(
//           items: DashboardMenuData.tumbuhQuickMenuItems.map((item) {
//             return {
//               ...item,
//               'onTap': () {
//                 switch (item['key']) {
//                   case 'pertumbuhan':
//                     // [MODUL: ANAK] Pilih anak → DetailPertumbuhanScreen
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const PilihAnakScreen()));
//                     break;
//                   case 'imunisasi':
//                     // [MODUL: ANAK] Pilih anak → ImunisasiScreen
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) =>
//                                 const PilihAnakScreen(tujuan: 'imunisasi')));
//                     break;
//                   case 'mpasi':
//                     // [MODUL: ANAK] Pilih anak → HalamanUtamaMpasiScreen
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) =>
//                                 const MpasiMenuScreen()));
//                     break;
//                   case 'edukasi':
//                     // [MODUL: ANAK] Langsung ke EdukasiScreen (tidak butuh pilih anak)
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const EdukasiScreenAll()));
//                     break;
//                   case 'bahaya':
//                     // [MODUL: ANAK] Pilih anak → SkriningBahayaScreen
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) =>
//                                 const PilihAnakScreen(tujuan: 'bahaya')));
//                     break;
//                   case 'pemantauan':
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) =>
//                                 const PilihAnakScreen(tujuan: 'pemantauan')));
//                     break;
//                   case 'catatan':
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const PilihAnakScreen(
//                           tujuan: 'catatan', // Arahkan tujuannya ke catatan
//                         ),
//                       ),
//                     );
//                     break;
//                   default:
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: Text('${item['label']} belum tersedia')));
//                 }
//               },
//             };
//           }).toList(),
//         ),
//         const SizedBox(height: 24),

//         // [MODUL: ANAK] Banner tanda bahaya — klik langsung ke SkriningBahayaScreen
//         GestureDetector(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (_) => const PilihAnakScreen(tujuan: 'bahaya')),
//           ),
//           child: Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//                 color: const Color(0xFFFFF3E0),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.orange.shade200)),
//             child: const Row(
//               children: [
//                 Icon(Icons.warning_amber_rounded, color: Colors.orange),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     'Kenali Tanda Bahaya — Segera ke faskes jika ada gejala ini',
//                     style: TextStyle(fontSize: 12),
//                   ),
//                 ),
//                 Icon(Icons.chevron_right, color: Colors.orange),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 40),
//       ],
//     );
//   }

//   Widget _buildPlaceholderContent() {
//     return const Center(
//       child: Padding(
//           padding: EdgeInsets.all(40),
//           child: Text('Konten fase ini segera hadir!')),
//     );
//   }

//   Widget _buildAnakCard(IbuAnakModel anak) {
//     return Container(
//       margin: const EdgeInsets.only(right: 16),
//       padding: const EdgeInsets.all(16),
//       width: MediaQuery.of(context).size.width * 0.75, // Biar card berikutnya ngintip
//       decoration: BoxDecoration(
//         color: const Color(0xFFEFF6FF), // Background biru sangat muda
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         border: Border.all(color: Colors.blue.shade100, width: 1),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               color: const Color(0xFF1E52A8), // Warna biru box icon
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: const Icon(Icons.person_outline, color: Colors.white, size: 32),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   anak.nama,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Color(0xFF1E3A8A), // Biru gelap untuk teks nama
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   anak.usiaTeks,
//                   style: const TextStyle(fontSize: 13, color: Colors.black54),
//                 ),
//                 Text(
//                   anak.jenisKelamin,
//                   style: const TextStyle(fontSize: 13, color: Colors.black54),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ─────────────────────────────────────────────
//   // [MODUL: IBU - Hamil] Banner surat rujukan
//   // ─────────────────────────────────────────────
//   Widget _buildDangerAlert() {
//     return InkWell(
//       borderRadius: BorderRadius.circular(16),
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const RujukanListScreen()),
//       ),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: const Color(0xFFEFF6FF),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.blue.shade100),
//         ),
//         child: Row(
//           children: [
//             Icon(Icons.description_outlined, color: Colors.blue.shade700),
//             const SizedBox(width: 12),
//             const Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Surat Rekomendasi Rujukan',
//                       style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.blue,
//                           fontWeight: FontWeight.bold)),
//                   Text('Belum ada surat rekomendasi rujukan saat ini',
//                       style: TextStyle(fontSize: 11, color: Colors.black54)),
//                 ],
//               ),
//             ),
//             const Icon(Icons.chevron_right, color: Colors.blue),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:ta_pa2_pa3_project/core/themes/app_theme.dart';
import 'package:ta_pa2_pa3_project/features/anak/mpasi/presentation/screens/mpasi_menu_screen.dart';
// import 'package:ta_pa2_pa3_project/features/anak/mpasi/presentation/screens/mpasi/halaman_utama_mpasi.dart';
import 'package:ta_pa2_pa3_project/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:ta_pa2_pa3_project/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';
import 'package:ta_pa2_pa3_project/features/dashboard/presentation/widgets/dashboard_menu_card.dart';
import 'package:ta_pa2_pa3_project/features/dashboard/presentation/widgets/dashboard_phase_selector.dart';
import 'package:ta_pa2_pa3_project/features/dashboard/presentation/widgets/dashboard_quick_menu.dart';
import 'package:ta_pa2_pa3_project/features/dashboard/data/dashboard_menu_data.dart';
// MODUL IBU
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/perjalanan_hamil_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/services/kehamilan_api_service.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/models/kehamilan_aktif_model.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/absensi_kelas_ibu_hamil_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/rujukan_list_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/pemantauan_ibu_hamil_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/catatan_pelayanan_menu_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/log_ttd_mms_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/nifas/presentation/screens/nifas_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/persalinan_screen.dart';
// MODUL ANAK
import 'package:ta_pa2_pa3_project/features/anak/anak/presentation/screens/anak/pilih_anak_screen.dart';
import 'package:ta_pa2_pa3_project/features/anak/anak/presentation/screens/anak/input_profil_anak_screen.dart';
// import 'package:ta_pa2_pa3_project/features/anak/anak/presentation/screens/anak/cari_anak_screen.dart';
import 'package:ta_pa2_pa3_project/features/anak/edukasi/presentation/screens/edukasi/edukasi_screen.dart';
import 'package:ta_pa2_pa3_project/features/anak/anak/data/models/ibu_anak_model.dart';
import 'package:ta_pa2_pa3_project/features/anak/anak/data/services/ibu_api_service.dart';
// import 'package:ta_pa2_pa3_project/features/anak/tumbuh_kembang/presentation/screens/skrining/skrining_bahaya.dart';
// MODUL CATATAN
// import 'package:ta_pa2_pa3_project/features/anak/anak/presentation/widgets/index.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/grafik_evaluasi_kehamilan_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/grafik_evaluasi_kehamilan_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/grafik_peningkatan_bb_screen.dart';

// import edukasi
import 'package:ta_pa2_pa3_project/features/edukasi/presentation/screens/edukasi_screen_all.dart';
import 'package:ta_pa2_pa3_project/core/constants/app_colors.dart';
import 'package:ta_pa2_pa3_project/core/services/auth_session.dart';
import 'package:ta_pa2_pa3_project/features/ibu/nifas/presentation/screens/ringkasan_persalinan_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/nifas/presentation/screens/pelayanan_ibu_nifas_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/nifas/presentation/screens/catatan_pelayanan_nifas_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedPhase = 'Hamil';
  int _selectedNavIndex = 0;

  final _kehamilanService = KehamilanApiService();
  bool _loadingKehamilan = false;
  KehamilanAktifModel? _kehamilanAktif;

  final _ibuApiService = IbuApiService();
  bool _loadingAnak = false;
  List<IbuAnakModel>? _anakSaya;

  @override
  void initState() {
    super.initState();
    _loadKehamilanAktif();
    _loadDataAnak();
  }

  Future<void> _loadDataAnak() async {
    setState(() => _loadingAnak = true);
    try {
      final anak = await _ibuApiService.getAnakSaya();
      if (!mounted) return;
      setState(() {
        _anakSaya = anak;
        _loadingAnak = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingAnak = false);
    }
  }

  @override
  void dispose() {
    _ibuApiService.dispose();
    super.dispose();
  }

  Future<void> _loadKehamilanAktif() async {
    try {
      final kehamilan = await _kehamilanService.getKehamilanAktif();
      if (!mounted) return;
      setState(() => _kehamilanAktif = kehamilan);
    } catch (_) {}
  }

  // Future<void> _openHamilJourney() async {
  //   if (_loadingKehamilan) return;
  //   setState(() => _loadingKehamilan = true);
  //   try {
  //     final kehamilan = await _kehamilanService.getKehamilanAktif();
  //     if (!mounted) return;
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => JourneyScreen(
  //           currentWeek: kehamilan.ukKehamilanSaatIni,
  //           gravida: kehamilan.gravida,
  //           paritas: kehamilan.paritas,
  //           abortus: kehamilan.abortus,
  //           hplText: kehamilan.taksiranPersalinan != null
  //               ? '${kehamilan.taksiranPersalinan!.day} / ${kehamilan.taksiranPersalinan!.month} / ${kehamilan.taksiranPersalinan!.year}'
  //               : '-',
  //           hphtText: kehamilan.hpht != null
  //               ? '${kehamilan.hpht!.day} / ${kehamilan.hpht!.month} / ${kehamilan.hpht!.year}'
  //               : '-',
  //         ),
  //       ),
  //     );
  //   } catch (e) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
  //   } finally {
  //     if (mounted) setState(() => _loadingKehamilan = false);
  //   }
  // }

  Future<void> _openHamilJourney() async {
    if (_loadingKehamilan) return;
    setState(() => _loadingKehamilan = true);
    try {
      final kehamilan = await _kehamilanService.getKehamilanAktif();
      if (!mounted) return;

      // Safety check: pastikan hpht tidak null
      if (kehamilan.hpht == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data HPHT belum tersedia')),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => JourneyScreen(
            currentWeek: kehamilan.ukKehamilanSaatIni,
            gravida: kehamilan.gravida,
            paritas: kehamilan.paritas,
            abortus: kehamilan.abortus,
            hplText: kehamilan.taksiranPersalinan != null
                ? '${kehamilan.taksiranPersalinan!.day} / ${kehamilan.taksiranPersalinan!.month} / ${kehamilan.taksiranPersalinan!.year}'
                : '-',
            hphtText:
                '${kehamilan.hpht!.day} / ${kehamilan.hpht!.month} / ${kehamilan.hpht!.year}',
            hpht: kehamilan.hpht!, // ✅ pakai kehamilan, bukan _kehamilanAktif
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loadingKehamilan = false);
    }
  }

  String _trimesterLabel(int week) {
    if (week <= 12) return 'Trimester 1';
    if (week <= 27) return 'Trimester 2';
    return 'Trimester 3';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agt',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_selectedNavIndex == 0) {
      body = _buildHomeBody();
    } else if (_selectedNavIndex == 1) {
      body = const AbsensiKelasIbuHamilScreen();
      // body = const Center(
      //   child: Padding(
      //     padding: EdgeInsets.all(20),
      //     child: Text(
      //       'Menu Catatan dapat diakses dari Menu Cepat di halaman Beranda',
      //       textAlign: TextAlign.center,
      //       style: TextStyle(fontSize: 16),
      //     ),
      //   ),
      // );
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

  Widget _buildHomeBody() {
    // --- LOGIKA PESAN KONTEKSTUAL BERDASARKAN KONDISI DATA TERKINI BUNDA (UNTUK USER TESTING Q4) ---
    String contextualGuidanceText = 'Bunda, yuk ketuk kartu di bawah ini untuk melihat kondisi kesehatanmu saat ini!';
    
    if (_selectedPhase == 'Hamil') {
      final week = _kehamilanAktif?.ukKehamilanSaatIni ?? 0;
      if (week > 0 && week <= 12) {
        contextualGuidanceText = 'Kehamilan Bunda di Trimester 1. Yuk ketuk kartu di bawah untuk melihat rangkuman kondisi kandungan awalmu!';
      } else if (week > 12 && week <= 27) {
        contextualGuidanceText = 'Janin Bunda berkembang baik di Trimester 2. Yuk ketuk kartu di bawah untuk memantau grafik kenaikan BB janin!';
      } else if (week > 27) {
        contextualGuidanceText = 'Persalinan makin dekat di Trimester 3, Bun! Yuk ketuk kartu di bawah untuk memeriksa kesiapan menyambut si kecil!';
      }
    } else if (_selectedPhase == 'Nifas') {
      contextualGuidanceText = 'Bunda dalam masa nifas. Yuk ketuk menu di bawah untuk memastikan pemulihan fisik Bunda berjalan lancar!';
    } else if (_selectedPhase == 'Menyusui') {
      contextualGuidanceText = 'Semangat mengASIhi, Bunda! Yuk ketuk menu di bawah untuk melihat panduan posisi menyusui yang benar.';
    } else if (_selectedPhase == 'Tumbuh') {
      contextualGuidanceText = 'Ayo pantau tumbuh kembang si kecil, Bun! Ketuk menu di bawah untuk mencatat tinggi dan berat badan terbarunya.';
    }

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
                // [WIDGET: DashboardPhaseSelector]
                DashboardPhaseSelector(
                  selectedPhase: _selectedPhase,
                  onPhaseSelected: (phase) =>
                      setState(() => _selectedPhase = phase),
                ),
                const SizedBox(height: 24),

                // --- DISPLAY UI BARU: BANNER PANDUAN KONTEKSTUAL YANG DINAMIS ---
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
                          contextualGuidanceText, // Menggunakan teks dinamis hasil analisa data di atas
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A8A),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                if (_selectedPhase == 'Hamil') _buildHamilContent(),
                if (_selectedPhase == 'Nifas') _buildNifasShortcut(),
                if (_selectedPhase == 'Menyusui') _buildMenyusuiShortcut(),
                if (_selectedPhase == 'Tumbuh') _buildTumbuhContent(),
                if (_selectedPhase != 'Hamil' &&
                    _selectedPhase != 'Nifas' &&
                    _selectedPhase != 'Menyusui' &&
                    _selectedPhase != 'Tumbuh')
                  _buildPlaceholderContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _buildNifasShortcut() {
  return Column(
    children: [

      DashboardMenuCard(
        title: 'Ringkasan Pelayanan Proses Melahirkan',
        subtitle: 'Lihat hasil pelayanan proses melahirkan',
        icon: Icons.child_friendly_rounded,
        iconColor: AppColors.primary,
        onTap: () {
          final token = AuthSession.token ?? '';

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RingkasanPersalinanScreen(
                token: token,
              ),
            ),
          );
        },
      ),

      const SizedBox(height: 16),

      DashboardMenuCard(
        title: 'Pemantauan Ibu Nifas',
        subtitle: 'Pantau masa nifas pasca persalinan',
        icon: Icons.person_outline,
        iconColor: AppColors.primary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const NifasScreen(),
          ),
        ),
      ),

      const SizedBox(height: 16),

      DashboardMenuCard(
        title: 'Pelayanan Ibu Nifas',
        subtitle: 'Lihat catatan pelayanan ibu nifas',
        icon: Icons.medical_services_outlined,
        iconColor: AppColors.primary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PelayananIbuNifasScreen(),
          ),
        ),
      ),

      const SizedBox(height: 16),

      DashboardMenuCard(
        title: 'Catatan Pelayanan Nifas',
        subtitle: 'Lihat catatan pemeriksaan dan saran nifas',
        icon: Icons.note_alt_outlined,
        iconColor: AppColors.primary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CatatanPelayananNifasScreen(),
          ),
        ),
      ),

    ],
  );
}

  Widget _buildMenyusuiShortcut() {
    return DashboardMenuCard(
      title: 'Menyusui',
      subtitle: 'Lihat edukasi menyusui dan ASI',
      icon: Icons.child_care_outlined,
      iconColor: Colors.orange,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const EdukasiScreenAll(),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // [MODUL: IBU - Hamil] Konten tab Hamil
  // Urutan sesuai desain lib_desain:
  //   1. Card progress kehamilan
  //   2. Card buah janin
  //   3. MENU CEPAT (6 item, 3 kolom)
  //   4. Menu Hamil (card navigasi)
  //   5. Banner surat rujukan
  // ─────────────────────────────────────────────
  Widget _buildHamilContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress kehamilan — klik navigasi ke JourneyScreen
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _openHamilJourney,
          child: DashboardInfoCard(
            child: Builder(builder: (_) {
              final week = _kehamilanAktif?.ukKehamilanSaatIni ?? 0;
              final progress = week > 0 ? (week / 40).clamp(0.0, 1.0) : 0.0;
              final trimester = week > 0 ? _trimesterLabel(week) : '-';
              final hpl = _formatDate(_kehamilanAktif?.taksiranPersalinan);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        week > 0 ? 'Kehamilan $week Minggu' : 'Kehamilan Active',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                  Text('$trimester • HPL: $hpl',
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.blue.shade50,
                    color: TrimesterTheme.t1Primary,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Minggu 1',
                          style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text('Minggu 40',
                          style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
        const SizedBox(height: 16),

        // Info insight janin
        DashboardInfoCard(
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sebesar Buah Jagung',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      'Panjang janin sekitar 30 cm dengan berat sekitar 600 gram.',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Image.network(
                'https://cdn-icons-png.flaticon.com/512/1141/1141771.png',
                width: 40,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // [WIDGET: DashboardQuickMenu] — 6 item, 3 kolom (sesuai desain lib_desain)

        // DISINI TADINYA YANG QUICK MENU YANG MENIMPA ITU

        // Menu Hamil — card navigasi
        const Text('Menu Hamil',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        const SizedBox(height: 16),

        DashboardMenuCard(
          title: 'Kehamilan Trimester 1–3',
          subtitle: 'Pantau perkembangan kehamilan',
          icon: Icons.favorite_outline,
          iconColor: Colors.pink,
          onTap: _openHamilJourney,
        ),
        DashboardMenuCard(
          title: 'Persalinan',
          subtitle: 'Persiapan & proses persalinan',
          icon: Icons.child_care_outlined,
          iconColor: Colors.blue,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PersalinanScreen()),
          ),
        ),
        // DashboardMenuCard(
        //   title: 'Grafik Evaluasi Kehamilan',
        //   subtitle: 'Pantau TFU & DJJ selama kehamilan',
        //   icon: Icons.show_chart_outlined,
        //   iconColor: Colors.purple,
        //   onTap: () => Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (_) => const GrafikEvaluasiKehamilanScreen(),
        //     ),
        //   ),
        // ),
        const SizedBox(height: 32),

        const Text('MENU CEPAT',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 16),

        // [WIDGET: DashboardQuickMenu] — Menu cepat modul ibu
        // DashboardQuickMenu(
        //   items: DashboardMenuData.hamilQuickMenuItems.map((item) {
        //     return {
        //       ...item,
        //       'onTap': () {
        //         if (item['key'] == 'absensi') {
        //           Navigator.push(context,
        //               MaterialPageRoute(builder: (_) => const AbsensiKelasIbuHamilScreen()));
        //           return;
        //         }
        //         if (item['key'] == 'catatan') {
        //           Navigator.push(context,
        //               MaterialPageRoute(builder: (_) => const CatatanMenuScreen()));
        //           return;
        //         }
        //         ScaffoldMessenger.of(context).showSnackBar(
        //             SnackBar(content: Text('${item['label']} belum tersedia')));
        //       },
        //     };
        //   }).toList(),
        // ),
        // const SizedBox(height: 32),

        DashboardQuickMenu(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          items: DashboardMenuData.hamilQuickMenuItems.map((item) {
            return {
              ...item,
              'onTap': () {
                switch (item['key']) {
                  case 'rujukan':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RujukanListScreen()));
                    break;
                  case 'bb_ibu':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                // const GrafikEvaluasiKehamilanScreen()));
                                const GrafikPeningkatanBBScreen()));
                    break;
                  case 'djj_tfu':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const GrafikEvaluasiKehamilanScreen()));
                    break;
                  case 'pemantauan':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PemantauanIbuHamilScreen()));
                    break;
                  case 'catatan':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const CatatanPelayananMenuScreen()));
                    break;
                  // case 'log_ttd':
                  //   Navigator.push(context,
                  //       MaterialPageRoute(builder: (_) => const LogTTDMMSScreen()));
                  //   break;
                  case 'log_ttd':
                    // Safety: cek dulu apakah data kehamilan tersedia
                    if (_kehamilanAktif?.hpht == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Data kehamilan belum tersedia')),
                      );
                      break;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LogTTDMMSScreen(
                          hpht: _kehamilanAktif!.hpht!,
                        ),
                      ),
                    );
                    break;
                  default:
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('${item['label']} belum tersedia')));
                }
              },
            };
          }).toList(),
        ),
        const SizedBox(height: 32),

        // [MODUL: IBU] Surat rujukan
        _buildDangerAlert(),
        const SizedBox(height: 40),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // [MODUL: ANAK - Tumbuh Kembang] Konten tab Tumbuh
  // ─────────────────────────────────────────────
  Widget _buildTumbuhContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_loadingAnak)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_anakSaya != null && _anakSaya!.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none, // Supaya bayangan card tidak terpotong
              itemCount: _anakSaya!.length,
              itemBuilder: (context, index) {
                return _buildAnakCard(_anakSaya![index]);
              },
            ),
          )
        else
          // Tampilkan tombol request tambah jika belum ada data anak
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const InputProfilAnakScreen())),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade200),
                borderRadius: BorderRadius.circular(16),
                color: Colors.blue.shade50,
              ),
              child: const Row(
                children: [
                  Icon(Icons.person_add, color: Colors.blue, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Request Tambah Profil Anak',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14)),
                        SizedBox(height: 4),
                        Text('Mulai pantau tumbuh kembang si kecil',
                            style:
                                TextStyle(fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.add, size: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 24),

        const Text('MENU CEPAT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 16),

        // [WIDGET: DashboardTumbuhQuickMenu] — 6 menu cepat modul anak
        DashboardTumbuhQuickMenu(
          items: DashboardMenuData.tumbuhQuickMenuItems.map((item) {
            return {
              ...item,
              'onTap': () {
                switch (item['key']) {
                  case 'pertumbuhan':
                    // [MODUL: ANAK] Pilih anak → DetailPertumbuhanScreen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PilihAnakScreen()));
                    break;
                  case 'imunisasi':
                    // [MODUL: ANAK] Pilih anak → ImunisasiScreen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const PilihAnakScreen(tujuan: 'imunisasi')));
                    break;
                  case 'mpasi':
                    // [MODUL: ANAK] Pilih anak → HalamanUtamaMpasiScreen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const MpasiMenuScreen()));
                    break;
                  case 'edukasi':
                    // [MODUL: ANAK] Langsung ke EdukasiScreen (tidak butuh pilih anak)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const EdukasiScreenAll()));
                    break;
                  case 'bahaya':
                    // [MODUL: ANAK] Pilih anak → SkriningBahayaScreen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const PilihAnakScreen(tujuan: 'bahaya')));
                    break;
                  case 'pemantauan':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const PilihAnakScreen(tujuan: 'pemantauan')));
                    break;
                  case 'catatan':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PilihAnakScreen(
                          tujuan: 'catatan', // Arahkan tujuannya ke catatan
                        ),
                      ),
                    );
                    break;
                  default:
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('${item['label']} belum tersedia')));
                }
              },
            };
          }).toList(),
        ),
        const SizedBox(height: 24),

        // [MODUL: ANAK] Banner tanda bahaya — klik langsung ke SkriningBahayaScreen
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const PilihAnakScreen(tujuan: 'bahaya')),
          ),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade200)),
            child: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Kenali Tanda Bahaya — Segera ke faskes jika ada gejala ini',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.orange),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildPlaceholderContent() {
    return const Center(
      child: Padding(
          padding: EdgeInsets.all(40),
          child: Text('Konten fase ini segera hadir!')),
    );
  }

  Widget _buildAnakCard(IbuAnakModel anak) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 0.75, // Biar card berikutnya ngintip
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), // Background biru sangat muda
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.blue.shade100, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF1E52A8), // Warna biru box icon
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.person_outline, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  anak.nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1E3A8A), // Biru gelap untuk teks nama
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  anak.usiaTeks,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                Text(
                  anak.jenisKelamin,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // [MODUL: IBU - Hamil] Banner surat rujukan
  // ─────────────────────────────────────────────
  Widget _buildDangerAlert() {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RujukanListScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.shade100),
        ),
        child: Row(
          children: [
            Icon(Icons.description_outlined, color: Colors.blue.shade700),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Surat Rekomendasi Rujukan',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold)),
                  Text('Belum ada surat rekomendasi rujukan saat ini',
                      style: TextStyle(fontSize: 11, color: Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}