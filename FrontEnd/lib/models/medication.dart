class Medication {
  final String? id;
  final String medicineName;
  final int? frequency;
  final String? dosage;
  final int? duration;
  final bool? afterMeal;
  final bool? isActive;
  final String? nextDoseTime;
  final List<String>? scheduledTimes;
  final DateTime? startDate;
  final String? startTime;
  final int? hoursPerDay;
  final String? type;
  final String? description;
  final List<String>? sideEffects;
  final List<String>? alternatives;

  Medication({
    this.id,
    required this.medicineName,
    this.frequency,
    this.dosage,
    this.duration,
    this.afterMeal = true,
    this.isActive = true,
    this.nextDoseTime,
    this.scheduledTimes,
    this.startDate,
    this.startTime,
    this.hoursPerDay,
    this.type,
    this.description,
    this.sideEffects,
    this.alternatives,
  });

  Medication copyWith({
    String? id,
    String? medicineName,
    int? frequency,
    String? dosage,
    int? duration,
    bool? afterMeal,
    bool? isActive, 
    String? nextDoseTime,
    List<String>? scheduledTimes,
    DateTime? startDate,
    String? startTime,
    int? hoursPerDay,
    String? type,
    String? description,
    List<String>? sideEffects,
    List<String>? alternatives,
  }) {
    return Medication(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      frequency: frequency ?? this.frequency,
      dosage: dosage ?? this.dosage,
      duration: duration ?? this.duration,
      afterMeal: afterMeal ?? this.afterMeal,
      isActive: isActive ?? this.isActive,
      nextDoseTime: nextDoseTime ?? this.nextDoseTime,
      scheduledTimes: scheduledTimes ?? this.scheduledTimes,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      hoursPerDay: hoursPerDay ?? this.hoursPerDay,
      type: type ?? this.type,
      description: description ?? this.description,
      sideEffects: sideEffects ?? this.sideEffects,
      alternatives: alternatives ?? this.alternatives,
    );
  }

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['_id'],
      medicineName: json['medicineName'],
      frequency: json['frequency'] ?? 1,
      dosage: json['dosage'] ?? "0",
      duration: json['duration'] ?? 1,
      afterMeal: json['afterMeal'] ?? true,
      isActive: json['isActive'] ?? true,
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      startTime: json['startTime'],
      hoursPerDay: json['hoursPerDay'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'medicineName': medicineName,
      'frequency': frequency,
      'dosage': dosage,
      'duration': duration,
      'afterMeal': afterMeal,
      'isActive': isActive,
      'nextDoseTime': nextDoseTime,
      'scheduledTimes': scheduledTimes,
      'startDate': startDate?.toIso8601String(),
      'startTime': startTime,
      'hoursPerDay': hoursPerDay,
      'type': type,
      'description': description,
      'sideEffects': sideEffects,
      'alternatives': alternatives,
    };
  }
}
