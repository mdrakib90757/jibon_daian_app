/// DonorModel - Data model for a blood donor
class DonorModel {
  const DonorModel({
    required this.id,
    required this.name,
    required this.bloodGroup,
    required this.location,
    required this.area,
    required this.city,
    required this.isAvailable,
    required this.lastDonated,
    this.avatarUrl,
    this.phone,
  });

  final String id;
  final String name;
  final String bloodGroup;
  final String location;
  final String area;
  final String city;
  final bool isAvailable;
  final String
  lastDonated; // e.g. "Available Now" or "Last donated 3 months ago"
  final String? avatarUrl;
  final String? phone;

  // ── Mock data ─────────────────────────────────────────────────
  static const List<DonorModel> mockDonors = [
    DonorModel(
      id: '1',
      name: 'Rahat Karim',
      bloodGroup: 'B+',
      location: 'Dhanmondi, Dhaka',
      area: 'Dhanmondi',
      city: 'Dhaka',
      isAvailable: true,
      lastDonated: 'Available Now',
      phone: '+8801711000001',
    ),
    DonorModel(
      id: '2',
      name: 'Nusrat Jahan',
      bloodGroup: 'B+',
      location: 'Gulshan-2, Dhaka',
      area: 'Gulshan',
      city: 'Dhaka',
      isAvailable: false,
      lastDonated: 'Last donated 3 months ago',
      phone: '+8801711000002',
    ),
    DonorModel(
      id: '3',
      name: 'Asif Zaman',
      bloodGroup: 'B+',
      location: 'Mirpur 10, Dhaka',
      area: 'Mirpur',
      city: 'Dhaka',
      isAvailable: true,
      lastDonated: 'Available Now',
      phone: '+8801711000003',
    ),
    DonorModel(
      id: '4',
      name: 'Sadia Islam',
      bloodGroup: 'A+',
      location: 'Uttara, Dhaka',
      area: 'Uttara',
      city: 'Dhaka',
      isAvailable: true,
      lastDonated: 'Available Now',
      phone: '+8801711000004',
    ),
    DonorModel(
      id: '5',
      name: 'Tariq Hossain',
      bloodGroup: 'O+',
      location: 'Banani, Dhaka',
      area: 'Banani',
      city: 'Dhaka',
      isAvailable: false,
      lastDonated: 'Last donated 2 months ago',
      phone: '+8801711000005',
    ),
    DonorModel(
      id: '6',
      name: 'Farhan Ahmed',
      bloodGroup: 'AB+',
      location: 'Motijheel, Dhaka',
      area: 'Motijheel',
      city: 'Dhaka',
      isAvailable: true,
      lastDonated: 'Available Now',
      phone: '+8801711000006',
    ),
  ];
}
