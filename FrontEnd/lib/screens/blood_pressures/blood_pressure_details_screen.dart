import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // <-- Add this import
import 'package:intl/intl.dart';

import '../../models/blood_pressure.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import './edit_blood_pressure.dart';

class BloodPressureDetailsScreen extends StatelessWidget {
  final BloodPressure bloodPressure;
  final Future<void> Function(String id) deleteBlood;

  const BloodPressureDetailsScreen({
    super.key,
    required this.bloodPressure,
    required this.deleteBlood,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('h:mm a');
    final formattedDate = dateFormat.format(bloodPressure.date);
    final formattedTime = timeFormat.format(bloodPressure.date);

    return GradientBackground(
      //title: loc.bloodPressureReading,
      withAppBar: true,
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.favorite, color: Colors.white, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    loc.bloodPressureReading, // Localized
                    style: AppTheme.headingStyle.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$formattedDate at $formattedTime',
                    style: AppTheme.subheadingStyle.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Values Cards
            Row(
              children: [
                Expanded(
                  child: _buildValueCard(
                    loc.systolic, // Localized
                    bloodPressure.systolic.toString(),
                    'mmHg',
                    Icons.arrow_upward,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildValueCard(
                    loc.diastolic, // Localized
                    bloodPressure.diastolic.toString(),
                    'mmHg',
                    Icons.arrow_downward,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildValueCard(
                    loc.pulse, // Localized
                    bloodPressure.pulse.toString(),
                    'bpm',
                    Icons.favorite,
                    Colors.pink,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Health Analysis Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getHealthStatusColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getHealthStatusColor().withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getHealthStatusIcon(),
                        color: _getHealthStatusColor(),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        loc.healthAnalysis, // Localized
                        style: AppTheme.subheadingStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _getHealthStatusColor(),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getHealthStatusLocalized(loc), // Localized
                    style: AppTheme.headingStyle.copyWith(
                      fontSize: 18,
                      color: _getHealthStatusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getHealthAdviceLocalized(loc), // Localized
                    style: AppTheme.subheadingStyle.copyWith(
                      color: AppTheme.textGrey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Notes Section
            if (bloodPressure.notes != null &&
                bloodPressure.notes!.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.note, color: Colors.grey.shade600, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          loc.notes, // Localized
                          style: AppTheme.subheadingStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bloodPressure.notes!,
                      style: AppTheme.subheadingStyle.copyWith(
                        color: AppTheme.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            const Spacer(),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _editBloodPressure(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.withOpacity(0.8),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: Text(
                      loc.editReading, // Localized
                      style: AppTheme.subheadingStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _deleteBloodPressure(context, loc),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.8),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.delete, color: Colors.white),
                    label: Text(
                      loc.delete, // Localized
                      style: AppTheme.subheadingStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildValueCard(
    String label,
    String value,
    String unit,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTheme.headingStyle.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            unit,
            style: AppTheme.subheadingStyle.copyWith(
              fontSize: 12,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.subheadingStyle.copyWith(
              fontSize: 12,
              color: AppTheme.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getHealthStatusLocalized(AppLocalizations loc) {
    if (bloodPressure.systolic < 90 || bloodPressure.diastolic < 60) {
      return loc.low; // Localized
    } else if (bloodPressure.systolic < 120 && bloodPressure.diastolic < 80) {
      return loc.normal; // Localized
    } else if (bloodPressure.systolic < 130 && bloodPressure.diastolic < 80) {
      return loc.elevatedBloodPressure ?? 'Elevated Blood Pressure'; // Add to ARB if needed
    } else if (bloodPressure.systolic < 140 || bloodPressure.diastolic < 90) {
      return loc.high; // Localized
    } else {
      return loc.high; // Localized
    }
  }

  String _getHealthAdviceLocalized(AppLocalizations loc) {
    if (bloodPressure.systolic < 90 || bloodPressure.diastolic < 60) {
      return loc.elevatedBpAdvice ?? 'Consider consulting your doctor if you experience symptoms like dizziness or fatigue.'; // Add to ARB if needed
    } else if (bloodPressure.systolic < 120 && bloodPressure.diastolic < 80) {
      return loc.normalBpAdvice ?? 'Great! Maintain a healthy lifestyle with regular exercise and balanced diet.'; // Add to ARB if needed
    } else if (bloodPressure.systolic < 130 && bloodPressure.diastolic < 80) {
      return loc.elevatedBpAdvice ?? 'Consider lifestyle changes like reducing sodium intake and increasing physical activity.'; // Add to ARB if needed
    } else {
      return loc.highBpAdvice ?? 'Consult your healthcare provider for proper evaluation and treatment options.'; // Add to ARB if needed
    }
  }

  Color _getHealthStatusColor() {
    if (bloodPressure.systolic < 90 || bloodPressure.diastolic < 60) {
      return Colors.blue;
    } else if (bloodPressure.systolic < 120 && bloodPressure.diastolic < 80) {
      return Colors.green;
    } else if (bloodPressure.systolic < 130 && bloodPressure.diastolic < 80) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  IconData _getHealthStatusIcon() {
    if (bloodPressure.systolic < 90 || bloodPressure.diastolic < 60) {
      return Icons.arrow_downward;
    } else if (bloodPressure.systolic < 120 && bloodPressure.diastolic < 80) {
      return Icons.check_circle;
    } else if (bloodPressure.systolic < 130 && bloodPressure.diastolic < 80) {
      return Icons.warning;
    } else {
      return Icons.error;
    }
  }

  void _editBloodPressure(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => EditBloodPressureScreen(bloodPressure: bloodPressure),
      ),
    );

    if (result != null && result is BloodPressure) {
      // Return the updated blood pressure to the previous screen
      Navigator.pop(context, result);
    }
  }

  void _deleteBloodPressure(BuildContext context, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(loc.deleteReading), // Localized
          content: Text(loc.deleteReadingConfirm), // Localized
          actionsAlignment:
              MainAxisAlignment.spaceBetween, // دي اللي بتحط Cancel على الشمال
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(loc.cancel), // Localized
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                await deleteBlood(bloodPressure.id); // Close dialog
                //! Delete the blood pressure reading from the database
                Navigator.pop(
                  context,
                  'delete',
                ); // Return to main screen with delete signal
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(loc.delete), // Localized
            ),
          ],
        );
      },
    );
  }
}
