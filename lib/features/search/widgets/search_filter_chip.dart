import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// SearchFilterChip - Removable / toggleable filter chip
/// used for blood group, city, availability filters
class SearchFilterChip extends StatelessWidget {
  const SearchFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.showRemove = false,
    this.showDropdown = false,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  /// Shows × button (selected blood group style)
  final bool showRemove;

  /// Shows ↓ dropdown arrow (city filter style)
  final bool showDropdown;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.inputBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.inputLabel.copyWith(
                fontSize: 12,
                color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
              ),
            ),
            if (showRemove && isSelected) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.close,
                size: 14,
                color: isSelected
                    ? AppColors.textWhite
                    : AppColors.textSecondary,
              ),
            ],
            if (showDropdown) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: isSelected
                    ? AppColors.textWhite
                    : AppColors.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
