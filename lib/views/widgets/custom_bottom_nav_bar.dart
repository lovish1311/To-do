import 'package:flutter/material.dart';
import 'package:to_do/utils/app_themes.dart'; // For AppDimens

/// A customizable and reusable Bottom Navigation Bar widget.
/// It integrates a Floating Action Button (FAB) directly within its layout,
/// creating a visually appealing "docked" and slightly offset effect.
class CustomBottomNavBar extends StatelessWidget {
  final bool isVisible;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final VoidCallback? onFabPressed;

  const CustomBottomNavBar({
    super.key,
    this.isVisible = true,
    this.currentIndex = 0,
    this.onTap,
    this.onFabPressed,
  });

  /// Helper method to build consistent bottom navigation items.
  Widget _buildBottomNavItem(IconData icon, String label, ThemeData theme, bool isActive, int index) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final iconColor = isActive ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7);
    final textColor = isActive ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7);

    return Expanded(
      child: InkWell(
        onTap: () {
          onTap?.call(index);
          print('$label tapped! Index: $index');
        },
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.cardMargin, vertical: AppDimens.cardMargin / 2),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!isVisible) {
      return const SizedBox.shrink();
    }

    // FAB should stick out half its height
    final double fabOffset = -(AppDimens.fabSize*1.18);
    final double bottomBarHeight = kBottomNavigationBarHeight;

    return Container(
      height: bottomBarHeight, // Keep fixed height
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none, // Allow FAB to protrude
        children: [
          // BottomAppBar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomAppBar(
              color: colorScheme.surface,
              elevation: AppDimens.cardElevation,
              shape: const CircularNotchedRectangle(),
              child: SizedBox(
                height: bottomBarHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBottomNavItem(Icons.assignment, 'Index', theme, currentIndex == 0, 0),
                    _buildBottomNavItem(Icons.calendar_today, 'Calendar', theme, currentIndex == 1, 1),
                    SizedBox(width: kMinInteractiveDimension + AppDimens.cardMargin), // FAB gap
                    _buildBottomNavItem(Icons.timer, 'Focus', theme, currentIndex == 2, 2),
                    _buildBottomNavItem(Icons.person, 'Profile', theme, currentIndex == 3, 3),
                  ],
                ),
              ),
            ),
          ),
          // Centered Floating Action Button
          Align(
            alignment: Alignment.topCenter,
            child: Transform.translate(
              offset: Offset(0, fabOffset),
              child: SizedBox(
                width: AppDimens.fabSize,
                height: AppDimens.fabSize,
                child: FloatingActionButton(
                  onPressed: onFabPressed,
                  tooltip: 'Add Task',
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: const CircleBorder(),
                  child: Icon(
                    Icons.add,
                    size: AppDimens.fabIconSize,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
