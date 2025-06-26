import 'package:flutter/material.dart';
import 'package:to_do/utils/app_themes.dart'; // For AppDimens

/// A customizable and reusable Bottom Navigation Bar widget.
/// It includes a floating action button "notch" and can be made visible/invisible.
class CustomBottomNavBar extends StatelessWidget {
  // Boolean to control the visibility of the navigation bar.
  final bool isVisible;
  // Index of the currently selected item. (Future use for active state management)
  final int currentIndex;
  // Callback function when a navigation item is tapped. (Future use for navigation)
  final ValueChanged<int>? onTap;

  const CustomBottomNavBar({
    super.key,
    this.isVisible = true, // Default to visible
    this.currentIndex = 0, // Default to first item selected
    this.onTap,
  });

  /// Helper method to build consistent bottom navigation items.
  /// This is extracted from TaskListsScreen for reusability.
  Widget _buildBottomNavItem(IconData icon, String label, ThemeData theme, bool isActive, int index) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    // Determine icon and text color based on active state
    final iconColor = isActive ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7);
    final textColor = isActive ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7);

    return Expanded( // Use Expanded to ensure even distribution of space for nav items
      child: InkWell(
        onTap: () {
          // If a callback is provided, call it with the index of the tapped item
          onTap?.call(index);
          print('$label tapped! Index: $index'); // For debugging
        },
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.cardMargin, vertical: AppDimens.cardMargin / 2),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Make column as small as possible vertically
            children: [
              Icon(icon, size: AppDimens.iconSize, color: iconColor),
              SizedBox(height: AppDimens.cardMargin / 4), // Small spacing between icon and text
              Text(
                label,
                style: textTheme.bodySmall?.copyWith(color: textColor),
                overflow: TextOverflow.ellipsis, // Prevent text from overflowing
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

    // Conditionally return the BottomAppBar or an empty SizedBox
    return isVisible
        ? BottomAppBar(
      color: colorScheme.surface, // Use theme surface for consistency
      elevation: AppDimens.cardElevation, // Consistent elevation
      shape: const CircularNotchedRectangle(), // Allows FAB to "notch" in
      child: SizedBox(
        height: kBottomNavigationBarHeight, // Explicitly set height for BottomAppBar's child
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribute items evenly
          children: [
            // Pass currentIndex to determine active state
            _buildBottomNavItem(Icons.assignment, 'Index', theme, currentIndex == 0, 0),
            _buildBottomNavItem(Icons.calendar_today, 'Calendar', theme, currentIndex == 1, 1),
            _buildBottomNavItem(Icons.timer, 'Focus', theme, currentIndex == 2, 2),
            _buildBottomNavItem(Icons.person, 'Profile', theme, currentIndex == 3, 3),
          ],
        ),
      ),
    )
        : const SizedBox.shrink(); // Return an empty widget if not visible
  }
}
