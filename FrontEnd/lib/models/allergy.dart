class Allergy {
  final String id;
  final String allergyName;
  final DateTime? date;
  final bool isActive;

  Allergy({
    required this.id,
    required this.allergyName,
    this.date,
    this.isActive = true,
  });
   
  // Convert from JSON
  factory Allergy.fromJson(Map<String, dynamic> json) {
    return Allergy(
      id: json['_id'] ?? '',
      allergyName: json['allergyName'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      isActive: json['isActive'] ?? true,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'allergyName': allergyName,
      'date': date?.toIso8601String(),
      'isActive': isActive,
    };
  }
  Allergy copyWith({
    String? id,
    String? allergyName,
    DateTime? date,
    bool? isActive,
  }) {
    return Allergy(
      id: id ?? this.id,
      allergyName: allergyName ?? this.allergyName,
      date: date ?? this.date,
      isActive: isActive ?? this.isActive,
    );
  }
}
