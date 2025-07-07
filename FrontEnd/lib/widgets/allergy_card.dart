import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add for localization

import '../../models/allergy.dart';
import '../../theme/app_theme.dart';

class AllergyCard extends StatelessWidget {
  final Allergy allergy;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AllergyCard({
    super.key,
    required this.allergy,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance
    return Dismissible(
      key: Key(allergy.id),
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
              color: _getAllergyColor().withOpacity(0.3),
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
                  // Allergy Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getAllergyColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getAllergyIcon(),
                      color: _getAllergyColor(),
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Allergy Name
                  Expanded(
                    child: Text(
                      allergy.allergyName,
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
                      semanticLabel: loc.edit, // Localized tooltip
                    ),
                    tooltip: loc.edit, // Localized tooltip
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Date Row
              if (allergy.date != null)
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppTheme.textGrey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${loc.date}: ${allergy.date!.day}/${allergy.date!.month}/${allergy.date!.year}', // Localized
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

  Color _getAllergyColor() {
    // Different colors based on allergy name/type
    final name = allergy.allergyName.toLowerCase();

    if (name.contains('peanut') ||
        name.contains('nut') ||
        name.contains('food')) {
      return Colors.orange;
    } else if (name.contains('drug') ||
        name.contains('medicine') ||
        name.contains('penicillin')) {
      return Colors.red;
    } else if (name.contains('dust') ||
        name.contains('pollen') ||
        name.contains('environmental')) {
      return Colors.green;
    } else if (name.contains('seasonal') ||
        name.contains('flower') ||
        name.contains('grass')) {
      return Colors.purple;
    } else if (name.contains('animal') ||
        name.contains('cat') ||
        name.contains('dog')) {
      return Colors.brown;
    } else if (name.contains('latex') || name.contains('rubber')) {
      return Colors.teal;
    } else {
      return AppTheme.primaryColor;
    }
  }

  IconData _getAllergyIcon() {
    // Different icons based on allergy name/type
    final name = allergy.allergyName.toLowerCase();

    if (name.contains('peanut') ||
        name.contains('nut') ||
        name.contains('food')) {
      return Icons.restaurant; // Food allergy
    } else if (name.contains('drug') ||
        name.contains('medicine') ||
        name.contains('penicillin')) {
      return Icons.medication; // Drug allergy
    } else if (name.contains('dust') || name.contains('environmental')) {
      return Icons.air; // Environmental allergy
    } else if (name.contains('seasonal') ||
        name.contains('pollen') ||
        name.contains('flower') ||
        name.contains('grass')) {
      return Icons.local_florist; // Seasonal/Pollen allergy
    } else if (name.contains('animal') ||
        name.contains('cat') ||
        name.contains('dog')) {
      return Icons.pets; // Animal allergy
    } else if (name.contains('latex') || name.contains('rubber')) {
      return Icons.healing; // Latex allergy
    } else if (name.contains('sun') || name.contains('light')) {
      return Icons.wb_sunny; // Sun/Light allergy
    } else if (name.contains('cold') || name.contains('temperature')) {
      return Icons.ac_unit; // Cold allergy
    } else if (name.contains('insect') ||
        name.contains('bee') ||
        name.contains('wasp')) {
      return Icons.bug_report; // Insect allergy
    } else {
      return Icons.warning; // General allergy
    }
  }
}
