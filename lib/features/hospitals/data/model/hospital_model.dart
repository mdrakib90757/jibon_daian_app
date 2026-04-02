enum HospitalStatus { open24h, closingSoon, closed }

class HospitalModel {
  const HospitalModel({
    required this.id,
    required this.name,
    required this.location,
    required this.distanceKm,
    required this.status,
    required this.statusLabel,
    this.imageUrl,
    this.phone,
    this.hasUrgentNeed = false,
    this.urgentBloodGroup,
  });

  final String id;
  final String name;
  final String location;
  final double distanceKm;
  final HospitalStatus status;
  final String statusLabel;
  final String? imageUrl;
  final String? phone;
  final bool hasUrgentNeed;
  final String? urgentBloodGroup;

  static const List<HospitalModel> mockList = [
    HospitalModel(
      id: '1',
      name: 'City General Hospital',
      location: 'Dhaka, Bangladesh',
      distanceKm: 1.5,
      status: HospitalStatus.open24h,
      statusLabel: 'Open 24/7',
      phone: '+8801711000001',
      hasUrgentNeed: true,
      urgentBloodGroup: 'O+',
    ),
    HospitalModel(
      id: '2',
      name: 'Evercare Hospital',
      location: 'Bashundhara, Dhaka',
      distanceKm: 3.2,
      status: HospitalStatus.open24h,
      statusLabel: 'Open 24/7',
      phone: '+8801711000002',
      hasUrgentNeed: false,
    ),
    HospitalModel(
      id: '3',
      name: 'Apollo Medical Center',
      location: 'Gulshan, Dhaka',
      distanceKm: 4.8,
      status: HospitalStatus.closingSoon,
      statusLabel: 'Closes 10 PM',
      phone: '+8801711000003',
      hasUrgentNeed: false,
    ),
    HospitalModel(
      id: '4',
      name: 'Square Hospital',
      location: 'Panthapath, Dhaka',
      distanceKm: 6.1,
      status: HospitalStatus.open24h,
      statusLabel: 'Open 24/7',
      phone: '+8801711000004',
      hasUrgentNeed: false,
    ),
  ];
}
