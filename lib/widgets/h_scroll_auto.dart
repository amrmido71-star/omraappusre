import 'package:flutter/material.dart';

/// A horizontally-scrolling row that sizes its height to the tallest child
/// instead of a guessed fixed height — the source of most "RenderFlex
/// overflowed" warnings on card scrollers (font metrics/locale/text-scale
/// changes make a hardcoded height wrong on some devices).
class HScrollAuto extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double spacing;
  final EdgeInsetsGeometry padding;

  const HScrollAuto({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.spacing = 10,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < itemCount; i++) ...[
              if (i > 0) SizedBox(width: spacing),
              itemBuilder(context, i),
            ],
          ],
        ),
      ),
    );
  }
}
