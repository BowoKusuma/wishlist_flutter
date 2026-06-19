import 'package:flutter/material.dart';
import '../theme.dart';
import '../models.dart';

// ── Progress Bar ──────────────────────────────────────────────────
class WishProgressBar extends StatelessWidget {
  final int saved;
  final int budget;
  final AppColorsTheme c;
  final double height;

  const WishProgressBar({
    super.key,
    required this.saved,
    required this.budget,
    required this.c,
    this.height = 7,
  });

  @override
  Widget build(BuildContext context) {
    final p = pct(saved, budget);
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: Stack(
        children: [
          Container(
            height: height,
            decoration: BoxDecoration(
              color: c.progressBg,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          FractionallySizedBox(
            widthFactor: p / 100,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                gradient: p >= 100 ? c.progressGreen : c.progressGrad,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Category Tag ──────────────────────────────────────────────────
class CategoryTag extends StatelessWidget {
  final WishCategory cat;
  final AppColorsTheme c;

  const CategoryTag({super.key, required this.cat, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.tag,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(cat.icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            cat.label,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600,
              color: c.tagText,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filter Pill ──────────────────────────────────────────────────
class FilterPill extends StatelessWidget {
  final String label;
  final String icon;
  final bool active;
  final AppColorsTheme c;
  final VoidCallback onTap;

  const FilterPill({
    super.key,
    required this.label,
    required this.icon,
    required this.active,
    required this.c,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? c.accent : c.tag,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : c.tagText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dark Mode Toggle Button ───────────────────────────────────────
class DarkModeButton extends StatelessWidget {
  final bool isDark;
  final AppColorsTheme c;
  final VoidCallback onToggle;

  const DarkModeButton({
    super.key,
    required this.isDark,
    required this.c,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: c.tag,
          border: Border.all(color: c.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            isDark ? '☀️' : '🌙',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

// ── Primary Button ───────────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final AppColorsTheme c;
  final Color? overrideColor;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.c,
    this.overrideColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
        decoration: BoxDecoration(
          color: overrideColor ?? c.accent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

// ── Ghost Button ─────────────────────────────────────────────────
class GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final AppColorsTheme c;

  const GhostButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: c.accent, width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: c.accentLabel,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

// ── Stat Card ────────────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final AppColorsTheme c;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.border),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: c.text,
              fontFamily: 'Nunito',
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: c.textSub,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
