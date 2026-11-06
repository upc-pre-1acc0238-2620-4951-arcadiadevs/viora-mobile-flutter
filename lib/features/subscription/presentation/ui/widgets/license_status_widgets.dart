import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/subscription/domain/entity/manager_license.dart';
import 'package:viora/features/subscription/presentation/ui/widgets/license_widgets.dart';
import 'package:viora/features/subscription/presentation/viewmodel/license_status_view_model.dart';

/// "Licencia activa", while the kept license of the manager is in force; nothing otherwise.
/// Screens of other contexts show it without knowing where the license comes from.
class LicenseStatusBadge extends StatelessWidget {
  const LicenseStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Opening the screen is when the license may have changed, such as a new manager.
      create: (context) => getIt<LicenseStatusViewModel>()..refresh(),
      child: BlocBuilder<LicenseStatusViewModel, ManagerLicense?>(
        builder: (context, license) {
          if (!context.read<LicenseStatusViewModel>().isActive) return const SizedBox.shrink();
          return LicenseActiveTag(label: AppLocalizations.of(context).licenseActiveBadge);
        },
      ),
    );
  }
}

/// " · Olivar del Sur" after the role of the manager, in the style around it; nothing while
/// no license is kept.
class LicenseOrganizationSuffix extends StatelessWidget {
  const LicenseOrganizationSuffix({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LicenseStatusViewModel>(),
      child: BlocBuilder<LicenseStatusViewModel, ManagerLicense?>(
        builder: (context, license) {
          if (license == null) return const SizedBox.shrink();
          return Text(
            AppLocalizations.of(context).licenseRoleOfOrganization(license.organizationName),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
    );
  }
}
