import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/models/kehamilan_aktif_model.dart';
import 'package:ta_pa2_pa3_project/features/anak/anak/data/models/ibu_anak_model.dart';

abstract class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final String selectedPhase;
  final KehamilanAktifModel? kehamilanAktif;
  final List<IbuAnakModel> anakSaya;

  const DashboardLoaded({
    this.selectedPhase = 'Hamil',
    this.kehamilanAktif,
    this.anakSaya = const [],
  });

  String get contextualGuidanceText {

  if (selectedPhase == 'Hamil') {

    final week = kehamilanAktif?.usiaKehamilanMinggu ?? 0;

    if (week > 0 && week <= 12) {
      return 'Bunda sedang di Trimester 1. Yuk cek kondisi awal kehamilan dan perkembangan janinmu!';
    }

    else if (week > 12 && week <= 27) {
      return 'Bunda sudah di dalam Trimester 2. Yuk pantau pertumbuhan janin dan kesehatan Bunda!';
    }

    else if (week > 27) {
      return 'Trimester 3 sedang berjalan, Bun. Yuk cek kesiapan persalinan dan kondisi kandunganmu!';
    }
  }

  else if (selectedPhase == 'Nifas') {
    return 'Masa nifas juga penting, Bun. Yuk cek pemulihan tubuh Bunda secara rutin!';
  }

  else if (selectedPhase == 'Menyusui') {
    return 'Semangat memberi ASI ya, Bun! Yuk cek panduan dan kesehatan ibu menyusui.';
  }

  else if (selectedPhase == 'Tumbuh') {
    return 'Yuk pantau pertumbuhan dan perkembangan si kecil sesuai usianya!';
  }

  return 'Yuk cek kondisi kesehatan Bunda dan si kecil hari ini!';
  }

  DashboardLoaded copyWith({String? selectedPhase}) {
    return DashboardLoaded(
      selectedPhase: selectedPhase ?? this.selectedPhase,
      kehamilanAktif: kehamilanAktif,
      anakSaya: anakSaya,
    );
  }
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
}
