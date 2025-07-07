class Chronic {
  final String id;
  final String diseaseName;
  final DateTime? date;

  Chronic({required this.id, required this.diseaseName, this.date});

  factory Chronic.fromJson(Map<String, dynamic> json) {
    return Chronic(
      id: json['_id'] ?? '',
      diseaseName: json['diseaseName'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'diseaseName': diseaseName,
      'date': date?.toIso8601String(),
    };
  }
  Chronic copyWith({String? id, String? diseaseName, DateTime? date}) {
    return Chronic(
      id: id ?? this.id,
      diseaseName: diseaseName ?? this.diseaseName,
      date: date ?? this.date,
    );
  }
}
