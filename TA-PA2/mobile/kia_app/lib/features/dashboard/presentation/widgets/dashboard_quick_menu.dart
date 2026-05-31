import 'package:flutter/material.dart';

import 'package:ta_pa2_pa3_project/core/themes/app_colors.dart';

class DashboardQuickMenu extends StatelessWidget {

  final List<Map<String, dynamic>> items;
  final int crossAxisCount;
  final double childAspectRatio;

  const DashboardQuickMenu({
    super.key,
    required this.items,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.72,
  });

  @override
  Widget build(BuildContext context) {

    return GridView.builder(

      shrinkWrap: true,

      physics:
          const NeverScrollableScrollPhysics(),

      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(

        crossAxisCount:
            crossAxisCount,

        mainAxisSpacing: 12,

        crossAxisSpacing: 12,

        childAspectRatio:
            childAspectRatio,
      ),

      itemCount: items.length,

      itemBuilder: (context, i) {

        final item = items[i];

        final VoidCallback? onTap =
            item['onTap'] as VoidCallback?;

        return Material(

          color: AppColors.transparent,

          child: InkWell(

            borderRadius:
                BorderRadius.circular(18),

            onTap: onTap == null

                ? null

                : () {

                    try {

                      onTap();

                    } catch (e) {

                      debugPrint(
                        'Quick menu error: $e',
                      );
                    }
                  },

            child: Container(

              padding:
                  const EdgeInsets.all(12),

              decoration: BoxDecoration(

                color: AppColors.white,

                borderRadius:
                    BorderRadius.circular(18),

                border: Border.all(
                  color: AppColors.borderLight,
                ),

                boxShadow: [

                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                  ),
                ],
              ),

              child: Column(

                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  Container(

                    width: 42,
                    height: 42,

                    decoration: BoxDecoration(

                      color:
                          (item['color'] as Color)
                              .withValues(
                        alpha: 0.12,
                      ),

                      borderRadius:
                          BorderRadius.circular(14),
                    ),

                    child: Icon(

                      item['icon']
                          as IconData,

                      color:
                          item['color']
                              as Color,

                      size: 22,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(

                    item['label'] as String,

                    maxLines: 2,

                    overflow:
                        TextOverflow.ellipsis,

                    textAlign:
                    TextAlign.center,

                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Grid menu untuk konten Tumbuh (3 kolom, ikon + teks)
class DashboardTumbuhQuickMenu extends StatelessWidget {

  final List<Map<String, dynamic>> items;

  const DashboardTumbuhQuickMenu({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {

    final screenWidth =
        MediaQuery.of(context).size.width;

    final itemWidth =
        (screenWidth - 40 - 24) / 3;

    return Wrap(

      alignment:
          WrapAlignment.center,

      spacing: 12,

      runSpacing: 12,

      children: items.map((item) {

        final VoidCallback? onTap =
            item['onTap'] as VoidCallback?;

        return SizedBox(

          width: itemWidth,
          height: itemWidth,

          child: Material(

            color: AppColors.transparent,

            child: InkWell(

              onTap: onTap == null

                  ? null

                  : () {

                      try {

                        onTap();

                      } catch (e) {

                        debugPrint(
                          'Tumbuh quick menu error: $e',
                        );
                      }
                    },

              borderRadius:
                  BorderRadius.circular(18),

              child: Container(

                decoration: BoxDecoration(

                  color: AppColors.white,

                  borderRadius:
                      BorderRadius.circular(18),

                  border: Border.all(
                    color: AppColors.borderLight,
                  ),

                  boxShadow: [

                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 8,
                    ),
                  ],
                ),

                child: Column(

                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [

                    Container(

                      width: 42,
                      height: 42,

                      decoration: BoxDecoration(

                        color:
                            (item['color'] as Color)
                                .withValues(
                          alpha: 0.12,
                        ),

                        borderRadius:
                            BorderRadius.circular(14),
                      ),

                      child: Icon(

                        item['icon']
                            as IconData,

                        color:
                            item['color']
                                as Color,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(

                      item['label']
                          as String,

                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),

                      textAlign:
                          TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

      }).toList(),
    );
  }
}