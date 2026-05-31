import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:ta_pa2_pa3_project/core/themes/app_colors.dart';

import '../../data/models/catatan_pelayanan_nifas_model.dart';
import '../../data/repositories/catatan_pelayanan_nifas_repository.dart';
import '../../data/services/catatan_pelayanan_nifas_service.dart';

class CatatanPelayananNifasScreen extends StatefulWidget {
  const CatatanPelayananNifasScreen({
    super.key,
  });

  @override
  State<CatatanPelayananNifasScreen> createState() =>
      _CatatanPelayananNifasScreenState();
}

class _CatatanPelayananNifasScreenState
    extends State<CatatanPelayananNifasScreen> {

  final repository =
      CatatanPelayananNifasRepository(
    CatatanPelayananNifasService(),
  );

  bool isLoading = true;

  List<CatatanPelayananNifasModel>
      data = [];

  @override
  void initState() {
    super.initState();

    initializeDateFormatting(
      'id_ID',
    );

    loadData();
  }

  Future<void> loadData() async {

    setState(() {
      isLoading = true;
    });

    try {

      final result =
          await repository.getMine();

      setState(() {
        data = result;
      });

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );

    } finally {

      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDate(
    DateTime? value,
  ) {

    if (value == null) {
      return '-';
    }

    return DateFormat(
      'dd MMMM yyyy',
      'id_ID',
    ).format(value);
  }

  Widget buildItem(
    String title,
    String value,
  ) {

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: const TextStyle(
              fontWeight:
                  FontWeight.bold,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),

          const SizedBox(
            height: 6,
          ),

          Text(
            value.isEmpty
                ? '-'
                : value,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF4F7FB),

      appBar: AppBar(
        title: const Text(
          'Catatan Pelayanan Nifas',
          style: TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.bold,
          ),
        ),
        backgroundColor:
            AppColors.primary,
        foregroundColor:
            Colors.white,
        elevation: 0,
      ),

      body: RefreshIndicator(
        onRefresh: loadData,

        child: isLoading

            ? const Center(
                child:
                    CircularProgressIndicator(),
              )

            : data.isEmpty

                ? ListView(
                    children: [

                      SizedBox(
                        height:
                            MediaQuery.of(
                                      context,
                                    )
                                    .size
                                    .height *
                                0.3,
                      ),

                      const Center(
                        child: Text(
                          'Belum ada catatan pelayanan nifas',
                          style:
                              TextStyle(
                            color:
                                Colors
                                    .black54,
                          ),
                        ),
                      ),
                    ],
                  )

                : ListView.builder(
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),

                    itemCount:
                        data.length,

                    itemBuilder:
                        (
                      context,
                      index,
                    ) {

                      final item =
                          data[index];

                      return Container(
                        margin:
                            const EdgeInsets.only(
                          bottom: 18,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                            26,
                          ),

                          boxShadow: [

                            BoxShadow(
                              color: Colors
                                  .black
                                  .withOpacity(
                                0.05,
                              ),

                              blurRadius:
                                  12,

                              offset:
                                  const Offset(
                                0,
                                4,
                              ),
                            ),
                          ],
                        ),

                        child: Column(
                          children: [

                            Container(
                              width: double.infinity,

                              padding:
                                  const EdgeInsets.all(
                                18,
                              ),

                              decoration:
                                  BoxDecoration(
                                color:
                                    AppColors
                                        .primary,

                                borderRadius:
                                    const BorderRadius.only(
                                  topLeft:
                                      Radius.circular(
                                    26,
                                  ),

                                  topRight:
                                      Radius.circular(
                                    26,
                                  ),
                                ),
                              ),

                              child: Row(
                                children: [

                                  const CircleAvatar(
                                    backgroundColor:
                                        Colors.white,

                                    child: Icon(
                                      Icons
                                          .note_alt_outlined,

                                      color:
                                          AppColors
                                              .primary,
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 12,
                                  ),

                                  Expanded(
                                    child:
                                        Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,

                                      children: [

                                        const Text(
                                          'Catatan Pemeriksaan',

                                          style:
                                              TextStyle(
                                            color:
                                                Colors.white,

                                            fontWeight:
                                                FontWeight.bold,

                                            fontSize:
                                                16,
                                          ),
                                        ),

                                        const SizedBox(
                                          height:
                                              4,
                                        ),

                                        Text(
                                          formatDate(
                                            item
                                                .tanggalPeriksa,
                                          ),

                                          style:
                                              const TextStyle(
                                            color:
                                                Colors.white70,

                                            fontSize:
                                                12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.all(
                                18,
                              ),

                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [

                                  buildItem(
                                    'Keluhan / Pemeriksaan / Tindakan / Saran',

                                    item.keluhan,
                                  ),

                                  buildItem(
                                    'Tanggal Kembali',

                                    formatDate(
                                      item
                                          .tanggalKembali,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}