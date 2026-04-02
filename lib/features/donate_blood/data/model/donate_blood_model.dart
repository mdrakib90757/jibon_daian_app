enum DonationCenterStatus { available, busy, closed }

class DonationCenterModel {
  const DonationCenterModel({
    required this.id,
    required this.name,
    required this.distanceKm,
    required this.openUntil,
    required this.status,
  });

  final String id;
  final String name;
  final double distanceKm;
  final String openUntil;
  final DonationCenterStatus status;

  static String statusLabel(DonationCenterStatus s) {
    switch (s) {
      case DonationCenterStatus.available:
        return 'Available';
      case DonationCenterStatus.busy:
        return 'Busy';
      case DonationCenterStatus.closed:
        return 'Closed';
    }
  }

  static const List<DonationCenterModel> mockList = [
    DonationCenterModel(
      id: '1',
      name: 'City Central Blood Bank',
      distanceKm: 1.2,
      openUntil: 'Open until 8:00 PM',
      status: DonationCenterStatus.available,
    ),
    DonationCenterModel(
      id: '2',
      name: 'Red Cross Medical Center',
      distanceKm: 3.5,
      openUntil: 'Open until 6:00 PM',
      status: DonationCenterStatus.busy,
    ),
    DonationCenterModel(
      id: '3',
      name: 'National Blood Center',
      distanceKm: 5.1,
      openUntil: 'Open until 9:00 PM',
      status: DonationCenterStatus.available,
    ),
  ];
}

class DonateDonorInfoModel {
  const DonateDonorInfoModel({
    required this.userName,
    required this.bloodGroup,
    required this.totalDonations,
    required this.nextEligible,
  });

  final String userName;
  final String bloodGroup;
  final int totalDonations;
  final String nextEligible;

  static const DonateDonorInfoModel mock = DonateDonorInfoModel(
    userName: 'Jibon Daian',
    bloodGroup: 'O+',
    totalDonations: 8,
    nextEligible: 'Tomorrow',
  );
}
