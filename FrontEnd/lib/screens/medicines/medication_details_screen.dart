import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add this import
import '../../models/medication.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import 'medication_schdule_screen.dart';
import 'medicine_info_search_screen.dart';

class MedicationDetailsScreen extends StatefulWidget {
  final Medication medication;
  final Function(Medication) onDelete;
  final Function(Medication, bool) onStatusChanged;
  final Function(Medication) onScheduleUpdated;

  const MedicationDetailsScreen({
    super.key,
    required this.medication,
    required this.onDelete,
    required this.onStatusChanged,
    required this.onScheduleUpdated,
  });

  @override
  State<MedicationDetailsScreen> createState() =>
      _MedicationDetailsScreenState();
}

class _MedicationDetailsScreenState extends State<MedicationDetailsScreen> {
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _isActive = widget.medication.isActive!;
  }

  void _toggleStatus() {
    setState(() {
      _isActive = !_isActive;
    });
    widget.onStatusChanged(widget.medication, _isActive);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localizations
    return Scaffold(
      body: GradientBackground(
        title: loc.medicationDetails, // Localized
        withAppBar: true,
        showBackButton: true,
        child: SizedBox.expand(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Enhanced Medication Header Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Medication Icon and Status
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.primaryColor.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              _getMedicationIcon(widget.medication),
                              color: AppTheme.primaryColor,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.medication.medicineName,
                                  style: AppTheme.headingStyle.copyWith(
                                    fontSize: 24,
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        _isActive
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color:
                                          _isActive
                                              ? Colors.green
                                              : Colors.orange,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _isActive
                                            ? Icons.check_circle
                                            : Icons.pause_circle,
                                        color:
                                            _isActive
                                                ? Colors.green
                                                : Colors.orange,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _isActive
                                            ? loc.active
                                            : loc.paused, // Localized
                                        style: AppTheme.subheadingStyle
                                            .copyWith(
                                              fontSize: 12,
                                              color:
                                                  _isActive
                                                      ? Colors.green
                                                      : Colors.orange,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Quick Status Toggle
                          GestureDetector(
                            onTap: _toggleStatus,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                    _isActive
                                        ? Colors.orange.withOpacity(0.1)
                                        : Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      _isActive
                                          ? Colors.orange.withOpacity(0.3)
                                          : Colors.green.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                _isActive ? Icons.pause : Icons.play_arrow,
                                color: _isActive ? Colors.orange : Colors.green,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Medication Details Cards
                _buildInfoCard(loc.dosageInformation, Icons.medication_liquid, [
                  _buildDetailItem(
                    Icons.local_pharmacy,
                    loc.dosage, // Localized
                    '${widget.medication.dosage} tablet(s)',
                  ),
                  _buildDetailItem(
                    Icons.repeat,
                    loc.frequency, // Localized
                    '${widget.medication.frequency} times daily',
                  ),
                  _buildDetailItem(
                    Icons.calendar_today,
                    loc.duration, // Localized
                    '${widget.medication.duration} days',
                  ),
                  _buildDetailItem(
                    Icons.restaurant,
                    loc.timing, // Localized
                    widget.medication.afterMeal!
                        ? loc.afterMeal
                        : loc.beforeMeal, // Localized
                  ),
                ]),

                const SizedBox(height: 16),

                if (widget.medication.scheduledTimes != null &&
                    widget.medication.scheduledTimes!.isNotEmpty)
                  _buildInfoCard(loc.schedule, Icons.schedule, [
                    _buildDetailItem(
                      Icons.access_time,
                      loc.times, // Localized
                      widget.medication.scheduledTimes!.join(', '),
                    ),
                    if (widget.medication.nextDoseTime != null)
                      _buildDetailItem(
                        Icons.notifications_active,
                        loc.nextDose, // Localized
                        widget.medication.nextDoseTime!,
                      ),
                  ]),

                const SizedBox(height: 24),

                // Quick Actions Grid
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.quickActions, // Localized
                        style: AppTheme.subheadingStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionCard(
                              loc.schedule, // Localized
                              Icons.schedule,
                              AppTheme.primaryColor,
                              () => _scheduleMedicine(context),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionCard(
                              loc.medicineInfo, // Localized
                              Icons.info_outline,
                              Colors.blue,
                              () => _showMedicineInfo(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Status and Delete buttons in a row
                      Row(
                        children: [
                          // Toggle Status Button
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _toggleStatus,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    _isActive ? Colors.orange : Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: Icon(
                                _isActive ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                              ),
                              label: Text(
                                _isActive
                                    ? loc.pause
                                    : loc.activate, // Localized
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Delete Button
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _deleteMedication(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              label: Text(
                                loc.delete, // Localized
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTheme.subheadingStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textGrey, size: 18),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTheme.subheadingStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textGrey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.subheadingStyle.copyWith(
                fontSize: 14,
                color: AppTheme.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTheme.subheadingStyle.copyWith(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _scheduleMedicine(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                MedicationScheduleScreen(medication: widget.medication),
      ),
    ).then((updatedMedication) {
      if (updatedMedication != null) {
        widget.onScheduleUpdated(updatedMedication);
      }
    });
  }

  void _showMedicineInfo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MedicineInfoSearchScreen(
              initialSearchTerm: widget.medication.medicineName,
            ),
      ),
    );
  }

  void _deleteMedication(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
                const SizedBox(width: 8),
                Text(loc.deleteMedication), // Localized
              ],
            ),
            content: Text(
              loc.deleteMedicationConfirm.replaceFirst(
                '{medicineName}',
                widget.medication.medicineName,
              ), // Localized
              style: AppTheme.subheadingStyle.copyWith(
                color: AppTheme.textGrey,
              ),
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: AppTheme.textGrey.withOpacity(0.3),
                          ),
                        ),
                      ),
                      child: Text(
                        loc.cancel, // Localized
                        style: TextStyle(
                          color: AppTheme.textGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        widget.onDelete(widget.medication);
                        Navigator.pop(context); // Go back to medications list
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        loc.delete, // Localized
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }

  IconData _getMedicationIcon(Medication medication) {
    final name = medication.medicineName.toLowerCase();

    if (name.contains('aspirin') ||
        name.contains('ibuprofen') ||
        name.contains('paracetamol')) {
      return Icons.healing;
    } else if (name.contains('antibiotic') ||
        name.contains('penicillin') ||
        name.contains('amoxicillin') ||
        name.contains('augmentin')) {
      return Icons.bug_report;
    } else if (name.contains('vitamin') || name.contains('supplement')) {
      return Icons.fitness_center;
    } else if (name.contains('insulin') ||
        name.contains('metformin') ||
        name.contains('diabetes')) {
      return Icons.monitor_heart;
    } else if (name.contains('blood') ||
        name.contains('pressure') ||
        name.contains('heart')) {
      return Icons.favorite;
    } else if (name.contains('allergy') || name.contains('antihistamine')) {
      return Icons.air;
    } else if (name.contains('sleep') || name.contains('melatonin')) {
      return Icons.bedtime;
    } else if (name.contains('inhaler') || name.contains('asthma')) {
      return Icons.air;
    } else {
      return Icons.medication;
    }
  }
}
