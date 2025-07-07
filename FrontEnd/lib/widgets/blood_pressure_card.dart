import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add for localization

import '../models/blood_pressure.dart';

class BloodPressureCard extends StatelessWidget {
  final BloodPressure bloodPressure;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BloodPressureCard({
    super.key,
    required this.bloodPressure,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('h:mm a');
    final formattedDate = dateFormat.format(bloodPressure.date);
    final formattedTime = timeFormat.format(bloodPressure.date);

    return Dismissible(
      key: Key(bloodPressure.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
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
          child: Column(
            children: [
              // Main content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Pulse section
                    Expanded(
                      child: _buildValueSection(
                        loc.pulse, // Localized
                        bloodPressure.pulse.toString(),
                        Icons.favorite,
                        Colors.red,
                      ),
                    ),

                    // Diastolic section
                    Expanded(
                      child: _buildValueSection(
                        loc.diastolic, // Localized
                        bloodPressure.diastolic.toString(),
                        Icons.arrow_downward,
                        Colors.blue,
                      ),
                    ),

                    // Systolic section
                    Expanded(
                      child: _buildValueSection(
                        loc.systolic, // Localized
                        bloodPressure.systolic.toString(),
                        Icons.arrow_upward,
                        Colors.purple,
                      ),
                    ),

                    // Menu button
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: onTap,
                    ),
                  ],
                ),
              ),

              // Date and time
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    // Date
                    Expanded(
                      child: Row(
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
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Time
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedTime,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValueSection(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
