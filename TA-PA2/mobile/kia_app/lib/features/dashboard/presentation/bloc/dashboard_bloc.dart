import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/services/kehamilan_api_service.dart';
import 'package:ta_pa2_pa3_project/features/anak/anak/data/services/ibu_api_service.dart';
import 'package:ta_pa2_pa3_project/features/ibu/hamil/data/models/kehamilan_aktif_model.dart';
import 'package:ta_pa2_pa3_project/features/anak/anak/data/models/ibu_anak_model.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final KehamilanApiService _kehamilanService;
  final IbuApiService _ibuApiService;

  DashboardBloc({
    KehamilanApiService? kehamilanService,
    IbuApiService? ibuApiService,
  })  : _kehamilanService = kehamilanService ?? KehamilanApiService(),
        _ibuApiService = ibuApiService ?? IbuApiService(),
        super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadData);
    on<DashboardPhaseChanged>(_onPhaseChanged);
  }

  // ✅ PENINGKATAN PAM: Parallel Fetching dengan Graceful Degradation
  Future<void> _onLoadData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      KehamilanAktifModel? kehamilan;
      List<IbuAnakModel> anak = [];

      // Future.wait menjalankan kedua API secara BERSAMAAN (paralel)
      // catchError menjamin kalau 1 API gagal, yang lain TETAP jalan
      await Future.wait([
        _kehamilanService
            .getKehamilanAktif()
            .then((data) => kehamilan = data)
            .catchError((_) => kehamilan = null), // Ibu belum hamil = null
        _ibuApiService
            .getAnakSaya()
            .then((data) => anak = data)
            .catchError((_) {}), // Belum punya anak = list kosong
      ]);

      emit(DashboardLoaded(
        kehamilanAktif: kehamilan,
        anakSaya: anak,
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  void _onPhaseChanged(
    DashboardPhaseChanged event,
    Emitter<DashboardState> emit,
  ) {
    if (state is DashboardLoaded) {
      // Update state tanpa fetch ulang data dari API
      emit((state as DashboardLoaded).copyWith(selectedPhase: event.phase));
    }
  }

  @override
  Future<void> close() {
    _kehamilanService.dispose();
    _ibuApiService.dispose();
    return super.close();
  }
}