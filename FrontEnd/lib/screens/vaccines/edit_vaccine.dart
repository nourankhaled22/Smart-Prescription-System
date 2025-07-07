import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/utils/date_picker_helper.dart';
import '/widgets/input_decoration_helper.dart';
import '/widgets/input_section.dart';

import '../../../models/vaccine.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/gradient_background.dart';
import '../../../providers/auth_provider.dart';
import '../../services/vaccine_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditVaccineScreen extends StatefulWidget {
  final Vaccine vaccine;

  const EditVaccineScreen({super.key, required this.vaccine});

  @override
  State<EditVaccineScreen> createState() => _EditVaccineScreenState();
}

class _EditVaccineScreenState extends State<EditVaccineScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  final _datecontroller = TextEditingController();

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.vaccine.vaccineName);
    _selectedDate = widget.vaccine.date;
    // Set the date controller's text to the formatted date
    if (_selectedDate != null) {
      _datecontroller.text =
          "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      //title: 'Edit vaccine',
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
                      Icons.edit,
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
                          AppLocalizations.of(context)!.editVaccine,
                          style: AppTheme.headingStyle.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        Text(
                          widget.vaccine.vaccineName,
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

              // vaccine Name
              InputSection(
                label: AppLocalizations.of(context)!.vaccineName,
                child: TextFormField(
                  controller: _nameController,
                  decoration: buildInputDecoration(
                    "Enter vaccine name",
                    fillColor: const Color(0xFFF5F5F5),
                    borderColor: Colors.purple.withOpacity(0.2),
                    outlineColor: Colors.purple,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter vaccine name';
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

              const SizedBox(height: 24),

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
                  onPressed: _savevaccine,
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
                        AppLocalizations.of(context)!.updateVaccine,
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

  void _savevaccine() async {
    if (_formKey.currentState!.validate()) {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final newvaccine = Vaccine(
        id: widget.vaccine.id,
        vaccineName: _nameController.text,
        date: _selectedDate,
      );
      print(newvaccine.toJson());
      try {
        await VaccineService().updatevaccine(
          token!,
          newvaccine.id,
          newvaccine.vaccineName,
          _selectedDate.toString(),
        );
        Navigator.pop(context, newvaccine);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save vaccine: $e')));
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
