import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/prescription.dart';
import '../../theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add for localization

class PrescriptionCard extends StatelessWidget {
  final Prescription prescription;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onDownload;

  const PrescriptionCard({
    super.key,
    required this.prescription,
    this.onTap,
    this.onDelete,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final formattedDate = dateFormat.format(prescription.date);
    final loc = AppLocalizations.of(context)!; // Localization instance

    return Dismissible(
      key: Key(prescription.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      onDismissed: (direction) {
        onDelete?.call();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.teal.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Doctor Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.medical_information,
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
                          '${loc.doctorPrefix} ${prescription.doctorName ?? loc.unknown}', // Localized
                          style: AppTheme.headingStyle.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          prescription.specialization ?? loc.unknown, // Localized
                          style: AppTheme.subheadingStyle.copyWith(
                            fontSize: 14,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: AppTheme.textGrey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${loc.date}: $formattedDate', // Localized
                              style: AppTheme.subheadingStyle.copyWith(
                                fontSize: 13,
                                color: AppTheme.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Arrow Icon
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppTheme.primaryColor.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
