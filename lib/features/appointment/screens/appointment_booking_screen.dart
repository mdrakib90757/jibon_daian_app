import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_daian_app/features/appointment/bloc/appointment_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/widgets.dart';
import '../bloc/appointment_bloc.dart';
import '../bloc/appointment_event.dart';
import 'appointment_confirmed_screen.dart';

class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({super.key});

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AppointmentBloc>().add(const AppointmentLoaded());
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: AppColors.textWhite,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null && context.mounted) {
      context.read<AppointmentBloc>().add(AppointmentDateSelected(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentBloc, AppointmentState>(
      listener: (context, state) {
        if (state is AppointmentBooked) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => AppointmentConfirmedScreen(state: state),
            ),
          );
        }
        if (state is AppointmentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundWhite,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Book Appointment', style: AppTextStyles.navTitle),
          centerTitle: true,
        ),
        body: BlocBuilder<AppointmentBloc, AppointmentState>(
          builder: (context, state) {
            if (state is AppointmentLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state is AppointmentFormState) {
              return _AppointmentForm(
                state: state,
                onPickDate: () => _pickDate(context),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _AppointmentForm extends StatelessWidget {
  const _AppointmentForm({required this.state, required this.onPickDate});

  final AppointmentFormState state;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.pagePaddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text('Book Your Appointment', style: AppTextStyles.authTitle),
          const SizedBox(height: 6),
          Text(
            'Select a donation center, date, and time that works for you.',
            style: AppTextStyles.authSubtitle,
          ),

          const SizedBox(height: AppDimens.spaceXL),

          // ── Select Center ──────────────────────────────────────
          Text('Select Center', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppDimens.spaceMD),

          ...state.centers.map((center) {
            final isSelected = state.selectedCenterId == center.id;
            return GestureDetector(
              onTap: () => context.read<AppointmentBloc>().add(
                AppointmentCenterSelected(center.id, center.name),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.ripple2
                      : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.inputBorder,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.ripple2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: isSelected
                            ? AppColors.textWhite
                            : AppColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(center.name, style: AppTextStyles.hospitalName),
                          const SizedBox(height: 3),
                          Text(
                            '${center.distanceKm} km • ${center.openUntil}',
                            style: AppTextStyles.hospitalSub,
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        size: 22,
                      ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: AppDimens.spaceXL),

          // ── Select Date ────────────────────────────────────────
          Text('Select Date', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppDimens.spaceMD),

          GestureDetector(
            onTap: onPickDate,
            child: Container(
              width: double.infinity,
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: state.selectedDate != null
                      ? AppColors.primary
                      : AppColors.inputBorder,
                  width: state.selectedDate != null ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    color: state.selectedDate != null
                        ? AppColors.primary
                        : AppColors.inputIcon,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    state.selectedDate != null
                        ? '${state.selectedDate!.day}/${state.selectedDate!.month}/${state.selectedDate!.year}'
                        : 'Select a date',
                    style: state.selectedDate != null
                        ? AppTextStyles.inputText.copyWith(
                            color: AppColors.textPrimary,
                          )
                        : AppTextStyles.inputHint,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppDimens.spaceXL),

          // ── Select Time ────────────────────────────────────────
          Text('Select Time', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppDimens.spaceMD),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: state.timeSlots.map((slot) {
              final isSelected = state.selectedTime == slot.time;
              final isDisabled = !slot.isAvailable;

              return GestureDetector(
                onTap: isDisabled
                    ? null
                    : () => context.read<AppointmentBloc>().add(
                        AppointmentTimeSelected(slot.time),
                      ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isDisabled
                        ? AppColors.inputBackground
                        : isSelected
                        ? AppColors.primary
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDisabled
                          ? AppColors.inputBorder
                          : isSelected
                          ? AppColors.primary
                          : AppColors.inputBorder,
                    ),
                  ),
                  child: Text(
                    slot.time,
                    style: AppTextStyles.inputLabel.copyWith(
                      color: isDisabled
                          ? AppColors.textHint
                          : isSelected
                          ? AppColors.textWhite
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: AppDimens.spaceXXL),

          // ── Confirm Button ─────────────────────────────────────
          AppPrimaryButton(
            label: 'Confirm Appointment',
            isLoading: state.isBooking,
            onPressed: state.isValid
                ? () => context.read<AppointmentBloc>().add(
                    const AppointmentConfirmed(),
                  )
                : null,
            icon: const Icon(
              Icons.check_circle_outline,
              color: AppColors.textWhite,
              size: 20,
            ),
          ),

          if (!state.isValid) ...[
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Please select center, date and time',
                style: AppTextStyles.hospitalSub,
              ),
            ),
          ],

          const SizedBox(height: AppDimens.spaceXXL),
        ],
      ),
    );
  }
}
