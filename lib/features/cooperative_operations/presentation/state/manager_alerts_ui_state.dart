import 'package:viora/features/cooperative_operations/domain/entity/sector_alert.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';

/// The capsules of T14 that narrow the list: «Críticas», «Atención» and «Normalizadas».
enum AlertFilter { critical, attention, normalized }

/// T14 · Alertas del gestor.
class ManagerAlertsUiState {
  const ManagerAlertsUiState({
    this.loading = true,
    this.failure,
    this.alerts = const [],
    this.readAt,
    this.filter,
  });

  final bool loading;
  final CooperativeFailure? failure;
  final List<SectorAlert> alerts;

  /// When the list was read, for «actualizado 7:40 a. m.».
  final DateTime? readAt;

  /// Null shows every alert.
  final AlertFilter? filter;

  /// By day, the most recent first; within a day the critical ones go first.
  List<SectorAlert> get active => alerts.where((alert) => alert.active).toList()
    ..sort((a, b) {
      final byDay = _day(b.changedAt).compareTo(_day(a.changedAt));
      if (byDay != 0) return byDay;
      final bySeverity = a.severity.index.compareTo(b.severity.index);
      return bySeverity != 0 ? bySeverity : _recentFirst(a, b);
    });

  /// The most recent first.
  List<SectorAlert> get normalized => alerts.where((alert) => !alert.active).toList()..sort(_recentFirst);

  int get critical => active.where((alert) => alert.severity == AlertSeverity.critical).length;

  int get attention => active.where((alert) => alert.severity == AlertSeverity.attention).length;

  /// The sectors with an active alert, once each, in the order of the list.
  List<String> get activeSectors => {for (final alert in active) alert.sectorName}.toList();

  List<SectorAlert> get visibleActive => switch (filter) {
        null => active,
        AlertFilter.critical => active.where((alert) => alert.severity == AlertSeverity.critical).toList(),
        AlertFilter.attention => active.where((alert) => alert.severity == AlertSeverity.attention).toList(),
        AlertFilter.normalized => const [],
      };

  List<SectorAlert> get visibleNormalized => filter == null || filter == AlertFilter.normalized ? normalized : const [];

  ManagerAlertsUiState withFilter(AlertFilter? filter) =>
      ManagerAlertsUiState(loading: loading, failure: failure, alerts: alerts, readAt: readAt, filter: filter);
}

/// The calendar day on the phone, as a number that sorts; an alert without a date goes last.
int _day(DateTime? at) {
  if (at == null) return 0;
  final local = at.toLocal();
  return local.year * 10000 + local.month * 100 + local.day;
}

int _recentFirst(SectorAlert a, SectorAlert b) {
  final first = a.changedAt;
  final second = b.changedAt;
  if (first == null || second == null) return first == null ? (second == null ? 0 : 1) : -1;
  return second.compareTo(first);
}
