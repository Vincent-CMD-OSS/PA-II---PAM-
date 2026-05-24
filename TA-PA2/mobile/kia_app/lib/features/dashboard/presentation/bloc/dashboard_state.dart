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
        return 'Kehamilan Bunda di Trimester 1. Yuk ketuk kartu di bawah untuk melihat rangkuman kondisi kandungan awalmu!';
      } else if (week > 12 && week <= 27) {
        return 'Janin Bunda berkembang baik di Trimester 2. Yuk ketuk kartu di bawah untuk memantau grafik kenaikan BB janin!';
      } else if (week > 27) {
        return 'Persalinan makin dekat di Trimester 3, Bun! Yuk ketuk kartu di bawah untuk memeriksa kesiapan menyambut si kecil!';
      }
    } else if (selectedPhase == 'Nifas') {
      return 'Bunda dalam masa nifas. Yuk ketuk menu di bawah untuk memastikan pemulihan fisik Bunda berjalan lancar!';
    } else if (selectedPhase == 'Menyusui') {
      return 'Semangat mengASIhi, Bunda! Yuk ketuk menu di bawah untuk melihat panduan posisi menyusui yang benar.';
    } else if (selectedPhase == 'Tumbuh') {
      return 'Ayo pantau tumbuh kembang si kecil, Bun! Ketuk menu di bawah untuk mencatat tinggi dan berat badan terbarunya.';
    }
    return 'Bunda, yuk ketuk kartu di bawah ini untuk melihat kondisi kesehatanmu saat ini!';
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
