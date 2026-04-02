import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_daian_app/features/blood_request/bloc/blood_request_event.dart';
import 'package:jibon_daian_app/features/blood_request/bloc/blood_request_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../bloc/blood_request_bloc.dart';
import '../../../shared/widgets/widgets.dart';

class BloodRequestScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;
  const BloodRequestScreen({super.key, this.onBackPressed});

  @override
  State<BloodRequestScreen> createState() => _BloodRequestScreenState();
}

class _BloodRequestScreenState extends State<BloodRequestScreen> {
  final _patientController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();
  final _additionalController = TextEditingController();

  static const List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];

  @override
  void dispose() {
    _patientController.dispose();
    _hospitalController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    _additionalController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(

      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            useMaterial3: false,
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.textWhite,
              surface: AppColors.cardBackground,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && context.mounted) {
      final formatted = '${picked.day}/${picked.month}/${picked.year}';
      context.read<BloodRequestBloc>().add(BloodRequestDateSelected(formatted));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BloodRequestBloc, BloodRequestState>(
      listener: (context, state) {
        if (state is BloodRequestSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Blood request posted successfully!'),
              backgroundColor: AppColors.primary,
            ),
          );
          Navigator.pop(context);
        }
        if (state is BloodRequestFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundWhite,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: widget.onBackPressed != null
              ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: widget.onBackPressed,
                )
              : IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
          automaticallyImplyLeading: false,
          title: Text('Request Blood', style: AppTextStyles.navTitle),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.pagePaddingH,
              vertical: AppDimens.pagePaddingV,
            ),
            child: BlocBuilder<BloodRequestBloc, BloodRequestState>(
              builder: (context, state) {
                final formState = state is BloodRequestFormState ? state : null;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Page Title ─────────────────────────────
                    Text('New Blood Request', style: AppTextStyles.authTitle),

                    const SizedBox(height: AppDimens.spaceXL),

                    // ── Patient Name ───────────────────────────
                    _SectionLabel(label: 'PATIENT NAME'),
                    const SizedBox(height: AppDimens.spaceXS),
                    _FormField(
                      controller: _patientController,
                      hint: "Enter patient's full name",
                      onChanged: (v) => context.read<BloodRequestBloc>().add(
                        BloodRequestPatientNameChanged(v),
                      ),
                    ),

                    const SizedBox(height: AppDimens.spaceLG),

                    // ── Blood Group Required ───────────────────
                    _SectionLabel(label: 'BLOOD GROUP REQUIRED'),
                    const SizedBox(height: AppDimens.spaceSM),
                    _BloodGroupGrid(
                      groups: _bloodGroups,
                      selected: formState?.selectedBloodGroup ?? '',
                      onSelect: (g) => context.read<BloodRequestBloc>().add(
                        BloodRequestGroupSelected(g),
                      ),
                    ),

                    const SizedBox(height: AppDimens.spaceLG),

                    // ── Hospital Name ──────────────────────────
                    _SectionLabel(label: 'HOSPITAL NAME'),
                    const SizedBox(height: AppDimens.spaceXS),
                    _FormField(
                      controller: _hospitalController,
                      hint: 'e.g. City General Hospital',
                      prefixIcon: Icons.local_hospital_outlined,
                      onChanged: (v) => context.read<BloodRequestBloc>().add(
                        BloodRequestHospitalChanged(v),
                      ),
                    ),

                    const SizedBox(height: AppDimens.spaceLG),

                    // ── Location / Area ────────────────────────
                    _SectionLabel(label: 'LOCATION / AREA'),
                    const SizedBox(height: AppDimens.spaceXS),
                    _FormField(
                      controller: _locationController,
                      hint: 'Select location',
                      prefixIcon: Icons.location_on_outlined,
                      onChanged: (v) => context.read<BloodRequestBloc>().add(
                        BloodRequestLocationChanged(v),
                      ),
                    ),

                    const SizedBox(height: AppDimens.spaceLG),

                    // ── When is it needed ──────────────────────
                    _SectionLabel(label: 'WHEN IS IT NEEDED?'),
                    const SizedBox(height: AppDimens.spaceXS),
                    GestureDetector(
                      onTap: () => _pickDate(context),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.inputBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              color: AppColors.inputIcon,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              formState?.neededDate.isNotEmpty == true
                                  ? formState!.neededDate
                                  : 'Select Date',
                              style: formState?.neededDate.isNotEmpty == true
                                  ? AppTextStyles.inputText
                                  : AppTextStyles.inputHint,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimens.spaceLG),

                    // ── Contact Number ─────────────────────────
                    _SectionLabel(label: 'CONTACT NUMBER'),
                    const SizedBox(height: AppDimens.spaceXS),
                    _FormField(
                      controller: _contactController,
                      hint: 'Phone number',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      onChanged: (v) => context.read<BloodRequestBloc>().add(
                        BloodRequestContactChanged(v),
                      ),
                    ),

                    const SizedBox(height: AppDimens.spaceLG),

                    // ── Additional Requirements (Optional) ─────
                    _SectionLabel(label: 'ADDITIONAL REQUIREMENTS (OPTIONAL)'),
                    const SizedBox(height: AppDimens.spaceXS),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.inputBorder),
                      ),
                      child: TextField(
                        controller: _additionalController,
                        maxLines: 3,
                        onChanged: (v) => context.read<BloodRequestBloc>().add(
                          BloodRequestAdditionalChanged(v),
                        ),
                        style: AppTextStyles.inputText,
                        decoration: InputDecoration(
                          hintText:
                              'Any specific requirements (e.g. Platelets, Fresh Blood)',
                          hintStyle: AppTextStyles.inputHint,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(14),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimens.spaceXXL),

                    // ── Submit Button ──────────────────────────
                    AppPrimaryButton(
                      label: 'Post Request',
                      isLoading: formState?.isSubmitting ?? false,
                      icon: const Icon(
                        Icons.send,
                        color: AppColors.textWhite,
                        size: 18,
                      ),
                      onPressed: () => context.read<BloodRequestBloc>().add(
                        const BloodRequestSubmitted(),
                      ),
                    ),

                    // ── Error message ──────────────────────────
                    if (formState?.errorMessage != null) ...[
                      const SizedBox(height: AppDimens.spaceMD),
                      Center(
                        child: Text(
                          formState!.errorMessage!,
                          style: AppTextStyles.hospitalSub.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: AppDimens.spaceLG),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ── Private Widgets ────────────────────────────────────────────────

/// Section label — uppercase small text
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.notifSectionHeader.copyWith(
        fontSize: 11,
        letterSpacing: 1.0,
        color: AppColors.textSecondary,
      ),
    );
  }
}

/// Reusable text input field
class _FormField extends StatelessWidget {
  const _FormField({
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
  });

  final TextEditingController controller;
  final String hint;
  final void Function(String) onChanged;
  final IconData? prefixIcon;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: AppTextStyles.inputText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.inputHint,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.inputIcon, size: 18)
            : null,
        filled: true,
        fillColor: AppColors.inputBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.inputFocusBorder,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

/// Blood group chip grid
class _BloodGroupGrid extends StatelessWidget {
  const _BloodGroupGrid({
    required this.groups,
    required this.selected,
    required this.onSelect,
  });

  final List<String> groups;
  final String selected;
  final void Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: groups.map((g) {
        final isSelected = g == selected;
        return GestureDetector(
          onTap: () => onSelect(g),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.inputBorder,
              ),
            ),
            child: Text(
              g,
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
