// lib/features/ibu/profil/data/models/profil_ibu_model.dart

class RiwayatKehamilanSingkat {
  final int id;
  final int gravida;
  final int paritas;
  final int abortus;
  final String hpht;
  final String taksiranPersalinan;
  final String statusKehamilan;
  final double bbAwal;
  final double tb;
  final double imtAwal;

  const RiwayatKehamilanSingkat({
    required this.id,
    required this.gravida,
    required this.paritas,
    required this.abortus,
    required this.hpht,
    required this.taksiranPersalinan,
    required this.statusKehamilan,
    required this.bbAwal,
    required this.tb,
    required this.imtAwal,
  });

  factory RiwayatKehamilanSingkat.fromJson(Map<String, dynamic> json) {
    return RiwayatKehamilanSingkat(
      id: (json['id'] as num?)?.toInt() ?? 0,
      gravida: (json['gravida'] as num?)?.toInt() ?? 0,
      paritas: (json['paritas'] as num?)?.toInt() ?? 0,
      abortus: (json['abortus'] as num?)?.toInt() ?? 0,
      hpht: json['hpht']?.toString() ?? '',
      taksiranPersalinan: json['taksiran_persalinan']?.toString() ?? '',
      statusKehamilan: json['status_kehamilan']?.toString() ?? '',
      bbAwal: (json['bb_awal'] as num?)?.toDouble() ?? 0.0,
      tb: (json['tb'] as num?)?.toDouble() ?? 0.0,
      imtAwal: (json['imt_awal'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ProfilIbuModel {
  final int userId;
  final String email;
  final String nomorTelepon;

  // Data kependudukan
  final String nik;
  final String namaLengkap;
  final String tempatLahir;
  final String tanggalLahir;
  final String golonganDarah;
  final String agama;
  final String pendidikanTerakhir;
  final String pekerjaan;
  final String statusPerkawinan;
  final String dusun;
  final String desa;
  final String kecamatan;
  final String nomorTeleponPenduduk;

  // Data ibu
  final int ibuId;
  final String statusKehamilan;

  // Riwayat kehamilan
  final List<RiwayatKehamilanSingkat> riwayatKehamilan;

  const ProfilIbuModel({
    required this.userId,
    required this.email,
    required this.nomorTelepon,
    required this.nik,
    required this.namaLengkap,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.golonganDarah,
    required this.agama,
    required this.pendidikanTerakhir,
    required this.pekerjaan,
    required this.statusPerkawinan,
    required this.dusun,
    required this.desa,
    required this.kecamatan,
    required this.nomorTeleponPenduduk,
    required this.ibuId,
    required this.statusKehamilan,
    required this.riwayatKehamilan,
  });

  factory ProfilIbuModel.fromJson(Map<String, dynamic> json) {
    final riwayatJson = json['riwayat_kehamilan'] as List<dynamic>? ?? [];
    return ProfilIbuModel(
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      email: json['email']?.toString() ?? '',
      nomorTelepon: json['nomor_telepon']?.toString() ?? '',
      nik: json['nik']?.toString() ?? '',
      namaLengkap: json['nama_lengkap']?.toString() ?? '',
      tempatLahir: json['tempat_lahir']?.toString() ?? '',
      tanggalLahir: json['tanggal_lahir']?.toString() ?? '',
      golonganDarah: json['golongan_darah']?.toString() ?? '',
      agama: json['agama']?.toString() ?? '',
      pendidikanTerakhir: json['pendidikan_terakhir']?.toString() ?? '',
      pekerjaan: json['pekerjaan']?.toString() ?? '',
      statusPerkawinan: json['status_perkawinan']?.toString() ?? '',
      dusun: json['dusun']?.toString() ?? '',
      desa: json['desa']?.toString() ?? '',
      kecamatan: json['kecamatan']?.toString() ?? '',
      nomorTeleponPenduduk: json['nomor_telepon_penduduk']?.toString() ?? '',
      ibuId: (json['ibu_id'] as num?)?.toInt() ?? 0,
      statusKehamilan: json['status_kehamilan']?.toString() ?? '',
      riwayatKehamilan: riwayatJson
          .map((e) =>
              RiwayatKehamilanSingkat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}