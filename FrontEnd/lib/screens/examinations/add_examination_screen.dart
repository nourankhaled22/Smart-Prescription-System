import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '/widgets/input_decoration_helper.dart';
import '/widgets/input_section.dart';
import '../../services/examination_service.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add this import

class AddExaminationScreen extends StatefulWidget {
  const AddExaminationScreen({super.key});

  @override
  State<AddExaminationScreen> createState() => _AddExaminationScreenState();
}

class _AddExaminationScreenState extends State<AddExaminationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _datecontroller = TextEditingController();
  DateTime? _selectedDate;
  String? _pdfPath;
  String? _pdfName;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance

    return GradientBackground(
      //title: loc.addNewExamination,
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
                    loc.addNewExamination, // Localized
                    style: AppTheme.headingStyle.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
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
                    fillColor:  const Color(0xFFF5F5F5),
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
                  onTap: () => _selectDate(context),
                  controller: _datecontroller,
                  decoration: buildInputDecoration(
                    "'DD/MM/YYYY",
                    fillColor:  const Color(0xFFF5F5F5),
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
              // PDF Upload
              InputSection(
                label: loc.uploadPdf, // Localized
                child: GestureDetector(
                  onTap: _pickPDF,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.upload_file,
                          color: AppTheme.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _pdfName ?? loc.uploadPdfFile, // Localized
                            style: AppTheme.subheadingStyle.copyWith(
                              color:
                                  _pdfName != null
                                      ? AppTheme.black
                                      : AppTheme.textGrey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  onPressed: _saveExamination,
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
                        loc.saveExamination, // Localized
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppTheme.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked; // Store as DateTime
        _datecontroller.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  void _pickPDF() async {
    final loc = AppLocalizations.of(context)!;
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _pdfPath = result.files.single.path;
          _pdfName = result.files.single.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${loc.failedToUploadExamination}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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

      if (_pdfPath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.pleaseUploadPdf), // Localized
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        final token = Provider.of<AuthProvider>(context, listen: false).token;
        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc.authenticationError), // Localized
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final newExamination = await ExaminationService().addExamination(
          token: token,
          examinationName: _nameController.text.trim(),
          date: _selectedDate!,
          file: File(_pdfPath!),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.examinationUploaded), // Localized
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, newExamination);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${loc.failedToUploadExamination}: $e'), // Localized
            backgroundColor: Colors.red,
          ),
        );
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
