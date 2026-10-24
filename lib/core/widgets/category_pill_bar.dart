import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';

/// Quick category filter pill bar (Live, Series, Videos, News, Stats).
class CategoryPillBar extends StatefulWidget {
  final ValueChanged<int>? onCategorySelected;
  final int initialIndex;

  const CategoryPillBar({
    super.key,
    this.onCategorySelected,
    this.initialIndex = 0,
  });

  @override
  State<CategoryPillBar> createState() => _CategoryPillBarState();
}

class _CategoryPillBarState extends State<CategoryPillBar> {
  late int _selectedIndex;

  static const List<_CategoryItem> _categories = [
    _CategoryItem(title: 'Live', icon: Icons.sensors_rounded),
    _CategoryItem(title: 'Series', icon: Icons.emoji_events_outlined),
    _CategoryItem(title: 'Videos', icon: Icons.play_circle_outline_rounded),
    _CategoryItem(title: 'News', icon: Icons.article_outlined),
    _CategoryItem(title: 'Stats', icon: Icons.bar_chart_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_categories.length, (index) {
          final item = _categories[index];
          final isSelected = _selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedIndex = index);
                widget.onCategorySelected?.call(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.symmetric(horizontal: 3.0),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.activePill(context)
                      : AppColors.surface(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary(context).withValues(alpha: 0.45)
                        : AppColors.border(context),
                    width: 1.2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary(context).withValues(alpha: 0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : AppShadows.neumorphic(context),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.icon,
                      size: 20,
                      color: isSelected
                          ? AppColors.primary(context)
                          : AppColors.textSecondary(context),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary(context)
                              : AppColors.textSecondary(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _CategoryItem {
  final String title;
  final IconData icon;

  const _CategoryItem({required this.title, required this.icon});
}
