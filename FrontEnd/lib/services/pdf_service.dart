import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../models/prescription.dart';

class PdfService {
  static Future<File> generatePrescriptionPdf(Prescription prescription) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd/MM/yyyy');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: PdfColors.teal,
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    children: [
                      pw.Container(
                        width: 40,
                        height: 40,
                        decoration: pw.BoxDecoration(
                          color: PdfColors.white,
                          borderRadius: pw.BorderRadius.circular(8),
                        ),
                        child: pw.Center(
                          child: pw.Text('', style: pw.TextStyle(fontSize: 20)),
                        ),
                      ),
                      pw.SizedBox(width: 16),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Medical Prescription',
                              style: pw.TextStyle(
                                fontSize: 24,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.white,
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              'Generated on ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                              style: pw.TextStyle(
                                fontSize: 12,
                                color: PdfColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 24),

            // Doctor Information
            _buildSection('Doctor Information', [
              _buildInfoRow('Doctor Name', 'Dr. ${prescription.doctorName}'),
              _buildInfoRow(
                'Specialization',
                prescription.specialization ?? "UnKnown",
              ),
              _buildInfoRow(
                'Clinic Address',
                prescription.clinicAddress ?? "Unknown",
              ),
              _buildInfoRow(
                'Phone Number',
                prescription.phoneNumber ?? "Unknow",
              ),
              _buildInfoRow('Date', dateFormat.format(prescription.date)),
            ], PdfColors.blue),

            pw.SizedBox(height: 20),

            // Medicines Section
            if (prescription.medicines != null &&
                prescription.medicines!.isNotEmpty)
              _buildListSection(
                'Prescribed Medicines',
                prescription.medicines!.map((med) => med.medicineName).toList(),
                PdfColors.red,
              ),

            pw.SizedBox(height: 20),

            // Examinations Section
            if (prescription.examinations != null &&
                prescription.examinations!.isNotEmpty)
              _buildListSection(
                'Required Examinations',
                prescription.examinations!,
                PdfColors.purple,
              ),

            pw.SizedBox(height: 20),

            // Diagnoses Section
            if (prescription.diagnoses != null &&
                prescription.diagnoses!.isNotEmpty)
              _buildListSection(
                'Medical Diagnoses',
                prescription.diagnoses!,
                PdfColors.orange,
              ),

            pw.SizedBox(height: 20),

            // Notes Section
            if (prescription.notes != null && prescription.notes!.isNotEmpty)
              _buildNotesSection(prescription.notes!),

            pw.SizedBox(height: 30),

            // Footer
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Column(
                children: [
                  pw.Text(
                    'Important Notice',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.red,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'This prescription is generated electronically. Please follow the doctor\'s instructions carefully and consult your healthcare provider if you have any questions.',
                    style: pw.TextStyle(fontSize: 10),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Generated by Medical Management App',
                    style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );
    //Todo There is something needs to be fixed here
    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'prescription_${prescription.doctorName?.replaceAll(' ', '_')}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  static pw.Widget _buildSection(
    String title,
    List<pw.Widget> content,
    PdfColor color,
  ) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: color.shade(0.3)),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: color.shade(0.1),
              borderRadius: const pw.BorderRadius.only(
                topLeft: pw.Radius.circular(8),
                topRight: pw.Radius.circular(8),
              ),
            ),
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: color,
              ),
            ),
          ),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: content,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildListSection(
    String title,
    List<String> items,
    PdfColor color,
  ) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: color.shade(0.3)),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: color.shade(0.1),
              borderRadius: const pw.BorderRadius.only(
                topLeft: pw.Radius.circular(8),
                topRight: pw.Radius.circular(8),
              ),
            ),
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: color,
              ),
            ),
          ),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children:
                  items
                      .map(
                        (item) => pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 8),
                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(
                                width: 4,
                                height: 4,
                                margin: const pw.EdgeInsets.only(
                                  top: 6,
                                  right: 8,
                                ),
                                decoration: pw.BoxDecoration(
                                  color: color,
                                  shape: pw.BoxShape.circle,
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  item,
                                  style: pw.TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildNotesSection(String notes) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.amber.shade(0.3)),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.amber.shade(0.1),
              borderRadius: const pw.BorderRadius.only(
                topLeft: pw.Radius.circular(8),
                topRight: pw.Radius.circular(8),
              ),
            ),
            child: pw.Text(
              'Doctor\'s Notes',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.amber,
              ),
            ),
          ),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            child: pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.amber.shade(0.05),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Text(notes, style: pw.TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  




  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(child: pw.Text(value, style: pw.TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
