import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add for localization

import '../../models/examination.dart';

class ExaminationCard extends StatelessWidget {
  final Examination examination;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onDownload;

  const ExaminationCard({
    super.key,
    required this.examination,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance
    final dateFormat = DateFormat('dd/MM/yyyy');
    final formattedDate = dateFormat.format(examination.date);

    return Dismissible(
      key: Key(examination.id),
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getExaminationColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getExaminationIcon(),
                      color: _getExaminationColor(),
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          examination.examinationName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Action buttons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onEdit != null)
                        IconButton(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit, size: 18),
                          color: Colors.blue,
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          tooltip: loc.edit, // Localized
                        ),
                      if (onDownload != null)
                        IconButton(
                          onPressed: onDownload,
                          icon: const Icon(Icons.download, size: 18),
                          color: Colors.green,
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          tooltip: loc.download, // Localized
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getExaminationIcon() {
    final name = examination.examinationName.toLowerCase();

    if (name.contains('blood') || name.contains('cbc')) {
      return Icons.bloodtype;
    } else if (name.contains('x-ray') ||
        name.contains('xray') ||
        name.contains('radiograph')) {
      return Icons.radio;
    } else if (name.contains('mri') || name.contains('magnetic')) {
      return Icons.panorama_horizontal;
    } else if (name.contains('ct') ||
        name.contains('cat scan') ||
        name.contains('computed tomography')) {
      return Icons.view_in_ar;
    } else if (name.contains('ultrasound') || name.contains('sonogram')) {
      return Icons.waves;
    } else if (name.contains('ecg') ||
        name.contains('ekg') ||
        name.contains('electrocardiogram')) {
      return Icons.monitor_heart;
    } else if (name.contains('urine') || name.contains('urinalysis')) {
      return Icons.opacity;
    } else if (name.contains('stool') || name.contains('fecal')) {
      return Icons.science;
    } else if (name.contains('biopsy')) {
      return Icons.biotech;
    } else {
      return Icons.medical_services;
    }
  }

  Color _getExaminationColor() {
    final name = examination.examinationName.toLowerCase();

    if (name.contains('blood') || name.contains('cbc')) {
      return Colors.red;
    } else if (name.contains('x-ray') ||
        name.contains('xray') ||
        name.contains('radiograph')) {
      return Colors.purple;
    } else if (name.contains('mri') || name.contains('magnetic')) {
      return Colors.indigo;
    } else if (name.contains('ct') ||
        name.contains('cat scan') ||
        name.contains('computed tomography')) {
      return Colors.blue;
    } else if (name.contains('ultrasound') || name.contains('sonogram')) {
      return Colors.teal;
    } else if (name.contains('ecg') ||
        name.contains('ekg') ||
        name.contains('electrocardiogram')) {
      return Colors.pink;
    } else if (name.contains('urine') || name.contains('urinalysis')) {
      return Colors.amber;
    } else if (name.contains('stool') || name.contains('fecal')) {
      return Colors.brown;
    } else if (name.contains('biopsy')) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }
}
