import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class BloodGroupSelector extends StatefulWidget {
  const BloodGroupSelector({
    super.key,
    required this.onSelected,
    this.initialValue,
  });

  final void Function(String) onSelected;
  final String? initialValue;

  @override
  State<BloodGroupSelector> createState() => _BloodGroupSelectorState();
}

class _BloodGroupSelectorState extends State<BloodGroupSelector> {
  static const List<String> _groups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];

  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _groups.map((group) {
        final isSelected = _selected == group;
        return GestureDetector(
          onTap: () {
            setState(() => _selected = group);
            widget.onSelected(group);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.chipSelected
                  : AppColors.chipUnselected,
              border: Border.all(
                color: isSelected
                    ? AppColors.chipSelected
                    : AppColors.chipBorder,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              group,
              style: AppTextStyles.bloodGroupChip.copyWith(
                color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
