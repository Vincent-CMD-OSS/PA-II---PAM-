import 'package:flutter/material.dart';
import 'package:ta_pa2_pa3_project/core/constants/app_colors.dart';

import '../ibu/konten_edukasi_ibu_screen.dart';
import '../anak/konten_edukasi_anak_screen.dart';

class EdukasiScreenAll extends StatelessWidget {
  const EdukasiScreenAll({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Edukasi',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,

        iconTheme: const IconThemeData(
          color: Colors.black87,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            _buildCategoryCard(
              context: context,
              title: 'Ibu',
              subtitle:
                  'Edukasi kesehatan ibu selama masa kehamilan',
              icon: Icons.pregnant_woman,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const KontenEdukasiIbuScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 18),

            _buildCategoryCard(
              context: context,
              title: 'Anak',
              subtitle:
                  'Edukasi tumbuh kembang anak sejak lahir hingga usia 6 tahun',
              icon: Icons.child_care,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const KontenEdukasiAnakScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [

            Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),

                borderRadius:
                    BorderRadius.circular(16),
              ),

              child: Icon(
                icon,
                size: 28,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}