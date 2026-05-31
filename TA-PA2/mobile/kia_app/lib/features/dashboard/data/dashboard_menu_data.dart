import 'package:flutter/material.dart';

import 'package:ta_pa2_pa3_project/core/themes/app_colors.dart';

import 'dashboard_menu_item.dart';

class DashboardMenuData {

  static List<Map<String, dynamic>> hamilMenuItems = [

    {
      'title': 'Kehamilan Trimester 1–3',
      'subtitle': 'Pantau perkembangan kehamilan',
      'icon': Icons.favorite_outline,
      'color': AppColors.pink,
    },

    {
      'title': 'Persalinan',
      'subtitle': 'Persiapan & proses persalinan',
      'icon': Icons.child_care_outlined,
      'color': AppColors.primary,
    },
  ];

  // Quick Menu Hamil
  static List<Map<String, dynamic>> hamilQuickMenuItems = [

    {
      'label': 'Grafik BB Ibu',
      'icon': Icons.show_chart,
      'color': AppColors.primary,
      'key': 'bb_ibu',
    },

    {
      'label': 'Grafik DJJ & TFU',
      'icon': Icons.monitor_heart_outlined,
      'color': AppColors.purple,
      'key': 'djj_tfu',
    },

    {
      'label': 'Catatan',
      'icon': Icons.assignment_outlined,
      'color': AppColors.indigo,
      'key': 'catatan',
    },

    {
      'label': 'Log Minum TTD/MMS',
      'icon': Icons.medication_outlined,
      'color': AppColors.danger,
      'key': 'log_ttd',
    },

    {
      'label': 'Rujukan',
      'icon': Icons.description_outlined,
      'color': AppColors.amber,
      'key': 'rujukan',
    },

    {
      'label': 'Pemantauan Ibu Hamil',
      'icon': Icons.health_and_safety_outlined,
      'color': AppColors.teal,
      'key': 'pemantauan',
    },
  ];

  // Quick Menu Tumbuh
  static List<Map<String, dynamic>> tumbuhQuickMenuItems = [

    {
      'label': 'Pertumbuhan',
      'icon': Icons.scale,
      'color': AppColors.primary,
      'key': 'pertumbuhan',
    },

    {
      'label': 'Perkembangan',
      'icon': Icons.self_improvement,
      'color': AppColors.secondary,
      'key': 'pemantauan',
    },

    {
      'label': 'Catatan',
      'icon': Icons.assignment_outlined,
      'color': AppColors.indigo,
      'key': 'catatan',
    },

    {
      'label': 'Imunisasi',
      'icon': Icons.health_and_safety_outlined,
      'color': AppColors.warning,
      'key': 'imunisasi',
    },

    {
      'label': 'MPASI',
      'icon': Icons.restaurant_menu,
      'color': AppColors.orangeSoft,
      'key': 'mpasi',
    },
  ];

  // Fase Dashboard
  static List<Map<String, dynamic>> phases = [

    {
      'label': 'Hamil',
      'icon': Icons.favorite_border,
    },

    {
      'label': 'Nifas',
      'icon': Icons.person_outline,
    },

    {
      'label': 'Menyusui',
      'icon': Icons.child_care_outlined,
    },

    {
      'label': 'Tumbuh',
      'icon': Icons.emoji_emotions_outlined,
    },
  ];
}