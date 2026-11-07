import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/core/domain/decimal.dart';
import 'package:viora/features/subscription/application/usecase/get_kept_producer_plan_catalog_use_case.dart';
import 'package:viora/features/subscription/application/usecase/refresh_producer_plan_catalog_use_case.dart';
import 'package:viora/features/subscription/domain/entity/producer_plan_catalog.dart';
import 'package:viora/features/subscription/domain/exception/plan_catalog_failure.dart';
import 'package:viora/features/subscription/domain/valueobject/plan_capacity.dart';
import 'package:viora/features/subscription/presentation/state/producer_plan_ui_state.dart';

/// Restores selection only; the server-backed policy remains the source of the displayed
/// estimate.
class ProducerPlanViewModel extends Cubit<ProducerPlanUiState> {
  ProducerPlanViewModel({required this.getKeptCatalog, required this.refreshCatalog})
      : super(const ProducerPlanLoading());

  final GetKeptProducerPlanCatalogUseCase getKeptCatalog;
  final RefreshProducerPlanCatalogUseCase refreshCatalog;

  ProducerPlanCatalog? _catalog;
  bool _isSavedCopy = false;
  bool _isRefreshing = false;
  PlanCatalogFailure? _failure;
  String? _selectedCode;
  Decimal? _hectares;

  /// Shows the kept catalog right away, if there is one, and brings it up to date. The
  /// [hectares] of the onboarding only seed the first selection; later changes win.
  Future<void> start({Decimal? hectares}) async {
    _hectares = hectares;
    _catalog = getKeptCatalog.execute();
    _isSavedCopy = _catalog != null;
    await refresh();
  }

  Future<void> refresh() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    _failure = null;
    _render();
    try {
      _catalog = await refreshCatalog.execute();
      _isSavedCopy = false;
    } on PlanCatalogFailure catch (failure) {
      _failure = failure;
    } finally {
      _isRefreshing = false;
      if (!isClosed) _render();
    }
  }

  void selectOffer(String code) {
    final catalog = _catalog;
    if (catalog == null || code == _selectedCode) return;
    if (catalog.offers.every((offer) => offer.code.value != code)) return;
    _selectedCode = code;
    // Each offer has its own minimum and increment: the selection starts over.
    _hectares = null;
    _render();
  }

  void increase() => _change(increase: true);

  void decrease() => _change(increase: false);

  void _change({required bool increase}) {
    final content = state;
    if (content is! ProducerPlanContent) return;
    final next = increase ? content.capacity.hectares + content.step : content.capacity.hectares - content.step;
    if (next < content.selectedOffer.minimumQuota.hectares) return;
    _selectedCode = content.selectedOffer.code.value;
    _hectares = next;
    _render();
  }

  void _render() {
    if (isClosed) return;
    final catalog = _catalog;
    if (catalog == null) {
      final failure = _failure;
      emit(failure != null ? ProducerPlanFailed(failure) : const ProducerPlanLoading());
      return;
    }
    if (catalog.offers.isEmpty) {
      emit(ProducerPlanEmpty(isRefreshing: _isRefreshing, failure: _failure));
      return;
    }
    final offer = catalog.offers.firstWhere(
      (offer) => offer.code.value == _selectedCode,
      orElse: () => catalog.offers.first,
    );
    final wanted = _hectares;
    final capacity = (wanted != null && wanted.signum > 0 ? PlanCapacity.of(wanted) : null);
    emit(
      ProducerPlanContent(
        offers: catalog.offers,
        selectedOffer: offer,
        capacity: capacity != null && offer.accepts(capacity) ? capacity : offer.minimumQuota,
        fetchedAt: catalog.fetchedAt,
        isRefreshing: _isRefreshing,
        isSavedCopy: _isSavedCopy,
        failure: _failure,
      ),
    );
  }
}
