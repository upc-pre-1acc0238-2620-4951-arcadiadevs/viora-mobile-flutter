import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_intake_forecasts_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_kept_reads_use_cases.dart';
import 'package:viora/features/cooperative_operations/application/usecase/has_active_sector_alerts_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/entity/intake_forecast.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/presentation/state/intake_ui_state.dart';

/// G30 · Acopio: the campaign in progress by default, or the one the manager chose. Without a
/// connection it shows the last projection read, with its date (G30 · Sin conexión).
class IntakeViewModel extends Cubit<IntakeUiState> {
  IntakeViewModel({
    required this.getCampaigns,
    required this.getCampaign,
    this.getKeptCampaigns,
    this.getKeptCampaign,
    required this.hasActiveAlerts,
  }) : super(const IntakeUiState());

  final GetIntakeForecastsUseCase getCampaigns;
  final GetIntakeForecastUseCase getCampaign;
  final GetKeptIntakeForecastsUseCase? getKeptCampaigns;
  final GetKeptIntakeForecastUseCase? getKeptCampaign;
  final HasActiveSectorAlertsUseCase hasActiveAlerts;

  /// Reads the campaigns and the chosen one again. What is on screen stays if the read fails.
  Future<void> load() async {
    _emit(state.copyWith(loading: true, failure: () => null));
    _readAlerts();
    try {
      final campaigns = await getCampaigns.execute();
      final year = _yearAmong(campaigns);
      _emit(state.copyWith(campaigns: campaigns, selectedYear: year));
      if (year == null) {
        _emit(state.copyWith(loading: false, savedAt: () => null));
        return;
      }
      await _read(year);
    } on CooperativeOffline catch (failure) {
      await _keepShowing(failure);
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
    } on CooperativeOffline catch (failure) {
      if (!await _showKept(year)) _emit(state.copyWith(loading: false, failure: () => failure));
    } on CooperativeFailure catch (failure) {
      _emit(state.copyWith(loading: false, failure: () => failure));
    }
  }

  Future<void> _read(int year) async {
    final forecast = await getCampaign.execute(year);
    // The manager may have chosen another campaign while this one was read.
    if (state.selectedYear == year) {
      _emit(state.copyWith(loading: false, forecast: () => forecast, savedAt: () => null));
    }
  }

  /// Without a connection: what is on screen stays, now marked with its date; with nothing on
  /// screen, the campaigns kept from the last read.
  Future<void> _keepShowing(CooperativeOffline failure) async {
    if (state.forecast != null) {
      _emit(state.copyWith(loading: false, savedAt: () => state.savedAt ?? state.forecast!.evaluatedAt));
      return;
    }
    final kept = await getKeptCampaigns?.execute();
    final year = kept == null ? null : _yearAmong(kept.value);
    if (kept != null && year != null) {
      _emit(state.copyWith(campaigns: kept.value, selectedYear: year));
      if (await _showKept(year)) return;
    }
    _emit(state.copyWith(loading: false, failure: () => failure));
  }

  Future<bool> _showKept(int year) async {
    final kept = await getKeptCampaign?.execute(year);
    if (kept == null || state.selectedYear != year) return false;
    _emit(state.copyWith(loading: false, forecast: () => kept.value, savedAt: () => kept.savedAt));
    return true;
  }

  /// The chosen campaign if it is still listed, else the newest.
  int? _yearAmong(List<IntakeForecast> campaigns) {
    final chosen = state.selectedYear;
    if (campaigns.any((campaign) => campaign.campaignYear == chosen)) return chosen;
    return campaigns.isEmpty ? null : campaigns.first.campaignYear;
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
