import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    show UILocalNotificationDateInterpretation;
import 'package:provider/provider.dart';
import '/main.dart';
import '/providers/auth_provider.dart';
import '/services/medication_service.dart';
import '/utils/date_picker_helper.dart';
import '/widgets/input_decoration_helper.dart';
import '/widgets/input_section.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../models/medication.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // <-- Add this import

class MedicationScheduleScreen extends StatefulWidget {
  final Medication medication;

  const MedicationScheduleScreen({super.key, required this.medication});

  @override
  State<MedicationScheduleScreen> createState() =>
      _MedicationScheduleScreenState();
}

class _MedicationScheduleScreenState extends State<MedicationScheduleScreen> {
  DateTime? _startDate;
  TimeOfDay? _startTime;
  int _hoursPerDay = 8;
  late TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    _durationController = TextEditingController(text: "7");
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance
    return GradientBackground(
      withAppBar: true,
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox.expand(
          child: SingleChildScrollView(
            // <-- Add this
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
                      child: Icon(
                        Icons.schedule,
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
                            loc.schedule, // Localized
                            style: AppTheme.headingStyle.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          Text(
                            widget.medication.medicineName,
                            style: AppTheme.subheadingStyle.copyWith(
                              fontSize: 14,
                              color: AppTheme.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Enter Start Date
                _buildInputSection(
                  loc.enterStartDate, // Localized
                  GestureDetector(
                    onTap: () async {
                      final picked = await DatePickerHelper.selectDate(
                        context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          const Duration(days: 3650),
                        ),
                        initialDate: _startDate ?? DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _startDate = picked;
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              _startDate != null
                                  ? AppTheme.primaryColor.withOpacity(0.3)
                                  : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.calendar_today,
                              color: AppTheme.primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _startDate != null
                                  ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                                  : loc.selectStartDate, // Localized
                              style: AppTheme.subheadingStyle.copyWith(
                                color:
                                    _startDate != null
                                        ? AppTheme.black
                                        : AppTheme.textGrey,
                                fontWeight:
                                    _startDate != null
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppTheme.primaryColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Enter Start Time
                _buildInputSection(
                  loc.enterStartTime, // Localized
                  GestureDetector(
                    onTap: _selectTime,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              _startTime != null
                                  ? AppTheme.primaryColor.withOpacity(0.3)
                                  : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.access_time,
                              color: AppTheme.primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _startTime != null
                                  ? _startTime!.format(context)
                                  : loc.selectStartTime, // Localized
                              style: AppTheme.subheadingStyle.copyWith(
                                color:
                                    _startTime != null
                                        ? AppTheme.black
                                        : AppTheme.textGrey,
                                fontWeight:
                                    _startTime != null
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppTheme.primaryColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                // Duration
                InputSection(
                  label: loc.duration, // Localized
                  child: TextFormField(
                    controller: _durationController,
                    decoration: buildInputDecoration(
                      loc.duration,
                      fillColor: const Color(0xFFF5F5F5),
                      borderColor: Colors.purple.withOpacity(0.2),
                      outlineColor: Colors.purple,
                    ), // Localized
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return loc.duration; // Localized
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Hours per day - Professional Stepper
                _buildInputSection(
                  loc.hoursPerDay, // Localized
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: NumberStepper(
                      value: _hoursPerDay,
                      minValue: 1,
                      maxValue: 24,
                      onChanged: (value) {
                        setState(() {
                          _hoursPerDay = value;
                        });
                      },
                    ),
                  ),
                ),
                //! instead of Spacer
                const SizedBox(height: 32),

                // Save Button
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4ECDC4).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _saveSchedule,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4ECDC4),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          loc.saveSchedule, // Localized
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

  //! Input Text
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

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  void scheduleMedicine(String medicineName) async {
    // Initialize timezone (in main before using this function)
    tz.initializeTimeZones();

    final now = tz.TZDateTime.now(egypt);

    // Loop to schedule 3 notifications, each 8 hours apart
    final int baseId =
        widget.medication.id.hashCode; // or int.parse(widget.medication.id)
    for (int i = 0; i < widget.medication.frequency!; i++) {
      final scheduledTime = now.add(Duration(hours: 8 * i));

      await flutterLocalNotificationsPlugin.zonedSchedule(
        baseId + i, // Unique ID per medicine and per notification
        'Medicine Reminder 💊',
        'Time to take $medicineName',
        _adjustToNextDayIfPast(scheduledTime),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'med_reminder_channel',
            'Medicine Reminders',
            channelDescription: 'Reminders to take your medication',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
        androidScheduleMode: AndroidScheduleMode.exact,
      );
    }
  }

  tz.TZDateTime _adjustToNextDayIfPast(tz.TZDateTime dateTime) {
    final now = tz.TZDateTime.now(egypt);
    if (dateTime.isBefore(now)) {
      return dateTime.add(Duration(days: 1));
    }
    return dateTime;
  }

  Future<void> _saveSchedule() async {
    final loc = AppLocalizations.of(context)!;
    if (_startDate != null && _startTime != null) {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final updatedMedication = await MedicationService().scheduleMedicine(
        token: token!,
        medicineId: widget.medication.id!,
        frequency: (24 / _hoursPerDay).toInt(),
        startDate: _startDate!,
        startTime:
            DateTime(
              _startDate!.year,
              _startDate!.month,
              _startDate!.day,
              _startTime!.hour,
              _startTime!.minute,
            ).toIso8601String(),
        hoursPerDay: _hoursPerDay,
        duration: int.parse(_durationController.text),
      );

      // Use the correct notification scheduling function
      scheduleNotifications(widget.medication.medicineName);

      Navigator.pop(context, updatedMedication);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loc.scheduleSaved(widget.medication.medicineName),
          ), // Localized
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.pleaseSelectDateTime), // Localized
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void scheduleNotifications(String medicineName) async {
    tz.initializeTimeZones();
    final egypt = tz.getLocation('Africa/Cairo');

    final int durationDays = int.tryParse(_durationController.text) ?? 1;
    final int intervalHours = _hoursPerDay;

    final tz.TZDateTime firstSchedule = tz.TZDateTime(
      egypt,
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
      _startTime!.hour,
      _startTime!.minute,
    );

    final tz.TZDateTime endDate = firstSchedule.add(
      Duration(days: durationDays),
    );

    final int baseId = widget.medication.id.hashCode;
    int notificationIndex = 0;
    tz.TZDateTime scheduledTime = firstSchedule;

    while (scheduledTime.isBefore(endDate)) {
      print(
        'Scheduling "$medicineName" at: $scheduledTime (notificationId: ${baseId + notificationIndex})',
      );
      await flutterLocalNotificationsPlugin.zonedSchedule(
        baseId + notificationIndex,
        'Medicine Reminder 💊',
        'Time to take $medicineName',
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'med_reminder_channel',
            'Medicine Reminders',
            channelDescription: 'Reminders to take your medication',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exact,
        matchDateTimeComponents: null,
      );
      notificationIndex++;
      scheduledTime = scheduledTime.add(Duration(hours: intervalHours));
    }
  }
}

// Professional Number Stepper Widget
class NumberStepper extends StatefulWidget {
  final int value;
  final int minValue;
  final int maxValue;
  final ValueChanged<int> onChanged;

  const NumberStepper({
    Key? key,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<NumberStepper> createState() => _NumberStepperState();
}

class _NumberStepperState extends State<NumberStepper>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animateValue() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Minus Button
          _buildStepperButton(
            icon: Icons.remove,
            onPressed:
                widget.value > widget.minValue
                    ? () {
                      HapticFeedback.lightImpact();
                      widget.onChanged(widget.value - 1);
                      _animateValue();
                    }
                    : null,
          ),

          // Value Display
          Expanded(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        widget.value.toString(),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Plus Button
          _buildStepperButton(
            icon: Icons.add,
            onPressed:
                widget.value < widget.maxValue
                    ? () {
                      HapticFeedback.lightImpact();
                      widget.onChanged(widget.value + 1);
                      _animateValue();
                    }
                    : null,
          ),
        ],
      ),
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    final bool isEnabled = onPressed != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient:
                isEnabled
                    ? LinearGradient(
                      colors: [
                        AppTheme.primaryColor.withOpacity(0.8),
                        AppTheme.primaryColor.withOpacity(0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : LinearGradient(
                      colors: [
                        Colors.grey.withOpacity(0.3),
                        Colors.grey.withOpacity(0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            borderRadius: BorderRadius.circular(12),
            boxShadow:
                isEnabled
                    ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                    : [],
          ),
          child: Icon(
            icon,
            color: isEnabled ? Colors.white : Colors.grey,
            size: 28,
          ),
        ),
      ),
    );
  }
}

final egypt = tz.getLocation('Africa/Cairo');
