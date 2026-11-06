import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:viora/core/designsystem/component/viora_avatar.dart';
import 'package:viora/core/designsystem/component/viora_editorial.dart';
import 'package:viora/core/designsystem/theme/colors.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/core/domain/account_rules.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/core/locale/app_language.dart';
import 'package:viora/features/iam/presentation/ui/iam_page.dart';
import 'package:viora/features/profiles/domain/entity/profile.dart';
import 'package:viora/features/profiles/presentation/state/account_ui_state.dart';
import 'package:viora/features/profiles/presentation/ui/change_password_page.dart';
import 'package:viora/features/profiles/presentation/ui/edit_profile_page.dart';
import 'package:viora/features/profiles/presentation/ui/language_sheet.dart';
import 'package:viora/features/profiles/presentation/ui/widgets/account_widgets.dart';
import 'package:viora/features/profiles/presentation/viewmodel/account_view_model.dart';

/// The person's account: the profile, its details, the preferences and closing the session.
class AccountPage extends StatelessWidget {
  const AccountPage({super.key, this.statusBadge, this.roleSuffix});

  static const path = '/account';

  /// Shown on the profile card, such as the license of the manager. The router provides it, so
  /// this context doesn't depend on where it comes from.
  final Widget? statusBadge;

  /// Follows the role under the title, in its style, such as the organization of the manager.
  final Widget? roleSuffix;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AccountViewModel>(),
      child: BlocConsumer<AccountViewModel, AccountUiState>(
        listenWhen: (previous, current) => current.signedOut,
        listener: (context, state) => context.go(IamPage.path),
        builder: (context, state) =>
            _AccountView(state: state, statusBadge: statusBadge, roleSuffix: roleSuffix),
      ),
    );
  }
}

class _AccountView extends StatefulWidget {
  const _AccountView({required this.state, this.statusBadge, this.roleSuffix});

  final AccountUiState state;
  final Widget? statusBadge;
  final Widget? roleSuffix;

  @override
  State<_AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<_AccountView> with WidgetsBindingObserver {
  bool? _notificationsOn;
  late final Future<PackageInfo> _packageInfo = PackageInfo.fromPlatform();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _readNotifications();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Notifications can be switched off in the phone's settings; read them again on every return.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _readNotifications();
  }

  Future<void> _readNotifications() async {
    bool? granted;
    try {
      granted = await Permission.notification.isGranted;
    } on Exception {
      granted = null;
    }
    if (mounted) setState(() => _notificationsOn = granted);
  }

  Future<void> _openDetails() async {
    final viewModel = context.read<AccountViewModel>();
    final saved = await context.push<bool>(EditProfilePage.path);
    if (saved != true) return;
    viewModel.showNotice(AccountNotice.detailsSaved);
  }

  Future<void> _openPassword() async {
    final viewModel = context.read<AccountViewModel>();
    final changed = await context.push<bool>(ChangePasswordPage.path);
    if (changed == true) viewModel.showNotice(AccountNotice.passwordChanged);
  }

  Future<void> _openLanguage() async {
    final viewModel = context.read<AccountViewModel>();
    final current = AppLanguage.of(Localizations.localeOf(context));
    final chosen = await showLanguageSheet(context, current);
    if (chosen == null || chosen == current || !mounted) return;
    await getIt<AppLanguageCubit>().choose(chosen);
    viewModel.showNotice(AccountNotice.language);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = widget.state;
    final profile = state.profile;
    final language = AppLanguage.of(Localizations.localeOf(context));
    final notificationsOn = _notificationsOn;
    return Scaffold(
      backgroundColor: VioraColors.neutral100,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Stays on top while the content scrolls under it.
            Padding(
              padding: const EdgeInsets.fromLTRB(accountGutter, 8, accountGutter, 8),
              child: AccountTopBar(
                title: l10n.accountTitle,
                subtitle: l10n.accountRole,
                subtitleSuffix: widget.roleSuffix,
                onBack: context.pop,
                notice: switch (state.notice) {
                  AccountNotice.language => l10n.accountLanguageNotice,
                  AccountNotice.detailsSaved => l10n.accountDetailsSaved,
                  AccountNotice.passwordChanged => l10n.accountPasswordChanged,
                  null => null,
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(accountGutter, 16, accountGutter, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    VioraEditorialTitle(l10n.accountHeadline),
                    const SizedBox(height: 20),
                    _ProfileCard(profile: profile, statusBadge: widget.statusBadge),
                    const SizedBox(height: 24),
                    AccountSection(
                      title: l10n.accountGroupPersonal,
                      children: [
                        AccountRow(
                          label: l10n.accountName,
                          value: profile?.fullName,
                          onTap: _openDetails,
                        ),
                        AccountRow(
                          label: l10n.accountMobile,
                          value: profile == null ? null : _readablePhone(profile),
                          onTap: _openDetails,
                        ),
                        AccountRow(
                          label: l10n.accountEmail,
                          value: l10n.accountVerified,
                          onTap: _openDetails,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AccountSection(
                      title: l10n.accountGroupSecurity,
                      children: [
                        AccountRow(label: l10n.accountChangePassword, onTap: _openPassword),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AccountSection(
                      title: l10n.accountGroupPreferences,
                      children: [
                        AccountRow(
                          label: l10n.accountLanguage,
                          value: language == AppLanguage.spanish
                              ? l10n.accountLanguageSpanish
                              : l10n.accountLanguageEnglish,
                          onTap: _openLanguage,
                        ),
                        AccountRow(
                          label: l10n.accountNotifications,
                          value: notificationsOn == null
                              ? null
                              : notificationsOn
                              ? l10n.accountNotificationsOn
                              : l10n.accountNotificationsOff,
                          onTap: openAppSettings,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AccountSection(
                      title: l10n.accountGroupSession,
                      children: [
                        AccountRow(
                          label: l10n.accountSignOut,
                          destructive: true,
                          onTap: context.read<AccountViewModel>().signOut,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder(
                      future: _packageInfo,
                      builder: (context, snapshot) => Text(
                        snapshot.hasData ? l10n.accountVersion(snapshot.requireData.version) : '',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(fontSize: 11, color: VioraColors.neutral500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _readablePhone(Profile profile) {
    final country = PhoneCountry.fromIso(profile.countryIso);
    return country.international(country.nationalOf(profile.phoneNumber));
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile, this.statusBadge});

  final Profile? profile;
  final Widget? statusBadge;

  @override
  Widget build(BuildContext context) {
    final profile = this.profile;
    return Container(
      constraints: const BoxConstraints(minHeight: 180),
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 16),
      decoration: BoxDecoration(
        color: VioraColors.terracotta100,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              VioraAvatar(name: profile?.fullName ?? '', size: 64, background: VioraColors.neutral0),
              const Spacer(),
              ?statusBadge,
            ],
          ),
          const SizedBox(height: 8),
          if (profile != null) ...[
            VioraEditorialTitle(_titleOf(profile.fullName), fontSize: 34, lineHeight: 36),
            if (profile.email.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                profile.email,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(fontSize: 13, color: VioraColors.neutral700),
              ),
            ],
          ],
        ],
      ),
    );
  }

  /// The first name upright and the rest in italics, as in "Rubén\n*Ticona*".
  String _titleOf(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts.length == 1 ? parts.first : '${parts.first}\n*${parts.skip(1).join(' ')}*';
  }
}
