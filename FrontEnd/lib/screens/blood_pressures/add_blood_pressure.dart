import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/services/blood_pressure_service.dart';
import '/utils/date_picker_helper.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // <-- Add this import

class AddBloodPressureScreen extends StatefulWidget {
  const AddBloodPressureScreen({super.key});

  @override
  State<AddBloodPressureScreen> createState() => _AddBloodPressureScreenState();
}

class _AddBloodPressureScreenState extends State<AddBloodPressureScreen> {
  final _formKey = GlobalKey<FormState>();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _pulseController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance
    return GradientBackground(
      //title: loc.addNewReading,
      withAppBar: true,
      showBackButton: true,
      child: SizedBox.expand(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.primaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.add_circle,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.addNewReading, // Localized
                              style: AppTheme.headingStyle.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              loc.recordYourBloodPressure, // Localized
                              style: AppTheme.subheadingStyle.copyWith(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Values Section
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.purple,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            loc.bloodPressureValues, // Localized
                            style: AppTheme.subheadingStyle.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Systolic and Diastolic in one row
                      Row(
                        children: [
                          Expanded(
                            child: _buildValueInput(
                              loc.systolic, // Localized
                              _systolicController,
                              loc.upperNumber, // Localized
                              Icons.arrow_upward,
                              Colors.blue,
                              loc.pleaseEnterSystolic, // Localized
                              loc.pleaseEnterValidNumber, // Localized
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildValueInput(
                              loc.diastolic, // Localized
                              _diastolicController,
                              loc.lowerNumber, // Localized
                              Icons.arrow_downward,
                              Colors.red,
                              loc.pleaseEnterDiastolic, // Localized
                              loc.pleaseEnterValidNumber, // Localized
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Pulse
                      _buildValueInput(
                        loc.pulse, // Localized
                        _pulseController,
                        loc.heartRateBpm, // Localized
                        Icons.favorite,
                        Colors.pink,
                        loc.pleaseEnterPulse, // Localized
                        loc.pleaseEnterValidNumber, // Localized
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Date & Time Section
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.schedule,
                              color: Colors.orange,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            loc.dateAndTime, // Localized
                            style: AppTheme.subheadingStyle.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: _buildDateTimeSelector(
                              loc.date, // Localized
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              Icons.calendar_today,
                              () async {
                                FocusScope.of(
                                  context,
                                ).requestFocus(FocusNode()); // Prevent keyboard
                                final picked =
                                    await DatePickerHelper.selectDate(
                                      context,
                                      firstDate: DateTime(1900),
                                      initialDate: _selectedDate,
                                    );
                                if (picked != null) {
                                  setState(() {
                                    _selectedDate = picked;
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDateTimeSelector(
                              loc.time, // Localized
                              _selectedTime.format(context),
                              Icons.access_time,
                              () => _selectTime(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                const SizedBox(height: 40),

                // Save Button
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
                          loc.saveReading, // Localized
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

  Widget _buildValueInput(
    String label,
    TextEditingController controller,
    String hint,
    IconData icon,
    Color color,
    String emptyError,
    String invalidError,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTheme.subheadingStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: color.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: color.withOpacity(0.2), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: color, width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return emptyError;
            }
            if (int.tryParse(value) == null) {
              return invalidError;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateTimeSelector(
    String label,
    String value,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.subheadingStyle.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.orange.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Text(
                  value,
                  style: AppTheme.subheadingStyle.copyWith(
                    color: AppTheme.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
        final newBloodPressure = await BloodPressureService().addbloodPressure(
          token!,
          int.parse(_pulseController.text.trim()),
          int.parse(_diastolicController.text.trim()),
          int.parse(_systolicController.text.trim()),
          dateTime,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.bloodPressureAdded)), // Localized
        );
        Navigator.pop(context, newBloodPressure);
      } catch (e) {
        final errorMsg = e.toString().replaceFirst('Exception: ', '');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(errorMsg)),
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
