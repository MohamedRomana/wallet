import 'package:flutter/material.dart';

import '../utils/money.dart';

/// Smoothly counts up/down to [value] whenever it changes. Used for balances
/// so updates feel alive without any always-running controller.
class AnimatedAmount extends StatelessWidget {
  final double value;
  final TextStyle? style;
  final bool signed;
  final bool isIncome;
  final Duration duration;

  const AnimatedAmount({
    super.key,
    required this.value,
    this.style,
    this.signed = false,
    this.isIncome = true,
    this.duration = const Duration(milliseconds: 700),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, v, _) {
        final text = signed ? Money.signed(v, isIncome: isIncome) : Money.format(v);
        return Text(text, style: style, maxLines: 1, overflow: TextOverflow.ellipsis);
      },
    );
  }
}
