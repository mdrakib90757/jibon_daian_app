import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_daian_app/features/contact_support/bloc/contact_support_event.dart';
import 'package:jibon_daian_app/features/contact_support/bloc/contact_support_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/widgets.dart';
import '../bloc/contact_support_bloc.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactSupportBloc, ContactSupportState>(
      listener: (context, state) {
        if (state is ContactSupportSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Message sent successfully!'),
              backgroundColor: AppColors.primary,
            ),
          );
          _subjectController.clear();
          _messageController.clear();
          context.read<ContactSupportBloc>().add(const ContactReset());
        }
        if (state is ContactSupportFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundWhite,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Contact Support', style: AppTextStyles.navTitle),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.pagePaddingH,
            vertical: AppDimens.pagePaddingV,
          ),
          child: BlocBuilder<ContactSupportBloc, ContactSupportState>(
            builder: (context, state) {
              final formState = state is ContactSupportInitial ? state : null;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How can we help you?',
                    style: AppTextStyles.authTitle.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Our team is here to assist you with any questions about blood donation.',
                    style: AppTextStyles.authSubtitle,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppDimens.spaceXL),

                  _ContactCard(
                    icon: Icons.mail_outline,
                    title: 'Email Support',
                    subtitle: 'support@jibondaian.com',
                    detail: 'Reply within 2 hours',
                    subtitleColor: AppColors.primary,
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  _ContactCard(
                    icon: Icons.phone_outlined,
                    title: 'Call Us',
                    subtitle: '+880 1234 567890',
                    detail: 'Available 24/7 for emergencies',
                    subtitleColor: AppColors.primary,
                  ),

                  const SizedBox(height: AppDimens.spaceXL),

                  Container(
                    padding: const EdgeInsets.all(AppDimens.spaceLG),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.cardShadow,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Send us a message',
                          style: AppTextStyles.sectionTitle,
                        ),

                        const SizedBox(height: AppDimens.spaceLG),

                        // Subject
                        Text('Subject', style: AppTextStyles.inputLabel),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _subjectController,
                          onChanged: (v) => context
                              .read<ContactSupportBloc>()
                              .add(ContactSubjectChanged(v)),
                          style: AppTextStyles.inputText,
                          decoration: _inputDecoration(
                            'What is this regarding?',
                          ),
                        ),

                        const SizedBox(height: AppDimens.spaceMD),

                        // Message
                        Text('Message', style: AppTextStyles.inputLabel),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _messageController,
                          onChanged: (v) => context
                              .read<ContactSupportBloc>()
                              .add(ContactMessageChanged(v)),
                          maxLines: 5,
                          style: AppTextStyles.inputText,
                          decoration: _inputDecoration(
                            'Type your message here...',
                          ),
                        ),

                        const SizedBox(height: AppDimens.spaceXL),

                        // Send button
                        AppPrimaryButton(
                          label: 'Send Message',
                          isLoading: formState?.isSending ?? false,
                          onPressed: () => context
                              .read<ContactSupportBloc>()
                              .add(const ContactSendSubmitted()),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppDimens.spaceXXL),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.inputHint,
      filled: true,
      fillColor: AppColors.inputBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.subtitleColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String detail;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.ripple2,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.hospitalName),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.hospitalSub.copyWith(
                  color: subtitleColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(detail, style: AppTextStyles.hospitalSub),
            ],
          ),
        ],
      ),
    );
  }
}
