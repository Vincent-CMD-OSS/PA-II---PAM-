import 'package:flutter/material.dart';

import 'package:ta_pa2_pa3_project/core/themes/app_colors.dart';

class DashboardBottomNav extends StatelessWidget {

  final int currentIndex;
  final ValueChanged<int> onTap;

  const DashboardBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(

      type: BottomNavigationBarType.fixed,

      backgroundColor: AppColors.white,

      selectedItemColor: AppColors.primary,

      unselectedItemColor: AppColors.textHint,

      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),

      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 11,
      ),

      elevation: 8,

      currentIndex: currentIndex,

      onTap: (index) {

        try {

          onTap(index);

        } catch (e) {

          debugPrint(
            'Bottom navigation error: $e',
          );
        }
      },

      items: const [

        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Beranda',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.event_available_outlined),
          label: 'Absensi',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.book_outlined),
          label: 'Edukasi',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profil',
        ),
      ],
    );
  }
}