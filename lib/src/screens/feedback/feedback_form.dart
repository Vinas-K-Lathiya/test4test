import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../ads/ads_service.dart';
import '../../l10n.dart';
import '../../providers.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import '../../widgets/labels.dart';

class FeedbackFormScreen extends ConsumerStatefulWidget {
  const FeedbackFormScreen({super.key, required this.groupId, required this.toUid});
  final String groupId;
  final String toUid;
  @override
  ConsumerState<FeedbackFormScreen> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends ConsumerState<FeedbackFormScreen> {
  int _rating = 0;
  String _category = 'bug';
  final _text = TextEditingController();
  XFile? _shot;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final uid = ref.read(uidProvider)!;
    final ok = await runAction(context, () async {
      String? path;
      if (_shot != null) {
        path = 'uploads/$uid/fb_${DateTime.now().millisecondsSinceEpoch}.jpg';
        await FirebaseStorage.instance
            .ref(path)
            .putData(await _shot!.readAsBytes(), SettableMetadata(contentType: 'image/jpeg'));
      }
      await ref
          .read(apiProvider)
          .submitFeedback(
            groupId: widget.groupId,
            toUid: widget.toUid,
            rating: _rating,
            category: _category,
            text: _text.text.trim(),
            screenshotPath: path,
          );
    }, success: context.l10n.feedbackSent);
    if (ok && mounted) {
      final ads = ref.read(adsServiceProvider);
      context.pop();
      // A natural break: the user just finished a task. Capped inside the service.
      ads.maybeShowInterstitial();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final members = ref.watch(membersProvider(widget.groupId)).value ?? const [];
    final app = members.where((m) => m.uid == widget.toUid).firstOrNull;
    final valid = _rating > 0 && _text.text.trim().length >= 20;

    return Scaffold(
      appBar: AppBar(title: Text(l.feedbackFor(app?.appName ?? ''))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (app != null && app.testNotes.isNotEmpty)
            InfoCard(image: 'bulb', title: l.developerAsks, body: app.testNotes),
          SectionTitle(l.rating),
          Row(
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  iconSize: 36,
                  onPressed: () => setState(() => _rating = i),
                  icon: Icon(i <= _rating ? Icons.star_rounded : Icons.star_outline_rounded, color: Brand.amber),
                ),
            ],
          ),
          SectionTitle(l.category),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in feedbackCategories)
                ChoiceChip(
                  label: Text(categoryLabel(l, c)),
                  selected: _category == c,
                  onSelected: (_) => setState(() => _category = c),
                ),
            ],
          ),
          SectionTitle(l.yourFeedback),
          TextField(
            controller: _text,
            maxLines: 6,
            maxLength: 2000,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(hintText: l.feedbackHint, helperText: l.feedbackMin),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.image_outlined),
            label: Text(_shot == null ? l.addScreenshot : l.screenshotAdded),
            onPressed: () async {
              final x = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1600, imageQuality: 80);
              if (x != null) setState(() => _shot = x);
            },
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: valid ? _submit : null, child: Text(l.sendFeedback)),
        ],
      ),
    );
  }
}
