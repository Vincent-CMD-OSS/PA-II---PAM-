import 'package:flutter/material.dart';
// Sesuaikan path app_colors jika perlu
import 'package:ta_pa2_pa3_project/core/themes/app_colors.dart';

class EdukasiCard extends StatelessWidget {
  final String title;
  final String duration;
  final String category;
  final VoidCallback onTap;

  const EdukasiCard({
    super.key,
    required this.title,
    required this.duration,
    required this.category,
    required this.onTap,
  });

  // Konstanta warna UI sesuai Figma
  static const Color colorLavenderBg = Color(0xFFF3E9FB);
  static const Color colorTagBlue = Color(0xFF4C6EF5);
  static const Color colorTagOrange = Color(0xFFFF922B);
  static const Color colorTextGray = Color(0xFF868E96);

  @override
  Widget build(BuildContext context) {
    final bool isArtikel = category == 'Artikel';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AREA HEADER CARD (LAVENDER)
            Container(
              height: 120,
              decoration: const BoxDecoration(
                color: colorLavenderBg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10, left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isArtikel ? colorTagOrange : colorTagBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isArtikel ? 'ARTIKEL' : 'VIDEO',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10, right: 10,
                    child: Row(
                      children: [
                        const Icon(Icons.access_time_filled_rounded, size: 14, color: colorTextGray),
                        const SizedBox(width: 4),
                        Text(duration, style: const TextStyle(fontSize: 11, color: colorTextGray)),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 50, width: 50,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Icon(
                        isArtikel ? Icons.menu_book_rounded : Icons.play_circle_outline_rounded,
                        size: 30, color: isArtikel ? colorTagOrange : colorTagBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}