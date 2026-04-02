class UserProfileModel {
  const UserProfileModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.location,
    required this.bloodGroup,
    required this.totalDonations,
    required this.lastDonation,
    required this.nextEligible,
    this.avatarUrl,
  });

  final String fullName;
  final String email;
  final String phoneNumber;
  final String location;
  final String bloodGroup;
  final int totalDonations;
  final String lastDonation;
  final String nextEligible;
  final String? avatarUrl;

  // ── Mock data ─────────────────────────────────────────────────
  static const UserProfileModel mock = UserProfileModel(
    fullName: 'Jibon Daian',
    email: 'jibon.daian@example.com',
    phoneNumber: '+880 1712-345678',
    location: 'Dhaka, Bangladesh',
    bloodGroup: 'A+',
    totalDonations: 5,
    lastDonation: 'Oct 12, 2023',
    nextEligible: 'Jan 12, 2024',
  );

  UserProfileModel copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? location,
    String? bloodGroup,
    int? totalDonations,
    String? lastDonation,
    String? nextEligible,
    String? avatarUrl,
  }) {
    return UserProfileModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      totalDonations: totalDonations ?? this.totalDonations,
      lastDonation: lastDonation ?? this.lastDonation,
      nextEligible: nextEligible ?? this.nextEligible,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
