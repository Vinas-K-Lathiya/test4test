import 'package:flutter/material.dart';

import '../theme.dart';

/// A 3D illustration from assets/3d (Microsoft Fluent Emoji, MIT).
class Img3d extends StatelessWidget {
  const Img3d(this.name, {super.key, this.size = 40, this.opacity = 1});
  final String name;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final img = Image.asset(
      'assets/3d/$name.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
    );
    return opacity >= 1 ? img : Opacity(opacity: opacity, child: img);
  }
}

/// A 3D image on a soft tinted rounded square, used as a leading visual in lists.
class ImgTile extends StatelessWidget {
  const ImgTile(this.name, {super.key, this.size = 52, this.color});
  final String name;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Brand.indigo;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.18 : 0.08),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      alignment: Alignment.center,
      child: Img3d(name, size: size * 0.66),
    );
  }
}

/// White rounded card with a soft shadow (the main surface of the design).
class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color,
    this.radius = 20,
    this.border,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final double radius;
  final Color? border;

  @override
  Widget build(BuildContext context) {
    final bg = color ?? Theme.of(context).cardTheme.color ?? Colors.white;
    final r = BorderRadius.circular(radius);
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: r,
        boxShadow: Brand.softShadow(context),
        border: border == null ? null : Border.all(color: border!, width: 1.4),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: r,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Violet gradient hero card with optional decorative image on the right.
class GradientCard extends StatelessWidget {
  const GradientCard({
    super.key,
    required this.child,
    this.image,
    this.imageSize = 110,
    this.gradient = Brand.gradient,
    this.onTap,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final String? image;
  final double imageSize;
  final Gradient gradient;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(24);
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: r,
        boxShadow: [
          BoxShadow(
            color: Brand.indigo.withValues(alpha: 0.22),
            blurRadius: 22,
            spreadRadius: -6,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: r,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              children: [
                // Soft decorative circles, like the reference hero.
                Positioned(right: -40, top: -40, child: _circle(160, 0.10)),
                Positioned(right: 30, bottom: -60, child: _circle(120, 0.07)),
                if (image != null) Positioned(right: 12, bottom: 12, child: Img3d(image!, size: imageSize)),
                Padding(
                  padding: image == null ? padding : padding.add(EdgeInsets.only(right: imageSize * 0.75)),
                  child: DefaultTextStyle.merge(
                    style: const TextStyle(color: Colors.white),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _circle(double s, double a) => Container(
    width: s,
    height: s,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withValues(alpha: a),
    ),
  );
}

/// White pill button used on top of gradient cards.
class OnGradientButton extends StatelessWidget {
  const OnGradientButton({super.key, required this.label, required this.onPressed, this.icon});
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => FilledButton(
    style: FilledButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Brand.indigo,
      minimumSize: const Size(0, 44),
      padding: const EdgeInsets.symmetric(horizontal: 18),
    ),
    onPressed: onPressed,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 6)],
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 4),
        const Icon(Icons.chevron_right_rounded, size: 20),
      ],
    ),
  );
}

/// "Title ........ View all" header above a section.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action, this.onAction, this.trailing, this.subtitle});
  final String title;
  final String? subtitle;
  final String? action;
  final VoidCallback? onAction;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(2, 22, 2, 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              if (subtitle != null) Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action!,
              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700),
            ),
          ),
        ?trailing,
      ],
    ),
  );
}

/// Numbered "how it works" row with a 3D image.
class StepRow extends StatelessWidget {
  const StepRow({super.key, required this.number, required this.image, required this.title, required this.body});
  final int number;
  final String image;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => SoftCard(
    padding: const EdgeInsets.all(12),
    child: Row(
      children: [
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Brand.indigo.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: Text(
            '$number',
            style: const TextStyle(color: Brand.indigo, fontWeight: FontWeight.w800, fontSize: 12),
          ),
        ),
        const SizedBox(width: 12),
        ImgTile(image, size: 52),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 2),
              Text(body, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    ),
  );
}

/// Big number + label tile (profile stats, group stats).
class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.value, required this.label, this.image, this.color});
  final String value;
  final String label;
  final String? image;
  final Color? color;

  @override
  Widget build(BuildContext context) => SoftCard(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (image != null) ...[Img3d(image!, size: 28), const SizedBox(height: 6)],
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: color),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  );
}

/// Small colored status pill ("Active", "Done", "In queue").
class StatusPill extends StatelessWidget {
  const StatusPill(this.text, {super.key, required this.color, this.icon});
  final String text;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(99)),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon, size: 12, color: color), const SizedBox(width: 4)],
        Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 11.5),
        ),
      ],
    ),
  );
}

/// Bottom navigation in the reference style: white bar, colored active icon + label.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.index, required this.onTap, required this.items});
  final int index;
  final ValueChanged<int> onTap;
  final List<(IconData, IconData, String)> items;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final active = Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: dark ? Brand.cardDark : Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => onTap(i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: i == index ? active.withValues(alpha: 0.10) : Colors.transparent,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Icon(
                            i == index ? items[i].$2 : items[i].$1,
                            color: i == index ? active : Brand.grey,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          items[i].$3,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: i == index ? FontWeight.w800 : FontWeight.w600,
                            color: i == index ? active : Brand.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
