/// Why the plan catalog couldn't be read, in the terms the screens react to. Screens never
/// see HTTP.
sealed class PlanCatalogFailure implements Exception {
  const PlanCatalogFailure();
}

/// The server couldn't be reached.
class PlanCatalogOffline extends PlanCatalogFailure {
  const PlanCatalogOffline();
}

/// Anything else, including an answer with incomplete or inconsistent plans.
class PlanCatalogUnexpected extends PlanCatalogFailure {
  const PlanCatalogUnexpected();
}
