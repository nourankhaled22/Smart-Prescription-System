import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/services/medication_service.dart';
import '/widgets/input_decoration_helper.dart';
import '/widgets/input_section.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // <-- Add this import

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  int _timesPerDay = 1;
  bool _afterMeal = true;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return GradientBackground(
      //title: loc.addMedicine,
      withAppBar: true,
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SizedBox(
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
                          Icons.add_circle,
                          color: AppTheme.primaryColor,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        loc.addMedicine, // Localized
                        style: AppTheme.headingStyle.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Medicine Name
                  InputSection(
                    label: loc.medicineName, // Localized
                    child: TextFormField(
                      controller: _nameController,
                      decoration: buildInputDecoration(
                        loc.enterMedicineName, // Localized
                        fillColor: const Color(0xFFF5F5F5),
                        borderColor: Colors.purple.withOpacity(0.2),
                        outlineColor: Colors.purple,
                      ), // Localized
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return loc.pleaseEnterMedicineName; // Localized
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Dose
                  InputSection(
                    label: loc.dose, // Localized
                    child: TextFormField(
                      controller: _dosageController,
                      keyboardType: TextInputType.number,
                      decoration: buildInputDecoration(
                        loc.enterDoseAmount,
                        fillColor: const Color(0xFFF5F5F5),
                        borderColor: Colors.purple.withOpacity(0.2),
                        outlineColor: Colors.purple,
                      ), // Localized
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return loc.pleaseEnterDose; // Add this key if needed
                      //   }
                      //   return null;
                      // },
                    ),
                  ),

                  const SizedBox(height: 24),

                  InputSection(
                    label: loc.timesPerDay, // Localized
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primaryColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (_timesPerDay > 1) {
                                setState(() {
                                  _timesPerDay--;
                                });
                              }
                            },
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    _timesPerDay > 1
                                        ? AppTheme.primaryColor.withOpacity(0.1)
                                        : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.remove,
                                color:
                                    _timesPerDay > 1
                                        ? AppTheme.primaryColor
                                        : Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _timesPerDay.toString(),
                              style: AppTheme.headingStyle.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _timesPerDay++;
                              });
                            },
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.add,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Meal Timing
                  Text(
                    loc.whenToTake, // Localized
                    style: AppTheme.subheadingStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Column(
                    children: [
                      _buildMealOption(
                        title: loc.afterMealOption, // Localized
                        subtitle: loc.afterMealDesc, // Localized
                        icon: Icons.restaurant,
                        selected: _afterMeal,
                        onTap: () => setState(() => _afterMeal = true),
                      ),
                      const SizedBox(height: 12),
                      _buildMealOption(
                        title: loc.beforeMealOption, // Localized
                        subtitle: loc.beforeMealDesc, // Localized
                        icon: Icons.no_meals,
                        selected: !_afterMeal,
                        onTap: () => setState(() => _afterMeal = false),
                      ),
                    ],
                  ),

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
                      onPressed: _saveMedicine,
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
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            loc.saveMedicine, // Localized
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
      ),
    );
  }

  Widget _buildMealOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              selected
                  ? AppTheme.primaryColor.withOpacity(0.1)
                  : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppTheme.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    selected
                        ? AppTheme.primaryColor
                        : Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: selected ? Colors.white : Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.subheadingStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: selected ? AppTheme.primaryColor : AppTheme.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTheme.subheadingStyle.copyWith(
                      fontSize: 12,
                      color: AppTheme.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle, color: AppTheme.primaryColor, size: 24),
          ],
        ),
      ),
    );
  }

  void _saveMedicine() async {
    final loc = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      final token = Provider.of<AuthProvider>(context, listen: false).token;

      try {
        final newMedication = await MedicationService().addmedicine(
          token: token!,
          medicineName: _nameController.text,
          hoursPerDay: (24 / _timesPerDay).toInt(),
          frequency: _timesPerDay,
          dosage: _dosageController.text,
          duration: 30, // default duration
          afterMeal: _afterMeal,
        );
        Navigator.pop(context, newMedication);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${loc.failedToUploadExamination}: $e')),
        ); // Localized error
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }
}
