import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n.dart';
import '../providers.dart';
import '../widgets/common.dart';

class JoinQueueScreen extends ConsumerStatefulWidget {
  const JoinQueueScreen({super.key});
  @override
  ConsumerState<JoinQueueScreen> createState() => _JoinQueueScreenState();
}

class _JoinQueueScreenState extends ConsumerState<JoinQueueScreen> {
  String? _appId;
  final _agreed = List<bool>.filled(4, false);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final apps = ref.watch(myAppsProvider);
    final rules = [l.rule1, l.rule2, l.rule3, l.rule4];
    final canJoin = _appId != null && _agreed.every((a) => a);

    return Scaffold(
      appBar: AppBar(title: Text(l.joinGroup)),
      body: AsyncView(apps, builder: (list) {
        _appId ??= list.length == 1 ? list.first.id : null;
        return ListView(padding: const EdgeInsets.all(16), children: [
          SectionTitle(l.chooseApp),
          Card(
            child: RadioGroup<String>(
              groupValue: _appId,
              onChanged: (v) => setState(() => _appId = v),
              child: Column(children: [
                for (final a in list)
                  RadioListTile<String>(
                    value: a.id,
                    title: Text(a.name),
                    subtitle: Text(a.packageName),
                    secondary: AppIconView(name: a.name, url: a.iconUrl, size: 40),
                  ),
              ]),
            ),
          ),
          SectionTitle(l.yourCommitment),
          Card(
            child: Column(children: [
              for (var i = 0; i < rules.length; i++)
                CheckboxListTile(
                  value: _agreed[i],
                  onChanged: (v) => setState(() => _agreed[i] = v ?? false),
                  title: Text(rules[i]),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
            ]),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: !canJoin
                ? null
                : () async {
                    String? groupId;
                    final ok = await runAction(
                      context,
                      () async => groupId = await ref.read(apiProvider).joinQueue(_appId!),
                      success: l.joinedQueue,
                    );
                    if (!ok || !context.mounted) return;
                    if (groupId != null) {
                      context.pushReplacement('/group/$groupId');
                    } else {
                      context.pop();
                    }
                  },
            child: Text(l.joinQueue),
          ),
        ]);
      }),
    );
  }
}
