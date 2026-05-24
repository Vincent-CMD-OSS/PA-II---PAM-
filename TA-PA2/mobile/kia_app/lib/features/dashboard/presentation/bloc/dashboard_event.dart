import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

// ── Event: Muat semua data dashboard saat pertama kali dibuka ──
class LoadDashboardData extends DashboardEvent {
  const LoadDashboardData();
}

// ── Event: Ganti tab phase (Hamil, Nifas, Menyusui, Tumbuh) ──
class DashboardPhaseChanged extends DashboardEvent {
  final String phase;

  const DashboardPhaseChanged(this.phase);

  @override
  List<Object?> get props => [phase];
}