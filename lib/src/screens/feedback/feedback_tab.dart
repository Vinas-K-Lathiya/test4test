import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../l10n.dart';
import '../../models.dart';
import '../../providers.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import '../../widgets/labels.dart';
import '../../widgets/ui.dart';

class FeedbackTab extends ConsumerStatefulWidget {
  const FeedbackTab({super.key});
  @override
  ConsumerState<FeedbackTab> createState() => _FeedbackTabState();
}

class _FeedbackTabState extends ConsumerState<FeedbackTab> {
  bool _received = true;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final value = ref.watch(_received ? feedbackReceivedProvider : feedbackGivenProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
          child: SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: true, label: Text(l.received), icon: const Icon(Icons.inbox_rounded)),
              ButtonSegment(value: false, label: Text(l.given), icon: const Icon(Icons.outbox_rounded)),
            ],
            selected: {_received},
            onSelectionChanged: (s) => setState(() => _received = s.first),
          ),
        ),
        Expanded(
          child: AsyncView(
            value,
            builder: (items) {
              if (items.isEmpty) {
                return EmptyState(
                  image: _received ? 'inbox' : 'speech',
                  title: _received ? l.noFeedbackReceived : l.noFeedbackGiven,
                  body: _received ? l.noFeedbackReceivedBody : l.noFeedbackGivenBody,
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _FeedbackCard(item: items[i], received: _received),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FeedbackCard extends ConsumerWidget {
  const _FeedbackCard({required this.item, required this.received});
  final FeedbackItem item;
  final bool received;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final f = item;
    return SoftCard(
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImgTile(switch (f.category) {
                  'bug' => 'bug',
                  'idea' => 'bulb',
                  'praise' => 'star',
                  'ux' => 'magnifier',
                  _ => 'speech',
                }, size: 40),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    received ? l.fromOnApp(f.fromName, f.appName) : f.appName,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                for (var i = 0; i < 5; i++)
                  Icon(i < f.rating ? Icons.star_rounded : Icons.star_outline_rounded, size: 16, color: Brand.amber),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              children: [
                Chip(label: Text(categoryLabel(l, f.category)), visualDensity: VisualDensity.compact),
                if (f.createdAt != null)
                  Chip(label: Text(DateFormat.MMMd().format(f.createdAt!)), visualDensity: VisualDensity.compact),
              ],
            ),
            const SizedBox(height: 6),
            Text(f.text),
            if (f.screenshotPath != null) ...[const SizedBox(height: 10), _Screenshot(path: f.screenshotPath!)],
            const SizedBox(height: 8),
            if (received && f.helpful == null)
              Row(
                children: [
                  Text(l.wasHelpful, style: Theme.of(context).textTheme.bodySmall),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => runAction(context, () => ref.read(apiProvider).rateFeedback(f.id, false)),
                    icon: const Icon(Icons.thumb_down_alt_outlined, size: 18),
                    label: Text(l.no),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => runAction(context, () => ref.read(apiProvider).rateFeedback(f.id, true)),
                    icon: const Icon(Icons.thumb_up_alt_rounded, size: 18),
                    label: Text(l.yes),
                  ),
                ],
              )
            else if (f.helpful != null)
              Row(
                children: [
                  Icon(
                    f.helpful! ? Icons.thumb_up_alt_rounded : Icons.thumb_down_alt_outlined,
                    size: 16,
                    color: f.helpful! ? Brand.green : Brand.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(f.helpful! ? l.markedHelpful : l.markedNotHelpful, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _Screenshot extends StatelessWidget {
  const _Screenshot({required this.path});
  final String path;
  @override
  Widget build(BuildContext context) => FutureBuilder<String>(
    future: FirebaseStorage.instance.ref(path).getDownloadURL(),
    builder: (context, s) {
      if (!s.hasData) return const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()));
      return GestureDetector(
        onTap: () => showDialog<void>(
          context: context,
          builder: (_) => Dialog(child: InteractiveViewer(child: Image.network(s.data!))),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(s.data!, height: 160, fit: BoxFit.cover),
        ),
      );
    },
  );
}
