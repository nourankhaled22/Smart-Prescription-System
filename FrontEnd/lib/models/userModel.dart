class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? nationalId;
  final String dateOfBirth;
  final String? role;
  final String? token;
  final String? status;
  final String? licenceUrl;
  final String? clinicAddress;
  final String? specialization;
  final String? address;
  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.nationalId,
    required this.dateOfBirth,
    required this.role,
    required this.token,
    required this.status,
    this.licenceUrl,
    this.clinicAddress,
    this.specialization,
    this.address,
  });
  // Convert from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      nationalId: json['nationalId'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      role: json['role'] ?? 'patient',
      token: json['token'] ?? '',
      status: json['status'] ?? 'active',
      licenceUrl: json['licenceUrl'],
      clinicAddress: json['clinicAddress'],
      specialization: json['specialization'],
      address: json['address'] ?? '',
    );
  }
  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'nationalId': nationalId,
      'dateOfBirth': dateOfBirth,
      'role': role,
      'token': token,
      'status': status,
      'licenceUrl': licenceUrl,
      'clinicAddress': clinicAddress,
      'specialization': specialization,
      'address': address,
    };
  }
}
