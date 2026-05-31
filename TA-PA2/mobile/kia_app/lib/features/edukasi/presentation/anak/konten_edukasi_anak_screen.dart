import 'package:flutter/material.dart';
import 'package:ta_pa2_pa3_project/core/themes/app_colors.dart';

import 'pedoman/pedoman_0_6_bulan_screen.dart';
import 'pedoman/pedoman_6_12_bulan_screen.dart';
import 'pedoman/pedoman_12_24_bulan_screen.dart';
import 'pedoman/pedoman_2_6_tahun_screen.dart';
import 'pedoman/pedoman_ibu_bayi_screen.dart';
import 'pedoman/pola_asuh_screen.dart';

import 'informasi_umum/informasi_umum_screen.dart';

import '../widgets/edukasi_search_filter.dart';

class KontenEdukasiAnakScreen extends StatefulWidget {
  const KontenEdukasiAnakScreen({super.key});

  @override
  State<KontenEdukasiAnakScreen> createState() =>
      _KontenEdukasiAnakScreenState();
}

class _KontenEdukasiAnakScreenState
    extends State<KontenEdukasiAnakScreen> {

  String selectedCategory = 'Semua';

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> edukasiAnak = [

      {
        'title': 'Informasi Umum Anak',
        'duration': '5 Menit',
        'category': 'ARTIKEL',
        'screen': const InformasiUmumScreen(),
      },

      {
        'title': 'Pedoman Ibu dan Bayi',
        'duration': '5 Menit',
        'category': 'VIDEO',
        'screen': const PedomanIbuBayiScreen(),
      },

      {
        'title': 'Pedoman 0 - 6 Bulan',
        'duration': '4 Menit',
        'category': 'ARTIKEL',
        'screen': const Pedoman06BulanScreen(),
      },

      {
        'title': 'Pedoman 6 - 12 Bulan',
        'duration': '6 Menit',
        'category': 'VIDEO',
        'screen': const Pedoman612BulanScreen(),
      },

      {
        'title': 'Pedoman 12 - 24 Bulan',
        'duration': '4 Menit',
        'category': 'ARTIKEL',
        'screen': const Pedoman1224BulanScreen(),
      },

      {
        'title': 'Pedoman 2 - 6 Tahun',
        'duration': '5 Menit',
        'category': 'VIDEO',
        'screen': const Pedoman26TahunScreen(),
      },

      {
        'title': 'Pola Asuh Anak',
        'duration': '3 Menit',
        'category': 'ARTIKEL',
        'screen': const PolaAsuhScreen(),
      },
    ];

    final filteredData = edukasiAnak.where((item) {

      final matchesCategory =
          selectedCategory == 'Semua'
              ? true
              : item['category'] ==
                  selectedCategory;

      final matchesSearch =
          item['title']
              .toString()
              .toLowerCase()
              .contains(
                searchQuery.toLowerCase(),
              );

      return matchesCategory &&
          matchesSearch;

    }).toList();

    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F7FB,
      ),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Edukasi Anak',

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
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            EdukasiSearchFilter(
              selectedCategory:
                  selectedCategory,

              categories: const [
                'Semua',
                'VIDEO',
                'ARTIKEL',
              ],

              onCategorySelected: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },

              onSearchChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),

            const SizedBox(height: 20),

            Expanded(
              child: filteredData.isEmpty

                  ? const Center(
                      child: Text(
                        'Edukasi tidak ditemukan',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    )

                  : ListView.builder(
                      itemCount:
                          filteredData.length,

                      itemBuilder:
                          (context, index) {

                        final item =
                            filteredData[index];

                        final bool isVideo =
                            item['category'] ==
                                'VIDEO';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) =>
                                    item['screen'],
                              ),
                            );
                          },

                          child: Container(
                            margin:
                                const EdgeInsets.only(
                              bottom: 16,
                            ),

                            decoration:
                                BoxDecoration(
                              color: Colors.white,

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                18,
                              ),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withValues(
                                    alpha: 0.04,
                                  ),

                                  blurRadius: 8,

                                  offset:
                                      const Offset(
                                    0,
                                    4,
                                  ),
                                ),
                              ],
                            ),

                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Container(
                                  height: 120,

                                  decoration:
                                      BoxDecoration(
                                    color: isVideo
                                        ? const Color(
                                            0xFFDDEEFF,
                                          )
                                        : const Color(
                                            0xFFFFE9B3,
                                          ),

                                    borderRadius:
                                        const BorderRadius
                                            .vertical(
                                      top:
                                          Radius.circular(
                                        18,
                                      ),
                                    ),
                                  ),

                                  child: Center(
                                    child: Container(
                                      padding:
                                          const EdgeInsets
                                              .all(
                                        12,
                                      ),

                                      decoration:
                                          BoxDecoration(
                                        color: Colors
                                            .white,

                                        shape:
                                            BoxShape
                                                .circle,

                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors
                                                .black
                                                .withValues(
                                              alpha:
                                                  0.08,
                                            ),

                                            blurRadius:
                                                8,
                                          ),
                                        ],
                                      ),

                                      child: Icon(
                                        isVideo
                                            ? Icons
                                                .play_arrow_rounded
                                            : Icons
                                                .menu_book_rounded,

                                        size: 32,

                                        color:
                                            AppColors
                                                .primary,
                                      ),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets
                                          .all(
                                    14,
                                  ),

                                  child: Row(
                                    children: [

                                      Container(
                                        padding:
                                            const EdgeInsets
                                                .symmetric(
                                          horizontal:
                                              10,
                                          vertical: 4,
                                        ),

                                        decoration:
                                            BoxDecoration(
                                          color:
                                              AppColors
                                                  .primary,

                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                            20,
                                          ),
                                        ),

                                        child: Text(
                                          item[
                                              'category'],

                                          style:
                                              const TextStyle(
                                            color: Colors
                                                .white,

                                            fontSize:
                                                11,

                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),
                                      ),

                                      const Spacer(),

                                      Row(
                                        children: [

                                          const Icon(
                                            Icons
                                                .access_time,
                                            size: 15,
                                            color: Colors
                                                .grey,
                                          ),

                                          const SizedBox(
                                            width: 4,
                                          ),

                                          Text(
                                            item[
                                                'duration'],

                                            style:
                                                const TextStyle(
                                              fontSize:
                                                  12,
                                              color: Colors
                                                  .grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets
                                          .only(
                                    left: 14,
                                    right: 14,
                                    bottom: 16,
                                  ),

                                  child: Text(
                                    item['title'],

                                    style:
                                        const TextStyle(
                                      fontSize: 15,

                                      fontWeight:
                                          FontWeight
                                              .w600,

                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}