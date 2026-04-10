import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/widgets.dart';
import '../../appointment/bloc/appointment_bloc.dart';
import '../../appointment/screens/appointment_booking_screen.dart';
import '../bloc/eligibility_bloc.dart';
import '../bloc/eligibility_event.dart';
import '../bloc/eligibility_state.dart';
import '../data/model/eligibility_model.dart';

class EligibilityCheckScreen extends StatefulWidget {
  const EligibilityCheckScreen({super.key});

  @override
  State<EligibilityCheckScreen> createState() => _EligibilityCheckScreenState();
}

class _EligibilityCheckScreenState extends State<EligibilityCheckScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EligibilityBloc>().add(const EligibilityLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EligibilityBloc, EligibilityState>(
      listener: (context, state) {
        if (state is EligibilityPassed) {
          // ✅ Navigate to appointment booking
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => AppointmentBloc(),
                child: const AppointmentBookingScreen(),
              ),
            ),
          );
        }
        if (state is EligibilityFailed) {
          // ❌ Show not eligible dialog
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  const Icon(Icons.cancel, color: AppColors.primary, size: 24),
                  const SizedBox(width: 8),
                  Text('Not Eligible', style: AppTextStyles.authTitle),
                ],
              ),
              content: Text(state.reason, style: AppTextStyles.authSubtitle),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Understood', style: AppTextStyles.authLinkBold),
                ),
              ],
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
          title: Text('Eligibility Check', style: AppTextStyles.navTitle),
          centerTitle: true,
        ),
        body: BlocBuilder<EligibilityBloc, EligibilityState>(
          builder: (context, state) {
            if (state is EligibilityFormState) {
              return _EligibilityForm(state: state);
            }
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          },
        ),
      ),
    );
  }
}

class _EligibilityForm extends StatelessWidget {
  const _EligibilityForm({required this.state});
  final EligibilityFormState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Progress bar ───────────────────────────────────────
        LinearProgressIndicator(
          value: state.questions.isEmpty
              ? 0
              : state.answeredCount / state.questions.length,
          backgroundColor: AppColors.progressInactive,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          minHeight: 4,
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.pagePaddingH),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimens.spaceMD),

                // Header
                Text(
                  'Are you eligible to donate?',
                  style: AppTextStyles.authTitle,
                ),
                const SizedBox(height: 8),
                Text(
                  'Please answer all questions honestly to ensure your safety and the safety of recipients.',
                  style: AppTextStyles.authSubtitle,
                ),

                const SizedBox(height: AppDimens.spaceXL),

                // Questions
                ...state.questions.map((q) {
                  final answer = state.answers[q.id];
                  return _QuestionCard(
                    question: q,
                    answer: answer,
                    onAnswer: (ans) => context.read<EligibilityBloc>().add(
                      EligibilityAnswered(questionId: q.id, answer: ans),
                    ),
                  );
                }),

                const SizedBox(height: AppDimens.spaceXL),

                // Submit button
                AppPrimaryButton(
                  label: 'Check Eligibility',
                  isLoading: state.isChecking,
                  onPressed: state.allAnswered
                      ? () => context.read<EligibilityBloc>().add(
                          const EligibilitySubmitted(),
                        )
                      : null,
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.textWhite,
                    size: 20,
                  ),
                ),

                if (!state.allAnswered) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Please answer all ${state.questions.length} questions',
                      style: AppTextStyles.hospitalSub,
                    ),
                  ),
                ],

                const SizedBox(height: AppDimens.spaceXXL),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.answer,
    required this.onAnswer,
  });

  final EligibilityQuestion question;
  final bool? answer;
  final void Function(bool) onAnswer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: answer != null
              ? (answer == question.passAnswer
                    ? const Color(0xFF22C55E)
                    : AppColors.primary)
              : AppColors.inputBorder,
          width: answer != null ? 1.5 : 1,
        ),
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
          // Question text
          Text(question.question, style: AppTextStyles.hospitalName),
          const SizedBox(height: 4),
          Text(question.hint, style: AppTextStyles.hospitalSub),
          const SizedBox(height: 14),

          // Yes / No buttons
          Row(
            children: [
              _AnswerButton(
                label: 'Yes',
                isSelected: answer == true,
                isPositive: true,
                onTap: () => onAnswer(true),
              ),
              const SizedBox(width: 12),
              _AnswerButton(
                label: 'No',
                isSelected: answer == false,
                isPositive: false,
                onTap: () => onAnswer(false),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  const _AnswerButton({
    required this.label,
    required this.isSelected,
    required this.isPositive,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isPositive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color bg = isSelected
        ? (isPositive ? const Color(0xFF22C55E) : AppColors.primary)
        : AppColors.inputBackground;
    Color fg = isSelected ? AppColors.textWhite : AppColors.textSecondary;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 42,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? Colors.transparent : AppColors.inputBorder,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.buttonLabel.copyWith(color: fg),
            ),
          ),
        ),
      ),
    );
  }
}
