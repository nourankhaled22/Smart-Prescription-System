import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import 'medication_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add for localization

class MedicineStepFixed extends StatelessWidget {
  final List<Map<String, dynamic>> medications;
  final Function(List<Map<String, dynamic>>) onMedicationsChanged;

  const MedicineStepFixed({
    super.key,
    required this.medications,
    required this.onMedicationsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
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
                  Icons.medication,
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
                      loc.medications, // Localized
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      loc.addPrescribedMedications, // Localized
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

          // Add Medicine Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _addMedication(context),
              icon: const Icon(Icons.add, size: 18, color: Colors.white),
              label: Text(loc.addMedicine), // Localized
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

          // Medications List
          if (medications.isEmpty)
            _buildEmptyState(loc)
          else
            Column(
              children: medications.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> med = entry.value;
                return _buildMedicationCard(med, index, context, loc);
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations loc) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor),
      ),
      child: Column(
        children: [
          Icon(
            Icons.medication_outlined,
            size: 48,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(height: 12),
          Text(
            loc.noMedicationsAddedYet, // Localized
            style: AppTheme.headingStyle.copyWith(
              color: AppTheme.primaryColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            loc.tapAddMedicineToStart, // Localized
            style: AppTheme.subheadingStyle.copyWith(
              fontSize: 12,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationCard(
    Map<String, dynamic> medication,
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
          // Header Row
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication['medicineName'] ?? '',
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${medication['dosage']} • ${medication['frequency']} ${loc.timesDaily}', // Localized
                      style: AppTheme.subheadingStyle.copyWith(
                        fontSize: 12,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _removeMedication(index),
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

          const SizedBox(height: 12),

          // Details Row
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildDetailItem(
                  loc.dosage, // Localized
                  medication['dosage'] ?? '',
                  Icons.local_pharmacy,
                  Colors.green,
                  loc,
                ),
                const SizedBox(width: 16),
                _buildDetailItem(
                  loc.timesPerDay, // Localized
                  '${medication['frequency']} ${loc.timesDaily}', // Localized
                  Icons.schedule,
                  Colors.orange,
                  loc,
                ),
                const SizedBox(width: 16),
                _buildDetailItem(
                  loc.timing, // Localized
                  medication['beforeMeal'] == true ? loc.beforeMeal : loc.afterMeal, // Localized
                  Icons.restaurant,
                  Colors.purple,
                  loc,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    String label,
    String value,
    IconData icon,
    Color color,
    AppLocalizations loc,
  ) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.subheadingStyle.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppTheme.textGrey,
            ),
          ),
          Text(
            value,
            style: AppTheme.subheadingStyle.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _addMedication(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => MedicationDialogFixed(
        onAdd: (medication) {
          final updatedMedications = List<Map<String, dynamic>>.from(
            medications,
          );
          updatedMedications.add(medication);
          onMedicationsChanged(updatedMedications);
        },
      ),
    );
  }

  void _removeMedication(int index) {
    final updatedMedications = List<Map<String, dynamic>>.from(medications);
    updatedMedications.removeAt(index);
    onMedicationsChanged(updatedMedications);
  }
}
