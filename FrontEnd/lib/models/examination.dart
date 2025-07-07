class Examination {
  final String id;
  final String examinationName;
  final DateTime date;
  final String? pdfUrl;
  final String? notes;

  Examination({
    required this.id,
    required this.examinationName,
    required this.date,
    this.pdfUrl,
    this.notes,
  });

  Examination copyWith({
    String? id,
    String? examinationName,
    DateTime? date,
    String? pdfUrl,
    String? notes,
  }) {
    return Examination(
      id: id ?? this.id,
      examinationName: examinationName ?? this.examinationName,
      date: date ?? this.date,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      notes: notes ?? this.notes,
    );
  }

  factory Examination.fromJson(Map<String, dynamic> json) {
    return Examination(
      id: json['_id'] ?? '',
      examinationName: json['examinationName'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      pdfUrl: json['pdfUrl'],
      notes: json['notes'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'examinationName': examinationName,
      'date': date.toIso8601String(),
      'pdfUrl': pdfUrl,
      'notes': notes,
    };
  }
}
