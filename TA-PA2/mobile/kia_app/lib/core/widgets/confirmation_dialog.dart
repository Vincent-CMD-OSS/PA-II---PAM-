// Sebagai dialog konfirmasi simpan data

import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class ConfirmationDialog extends StatelessWidget {

  final String title;
  final String content;
  final VoidCallback onConfirm;
  final Color primaryColor;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      backgroundColor: AppColors.white,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      titlePadding: const EdgeInsets.fromLTRB(
        24,
        24,
        24,
        8,
      ),

      contentPadding: const EdgeInsets.fromLTRB(
        24,
        0,
        24,
        12,
      ),

      actionsPadding: const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16,
      ),

      title: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withValues(
                alpha: 0.12,
              ),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.assignment_turned_in_outlined,
              color: primaryColor,
              size: 24,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),

      content: Text(
        content,
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
          color: AppColors.textSecondary,
        ),
      ),

      actions: [

        Expanded(
          child: OutlinedButton(

            style: OutlinedButton.styleFrom(
              foregroundColor:
                  AppColors.textSecondary,

              side: const BorderSide(
                color: AppColors.border,
              ),

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),

              padding:
                  const EdgeInsets.symmetric(
                vertical: 14,
              ),
            ),

            onPressed: () {

              try {

                Navigator.pop(context);

              } catch (e) {

                debugPrint(
                  'Dialog close error: $e',
                );
              }
            },

            child: const Text(
              'Periksa Lagi',
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: ElevatedButton(

            style: ElevatedButton.styleFrom(
              elevation: 0,

              backgroundColor: primaryColor,

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),

              padding:
                  const EdgeInsets.symmetric(
                vertical: 14,
              ),
            ),

            onPressed: () async {

              try {

                Navigator.pop(context);

                onConfirm();

              } catch (e) {

                debugPrint(
                  'Confirmation dialog error: $e',
                );

                if (context.mounted) {

                  ScaffoldMessenger.of(context)
                      .showSnackBar(

                    const SnackBar(
                      content: Text(
                        'Terjadi kesalahan, coba lagi',
                      ),
                    ),
                  );
                }
              }
            },

            child: const Text(
              'Ya, Simpan',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}