import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/cooperative_operations/presentation/cooperative_formats.dart';

/// Codes are sent outside Viora: WhatsApp opens with the message written, and the manager
/// picks the chat. Without WhatsApp the phone offers whatever opens the link.
Future<void> shareCodesOnWhatsapp(
  BuildContext context, {
  required String organizationName,
  required List<String> codes,
  required DateTime expiresAt,
}) async {
  final l10n = AppLocalizations.of(context);
  final date = formatDayMonth(expiresAt, Localizations.localeOf(context).toLanguageTag());
  final text = codes.length == 1
      ? l10n.shareCodeMessage(organizationName, codes.single, date)
      : l10n.shareCodesMessage(organizationName, codes.join('\n'), date);
  await launchUrl(
    Uri.https('wa.me', '/', {'text': text}),
    mode: LaunchMode.externalApplication,
  );
}

/// Copies [code] and says so for a moment.
Future<void> copyCode(BuildContext context, String code) async {
  final messenger = ScaffoldMessenger.of(context);
  final copied = AppLocalizations.of(context).issuedCopied;
  await Clipboard.setData(ClipboardData(text: code));
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$copied · $code'), duration: const Duration(seconds: 2)));
}
