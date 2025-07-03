import 'package:flutter/material.dart';
import 'package:to_do/utils/app_themes.dart'; // For AppDimens

/// A customizable and reusable Bottom Navigation Bar widget.
/// This version excludes the Floating Action Button, which should be placed
/// in the Scaffold using [floatingActionButton] and [floatingActionButtonLocation].
class CustomBottomNavBar extends StatelessWidget {
  final bool isVisible;
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const CustomBottomNavBar({
    super.key,
    this.isVisible = true,
    this.currentIndex = 0,
    this.onTap,
  });

  /// Helper method to build consistent bottom navigation items.
  Widget _buildBottomNavItem(IconData icon, String label, ThemeData theme, bool isActive, int index) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final iconColor = isActive ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7);
    final textColor = isActive ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7);

    return Expanded(
      child: InkWell(
        onTap: () => onTap?.call(index),
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.cardMargin,
            vertical: AppDimens.cardMargin / 2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: AppDimens.iconSize, color: iconColor),
              SizedBox(height: AppDimens.cardMargin / 4),
              Text(
                label,
                style: textTheme.bodySmall?.copyWith(color: textColor),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BottomAppBar(
      color: colorScheme.surface,
      elevation: AppDimens.cardElevation,
      shape: const CircularNotchedRectangle(), // Creates notch for FAB
      child: SizedBox(
        height: kBottomNavigationBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(Icons.assignment, 'Index', theme, currentIndex == 0, 0),
            _buildBottomNavItem(Icons.calendar_today, 'Calendar', theme, currentIndex == 1, 1),
            const SizedBox(width: AppDimens.fabSize), // Spacer for FAB
            _buildBottomNavItem(Icons.timer, 'Focus', theme, currentIndex == 2, 2),
            _buildBottomNavItem(Icons.person, 'Profile', theme, currentIndex == 3, 3),
          ],
        ),
      ),
    );
  }
}
