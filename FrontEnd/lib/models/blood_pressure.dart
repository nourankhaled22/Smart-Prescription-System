class BloodPressure {
  final String id;
  final int pulse;
  final int diastolic;
  final int systolic;
  final DateTime date;
  final String? notes;

  BloodPressure({
    required this.id,
    required this.pulse,
    required this.diastolic,
    required this.systolic,
    required this.date,
    this.notes,
  });

  factory BloodPressure.fromJson(Map<String, dynamic> json) {
    return BloodPressure(
      id: json['_id'],
      pulse: json['pulse'],
      diastolic: json['diastolic'],
      systolic: json['systolic'],
      date: DateTime.parse(
        json['date'] ?? DateTime.now().toIso8601String(),
      ), 
      notes: json['notes'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'pulse': pulse,
      'diastolic': diastolic,
      'systolic': systolic,
      'date': date.toIso8601String(), 
      'notes': notes,
    };
  }
}
