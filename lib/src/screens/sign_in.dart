import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config.dart';
import '../l10n.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/ui.dart';
import 'settings.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});
  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  bool _busy = false;

  Future<void> _signIn() async {
    setState(() => _busy = true);
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(friendlyError(context, e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: Brand.gradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    onPressed: () => showLanguagePicker(context, ref),
                    icon: const Icon(Icons.translate_rounded),
                    label: Text(l.language),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 260,
                  height: 150,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.12)),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset('assets/branding/logo_round.png', width: 108, height: 108),
                      ),
                      const Positioned(left: 8, top: 10, child: Img3d('rocket', size: 52)),
                      const Positioned(right: 6, top: 4, child: Img3d('trophy', size: 48)),
                      const Positioned(left: 26, bottom: 0, child: Img3d('people', size: 44)),
                      const Positioned(right: 20, bottom: 4, child: Img3d('check', size: 42)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'TestPact',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  l.tagline,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 32),
                _Bullet(image: 'people', text: l.signInBullet1),
                _Bullet(image: 'shield', text: l.signInBullet2),
                _Bullet(image: 'speech', text: l.signInBullet3),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Brand.indigo),
                    onPressed: _busy ? null : _signIn,
                    icon: _busy
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.login_rounded),
                    label: Text(l.continueWithGoogle),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.white70),
                      onPressed: () => openUrl(AppConfig.privacyUrl),
                      child: Text(l.privacyPolicy),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.white70),
                      onPressed: () => openUrl(AppConfig.termsUrl),
                      child: Text(l.terms),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.image, required this.text});
  final String image;
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Img3d(image, size: 26),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 15)),
        ),
      ],
    ),
  );
}
