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

    // The desired amount the FAB should visually protrude above the BottomAppBar.
    // For "half inside, half outside", this is exactly half of the FAB's height.
    final double fabProtrusionAmount = AppDimens.fabSize / 2;
    final double bottomBarHeight = kBottomNavigationBarHeight;

    // Calculate the total height this CustomBottomNavBar widget will occupy.
    // This is the standard BottomAppBar height PLUS the portion of the FAB
    // that sticks out upwards. This height is crucial for the Scaffold's body padding.
    final double totalHeightWithFabProtrusion = bottomBarHeight + fabProtrusionAmount;

    // Calculate the y-offset for Transform.translate.
    // The Align(alignment: Alignment.topCenter) places the FAB's top at the top of the Stack.
    // To make it half-in and half-out, the FAB's *top edge* should be at
    // `totalHeightWithFabProtrusion - AppDimens.fabSize`.
    final double fabTranslateYOffset = totalHeightWithFabProtrusion - AppDimens.fabSize;


    return SizedBox( // Use SizedBox to explicitly define the height of the bottom nav bar area
      height: totalHeightWithFabProtrusion, // Corrected: This now reports its true visual height
      child: Stack(
        alignment: Alignment.bottomCenter, // Align children to the bottom center
        clipBehavior: Clip.none, // Crucial: Allows children (FAB) to paint outside the Stack's bounds
        children: [
          // The BottomAppBar itself, positioned at the very bottom of the Stack
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomAppBar(
              color: colorScheme.surface,
              elevation: AppDimens.cardElevation,
              shape: const CircularNotchedRectangle(), // Creates the notch for the FAB
              child: SizedBox(
                height: bottomBarHeight, // Height for the internal Row
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBottomNavItem(Icons.assignment, 'Index', theme, currentIndex == 0, 0),
                    _buildBottomNavItem(Icons.calendar_today, 'Calendar', theme, currentIndex == 1, 1),
                    // HERE IS THE FLOATING ACTION BUTTON SPACE
                    // This SizedBox creates the horizontal space in the Row for the FAB.
                    // Its width should be at least the FAB's diameter plus some margin.
                    SizedBox(width: AppDimens.fabSize + AppDimens.cardMargin),
                    _buildBottomNavItem(Icons.timer, 'Focus', theme, currentIndex == 2, 2),
                    _buildBottomNavItem(Icons.person, 'Profile', theme, currentIndex == 3, 3),
                  ],
                ),
              ),
            ),
          ),
          // Centered Floating Action Button
          Align(
            alignment: Alignment.topCenter, // Align to the top of the stack
            child: Transform.translate(
              // Apply the Y offset to move the FAB to its correct position.
              // This positions the FAB for the "half inside, half outside" effect.
              offset: Offset(0, fabTranslateYOffset),
              child: SizedBox(
                width: AppDimens.fabSize, // Explicitly set FAB width
                height: AppDimens.fabSize, // Explicitly set FAB height
                child: FloatingActionButton(
                  onPressed: onFabPressed, // Use the provided callback
                  tooltip: 'Add Task',
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: const CircleBorder(), // Keep it circular
                  child: Icon(
                    Icons.add,
                    size: AppDimens.fabIconSize, // Use custom FAB icon size
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
