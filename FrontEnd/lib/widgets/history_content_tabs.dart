import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/models/chronic.dart';
import '/services/examination_service.dart';
import '/widgets/blood_pressure_history_card.dart';
import 'package:open_file/open_file.dart';

import '../../theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../services/history_service.dart';
import '../models/blood_pressure.dart';
import '../models/allergy.dart';
import '../models/vaccine.dart';
import '../models/examination.dart';
import '../models/medication.dart';
import 'medical_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // <-- Add for localization

class HistoryContentTabs extends StatefulWidget {
  final int selectedTab;
  final String searchQuery;
  final DateTime? selectedDate;
  final String? bloodPressureFilter;
  final bool? medicationActiveFilter;

  const HistoryContentTabs({
    super.key,
    required this.selectedTab,
    required this.searchQuery,
    required this.selectedDate,
    required this.bloodPressureFilter,
    required this.medicationActiveFilter,
  });

  @override
  State<HistoryContentTabs> createState() => _HistoryContentTabsState();
}

class _HistoryContentTabsState extends State<HistoryContentTabs> {
  Map<String, dynamic>? history;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPatientHistory();
  }

  Future<void> fetchPatientHistory() async {
    String? token = Provider.of<AuthProvider>(context, listen: false).token;
    String? sessionToken =
        Provider.of<AuthProvider>(context, listen: false).sessionToken;

    if (token != null && sessionToken != null) {
      try {
        final fetchedHistory = await HistoryService().getHistory(
          token,
          sessionToken,
        );
        setState(() {
          history = fetchedHistory;
          isLoading = false;
        });
        print('Fetched history: $history');
      } catch (e) {
        print('Error fetching history: $e');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    switch (widget.selectedTab) {
      case 0:
        return _buildChronicDiseasesTab(loc);
      case 1:
        return _buildAllergiesTab(loc);
      case 2:
        return _buildVaccinesTab(loc);
      case 3:
        return _buildBloodPressureTab(loc);
      case 4:
        return _buildExaminationsTab(loc);
      case 5:
        return _buildMedicationsTab(loc);
      default:
        return const SizedBox();
    }
  }

  Widget _buildChronicDiseasesTab(AppLocalizations loc) {
    final diseases = _getFilteredChronicDiseases();

    if (diseases.isEmpty) {
      return _buildEmptyState(
        loc.noChronicDiseasesFound, // Localized
        Icons.medical_services,
        loc,
      );
    }

    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(
        scrollbars: false,
        overscroll: false,
        physics: const BouncingScrollPhysics(),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: diseases.length,
        itemBuilder: (context, index) {
          final disease = diseases[index];
          return MedicalCard(
            title: disease.diseaseName,
            icon: Icons.medical_services,
            color: const Color(0xFF2563EB), // Professional blue
            date: disease.date,
          );
        },
      ),
    );
  }

  Widget _buildAllergiesTab(AppLocalizations loc) {
    final allergies = _getFilteredAllergies();

    if (allergies.isEmpty) {
      return _buildEmptyState(
        loc.noAllergiesFound, // Localized
        Icons.warning_amber_rounded,
        loc,
      );
    }

    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(
        scrollbars: false,
        overscroll: false,
        physics: const BouncingScrollPhysics(),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: allergies.length,
        itemBuilder: (context, index) {
          final allergy = allergies[index];
          return MedicalCard(
            title: allergy.allergyName,
            icon: Icons.warning_amber_rounded,
            color: const Color(0xFFDC2626), // Professional red
            date: allergy.date,
          );
        },
      ),
    );
  }

  Widget _buildVaccinesTab(AppLocalizations loc) {
    final vaccines = _getFilteredVaccines();

    if (vaccines.isEmpty) {
      return _buildEmptyState(loc.noVaccinesFound, Icons.vaccines, loc);
    }

    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(
        scrollbars: false,
        overscroll: false,
        physics: const BouncingScrollPhysics(),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: vaccines.length,
        itemBuilder: (context, index) {
          final vaccine = vaccines[index];
          return MedicalCard(
            title: vaccine.vaccineName,
            icon: Icons.vaccines,
            color: const Color(0xFF059669), // Professional green
            date: vaccine.date,
          );
        },
      ),
    );
  }

  Widget _buildBloodPressureTab(AppLocalizations loc) {
    final readings = _getFilteredBloodPressure();

    if (readings.isEmpty) {
      return _buildEmptyState(
        loc.noBloodPressureReadingsFound, // Localized
        Icons.favorite,
        loc,
      );
    }

    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(
        scrollbars: false,
        overscroll: false,
        physics: const BouncingScrollPhysics(),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: readings.length,
        itemBuilder: (context, index) {
          return BloodPressureCard(reading: readings[index]);
        },
      ),
    );
  }

  Widget _buildExaminationsTab(AppLocalizations loc) {
    final examinations = _getFilteredExaminations();

    if (examinations.isEmpty) {
      return _buildEmptyState(loc.noExaminationsFound, Icons.assignment, loc);
    }

    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(
        scrollbars: false,
        overscroll: false,
        physics: const BouncingScrollPhysics(),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: examinations.length,
        itemBuilder: (context, index) {
          final examination = examinations[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.assignment,
                    color: AppTheme.primaryColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        examination.examinationName,
                        style: AppTheme.subheadingStyle.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.lightBlue.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _formatDate(examination.date),
                          style: AppTheme.subheadingStyle.copyWith(
                            fontSize: 11,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _downloadPdf(examination.id, loc),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.download,
                      color: AppTheme.accentColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMedicationsTab(AppLocalizations loc) {
    final medications = _getFilteredMedications();

    if (medications.isEmpty) {
      return _buildEmptyState(loc.noMedicationsFound, Icons.medication, loc);
    }

    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(
        scrollbars: false,
        overscroll: false,
        physics: const BouncingScrollPhysics(),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: medications.length,
        itemBuilder: (context, index) {
          final medication = medications[index];
          final statusColor =
              medication.isActive! ? AppTheme.accentColor : AppTheme.textGrey;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: statusColor.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.medication, color: statusColor, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medication.medicineName,
                        style: AppTheme.subheadingStyle.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          medication.isActive! ? loc.active : loc.inactive, // Localized
                          style: AppTheme.subheadingStyle.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon, AppLocalizations loc) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.lightBlue.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 64,
              color: AppTheme.primaryColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            loc.noDataAvailable, // Localized
            style: AppTheme.headingStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTheme.subheadingStyle.copyWith(
              fontSize: 14,
              color: AppTheme.textGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Helper methods for filtering
  List<Chronic> _getFilteredChronicDiseases() {
    if (history == null || history!['chronicDiseases'] == null) return [];
    return (history!['chronicDiseases'] as List)
        .map((item) => Chronic.fromJson(item))
        .where((disease) {
          if (widget.searchQuery.isNotEmpty) {
            return disease.diseaseName.toLowerCase().contains(
              widget.searchQuery.toLowerCase(),
            );
          }
          return true;
        })
        .toList();
  }

  List<Allergy> _getFilteredAllergies() {
    if (history == null || history!['allergies'] == null) return [];
    return (history!['allergies'] as List)
        .map((item) => Allergy.fromJson(item))
        .where((allergy) {
          if (widget.searchQuery.isNotEmpty) {
            return allergy.allergyName.toLowerCase().contains(
              widget.searchQuery.toLowerCase(),
            );
          }
          return true;
        })
        .toList();
  }

  List<Vaccine> _getFilteredVaccines() {
    if (history == null || history!['vaccines'] == null) return [];
    return (history!['vaccines'] as List)
        .map((item) => Vaccine.fromJson(item))
        .where((vaccine) {
          if (widget.searchQuery.isNotEmpty) {
            return vaccine.vaccineName.toLowerCase().contains(
              widget.searchQuery.toLowerCase(),
            );
          }
          return true;
        })
        .toList();
  }

  List<BloodPressure> _getFilteredBloodPressure() {
    if (history == null || history!['bloodPressures'] == null) return [];
    return (history!['bloodPressures'] as List)
        .map((item) => BloodPressure.fromJson(item))
        .where((reading) {
          // Date filter
          if (widget.selectedDate != null) {
            final selectedDay = DateTime(
              widget.selectedDate!.year,
              widget.selectedDate!.month,
              widget.selectedDate!.day,
            );
            final readingDay = DateTime(
              reading.date.year,
              reading.date.month,
              reading.date.day,
            );

            if (selectedDay != readingDay) {
              // Check if it's a range filter (last 7 days, last 30 days)
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);

              if (selectedDay == today.subtract(const Duration(days: 7))) {
                if (reading.date.isBefore(selectedDay)) return false;
              } else if (selectedDay ==
                  today.subtract(const Duration(days: 30))) {
                if (reading.date.isBefore(selectedDay)) return false;
              } else {
                return false;
              }
            }
          }

          // Blood pressure status filter
          if (widget.bloodPressureFilter != null) {
            final indicator = _getBloodPressureIndicator(
              reading.systolic,
              reading.diastolic,
            );
            if (indicator['status'] != widget.bloodPressureFilter) {
              return false;
            }
          }

          return true;
        })
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<Examination> _getFilteredExaminations() {
    if (history == null || history!['examinations'] == null) return [];
    return (history!['examinations'] as List)
        .map((item) => Examination.fromJson(item))
        .where((examination) {
          // Search filter
          if (widget.searchQuery.isNotEmpty) {
            if (!examination.examinationName.toLowerCase().contains(
              widget.searchQuery.toLowerCase(),
            )) {
              return false;
            }
          }

          // Date filter
          if (widget.selectedDate != null) {
            final selectedDay = DateTime(
              widget.selectedDate!.year,
              widget.selectedDate!.month,
              widget.selectedDate!.day,
            );
            final examDay = DateTime(
              examination.date.year,
              examination.date.month,
              examination.date.day,
            );

            if (selectedDay != examDay) {
              // Check if it's a range filter
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);

              if (selectedDay == today.subtract(const Duration(days: 7))) {
                if (examination.date.isBefore(selectedDay)) return false;
              } else if (selectedDay ==
                  today.subtract(const Duration(days: 30))) {
                if (examination.date.isBefore(selectedDay)) return false;
              } else {
                return false;
              }
            }
          }

          return true;
        })
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<Medication> _getFilteredMedications() {
    if (history == null || history!['medicines'] == null) return [];
    return (history!['medicines'] as List)
        .map((item) => Medication.fromJson(item))
        .where((medication) {
          // Search filter
          if (widget.searchQuery.isNotEmpty) {
            if (!medication.medicineName.toLowerCase().contains(
              widget.searchQuery.toLowerCase(),
            )) {
              return false;
            }
          }

          // Status filter
          if (widget.medicationActiveFilter != null) {
            if (medication.isActive != widget.medicationActiveFilter) {
              return false;
            }
          }

          return true;
        })
        .toList();
  }

  Map<String, dynamic> _getBloodPressureIndicator(int systolic, int diastolic) {
    if (systolic >= 140 || diastolic >= 90) {
      return {'status': 'high', 'color': AppTheme.errorColor};
    } else if (systolic < 90 || diastolic < 60) {
      return {'status': 'low', 'color': Colors.blue.shade600};
    } else {
      return {'status': 'normal', 'color': AppTheme.accentColor};
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _downloadPdf(examinationId, AppLocalizations loc) async {
    HapticFeedback.lightImpact();

    String? token = Provider.of<AuthProvider>(context, listen: false).token;
    String fileName = 'examination_$examinationId.pdf';

    try {
      // Download the PDF
      final filePath = await ExaminationService().downloadExaminationPdf(
        token: token!,
        examinationId: examinationId,
        fileName: fileName,
        sessionToken:
            Provider.of<AuthProvider>(context, listen: false).sessionToken!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.pdfDownloaded), // Localized
          backgroundColor: Colors.green,
        ),
      );
      if (filePath != null) {
        await OpenFile.open(filePath);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.failedToDownloadPdf(e.toString())), // Localized
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
