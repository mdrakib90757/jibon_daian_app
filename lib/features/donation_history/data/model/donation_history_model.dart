enum DonationStatus { completed, pending, cancelled }

class DonationHistoryModel {
  const DonationHistoryModel({
    required this.id,
    required this.hospitalName,
    required this.date,
    required this.bags,
    required this.status,
    this.bloodGroup = 'B+',
  });

  final String id;
  final String hospitalName;
  final String date;
  final int bags;
  final DonationStatus status;
  final String bloodGroup;

  static String statusLabel(DonationStatus s) {
    switch (s) {
      case DonationStatus.completed:
        return 'COMPLETED';
      case DonationStatus.pending:
        return 'PENDING';
      case DonationStatus.cancelled:
        return 'CANCELLED';
    }
  }

  // ── Mock data ──────────────────────────────────────────────────
  static const List<DonationHistoryModel> mockList = [
    DonationHistoryModel(
      id: '1',
      hospitalName: 'City General Hospital',
      date: 'Oct 12, 2023',
      bags: 1,
      status: DonationStatus.completed,
    ),
    DonationHistoryModel(
      id: '2',
      hospitalName: 'Red Cross Center',
      date: 'Jul 05, 2023',
      bags: 1,
      status: DonationStatus.completed,
    ),
    DonationHistoryModel(
      id: '3',
      hospitalName: "St. Mary's Clinic",
      date: 'Mar 22, 2023',
      bags: 1,
      status: DonationStatus.completed,
    ),
    DonationHistoryModel(
      id: '4',
      hospitalName: 'District Health Post',
      date: 'Nov 15, 2022',
      bags: 1,
      status: DonationStatus.completed,
    ),
    DonationHistoryModel(
      id: '5',
      hospitalName: 'City General Hospital',
      date: 'Aug 10, 2022',
      bags: 1,
      status: DonationStatus.completed,
    ),
  ];
}
