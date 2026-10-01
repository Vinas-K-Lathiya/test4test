import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../l10n.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets/common.dart';

class AppealScreen extends ConsumerStatefulWidget {
  const AppealScreen({super.key});
  @override
  ConsumerState<AppealScreen> createState() => _AppealScreenState();
}

class _AppealScreenState extends ConsumerState<AppealScreen> {
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final appeals = ref.watch(myAppealsProvider).value ?? const [];
    final hasOpen = appeals.any((a) => a.status == 'open');

    return Scaffold(
      appBar: AppBar(title: Text(l.appeal)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        InfoCard(icon: Icons.gavel_rounded, title: l.appealTitle, body: l.appealExplain),
        const SizedBox(height: 16),
        if (!hasOpen) ...[
          TextField(
            controller: _text,
            maxLines: 6,
            maxLength: 2000,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(hintText: l.appealHint),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _text.text.trim().length < 20
                ? null
                : () async {
                    final groupId = ref.read(accountProvider).value?.currentGroupId;
                    final ok = await runAction(
                      context,
                      () => ref.read(apiProvider).submitAppeal(_text.text.trim(), groupId: groupId),
                      success: l.appealSent,
                    );
                    if (ok) _text.clear();
                  },
            child: Text(l.sendAppeal),
          ),
        ],
        if (appeals.isNotEmpty) SectionTitle(l.yourAppeals),
        for (final a in appeals)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(a.text, maxLines: 3, overflow: TextOverflow.ellipsis),
              subtitle: Text([
                switch (a.status) {
                  'open' => l.appealOpen,
                  'accepted' => l.appealAccepted,
                  _ => l.appealRejected,
                },
                if (a.note != null && a.note!.isNotEmpty) a.note!,
                if (a.createdAt != null) DateFormat.yMMMd().format(a.createdAt!),
              ].join(' · ')),
              leading: Icon(
                a.status == 'open'
                    ? Icons.hourglass_top_rounded
                    : a.status == 'accepted'
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                color: a.status == 'accepted' ? Brand.green : (a.status == 'open' ? Brand.amber : Brand.red),
              ),
            ),
          ),
      ]),
    );
  }
}
