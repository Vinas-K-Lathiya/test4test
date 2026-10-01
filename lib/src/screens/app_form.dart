import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n.dart';
import '../models.dart';
import '../providers.dart';
import '../widgets/common.dart';

final _pkgRe = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*(\.[a-zA-Z][a-zA-Z0-9_]*)+$');
final _optInRe = RegExp(r'^https://play\.google\.com/apps/(internaltest|testing)/.+');

class AppFormScreen extends ConsumerStatefulWidget {
  const AppFormScreen({super.key, this.appId});
  final String? appId;
  @override
  ConsumerState<AppFormScreen> createState() => _AppFormScreenState();
}

class _AppFormScreenState extends ConsumerState<AppFormScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _pkg = TextEditingController();
  final _desc = TextEditingController();
  final _notes = TextEditingController();
  final _optIn = TextEditingController();
  String? _iconUrl;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _pkg.addListener(() {
      final p = _pkg.text.trim();
      if (_optIn.text.isEmpty || _optIn.text.startsWith('https://play.google.com/apps/testing/')) {
        _optIn.text = p.isEmpty ? '' : AppListing.optInUrlFor(p);
      }
      setState(() {});
    });
    if (widget.appId == null) {
      _loaded = true;
    } else {
      FirebaseFirestore.instance.collection('apps').doc(widget.appId).get().then((d) {
        if (!d.exists || !mounted) return;
        final a = AppListing.fromDoc(d);
        _name.text = a.name;
        _pkg.text = a.packageName;
        _desc.text = a.description;
        _notes.text = a.testNotes;
        _optIn.text = a.optInWebUrl;
        setState(() {
          _iconUrl = a.iconUrl;
          _loaded = true;
        });
      });
    }
  }

  @override
  void dispose() {
    for (final c in [_name, _pkg, _desc, _notes, _optIn]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickIcon() async {
    final uid = ref.read(uidProvider)!;
    final x = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512, imageQuality: 85);
    if (x == null || !mounted) return;
    await runAction(context, () async {
      final r = FirebaseStorage.instance.ref('uploads/$uid/icon_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await r.putData(await x.readAsBytes(), SettableMetadata(contentType: 'image/jpeg'));
      final url = await r.getDownloadURL();
      setState(() => _iconUrl = url);
    });
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final uid = ref.read(uidProvider)!;
    final pkg = _pkg.text.trim();
    final app = AppListing(
      id: widget.appId ?? '',
      ownerUid: uid,
      name: _name.text.trim(),
      packageName: pkg,
      description: _desc.text.trim(),
      testNotes: _notes.text.trim(),
      optInWebUrl: _optIn.text.trim(),
      optInPlayUrl: AppListing.playUrlFor(pkg),
      iconUrl: _iconUrl,
    );
    final col = FirebaseFirestore.instance.collection('apps');
    final ok = await runAction(
      context,
      () => widget.appId == null ? col.add(app.toJson()) : col.doc(widget.appId).set(app.toJson()),
      success: context.l10n.saved,
    );
    if (ok && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (!_loaded) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: Text(widget.appId == null ? l.addApp : l.editApp)),
      body: Form(
        key: _form,
        child: ListView(padding: const EdgeInsets.all(16), children: [
          Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _pickIcon,
              child: Column(children: [
                AppIconView(name: _name.text.isEmpty ? '+' : _name.text, url: _iconUrl, size: 80),
                const SizedBox(height: 6),
                Text(l.appIcon, style: Theme.of(context).textTheme.bodySmall),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _name,
            decoration: InputDecoration(labelText: l.appName),
            maxLength: 50,
            onChanged: (_) => setState(() {}),
            validator: (v) => (v ?? '').trim().length < 2 ? l.required : null,
          ),
          TextFormField(
            controller: _pkg,
            decoration: InputDecoration(labelText: l.packageName, hintText: 'com.example.myapp'),
            enabled: widget.appId == null,
            validator: (v) => _pkgRe.hasMatch((v ?? '').trim()) ? null : l.invalidPackage,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _optIn,
            decoration: InputDecoration(labelText: l.optInLink, helperText: l.optInHelp, helperMaxLines: 3),
            keyboardType: TextInputType.url,
            validator: (v) => _optInRe.hasMatch((v ?? '').trim()) ? null : l.invalidOptIn,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _desc,
            decoration: InputDecoration(labelText: l.shortDescription),
            maxLength: 300,
            maxLines: 2,
          ),
          TextFormField(
            controller: _notes,
            decoration: InputDecoration(labelText: l.testNotes, helperText: l.testNotesHelp, helperMaxLines: 2),
            maxLength: 1000,
            maxLines: 4,
          ),
          const SizedBox(height: 8),
          InfoCard(icon: Icons.lightbulb_outline_rounded, title: l.closedTestTipTitle, body: l.closedTestTipBody),
          const SizedBox(height: 20),
          FilledButton(onPressed: _save, child: Text(l.save)),
        ]),
      ),
    );
  }
}
