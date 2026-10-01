import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../l10n.dart';
import '../../models.dart';
import '../../providers.dart';
import '../../widgets/common.dart';
import '../../widgets/labels.dart';

Future<void> showReportSheet(BuildContext context, {required String groupId, required Member target}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _ReportSheet(groupId: groupId, target: target),
  );
}

class _ReportSheet extends ConsumerStatefulWidget {
  const _ReportSheet({required this.groupId, required this.target});
  final String groupId;
  final Member target;
  @override
  ConsumerState<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends ConsumerState<_ReportSheet> {
  String _reason = reportReasons.first;
  final _details = TextEditingController();
  XFile? _shot;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final uid = ref.read(uidProvider)!;
    final ok = await runAction(context, () async {
      String? path;
      if (_shot != null) {
        path = 'uploads/$uid/report_${DateTime.now().millisecondsSinceEpoch}.jpg';
        await FirebaseStorage.instance
            .ref(path)
            .putData(await _shot!.readAsBytes(), SettableMetadata(contentType: 'image/jpeg'));
      }
      await ref.read(apiProvider).submitReport(
            groupId: widget.groupId,
            targetUid: widget.target.uid,
            reason: _reason,
            details: _details.text.trim(),
            screenshotPath: path,
          );
    }, success: context.l10n.reportSent);
    if (ok && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.reportTitle(widget.target.displayName), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(l.reportExplain, style: Theme.of(context).textTheme.bodySmall),
          RadioGroup<String>(
            groupValue: _reason,
            onChanged: (v) => setState(() => _reason = v ?? _reason),
            child: Column(children: [
              for (final r in reportReasons)
                RadioListTile<String>(value: r, title: Text(reportReasonLabel(l, r)), dense: true),
            ]),
          ),
          TextField(
            controller: _details,
            maxLength: 1000,
            maxLines: 3,
            decoration: InputDecoration(labelText: l.detailsOptional),
          ),
          Row(children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.image_outlined),
              label: Text(_shot == null ? l.addScreenshot : l.screenshotAdded),
              onPressed: () async {
                final x = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1600, imageQuality: 80);
                if (x != null) setState(() => _shot = x);
              },
            ),
            const Spacer(),
            FilledButton(onPressed: _submit, child: Text(l.sendReport)),
          ]),
        ]),
      ),
    );
  }
}
