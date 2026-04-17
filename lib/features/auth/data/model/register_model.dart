class RegisterRequest {
  final String name;
  final String contactNumber;
  final String email;
  final String password;
  final String type;
  final int divisionId;
  final int districtId;
  final int areaId;
  final RegisterProps props;

  RegisterRequest({
    required this.name,
    required this.contactNumber,
    required this.email,
    required this.password,
    this.type = "user",
    required this.divisionId,
    required this.districtId,
    required this.areaId,
    required this.props,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "contactNumber": contactNumber,
    "email": email,
    "password": password,
    "type": type,
    "divisionId": divisionId,
    "districtId": districtId,
    "areaId": areaId,
    "props": props.toJson(),
  };
}

class RegisterProps {
  final String address;
  final String photo;
  final String birthDate;
  final String gender;
  final String bloodGroup;
  final Geolocation geolocation;

  RegisterProps({
    required this.address,
    required this.photo,
    required this.birthDate,
    required this.gender,
    required this.bloodGroup,
    required this.geolocation,
  });

  Map<String, dynamic> toJson() => {
    "address": address,
    "photo": photo,
    "birthDate": birthDate,
    "gender": gender,
    "bloodGroup": bloodGroup,
    "geolocation": geolocation.toJson(),
  };
}

class Geolocation {
  final double latitude;
  final double longitude;

  Geolocation({required this.latitude, required this.longitude});

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}
