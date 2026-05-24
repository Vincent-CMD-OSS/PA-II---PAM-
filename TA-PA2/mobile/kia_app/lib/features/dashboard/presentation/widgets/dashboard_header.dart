// import 'package:flutter/material.dart';
// import 'package:ta_pa2_pa3_project/core/services/auth_session.dart';
// import 'package:ta_pa2_pa3_project/core/themes/app_theme.dart';

// class DashboardHeader extends StatelessWidget {
//   const DashboardHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final name = AuthSession.userName ?? 'Bunda';

//     return Container(
//       padding: const EdgeInsets.only(
//         top: 60,
//         left: 24,
//         right: 24,
//         bottom: 32,
//       ),
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: TrimesterTheme.t1Gradient,
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//           bottomRight: Radius.circular(30),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Selamat Pagi ✨",
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 16,
//                 ),
//               ),
//               Text(
//                 "Halo, $name!",
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Row(
//                 children: [
//                   Icon(
//                     Icons.calendar_today,
//                     color: Colors.white70,
//                     size: 14,
//                   ),
//                   SizedBox(width: 4),
//                   Text(
//                     "Trimester 2 • Bebas keluhan berat",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),

//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               shape: BoxShape.circle,
//             ),
//             child: PopupMenuButton<String>(
//               padding: EdgeInsets.zero,
//               color: Colors.white,
//               elevation: 6,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               icon: const Icon(
//                 Icons.notifications_none,
//                 color: Colors.white,
//               ),
//               onSelected: (value) {},
//               itemBuilder: (context) => [
//                 const PopupMenuItem(
//                   value: 'notif',
//                   enabled: false,
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.notifications_off_outlined,
//                         size: 18,
//                         color: Colors.grey,
//                       ),
//                       SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           'Belum ada notifikasi',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:ta_pa2_pa3_project/core/services/auth_session.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final name = AuthSession.userName ?? 'Bunda';

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
            Color(0xFF185FA5),
            Color(0xFF2A79C5),
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
                "Halo, $name!",

                style: const TextStyle(
                  color: Colors.white,
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
                    "Semangat jalani hari ini, Bunda!",

                    style: TextStyle(
                      color: Colors.white,
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
              color:
                  Colors.white.withValues(
                alpha: 0.2,
              ),

              shape: BoxShape.circle,
            ),

            child: PopupMenuButton<String>(
              padding: EdgeInsets.zero,

              color: Colors.white,

              elevation: 6,

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),

              icon: const Icon(
                Icons.notifications_none,
                color: Colors.white,
              ),

              onSelected: (value) {},

              itemBuilder: (context) => [

                const PopupMenuItem(
                  value: 'notif',
                  enabled: false,

                  child: Row(
                    children: [

                      Icon(
                        Icons
                            .notifications_off_outlined,
                        size: 18,
                        color: Colors.grey,
                      ),

                      SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          'Belum ada notifikasi',

                          style: TextStyle(
                            fontSize: 13,
                            color:
                                Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}