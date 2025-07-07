import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/utils/date_picker_helper.dart';
import '/widgets/input_decoration_helper.dart';
import '/widgets/input_section.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/allergy_service.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/gradient_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddAllergyScreen extends StatefulWidget {
  const AddAllergyScreen({super.key});

  @override
  State<AddAllergyScreen> createState() => _AddAllergyScreenState();
}

class _AddAllergyScreenState extends State<AddAllergyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _datecontroller = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      // title: 'Add Allergy',
      withAppBar: true,
      showBackButton: true,
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
                    child: Icon(
                      Icons.add_circle,
                      color: AppTheme.primaryColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    AppLocalizations.of(context)!.addNewAllergy,
                    style: AppTheme.headingStyle.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Allergy Name
              InputSection(
                label: AppLocalizations.of(context)!.allergyName,
                child: TextFormField(
                  controller: _nameController,
                  decoration: buildInputDecoration(
                    "Enter allergy name",
                    fillColor: const Color(0xFFF5F5F5),
                    borderColor: Colors.purple.withOpacity(0.2),
                    outlineColor: Colors.purple,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter allergy name';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Date
              InputSection(
                label: AppLocalizations.of(context)!.date,
                child: TextFormField(
                  onTap: () async {
                    FocusScope.of(
                      context,
                    ).requestFocus(FocusNode()); // Prevent keyboard
                    final picked = await DatePickerHelper.selectDate(
                      context,
                      firstDate: DateTime(1900),
                      initialDate: _selectedDate ?? DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                        _datecontroller.text =
                            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                      });
                    }
                  },
                  controller: _datecontroller,
                  decoration: buildInputDecoration(
                    "DD/MM/YYYY",
                    fillColor: const Color(0xFFF5F5F5),
                    borderColor: Colors.purple.withOpacity(0.2),
                    outlineColor: Colors.purple,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Date';
                    }
                    return null;
                  },
                ),
              ),

              const Spacer(),

              // Save Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _saveAllergy,
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
                      Icon(Icons.check_circle, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context)!.saveAllergy,
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
    );
  }

  void _saveAllergy() async {
    if (_formKey.currentState!.validate()) {
      final token = Provider.of<AuthProvider>(context, listen: false).token;

      try {
        final newAllergy = await AllergyService().addAllergy(
          token!,
          _nameController.text,
          _selectedDate.toString(),
        );
        Navigator.pop(context, newAllergy);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save allergy: $e')));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _datecontroller.dispose();
    super.dispose();
  }
}
