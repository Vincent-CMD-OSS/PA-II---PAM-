import 'package:flutter/material.dart';

import 'package:ta_pa2_pa3_project/core/services/auth_session.dart';
import 'package:ta_pa2_pa3_project/core/services/notification_data.dart';

import 'package:ta_pa2_pa3_project/core/themes/app_colors.dart';

class DashboardHeader extends StatelessWidget {

  const DashboardHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final name =
        AuthSession.userName ??
        'Bunda';

    return Container(

      padding: const EdgeInsets.only(
        top: 60,
        left: 24,
        right: 24,
        bottom: 32,
      ),

      decoration: const BoxDecoration(

        gradient: LinearGradient(

          colors: [
            AppColors.primary,
            AppColors.blue500,
          ],

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),

      child: Row(

        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [

          Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                'Halo, $name!',

                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Row(
                children: [

                  Icon(
                    Icons.favorite,
                    color: Colors.white70,
                    size: 14,
                  ),

                  SizedBox(width: 4),

                  Text(
                    'Semangat jalani hari ini, Bunda!',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Container(

            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: AppColors.white.withValues(
                alpha: 0.20,
              ),

              shape: BoxShape.circle,
            ),

            child: PopupMenuButton<String>(

              padding: EdgeInsets.zero,

              color: AppColors.white,

              elevation: 8,

              offset: const Offset(0, 50),

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(18),
              ),

              icon: Stack(
                children: [

                  const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.white,
                    size: 28,
                  ),

                  if (NotificationData
                      .notifications
                      .isNotEmpty)

                    Positioned(

                      right: 0,
                      top: 0,

                      child: Container(
                        width: 10,
                        height: 10,

                        decoration: const BoxDecoration(
                          color: AppColors.danger,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),

              onSelected: (value) {

                try {

                } catch (e) {

                  debugPrint(
                    'Notification menu error: $e',
                  );
                }
              },

              itemBuilder: (context) {

                final notifications =
                    NotificationData.notifications;

                if (notifications.isEmpty) {

                  return [

                    const PopupMenuItem<String>(

                      enabled: false,

                      child: Row(
                        children: [

                          Icon(
                            Icons.notifications_off_outlined,
                            color: AppColors.textHint,
                            size: 18,
                          ),

                          SizedBox(width: 10),

                          Text(
                            'Belum ada notifikasi',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                }

                return notifications.map((notif) {

                  return PopupMenuItem<String>(

                    value:
                        notif['title'],

                    child: Container(

                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 8,
                      ),

                      child: Row(

                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Container(

                            padding:
                                const EdgeInsets.all(10),

                            decoration: BoxDecoration(

                              color:
                                  (notif['color'] as Color)
                                      .withValues(
                                alpha: 0.15,
                              ),

                              borderRadius:
                                  BorderRadius.circular(12),
                            ),

                            child: Icon(
                              notif['icon'],
                              size: 20,
                              color: notif['color'],
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(

                            child: Column(

                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              mainAxisSize:
                                  MainAxisSize.min,

                              children: [

                                Text(
                                  notif['title'],

                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  notif['subtitle'],

                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );

                }).toList();
              },
            ),
          ),
        ],
      ),
    );
  }
}