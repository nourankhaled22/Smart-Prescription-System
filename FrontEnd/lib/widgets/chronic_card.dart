import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add for localization

import '../../models/chronic.dart';
import '../../theme/app_theme.dart';

class ChronicDiseaseCard extends StatelessWidget {
  final Chronic chronicDisease;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ChronicDiseaseCard({
    super.key,
    required this.chronicDisease,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance
    return Dismissible(
      key: Key(chronicDisease.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 28,
        ),
      ),
      onDismissed: (direction) {
        onDelete?.call();
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _getDiseaseColor().withOpacity(0.3),
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
                  // Disease Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getDiseaseColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getDiseaseIcon(),
                      color: _getDiseaseColor(),
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Disease Name
                  Expanded(
                    child: Text(
                      chronicDisease.diseaseName,
                      style: AppTheme.subheadingStyle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.black,
                      ),
                    ),
                  ),

                  // Edit Button
                  IconButton(
                    onPressed: onEdit,
                    icon: Icon(
                      Icons.edit,
                      color: AppTheme.primaryColor,
                      size: 20,
                      semanticLabel: loc.edit, // Localized
                    ),
                    tooltip: loc.edit, // Localized
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Date Row
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppTheme.textGrey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    chronicDisease.date != null
                        ? '${loc.diagnosed}: ${chronicDisease.date!.day}/${chronicDisease.date!.month}/${chronicDisease.date!.year}'
                        : loc.diagnosedUnknown, // Localized
                    style: AppTheme.subheadingStyle.copyWith(
                      fontSize: 14,
                      color: AppTheme.textGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDiseaseColor() {
    // Different colors based on disease name/type
    final name = chronicDisease.diseaseName.toLowerCase();

    // Specific diseases
    if (name.contains('chronic kidney disease') || name.contains('kidney failure')) {
      return Colors.teal;
    } else if (name.contains('colitis')) {
      return Colors.orange;
    } else if (name.contains('osteoarthritis')) {
      return Colors.brown;
    } else if (name.contains('obesity')) {
      return Colors.deepOrange;
    } else if (name.contains('diabetes')) {
      return Colors.red;
    } else if (name.contains('stroke')) {
      return Colors.purple;
    } else if (name.contains('heart failure')) {
      return Colors.pink;
    }
    // General categories
    else if (name.contains('hypertension') || name.contains('blood pressure')) {
      return Colors.red;
    } else if (name.contains('asthma') || name.contains('copd')) {
      return Colors.lightBlue;
    } else if (name.contains('arthritis') || name.contains('joint')) {
      return Colors.brown;
    } else if (name.contains('heart') || name.contains('cardiac')) {
      return Colors.pink;
    } else if (name.contains('kidney') || name.contains('renal')) {
      return Colors.teal;
    } else if (name.contains('liver') || name.contains('hepatic')) {
      return Colors.amber;
    } else if (name.contains('thyroid')) {
      return Colors.purple;
    } else if (name.contains('depression') || name.contains('anxiety') || name.contains('mental')) {
      return Colors.indigo;
    } else if (name.contains('migraine') || name.contains('headache')) {
      return Colors.deepPurple;
    } else {
      return AppTheme.primaryColor;
    }
  }

  IconData _getDiseaseIcon() {
    // Different icons based on disease name/type
    final name = chronicDisease.diseaseName.toLowerCase();

    // Specific diseases
    if (name.contains('chronic kidney disease') || name.contains('kidney failure')) {
      return Icons.water_drop; // Kidney related
    } else if (name.contains('colitis')) {
      return Icons.local_dining; // Digestive system
    } else if (name.contains('osteoarthritis')) {
      return Icons.accessibility_new; // Joint/bone related
    } else if (name.contains('obesity')) {
      return Icons.monitor_weight; // Weight related
    } else if (name.contains('diabetes')) {
      return Icons.bloodtype; // Blood sugar related
    } else if (name.contains('stroke')) {
      return Icons.psychology; // Brain related
    } else if (name.contains('heart failure')) {
      return Icons.favorite; // Heart related
    }
    // General categories
    else if (name.contains('hypertension') || name.contains('blood pressure')) {
      return Icons.favorite;
    } else if (name.contains('asthma') || name.contains('copd') || name.contains('lung')) {
      return Icons.air;
    } else if (name.contains('arthritis') || name.contains('joint') || name.contains('bone')) {
      return Icons.accessibility;
    } else if (name.contains('heart') || name.contains('cardiac')) {
      return Icons.monitor_heart;
    } else if (name.contains('kidney') || name.contains('renal')) {
      return Icons.water_drop;
    } else if (name.contains('liver') || name.contains('hepatic')) {
      return Icons.local_hospital;
    } else if (name.contains('thyroid')) {
      return Icons.psychology;
    } else if (name.contains('depression') || name.contains('anxiety') || name.contains('mental')) {
      return Icons.psychology_alt;
    } else if (name.contains('migraine') || name.contains('headache')) {
      return Icons.psychology;
    } else if (name.contains('cancer') || name.contains('tumor')) {
      return Icons.healing;
    } else if (name.contains('eye') || name.contains('vision')) {
      return Icons.visibility;
    } else {
      return Icons.medical_services;
    }
  }
}
