import '/models/medication.dart';

class Prescription {
  final String id;
  final String? doctorName;
  final String? clinicAddress;
  final DateTime date;
  final String? phoneNumber;
  final String? specialization;
  final List<Medication>? medicines;
  final List<String>? examinations;
  final List<String>? diagnoses;
  final String? notes;
  final String? pdfUrl;
  final String? imageUrl;

  Prescription({
    required this.id,
    this.doctorName,
    this.clinicAddress,
    required this.date,
    this.phoneNumber,
    this.specialization,
    this.medicines,
    this.examinations,
    this.diagnoses,
    this.notes,
    this.pdfUrl,
    this.imageUrl,
  });
  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['_id'],
      doctorName: json['doctorName'],
      clinicAddress: json['clinicAddress'],
      date: DateTime.parse(json['date']),
      phoneNumber: json['phoneNumber'],
      specialization: json['specialization'],
      medicines:
          (json['medicines'] as List?)?.map((e) => Medication.fromJson(e as Map<String, dynamic>)).toList(),
      examinations:
          (json['examinations'] as List?)?.map((e) => e.toString()).toList(),
      diagnoses:
          (json['diagnoses'] as List?)?.map((e) => e.toString()).toList(),
      notes: json['notes'],
      pdfUrl: json['pdfUrl'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'doctorName': doctorName,
      'clinicAddress': clinicAddress,
      'date': date.toIso8601String(),
      'phoneNumber': phoneNumber,
      'specialization': specialization,
      'medicines': medicines,
      'examinations': examinations,
      'diagnoses': diagnoses,
      'notes': notes,
      'pdfUrl': pdfUrl,
      'imageUrl': imageUrl,
    };
  }
}
