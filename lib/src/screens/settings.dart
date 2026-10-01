import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../l10n.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets/common.dart';

Future<void> showLanguagePicker(BuildContext context, WidgetRef ref) {
  final l = context.l10n;
  final current = ref.read(localeProvider)?.languageCode;
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (c) => SafeArea(
      child: RadioGroup<String>(
        groupValue: current ?? '',
        onChanged: (v) {
          ref.read(localeProvider.notifier).set(v == null || v.isEmpty ? null : v);
          Navigator.pop(c);
        },
        child: ListView(shrinkWrap: true, children: [
          RadioListTile<String>(value: '', title: Text(l.systemLanguage)),
          for (final code in AppConfig.locales)
            RadioListTile<String>(value: code, title: Text(AppConfig.localeNames[code]!)),
        ]),
      ),
    ),
  );
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> with WidgetsBindingObserver {
  bool? _usage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _check();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    if (s == AppLifecycleState.resumed) {
      _check();
      ref.invalidate(notificationPermissionProvider);
    }
  }

  Future<void> _check() async {
    final v = await ref.read(deviceProvider).hasUsageAccess().catchError((_) => false);
    if (mounted) setState(() => _usage = v);
  }

  Future<void> _deleteAccount() async {
    final l = context.l10n;
    final ok = await confirm(context, title: l.deleteAccountTitle, body: l.deleteAccountBody, ok: l.delete, danger: true);
    if (!ok || !mounted) return;
    final done = await runAction(context, () => ref.read(apiProvider).deleteAccount());
    if (done) await ref.read(authServiceProvider).signOut();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final locale = ref.watch(localeProvider);
    final isAdmin = ref.watch(isAdminProvider);
    final account = ref.watch(accountProvider).value;

    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 32), children: [
        SectionTitle(l.general),
        Card(
          child: Column(children: [
            ListTile(
              leading: const Icon(Icons.translate_rounded),
              title: Text(l.language),
              subtitle: Text(locale == null ? l.systemLanguage : AppConfig.localeNames[locale.languageCode] ?? ''),
              onTap: () => showLanguagePicker(context, ref),
            ),
            ListTile(
              leading: Icon(Icons.query_stats_rounded, color: _usage == true ? Brand.green : Brand.amber),
              title: Text(l.usageAccessTitle),
              subtitle: Text(_usage == true ? l.granted : l.notGranted),
              onTap: () => ref.read(deviceProvider).openUsageAccessSettings(),
            ),
            if (isAdmin)
              ListTile(
                leading: const Icon(Icons.admin_panel_settings_rounded),
                title: Text(l.admin),
                onTap: () => context.push('/admin'),
              ),
          ]),
        ),
        SectionTitle(l.notificationSettings),
        const _NotificationSettings(),
        SectionTitle(l.about),
        Card(
          child: Column(children: [
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: Text(l.privacyPolicy),
              onTap: () => openUrl(AppConfig.privacyUrl),
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(l.terms),
              onTap: () => openUrl(AppConfig.termsUrl),
            ),
            ListTile(
              leading: const Icon(Icons.mail_outline_rounded),
              title: Text(l.contactSupport),
              subtitle: const Text(AppConfig.supportEmail),
              onTap: () => launchUrl(Uri(scheme: 'mailto', path: AppConfig.supportEmail, query: 'subject=TestPact')),
            ),
            ListTile(
              leading: const Icon(Icons.star_outline_rounded),
              title: Text(l.rateApp),
              onTap: () => openUrl(AppConfig.playStoreUrl),
            ),
            if (account != null && (account.strikes > 0 || account.banned))
              ListTile(
                leading: const Icon(Icons.gavel_rounded),
                title: Text(l.appeal),
                onTap: () => context.push('/appeal'),
              ),
          ]),
        ),
        SectionTitle(l.account),
        Card(
          child: Column(children: [
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: Text(l.signOut),
              subtitle: account == null ? null : Text(account.email),
              onTap: () => ref.read(authServiceProvider).signOut(),
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever_rounded, color: Brand.red),
              title: Text(l.deleteAccount, style: const TextStyle(color: Brand.red)),
              onTap: _deleteAccount,
            ),
          ]),
        ),
      ]),
    );
  }
}

class _NotificationSettings extends ConsumerWidget {
  const _NotificationSettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final account = ref.watch(accountProvider).value;
    final allowed = ref.watch(notificationPermissionProvider).value ?? true;
    if (account == null) return const SizedBox.shrink();

    Future<void> set(String category, bool on) => FirebaseFirestore.instance
        .collection('users')
        .doc(account.uid)
        .update({'notifications': {...account.notifications, category: on}});

    Widget toggle(String category, String title, String subtitle) => SwitchListTile(
          value: account.notifyFor(category),
          onChanged: allowed ? (v) => set(category, v) : null,
          title: Text(title),
          subtitle: Text(subtitle),
        );

    return Card(
      child: Column(children: [
        if (!allowed)
          ListTile(
            leading: const Icon(Icons.notifications_off_rounded, color: Brand.red),
            title: Text(l.notifPermissionOff),
            trailing: TextButton(
              onPressed: () => ref.read(deviceProvider).openNotificationSettings(),
              child: Text(l.openSettings),
            ),
          ),
        toggle('daily', l.notifDaily, l.notifDailySub),
        toggle('group', l.notifGroup, l.notifGroupSub),
        toggle('feedback', l.notifFeedback, l.notifFeedbackSub),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
          child: Row(children: [
            const Icon(Icons.info_outline_rounded, size: 16),
            const SizedBox(width: 8),
            Expanded(child: Text(l.notifImportantNote, style: Theme.of(context).textTheme.bodySmall)),
          ]),
        ),
      ]),
    );
  }
}
