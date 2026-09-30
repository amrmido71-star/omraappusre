import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'h_scroll_auto.dart';

/// Mirrors `.fbar` / `.fchip` — the horizontal filter-chip row under the
/// search bar on the Umrah tab.
class FilterChipBar extends StatelessWidget {
  final List<String> labels;
  final int selected;
  final Color accent;
  final ValueChanged<int> onSelect;

  const FilterChipBar(
      {super.key,
      required this.labels,
      required this.selected,
      required this.onSelect,
      this.accent = AppColors.blue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: AppColors.border))),
      child: HScrollAuto(
        itemCount: labels.length,
        spacing: 7,
        itemBuilder: (context, i) {
          final on = i == selected;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
              decoration: BoxDecoration(
                color: on ? accent : Colors.white,
                border: Border.all(
                    color: on ? accent : AppColors.border, width: 1.5),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(labels[i],
                  style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: on ? Colors.white : AppColors.muted)),
            ),
          );
        },
      ),
    );
  }
}
