/// BloodRequestModel - Data model for a blood request
class BloodRequestModel {
  const BloodRequestModel({
    required this.patientName,
    required this.bloodGroup,
    required this.hospitalName,
    required this.location,
    required this.neededDate,
    required this.contactNumber,
    this.additionalRequirements = '',
  });

  final String patientName;
  final String bloodGroup;
  final String hospitalName;
  final String location;
  final String neededDate;
  final String contactNumber;
  final String additionalRequirements;

  Map<String, dynamic> toMap() {
    return {
      'patientName': patientName,
      'bloodGroup': bloodGroup,
      'hospitalName': hospitalName,
      'location': location,
      'neededDate': neededDate,
      'contactNumber': contactNumber,
      'additionalRequirements': additionalRequirements,
    };
  }
}
