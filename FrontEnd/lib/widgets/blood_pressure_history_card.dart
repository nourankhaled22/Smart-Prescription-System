import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add for localization
import '../models/blood_pressure.dart';
import '../../theme/app_theme.dart';

class BloodPressureCard extends StatelessWidget {
  final BloodPressure reading;

  const BloodPressureCard({super.key, required this.reading});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance
    final indicator = _getBloodPressureIndicator(
      reading.systolic,
      reading.diastolic,
      loc,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: indicator['color'], width: 1.5),
        boxShadow: [
          BoxShadow(
            color: indicator['color'].withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildReadingColumn(
                  icon: Icons.favorite,
                  iconColor: Colors.red.shade500,
                  label: loc.pulse, // Localized
                  value: '${reading.pulse}',
                ),
              ),
              Container(width: 1, height: 35, color: Colors.grey.shade300),
              Expanded(
                child: _buildReadingColumn(
                  icon: Icons.keyboard_arrow_down,
                  iconColor: Colors.blue.shade500,
                  label: loc.diastolic, // Localized
                  value: '${reading.diastolic}',
                ),
              ),
              Container(width: 1, height: 35, color: Colors.grey.shade300),
              Expanded(
                child: _buildReadingColumn(
                  icon: Icons.keyboard_arrow_up,
                  iconColor: Colors.purple.shade500,
                  label: loc.systolic, // Localized
                  value: '${reading.systolic}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: AppTheme.textGrey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(reading.date),
                    style: AppTheme.subheadingStyle.copyWith(
                      fontSize: 11,
                      color: AppTheme.textGrey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.access_time, size: 12, color: AppTheme.textGrey),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(reading.date),
                    style: AppTheme.subheadingStyle.copyWith(
                      fontSize: 11,
                      color: AppTheme.textGrey,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: indicator['color'],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  indicator['status'].toUpperCase(),
                  style: AppTheme.subheadingStyle.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReadingColumn({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.headingStyle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: iconColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTheme.subheadingStyle.copyWith(
            fontSize: 9,
            color: AppTheme.textGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _getBloodPressureIndicator(
      int systolic, int diastolic, AppLocalizations loc) {
    if (systolic >= 140 || diastolic >= 90) {
      return {'status': loc.high, 'color': Colors.red.shade600}; // Localized
    } else if (systolic < 90 || diastolic < 60) {
      return {'status': loc.low, 'color': Colors.blue.shade600}; // Localized
    } else {
      return {'status': loc.normal, 'color': Colors.green.shade600}; // Localized
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour =
        date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $period';
  }
}
