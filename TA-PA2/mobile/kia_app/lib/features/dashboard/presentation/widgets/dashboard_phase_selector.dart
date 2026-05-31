import 'package:flutter/material.dart';

import 'package:ta_pa2_pa3_project/core/themes/app_colors.dart';
import 'package:ta_pa2_pa3_project/features/dashboard/data/dashboard_menu_data.dart';

class DashboardPhaseSelector extends StatelessWidget {

  final String selectedPhase;
  final ValueChanged<String> onPhaseSelected;

  const DashboardPhaseSelector({
    super.key,
    required this.selectedPhase,
    required this.onPhaseSelected,
  });

  @override
  Widget build(BuildContext context) {

    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        const Text(
          'TAHAP SAAT INI',

          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textHint,
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(height: 12),

        Row(

          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

          children:
              DashboardMenuData.phases.map((p) {

            final bool isActive =
                selectedPhase == p['label'];

            return GestureDetector(

              onTap: () {

                try {

                  onPhaseSelected(
                    p['label'] as String,
                  );

                } catch (e) {

                  debugPrint(
                    'Phase selector error: $e',
                  );
                }
              },

              child: Column(
                children: [

                  AnimatedContainer(

                    duration:
                        const Duration(
                      milliseconds: 220,
                    ),

                    width: 65,
                    height: 65,

                    decoration: BoxDecoration(

                      color: AppColors.white,

                      borderRadius:
                          BorderRadius.circular(16),

                      border: isActive

                          ? Border.all(
                              color: AppColors.primary,
                              width: 2,
                            )

                          : Border.all(
                              color: AppColors.borderLight,
                            ),

                      boxShadow: [

                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 10,
                        ),
                      ],
                    ),

                    child: Icon(

                      p['icon'] as IconData,

                      color: isActive

                          ? AppColors.primary

                          : AppColors.textHint,

                      size: 30,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(

                    p['label'] as String,

                    style: TextStyle(

                      fontSize: 12,

                      color: isActive

                          ? AppColors.primary

                          : AppColors.textSecondary,

                      fontWeight: isActive

                          ? FontWeight.bold

                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );

          }).toList(),
        ),
      ],
    );
  }
}