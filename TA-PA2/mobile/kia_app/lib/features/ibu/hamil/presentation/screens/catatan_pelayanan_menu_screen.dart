// import 'package:flutter/material.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/catatan_pelayanan_t1_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/catatan_pelayanan_t2_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/catatan_pelayanan_t3_screen.dart';
// import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/widgets/index.dart';

// class CatatanPelayananMenuScreen extends StatelessWidget {
//   const CatatanPelayananMenuScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F5F9),
//       appBar: IbuGradientHeader(
//         title: 'Catatan Pelayanan',
//         subtitle: 'Riwayat pemeriksaan kehamilan',
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(18),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const IbuSectionTitle(
//               title: 'Pilih Trimester',
//               subtitle: 'Lihat catatan pelayanan berdasarkan trimester',
//             ),
//             IbuMenuCard(
//               icon: Icons.looks_one_outlined,
//               title: 'Catatan Pelayanan Trimester 1',
//               subtitle: 'Lihat catatan pemeriksaan trimester 1',
//               iconColor: const Color(0xFF2F80ED),
//               iconBgColor: const Color(0xFFEAF4FF),
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => CatatanPelayananT1Screen()),
//               ),
//             ),
//             IbuMenuCard(
//               icon: Icons.looks_two_outlined,
//               title: 'Catatan Pelayanan Trimester 2',
//               subtitle: 'Lihat catatan pemeriksaan trimester 2',
//               iconColor: const Color(0xFF3949AB),
//               iconBgColor: const Color(0xFFE8EAF6),
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => CatatanPelayananT2Screen()),
//               ),
//             ),
//             IbuMenuCard(
//               icon: Icons.looks_3_outlined,
//               title: 'Catatan Pelayanan Trimester 3',
//               subtitle: 'Lihat catatan pemeriksaan trimester 3',
//               iconColor: const Color(0xFF7B1FA2),
//               iconBgColor: const Color(0xFFF3E5F5),
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => CatatanPelayananT3Screen()),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Container(
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFEAF4FF),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: const Row(
//                 children: [
//                   Icon(Icons.info_outline, color: Color(0xFF2F80ED)),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       'Catatan pelayanan berisi hasil pemeriksaan oleh tenaga kesehatan selama masa kehamilan.',
//                       style: TextStyle(fontSize: 12, color: Color(0xFF4A5568)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/catatan_pelayanan_t1_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/catatan_pelayanan_t2_screen.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/presentation/screens/catatan_pelayanan_t3_screen.dart';

import 'package:ta_pa2_pa3_project/core/constants/app_colors.dart';
class CatatanPelayananMenuScreen extends StatelessWidget {
  const CatatanPelayananMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FF),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pilih Trimester Pemeriksaan",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 18),

                  _card(
                    context,
                    title: "Catatan Pelayanan Trimester 1",
                    subtitle: "Lihat catatan pemeriksaan awal kehamilan",
                    icon: Icons.looks_one_outlined,
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CatatanPelayananT1Screen(),
                        ),
                      );
                    },
                  ),

                  _card(
                    context,
                    title: "Catatan Pelayanan Trimester 2",
                    subtitle: "Lihat catatan pemeriksaan pertengahan kehamilan",
                    icon: Icons.looks_two_outlined,
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CatatanPelayananT2Screen(),
                        ),
                      );
                    },
                  ),

                  _card(
                    context,
                    title: "Catatan Pelayanan Trimester 3",
                    subtitle: "Lihat catatan pemeriksaan menjelang persalinan",
                    icon: Icons.looks_3_outlined,
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CatatanPelayananT3Screen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: AppColors.primary),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Catatan pelayanan berisi hasil pemeriksaan yang dilakukan oleh bidan atau tenaga kesehatan selama masa kehamilan ibu.",
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 55, left: 20, right: 20, bottom: 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Catatan Pelayanan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Riwayat pemeriksaan kehamilan per trimester",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}