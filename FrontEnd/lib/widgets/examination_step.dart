import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add for localization
import '../../../theme/app_theme.dart';
import 'examination_dialog.dart';

class ExaminationsStepFixed extends StatelessWidget {
  final List<Map<String, dynamic>> examinations;
  final Function(List<Map<String, dynamic>>) onExaminationsChanged;

  const ExaminationsStepFixed({
    super.key,
    required this.examinations,
    required this.onExaminationsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.assignment,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.examinations, // Localized
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      loc.recordPhysicalFindings, // Localized
                      style: AppTheme.subheadingStyle.copyWith(
                        color: AppTheme.textGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Add Examination Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _addExamination(context),
              icon: const Icon(Icons.add, size: 18, color: Colors.white),
              label: Text(loc.addExamination), // Localized
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Examinations List
          if (examinations.isEmpty)
            _buildEmptyExaminationsState(context)
          else
            Column(
              children:
                  examinations.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> exam = entry.value;
                    return _buildExaminationCard(exam, index, context, loc);
                  }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyExaminationsState(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 48,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(height: 12),
          Text(
            loc.noExaminationsRecorded, // Localized
            style: AppTheme.headingStyle.copyWith(
              color: AppTheme.primaryColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            loc.addPhysicalFindings, // Localized
            style: AppTheme.subheadingStyle.copyWith(
              fontSize: 12,
              color: AppTheme.primaryColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExaminationCard(
    Map<String, dynamic> examination,
    int index,
    BuildContext context,
    AppLocalizations loc,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  examination['examinationName'],
                  style: AppTheme.headingStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _removeExamination(index),
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  minimumSize: const Size(32, 32),
                  padding: const EdgeInsets.all(6),
                ),
                tooltip: loc.delete, // Localized
              ),
            ],
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  void _addExamination(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => ExaminationDialogFixed(
            onAdd: (examination) {
              final updatedExaminations = List<Map<String, dynamic>>.from(
                examinations,
              );
              updatedExaminations.add(examination);
              onExaminationsChanged(updatedExaminations);
            },
          ),
    );
  }

  void _removeExamination(int index) {
    final updatedExaminations = List<Map<String, dynamic>>.from(examinations);
    updatedExaminations.removeAt(index);
    onExaminationsChanged(updatedExaminations);
  }
}
