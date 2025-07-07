class HistorySummary {
  final String? healthSummary;
  final List<String>? tipsAndGuides;
  final List<String>? currentMedicines; // <-- updated type
  final String? generalAdvicesAboutMedicines;
  final String? manageBloodPressure;
  final Map<String, String>? informationAboutEachVaccine;
  final Map<String, String>? informationAboutEachAllergy;

  HistorySummary({
    this.healthSummary,
    this.tipsAndGuides,
    this.currentMedicines,
    this.generalAdvicesAboutMedicines,
    this.manageBloodPressure,
    this.informationAboutEachVaccine,
    this.informationAboutEachAllergy,
  });

  factory HistorySummary.fromJson(Map<String, dynamic> json) {
    return HistorySummary(
      healthSummary: json['health_summary'] as String?,
      tipsAndGuides:
          (json['tips_and_guides'] as List?)?.map((e) => e.toString()).toList(),
      currentMedicines:
          json['current_medicines'] is List
              ? (json['current_medicines'] as List)
                  .map((e) => e.toString())
                  .toList()
              : json['current_medicines'] != null
              ? [json['current_medicines'].toString()]
              : null,
      generalAdvicesAboutMedicines:
          json['general_advices_about_medicines'] as String?,
      manageBloodPressure: json['manage_blood_pressure'] as String?,
      informationAboutEachVaccine: (json['information_about_each_vaccine']
              as Map?)
          ?.map((k, v) => MapEntry(k.toString(), v.toString())),
      informationAboutEachAllergy: (json['information_about_each_allergy']
              as Map?)
          ?.map((k, v) => MapEntry(k.toString(), v.toString())),
    );
  }
}
