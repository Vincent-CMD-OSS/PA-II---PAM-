import 'package:flutter/material.dart';

import 'package:ta_pa2_pa3_project/core/themes/app_colors.dart';

class DashboardMenuCard extends StatelessWidget {

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  final bool isCompact;
  final Color? backgroundColor;
  final Color? borderColor;

  const DashboardMenuCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    this.onTap,
    this.isCompact = false,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.only(
        bottom: 16,
      ),

      decoration: BoxDecoration(

        color:
            backgroundColor ??
            AppColors.white,

        borderRadius:
            BorderRadius.circular(24),

        border: Border.all(

          color:
              borderColor ??
              AppColors.transparent,
        ),

        boxShadow: [

          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Material(

        color: AppColors.transparent,

        child: InkWell(

          borderRadius:
              BorderRadius.circular(24),

          onTap: onTap == null

              ? null

              : () {

                  try {

                    onTap!();

                  } catch (e) {

                    debugPrint(
                      'Dashboard menu error: $e',
                    );
                  }
                },

          child: Padding(

            padding: EdgeInsets.all(
              isCompact ? 16 : 20,
            ),

            child: Row(
              children: [

                Container(

                  width:
                      isCompact ? 48 : 56,

                  height:
                      isCompact ? 48 : 56,

                  decoration: BoxDecoration(

                    color:
                        iconColor.withValues(
                      alpha: 0.10,
                    ),

                    borderRadius:
                        BorderRadius.circular(16),
                  ),

                  child: Icon(
                    icon,
                    color: iconColor,
                    size:
                        isCompact ? 24 : 28,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      Text(
                        title,

                        style: TextStyle(

                          fontSize:
                              isCompact ? 15 : 16,

                          fontWeight:
                              FontWeight.bold,

                          color:
                              AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        subtitle,

                        maxLines: 2,

                        overflow:
                            TextOverflow.ellipsis,

                        style: TextStyle(

                          fontSize:
                              isCompact ? 12 : 13,

                          color:
                              AppColors.textSecondary,

                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),

                if (onTap != null)

                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textHint,
                    size:
                        isCompact ? 22 : 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget kartu info generic (progress kehamilan, buah, dll)
class DashboardInfoCard extends StatelessWidget {

  final Widget child;

  const DashboardInfoCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: AppColors.white,

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: [

          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
          ),
        ],
      ),

      child: child,
    );
  }
}