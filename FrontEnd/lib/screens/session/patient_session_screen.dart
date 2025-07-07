import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/models/userModel.dart';
import '/screens/session/patient_history_screen.dart';
import '/screens/session/prescription_creation_screen.dart';
import '/utils/age_helper.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import "../../utils/date_formatter.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatientSessionScreen extends StatelessWidget {
  final UserModel patient;

  const PatientSessionScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GradientBackground(
      withAppBar: true,
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Patient Info Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Patient Photo - Fixed dummy photo
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE0E7FF),
                      border: Border.all(
                        color: const Color(0xFF6366F1).withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: Color(0xFF6366F1),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Patient Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${patient.firstName} ${patient.lastName}',
                          style: AppTheme.headingStyle.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E7FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${loc.age}: ${AgeHelper.calculateAge(formatDate(patient.dateOfBirth))}', // Localized
                            style: AppTheme.subheadingStyle.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF6366F1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Session Options Header
            Text(
              loc.sessionOptions, // Localized
              style: AppTheme.headingStyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              loc.chooseSessionAction(patient.firstName), // Localized
              style: AppTheme.subheadingStyle.copyWith(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            // Action Options
            Expanded(
              child: Column(
                children: [
                  // Write Prescription Option
                  _buildActionCard(
                    context: context,
                    title: loc.typePrescription, // Localized
                    subtitle: loc.createNewPrescriptionFor != null
                        ? loc.createNewPrescriptionFor(patient.firstName)
                        : '', // Add this key to ARB if needed
                    icon: Icons.edit_note,
                    color: const Color(0xFF3B82F6),
                    onTap: () => _writePrescription(context),
                  ),

                  const SizedBox(height: 16),

                  // View History Option
                  _buildActionCard(
                    context: context,
                    title: loc.viewHistory, // Localized
                    subtitle: loc.reviewMedicalHistory(patient.firstName), // Localized
                    icon: Icons.history,
                    color: const Color(0xFF22C55E),
                    onTap: () => _viewHistory(context),
                  ),

                  const Spacer(),

                  // End Session Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFEF4444).withOpacity(0.3),
                      ),
                    ),
                    child: TextButton.icon(
                      onPressed: () => _endSession(context, loc),
                      icon: const Icon(Icons.logout, color: Color(0xFFEF4444)),
                      label: Text(
                        loc.endSession, // Localized
                        style: AppTheme.subheadingStyle.copyWith(
                          color: const Color(0xFFEF4444),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTheme.subheadingStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: AppTheme.subheadingStyle.copyWith(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: color, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _writePrescription(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrescriptionWriterScreen(patient: patient),
      ),
    );
  }

  void _viewHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientHistoryScreen(patient: patient),
      ),
    );
  }

  void _endSession(BuildContext context, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            loc.endSession, // Localized
            style: AppTheme.headingStyle.copyWith(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          content: Text(
            loc.areYouSureEndSession('${patient.firstName} ${patient.lastName}'), // Localized
            style: AppTheme.subheadingStyle.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      loc.cancel, // Localized
                      style: AppTheme.subheadingStyle.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      loc.endSession, // Localized
                      style: AppTheme.subheadingStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.7,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
