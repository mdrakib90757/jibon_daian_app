class EligibilityQuestion {
  const EligibilityQuestion({
    required this.id,
    required this.question,
    required this.hint,
    required this.passAnswer, // true = Yes passes, false = No passes
  });

  final String id;
  final String question;
  final String hint;
  final bool passAnswer;

  static const List<EligibilityQuestion> questions = [
    EligibilityQuestion(
      id: 'age',
      question: 'Are you between 18 and 60 years old?',
      hint: 'Age requirement for blood donation',
      passAnswer: true,
    ),
    EligibilityQuestion(
      id: 'weight',
      question: 'Do you weigh at least 50 kg (110 lbs)?',
      hint: 'Minimum weight requirement',
      passAnswer: true,
    ),
    EligibilityQuestion(
      id: 'last_donation',
      question: 'Has it been more than 90 days since your last donation?',
      hint: 'Recovery period between donations',
      passAnswer: true,
    ),
    EligibilityQuestion(
      id: 'health',
      question: 'Are you feeling healthy and well today?',
      hint: 'No cold, flu, or fever symptoms',
      passAnswer: true,
    ),
    EligibilityQuestion(
      id: 'medication',
      question: 'Are you currently free of any medications?',
      hint: 'Some medications may affect eligibility',
      passAnswer: true,
    ),
    EligibilityQuestion(
      id: 'surgery',
      question: 'Have you been free of surgery in the last 6 months?',
      hint: 'Recent surgery may affect eligibility',
      passAnswer: true,
    ),
  ];
}

class AppointmentSlot {
  const AppointmentSlot({required this.time, required this.isAvailable});

  final String time;
  final bool isAvailable;

  static const List<AppointmentSlot> mockSlots = [
    AppointmentSlot(time: '09:00 AM', isAvailable: true),
    AppointmentSlot(time: '10:00 AM', isAvailable: true),
    AppointmentSlot(time: '11:00 AM', isAvailable: false),
    AppointmentSlot(time: '12:00 PM', isAvailable: true),
    AppointmentSlot(time: '02:00 PM', isAvailable: true),
    AppointmentSlot(time: '03:00 PM', isAvailable: false),
    AppointmentSlot(time: '04:00 PM', isAvailable: true),
    AppointmentSlot(time: '05:00 PM', isAvailable: true),
  ];
}
