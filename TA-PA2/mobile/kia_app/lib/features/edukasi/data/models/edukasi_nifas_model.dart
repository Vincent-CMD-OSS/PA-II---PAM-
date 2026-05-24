class EdukasiNifasModel {
  final int id;
  final String judul;
  final String isi;
  final String perawatan;
  final String tandaBahaya;
  final String gambarUrl;

  EdukasiNifasModel({
    required this.id,
    required this.judul,
    required this.isi,
    required this.perawatan,
    required this.tandaBahaya,
    required this.gambarUrl,
  });

  factory EdukasiNifasModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EdukasiNifasModel(
      id: json['id'],
      judul: json['judul'] ?? '',
      isi: json['isi'] ?? '',
      perawatan: json['perawatan'] ?? '',
      tandaBahaya: json['tanda_bahaya'] ?? '',
      gambarUrl: json['gambar_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'isi': isi,
      'perawatan': perawatan,
      'tanda_bahaya': tandaBahaya,
      'gambar_url': gambarUrl,
    };
  }
}