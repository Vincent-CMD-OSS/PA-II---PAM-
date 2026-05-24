class PemantauanIbuHamilModel {
  final int? id;
  final int mingguKehamilan;
  final bool demamLebih2Hari;
  final bool sakitKepala;
  final bool cemasBerlebih;
  final bool resikoTB;
  final bool gerakanBayiKurang;
  final bool nyeriPerut;
  final bool cairanJalanLahir;
  final bool masalahKemaluan;
  final bool diareBerulang;

  const PemantauanIbuHamilModel({
    this.id,
    required this.mingguKehamilan,
    required this.demamLebih2Hari,
    required this.sakitKepala,
    required this.cemasBerlebih,
    required this.resikoTB,
    required this.gerakanBayiKurang,
    required this.nyeriPerut,
    required this.cairanJalanLahir,
    required this.masalahKemaluan,
    required this.diareBerulang,
  });

  factory PemantauanIbuHamilModel.fromJson(Map<String, dynamic> json) {
    return PemantauanIbuHamilModel(
      id: json['id'],
      mingguKehamilan: json['minggu_kehamilan'] ?? 0,
      demamLebih2Hari: json['demam_lebih_2_hari'] ?? false,
      sakitKepala: json['sakit_kepala'] ?? false,
      cemasBerlebih: json['cemas_berlebih'] ?? false,
      resikoTB: json['resiko_tb'] ?? false,
      gerakanBayiKurang: json['gerakan_bayi_kurang'] ?? false,
      nyeriPerut: json['nyeri_perut'] ?? false,
      cairanJalanLahir: json['cairan_jalan_lahir'] ?? false,
      masalahKemaluan: json['masalah_kemaluan'] ?? false,
      diareBerulang: json['diare_berulang'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minggu_kehamilan': mingguKehamilan,
      'demam_lebih_2_hari': demamLebih2Hari,
      'sakit_kepala': sakitKepala,
      'cemas_berlebih': cemasBerlebih,
      'resiko_tb': resikoTB,
      'gerakan_bayi_kurang': gerakanBayiKurang,
      'nyeri_perut': nyeriPerut,
      'cairan_jalan_lahir': cairanJalanLahir,
      'masalah_kemaluan': masalahKemaluan,
      'diare_berulang': diareBerulang,
    };
  }
}