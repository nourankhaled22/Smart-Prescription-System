import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/services/medication_service.dart';
import '../../../theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add for localization

class MedicationDialogFixed extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  const MedicationDialogFixed({super.key, required this.onAdd});

  @override
  State<MedicationDialogFixed> createState() => _MedicationDialogFixedState();
}

class _MedicationDialogFixedState extends State<MedicationDialogFixed> {
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  int timesPerDay = 1;
  bool beforeMeal = true;
  List<String> _suggestions = [];
  bool _showSuggestions = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                    child: const Icon(
                      Icons.medication,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    loc.addMedicine, // Localized
                    style: AppTheme.headingStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Medicine Name
              Text(
                loc.medicineNameRequired, // Localized
                style: AppTheme.subheadingStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: loc.medicineNameHint, // Localized
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
              // Suggestions
              if (_showSuggestions && _suggestions.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: _suggestions
                        .map(
                          (suggestion) => ListTile(
                            title: Text(suggestion),
                            leading: Icon(
                              Icons.medication,
                              color: AppTheme.primaryColor,
                            ),
                            onTap: () {
                              setState(() {
                                _nameController.text = suggestion;
                                _showSuggestions = false;
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Dosage
              Text(
                loc.dosageRequired, // Localized
                style: AppTheme.subheadingStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _dosageController,
                decoration: InputDecoration(
                  hintText: loc.dosageHint, // Localized
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Times per Day
              Text(
                loc.timesPerDay, // Localized
                style: AppTheme.subheadingStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: timesPerDay > 1
                          ? () {
                              setState(() {
                                timesPerDay--;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$timesPerDay',
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      loc.timesDaily, // Localized
                      style: AppTheme.subheadingStyle.copyWith(
                        fontSize: 14,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: timesPerDay < 6
                          ? () {
                              setState(() {
                                timesPerDay++;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.add_circle_outline),
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // When to Take
              Text(
                loc.whenToTake, // Localized
                style: AppTheme.subheadingStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            beforeMeal = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: beforeMeal
                                ? AppTheme.primaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            loc.beforeMeal, // Localized
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: beforeMeal
                                  ? Colors.white
                                  : AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            beforeMeal = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !beforeMeal
                                ? AppTheme.primaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            loc.afterMeal, // Localized
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: !beforeMeal
                                  ? Colors.white
                                  : AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        loc.cancel, // Localized
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _addMedication,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        loc.addMedicine, // Localized
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  void _onSearchChanged(String value) async {
    if (value.length < 3) {
      setState(() {
        _showSuggestions = false;
        _suggestions = [];
      });
      return;
    }

    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final suggestions = await MedicationService().searchForMedicines(
        token!,
        _nameController.text,
      );
      setState(() {
        _suggestions = suggestions.cast<String>();
        _showSuggestions = suggestions.isNotEmpty;
      });
    } catch (e) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
    }
  }

  void _addMedication() {
    final loc = AppLocalizations.of(context)!;
    if (_nameController.text.isNotEmpty && _dosageController.text.isNotEmpty) {
      widget.onAdd({
        'medicineName': _nameController.text,
        'dosage': _dosageController.text,
        'frequency': timesPerDay,
        'beforeMeal': beforeMeal,
      });
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.pleaseFillRequiredFields), // Localized
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
