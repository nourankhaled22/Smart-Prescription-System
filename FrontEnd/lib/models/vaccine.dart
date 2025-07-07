class Vaccine {
  final String id;
  final String vaccineName;
  final DateTime? date;

  Vaccine({required this.id, required this.vaccineName, this.date});
  factory Vaccine.fromJson(Map<String, dynamic> json) {
    return Vaccine(
      id: json['_id'] ?? '',
      vaccineName: json['vaccineName'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'vaccineName': vaccineName,
      'date': date?.toIso8601String(),
    };
  }
  Vaccine copyWith({String? id, String? vaccineName, DateTime? date}) {
    return Vaccine(
      id: id ?? this.id,
      vaccineName: vaccineName ?? this.vaccineName,
      date: date ?? this.date,
    );
  }
}
