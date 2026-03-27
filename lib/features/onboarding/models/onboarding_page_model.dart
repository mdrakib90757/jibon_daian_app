/// OnboardingPage - Data model for each onboarding slide
class OnboardingPage {
  const OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  final String title;
  final String description;
  final String imagePath;
}
