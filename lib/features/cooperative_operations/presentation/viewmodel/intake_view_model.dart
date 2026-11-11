import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_intake_forecasts_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/has_active_sector_alerts_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/presentation/state/intake_ui_state.dart';

/// G30 · Acopio: the campaign in progress by default, or the one the manager chose.
class IntakeViewModel extends Cubit<IntakeUiState> {
  IntakeViewModel({
    required this.getCampaigns,
    required this.getCampaign,
    required this.hasActiveAlerts,
  }) : super(const IntakeUiState());

  final GetIntakeForecastsUseCase getCampaigns;
  final GetIntakeForecastUseCase getCampaign;
  final HasActiveSectorAlertsUseCase hasActiveAlerts;

  /// Reads the campaigns and the chosen one again. What is on screen stays if the read fails.
  Future<void> load() async {
    _emit(state.copyWith(loading: true, failure: () => null));
    _readAlerts();
    try {
      final campaigns = await getCampaigns.execute();
      final chosen = state.selectedYear;
      final year = campaigns.any((campaign) => campaign.campaignYear == chosen)
          ? chosen
          : (campaigns.isEmpty ? null : campaigns.first.campaignYear);
      _emit(state.copyWith(campaigns: campaigns, selectedYear: year));
      if (year == null) {
        _emit(state.copyWith(loading: false));
        return;
      }
      await _read(year);
    } on CooperativeFailure catch (failure) {
      _emit(state.copyWith(loading: false, failure: state.forecast == null ? () => failure : null));
    }
  }

  /// A campaign of «Elige la campaña».
  Future<void> selectCampaign(int year) async {
    if (year == state.selectedYear && state.forecast != null) return;
    _emit(state.copyWith(selectedYear: year, forecast: () => null, loading: true, failure: () => null));
    try {
      await _read(year);
    } on CooperativeFailure catch (failure) {
      _emit(state.copyWith(loading: false, failure: () => failure));
    }
  }

  Future<void> _read(int year) async {
    final forecast = await getCampaign.execute(year);
    // The manager may have chosen another campaign while this one was read.
    if (state.selectedYear == year) _emit(state.copyWith(loading: false, forecast: () => forecast));
  }

  Future<void> _readAlerts() async {
    try {
      final active = await hasActiveAlerts.execute();
      _emit(state.copyWith(hasActiveAlerts: active));
    } on CooperativeFailure {
      // The dot is a hint: without it the bell still opens the alerts.
    }
  }

  void _emit(IntakeUiState next) {
    if (!isClosed) emit(next);
  }
}
