import 'package:flutter/material.dart';
import '/utils/age_helper.dart';
import '../models/userModel.dart';
import '../../theme/app_theme.dart';
import "../../utils/date_formatter.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add for localization

class PatientCard extends StatelessWidget {
  final UserModel patient;
  final VoidCallback onTap;
  final VoidCallback onStatusToggle;

  const PatientCard({
    super.key,
    required this.patient,
    required this.onTap,
    required this.onStatusToggle,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Profile Avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Patient Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${patient.firstName} ${patient.lastName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AgeHelper.calculateAge(formatDate(patient.dateOfBirth)),
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                // Status Toggle Button
                GestureDetector(
                  onTap: onStatusToggle,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: patient.status == "active"
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFFF5252),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      patient.status == "active" ? loc.active : loc.inactive, // Localized
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
