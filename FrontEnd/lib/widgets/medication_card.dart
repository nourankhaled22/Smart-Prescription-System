import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add for localization

import '../models/medication.dart';
import '../../theme/app_theme.dart';

class MedicationCard extends StatelessWidget {
  final Medication medication;
  final VoidCallback? onTap;
  final VoidCallback? onSchedule;
  final VoidCallback? onInfo;
  final VoidCallback? onDelete;
  final Function(bool)? onActiveChanged;

  const MedicationCard({
    super.key,
    required this.medication,
    this.onTap,
    this.onSchedule,
    this.onInfo,
    this.onDelete,
    this.onActiveChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                medication.isActive!
                    ? Colors.green.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // Medication Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getMedicationIcon(),
                    color: AppTheme.primaryColor,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 16),

                // Medication Name and Dosage
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medication.medicineName,
                        style: AppTheme.subheadingStyle.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${medication.dosage} ${loc.tablet}', // Localized
                        style: AppTheme.subheadingStyle.copyWith(
                          fontSize: 14,
                          color: AppTheme.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Action Buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: onSchedule,
                      icon: Icon(
                        Icons.schedule,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                      tooltip: loc.timing, // Localized
                    ),
                    IconButton(
                      onPressed: onInfo,
                      icon: Icon(
                        Icons.info_outline,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                      tooltip: loc.medicineNameRequired, // Localized
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Medication Details
            Row(
              children: [
                _buildDetailChip(
                  icon: Icons.repeat,
                  label:
                      '${medication.frequency} ${loc.timesDaily}', // Localized
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                _buildDetailChip(
                  icon: Icons.timer,
                  label: '${medication.duration} ${loc.days}', // Localized
                  color: Colors.orange,
                ),
                const SizedBox(width: 8),
                _buildDetailChip(
                  icon:
                      medication.afterMeal! ? Icons.restaurant : Icons.no_meals,
                  label:
                      medication.afterMeal!
                          ? loc.afterMeal
                          : loc.beforeMeal, // Localized
                  color: medication.afterMeal! ? Colors.green : Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Status and Action Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Next dose time
                if (medication.nextDoseTime != null)
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppTheme.textGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        loc.next(
                          medication.nextDoseTime ?? "—",
                        ), // or format the time if needed
                        style: AppTheme.subheadingStyle.copyWith(
                          fontSize: 12,
                          color: AppTheme.textGrey,
                        ),
                      ),
                    ],
                  ),

                // Active Status Button
                GestureDetector(
                  onTap: () {
                    onActiveChanged?.call(!medication.isActive!);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          medication.isActive!
                              ? Colors.green.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            medication.isActive! ? Colors.green : Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          medication.isActive!
                              ? Icons.check_circle
                              : Icons.pause_circle,
                          color:
                              medication.isActive! ? Colors.green : Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          medication.isActive!
                              ? loc.active
                              : loc.inactive, // Localized
                          style: AppTheme.subheadingStyle.copyWith(
                            fontSize: 12,
                            color:
                                medication.isActive!
                                    ? Colors.green
                                    : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTheme.subheadingStyle.copyWith(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMedicationIcon() {
    // Different icons based on medication name/type
    final name = medication.medicineName.toLowerCase();

    if (name.contains('aspirin') ||
        name.contains('ibuprofen') ||
        name.contains('paracetamol')) {
      return Icons.healing; // Pain relievers
    } else if (name.contains('antibiotic') ||
        name.contains('penicillin') ||
        name.contains('amoxicillin') ||
        name.contains('augmentin')) {
      return Icons.bug_report; // Antibiotics
    } else if (name.contains('vitamin') || name.contains('supplement')) {
      return Icons.fitness_center; // Vitamins/Supplements
    } else if (name.contains('insulin') ||
        name.contains('metformin') ||
        name.contains('diabetes')) {
      return Icons.monitor_heart; // Diabetes medication
    } else if (name.contains('blood') ||
        name.contains('pressure') ||
        name.contains('heart')) {
      return Icons.favorite; // Heart/Blood pressure medication
    } else if (name.contains('allergy') || name.contains('antihistamine')) {
      return Icons.air; // Allergy medication
    } else if (name.contains('sleep') || name.contains('melatonin')) {
      return Icons.bedtime; // Sleep aids
    } else if (name.contains('inhaler') || name.contains('asthma')) {
      return Icons.air; // Respiratory medication
    } else {
      return Icons.medication; // Default medication icon
    }
  }
}
