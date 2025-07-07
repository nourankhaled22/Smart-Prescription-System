import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/utils/date_picker_helper.dart';
import '/widgets/input_decoration_helper.dart';
import '/widgets/input_section.dart';
import '../../models/examination.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import '../../services/examination_service.dart';
import '../../providers/auth_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add this import

class EditExaminationScreen extends StatefulWidget {
  final Examination examination;

  const EditExaminationScreen({super.key, required this.examination});

  @override
  State<EditExaminationScreen> createState() => _EditExaminationScreenState();
}

class _EditExaminationScreenState extends State<EditExaminationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  final _datecontroller = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.examination.examinationName,
    );
    _selectedDate = widget.examination.date;
    if (_selectedDate != null) {
      _datecontroller.text =
          "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance

    return GradientBackground(
      // title: loc.editExamination,
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
                          loc.editExamination, // Localized
                          style: AppTheme.headingStyle.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        Text(
                          widget.examination.examinationName,
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

              // Examination Name
              InputSection(
                label: loc.examinationName, // Localized
                child: TextFormField(
                  controller: _nameController,
                  decoration: buildInputDecoration(
                    loc.enterExaminationName,
                    fillColor: const Color(0xFFF5F5F5),
                    borderColor: Colors.purple.withOpacity(0.2),
                    outlineColor: Colors.purple,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return loc.enterExaminationName; // Localized
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Date
              InputSection(
                label: loc.date, // Localized
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
                      return loc.enterDate; // Localized
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 24),

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
                  onPressed: _isLoading ? null : _saveExamination,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                loc.updateExamination, // Localized
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

  void _saveExamination() async {
    final loc = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.pleaseSelectDate), // Localized
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        final token = Provider.of<AuthProvider>(context, listen: false).token;

        final newExamination = await ExaminationService().updateExaminationJson(
          token: token!,
          examinationId: widget.examination.id,
          examinationName: _nameController.text.trim(),
          date: _selectedDate!,
          // file: fileToSend,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.examinationUpdated), // Localized
            backgroundColor: Colors.green,
          ),
        );
        if (mounted) {
          Navigator.pop(context, newExamination);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${loc.failedToUpdateExamination}: $e'), // Localized
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
