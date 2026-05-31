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
  }) : _kehamilanService = kehamilanService ?? KehamilanApiService(),
       _ibuApiService = ibuApiService ?? IbuApiService(),
       super(DashboardInitial()) {

    on<LoadDashboardData>(_onLoadData);
    on<DashboardPhaseChanged>(_onPhaseChanged);
  }

  // Parallel fetching dashboard data
  Future<void> _onLoadData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {

    emit(DashboardLoading());

    try {

      KehamilanAktifModel? kehamilan;
      List<IbuAnakModel> anak = [];

      // Fetch API bersamaan
      await Future.wait([

        _kehamilanService
            .getKehamilanAktif()
            .then((data) => kehamilan = data)
            .catchError((_) => kehamilan = null),

        _ibuApiService
            .getAnakSaya()
            .then((data) => anak = data)
            .catchError((_) => anak = []),
      ]);

      emit(
        DashboardLoaded(
          kehamilanAktif: kehamilan,
          anakSaya: anak,
        ),
      );

    } catch (e) {

      emit(
        DashboardError(
          e.toString(),
        ),
      );
    }
  }

  // Change phase dashboard
  void _onPhaseChanged(
    DashboardPhaseChanged event,
    Emitter<DashboardState> emit,
  ) {

    try {

      if (state is DashboardLoaded) {

        emit(
          (state as DashboardLoaded).copyWith(
            selectedPhase: event.phase,
          ),
        );
      }

    } catch (e) {

      emit(
        DashboardError(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {

    _kehamilanService.dispose();
    _ibuApiService.dispose();

    return super.close();
  }
}