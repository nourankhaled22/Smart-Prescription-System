import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add for localization
import '../models/userModel.dart';
import '../../theme/app_theme.dart';

class DoctorCard extends StatelessWidget {
  final UserModel doctor;
  final VoidCallback onTap;
  final VoidCallback onStatusToggle;
  final bool showVerifyButton;

  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onTap,
    required this.onStatusToggle,
    this.showVerifyButton = false,
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
                    Icons.local_hospital,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Doctor Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${doctor.firstName} ${doctor.lastName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor.specialization!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (doctor.status == "unverified") ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 12,
                              color: Colors.orange[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              loc.pendingVerification, // Localized
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Status Button
                _buildStatusButton(context, loc),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusButton(BuildContext context, AppLocalizations loc) {
    if (showVerifyButton && doctor.status == "unverified") {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF2196F3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          loc.verify, // Localized
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    if (!(doctor.status == "unverified")) {
      return GestureDetector(
        onTap: onStatusToggle,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: doctor.status == "active"
                ? const Color(0xFF4CAF50)
                : const Color(0xFFFF5252),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            doctor.status == "active" ? loc.active : loc.inactive, // Localized
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}