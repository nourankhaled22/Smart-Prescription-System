import 'package:flutter/material.dart';

import '../../models/vaccine.dart';
import '../../theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VaccineCard extends StatelessWidget {
  final Vaccine vaccine;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const VaccineCard({
    super.key,
    required this.vaccine,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(vaccine.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
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
              color: _getVaccineColor().withOpacity(0.3),
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
                  // Vaccine Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getVaccineColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getVaccineIcon(),
                      color: _getVaccineColor(),
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Vaccine Name
                  Expanded(
                    child: Text(
                      vaccine.vaccineName,
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
                    ),
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
                    vaccine.date != null
                        ? AppLocalizations.of(context)!.dateLabel(
                          '${vaccine.date!.day}/${vaccine.date!.month}/${vaccine.date!.year}',
                        )
                        : AppLocalizations.of(context)!.dateNotAvailable,
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

  Color _getVaccineColor() {
    // Different colors based on vaccine name/type
    final name = vaccine.vaccineName.toLowerCase();

    if (name.contains('covid') || name.contains('corona')) {
      return Colors.blue;
    } else if (name.contains('flu') || name.contains('influenza')) {
      return Colors.orange;
    } else if (name.contains('mmr') || name.contains('measles')) {
      return Colors.purple;
    } else if (name.contains('hpv')) {
      return Colors.pink;
    } else if (name.contains('hepatitis')) {
      return Colors.amber;
    } else if (name.contains('tetanus') || name.contains('tdap')) {
      return Colors.teal;
    } else if (name.contains('polio')) {
      return Colors.indigo;
    } else {
      return AppTheme.primaryColor;
    }
  }

  IconData _getVaccineIcon() {
    // Different icons based on vaccine name/type
    final name = vaccine.vaccineName.toLowerCase();

    if (name.contains('covid') || name.contains('corona')) {
      return Icons.coronavirus;
    } else if (name.contains('flu') || name.contains('influenza')) {
      return Icons.sick;
    } else if (name.contains('travel') || name.contains('yellow fever')) {
      return Icons.flight;
    } else if (name.contains('child') ||
        name.contains('mmr') ||
        name.contains('dtap')) {
      return Icons.child_care;
    } else if (name.contains('hpv') || name.contains('hepatitis')) {
      return Icons.shield;
    } else if (name.contains('tetanus') || name.contains('tdap')) {
      return Icons.healing;
    } else if (name.contains('booster')) {
      return Icons.add_circle;
    } else {
      return Icons.local_hospital;
    }
  }
}
