import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/services/blood_pressure_service.dart';
import '/utils/date_picker_helper.dart';

import '../../models/blood_pressure.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // <-- Add this import

class EditBloodPressureScreen extends StatefulWidget {
  final BloodPressure bloodPressure;

  const EditBloodPressureScreen({super.key, required this.bloodPressure});

  @override
  State<EditBloodPressureScreen> createState() =>
      _EditBloodPressureScreenState();
}

class _EditBloodPressureScreenState extends State<EditBloodPressureScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _systolicController;
  late TextEditingController _diastolicController;
  late TextEditingController _pulseController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _systolicController = TextEditingController(
      text: widget.bloodPressure.systolic.toString(),
    );
    _diastolicController = TextEditingController(
      text: widget.bloodPressure.diastolic.toString(),
    );
    _pulseController = TextEditingController(
      text: widget.bloodPressure.pulse.toString(),
    );
    _selectedDate = widget.bloodPressure.date;
    _selectedTime = TimeOfDay(
      hour: widget.bloodPressure.date.hour,
      minute: widget.bloodPressure.date.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance
    return GradientBackground(
      //title: loc.editBloodPressure,
      withAppBar: true,
      showBackButton: true,
      child: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Header with icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: AppTheme.primaryColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      loc.editBloodPressure, // Localized
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Scrollable form
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Systolic
                        _buildInputSection(
                          loc.systolic, // Localized
                          TextFormField(
                            controller: _systolicController,
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration(
                              loc.upperNumber, // Localized
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return loc.pleaseEnterSystolic; // Localized
                              }
                              if (int.tryParse(value) == null) {
                                return loc.pleaseEnterValidNumber; // Localized
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Diastolic
                        _buildInputSection(
                          loc.diastolic, // Localized
                          TextFormField(
                            controller: _diastolicController,
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration(
                              loc.lowerNumber, // Localized
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return loc.pleaseEnterDiastolic; // Localized
                              }
                              if (int.tryParse(value) == null) {
                                return loc.pleaseEnterValidNumber; // Localized
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Pulse
                        _buildInputSection(
                          loc.pulse, // Localized
                          TextFormField(
                            controller: _pulseController,
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration(
                              loc.heartRateBpm, // Localized
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return loc.pleaseEnterPulse; // Localized
                              }
                              if (int.tryParse(value) == null) {
                                return loc.pleaseEnterValidNumber; // Localized
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Date
                        _buildInputSection(
                          loc.date, // Localized
                          GestureDetector(
                            onTap: _selectDate,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.purple.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: Colors.purple,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                    style: AppTheme.subheadingStyle.copyWith(
                                      color: AppTheme.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Time
                        _buildInputSection(
                          loc.time, // Localized
                          GestureDetector(
                            onTap: _selectTime,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.purple.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: Colors.purple,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _selectedTime.format(context),
                                    style: AppTheme.subheadingStyle.copyWith(
                                      color: AppTheme.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Update Button
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _saveBloodPressure,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.updateReading, // Localized
                          style: AppTheme.subheadingStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.subheadingStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.black,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.purple.withOpacity(0.2), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.purple, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      contentPadding: const EdgeInsets.all(16),
    );
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.purple,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.purple,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveBloodPressure() async {
    final loc = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      // Combine date and time
      final dateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      try {
        final updatedBloodPressure = await BloodPressureService()
            .updatebloodPressure(
              token!,
              widget.bloodPressure.id,
              int.parse(_pulseController.text.trim()),
              int.parse(_diastolicController.text.trim()),
              int.parse(_systolicController.text.trim()),
              dateTime,
            );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(loc.bloodPressureUpdated), // Localized
          ),
        );
        Navigator.pop(context, updatedBloodPressure);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.failedToUpdateBloodPressure(e.toString())),
          ), // Localized
        );
      }
    }
  }

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}
