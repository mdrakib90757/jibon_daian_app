import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/widgets.dart';
import '../bloc/appointment_bloc.dart';
import '../bloc/appointment_state.dart';

class AppointmentConfirmedScreen extends StatelessWidget {
  const AppointmentConfirmedScreen({super.key, required this.state});
  final AppointmentBooked state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Appointment Confirmed', style: AppTextStyles.navTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.pagePaddingH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppDimens.spaceXL),

            // ── Success icon ──────────────────────────────────────
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFDCFCE7),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF22C55E),
                size: 48,
              ),
            ),

            const SizedBox(height: AppDimens.spaceLG),

            Text(
              'Booking Confirmed!',
              style: AppTextStyles.authTitle.copyWith(fontSize: 22),
            ),

            const SizedBox(height: 6),

            Text(
              'Show this QR code at the donation center',
              style: AppTextStyles.authSubtitle,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppDimens.spaceXL),

            // ── QR Code placeholder ───────────────────────────────
            Container(
              width: 200,
              height: 200,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.inputBorder, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              // TODO: Replace with real QR package
              // qr_flutter: QrImageView(data: state.qrCode, ...)
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.qr_code_2,
                    size: 120,
                    color: AppColors.textPrimary,
                  ),
                  Text(
                    state.appointmentId,
                    style: AppTextStyles.hospitalSub.copyWith(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimens.spaceXL),

            // ── Appointment Details ───────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimens.spaceLG),
              decoration: BoxDecoration(
                color: AppColors.ripple3,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.ripple1),
              ),
              child: Column(
                children: [
                  _DetailRow(
                    icon: Icons.local_hospital_outlined,
                    label: 'Center',
                    value: state.centerName,
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Date',
                    value: state.date,
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    icon: Icons.access_time,
                    label: 'Time',
                    value: state.time,
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    icon: Icons.confirmation_number_outlined,
                    label: 'Appointment ID',
                    value: state.appointmentId,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimens.spaceLG),

            // ── Important note ────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.ripple2,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Please arrive 10 minutes early. '
                      'Bring a valid ID. Stay hydrated before donating.',
                      style: AppTextStyles.hospitalSub.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimens.spaceXL),

            // ── Back to Home button ───────────────────────────────
            AppPrimaryButton(
              label: 'Back to Home',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              ),
              icon: const Icon(
                Icons.home_outlined,
                color: AppColors.textWhite,
                size: 20,
              ),
            ),

            const SizedBox(height: AppDimens.spaceXXL),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: AppTextStyles.hospitalSub.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.hospitalName.copyWith(fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
