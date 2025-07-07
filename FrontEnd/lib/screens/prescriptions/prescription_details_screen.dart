import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import 'package:intl/intl.dart';
import '/widgets/header_info.dart';
import '/widgets/notes_section.dart';

import '../../models/prescription.dart';
import '../../services/pdf_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrescriptionDetailsScreen extends StatelessWidget {
  final Prescription prescription;
  final Future<void> Function(String id) deletePrescription;

  const PrescriptionDetailsScreen({
    super.key,
    required this.prescription,
    required this.deletePrescription,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('dd/MM/yyyy');
    final formattedDate = dateFormat.format(prescription.date);

    return GradientBackground(
      //title: loc.prescriptionDetails,
      withAppBar: true,
      showBackButton: true,
      child: SizedBox.expand(
        child: SingleChildScrollView(
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
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.medical_information,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dr. ${prescription.doctorName}',
                                style: AppTheme.headingStyle.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              if (prescription.specialization != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  prescription.specialization ??
                                      loc.specialization, // Localized
                                  style: AppTheme.subheadingStyle.copyWith(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (prescription.clinicAddress != null) ...[
                          HeaderInfo(
                            icon: Icons.location_on,
                            text: prescription.clinicAddress ??
                                loc.clinicAddress, // Localized
                          ),
                        ],
                        if (prescription.phoneNumber != null) ...[
                          const SizedBox(width: 20),
                          HeaderInfo(
                           icon: Icons.phone,
                            text:prescription.phoneNumber ?? "",
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    HeaderInfo
                    (icon:Icons.calendar_today,
                     text:formattedDate),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Medicines Section
              if (prescription.medicines != null &&
                  prescription.medicines!.isNotEmpty) ...[
                _buildSection(
                  loc.medicines, // Localized
                  Icons.medication,
                  Colors.red,
                  prescription.medicines!
                      .map((med) => med.medicineName)
                      .toList(),
                ),
              ],

              const SizedBox(height: 24),

              // Examinations Section
              if (prescription.examinations != null &&
                  prescription.examinations!.isNotEmpty) ...[
                _buildSection(
                  loc.examinations, // Localized
                  Icons.biotech,
                  Colors.blue,
                  prescription.examinations!,
                ),
                const SizedBox(height: 24),
              ],

              // Diagnoses Section
              if (prescription.diagnoses != null &&
                  prescription.diagnoses!.isNotEmpty) ...[
                _buildSection(
                  loc.diagnoses, // Localized
                  Icons.medical_services,
                  Colors.purple,
                  prescription.diagnoses!,
                ),
                const SizedBox(height: 24),
              ],

              // Notes Section
              if (prescription.notes != null &&
                  prescription.notes!.isNotEmpty) ...[
                NotesSection(
                  title: loc.doctorNotes,
                  content: prescription.notes ?? "",
                ),
                const SizedBox(height: 24),
              ],

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _downloadPrescriptionPdf(context, loc),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      icon: const Icon(
                        Icons.picture_as_pdf,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: Text(
                        loc.downloadPdf, // Localized
                        style: AppTheme.subheadingStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _deletePrescription(context, loc),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: Text(
                        loc.delete, // Localized
                        style: AppTheme.subheadingStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
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
      ),
    );
  }

 

  Widget _buildSection(
    String title,
    IconData icon,
    Color color,
    List<String> items,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTheme.subheadingStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 6, right: 12),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item,
                          style: AppTheme.subheadingStyle.copyWith(
                            fontSize: 15,
                            color: AppTheme.black,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  void _downloadPrescriptionPdf(
    BuildContext context,
    AppLocalizations loc,
  ) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20),
                Text(loc.generatingPdf), // Localized
              ],
            ),
          );
        },
      );

      // Generate PDF
      final pdfFile = await PdfService.generatePrescriptionPdf(prescription);

      // Close loading dialog
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.prescriptionPdfSaved(pdfFile.path)), // Localized
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: loc.open, // Localized
            textColor: Colors.white,
            onPressed: () async {
              await OpenFile.open(pdfFile.path);
            },
          ),
        ),
      );

      // Optionally open the PDF automatically
      await OpenFile.open(pdfFile.path);
    } catch (e) {
      // Close loading dialog if still open
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${loc.errorGeneratingPdf ?? "Error generating PDF"}: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deletePrescription(BuildContext context, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(loc.deletePrescription), // Localized
          content: Text(
            '${loc.doctorName} : ${prescription.doctorName}', // Localized
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(loc.cancel), // Localized
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await deletePrescription(prescription.id);
                Navigator.of(context).pop('delete');
              },
              child: Text(
                loc.delete,
                style: const TextStyle(color: Colors.red),
              ), // Localized
            ),
          ],
        );
      },
    );
  }
}
