import 'package:flutter/material.dart';
import '/models/medication.dart';
import '/utils/date_picker_helper.dart';
import '/widgets/dynamic_input_section.dart';
import '/widgets/input_decoration_helper.dart';
import '/widgets/input_section.dart';
import '../../models/prescription.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddPrescriptionScreen extends StatefulWidget {
  const AddPrescriptionScreen({super.key});

  @override
  State<AddPrescriptionScreen> createState() => _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends State<AddPrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _doctorNameController = TextEditingController();
  final _clinicAddressController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _specializationController = TextEditingController();
  final _notesController = TextEditingController();

  final List<TextEditingController> _medicineControllers = [
    TextEditingController(),
  ];
  final List<TextEditingController> _examinationControllers = [];
  final List<TextEditingController> _diagnosisControllers = [];

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GradientBackground(
      title: loc.addPrescription, // Localized
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
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.add_circle,
                      color: Colors.teal,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    loc.addPrescription, // Localized
                    style: AppTheme.headingStyle.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
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
                      // Doctor Name
                      InputSection(
                        label: loc.doctorName, // Localized
                        child: TextFormField(
                          controller: _doctorNameController,
                          decoration: buildInputDecoration(
                            loc.enterDoctorName,
                            fillColor: const Color(0xFFF5F5F5),
                            borderColor: Colors.purple.withOpacity(0.2),
                            outlineColor: Colors.purple,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return loc.pleaseEnterDoctorName;
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Specialization
                      InputSection(
                        label: loc.specialization, // Localized
                        child: TextFormField(
                          controller: _specializationController,
                          decoration: buildInputDecoration(
                            loc.enterSpecialization,
                            fillColor: const Color(0xFFF5F5F5),
                            borderColor: Colors.purple.withOpacity(0.2),
                            outlineColor: Colors.purple,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return loc.pleaseEnterSpecialization;
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Clinic Address
                      InputSection(
                        label: loc.clinicAddress, // Localized
                        child: TextFormField(
                          controller: _clinicAddressController,
                          decoration: buildInputDecoration(
                            loc.enterClinicAddress,
                            fillColor: const Color(0xFFF5F5F5),
                            borderColor: Colors.purple.withOpacity(0.2),
                            outlineColor: Colors.purple,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return loc.pleaseEnterClinicAddress;
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Phone Number
                      InputSection(
                        label: loc.phoneNumber, // Localized
                        child: TextFormField(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.phone,
                          decoration: buildInputDecoration(
                            loc.enterPhoneNumber,
                            fillColor: const Color(0xFFF5F5F5),
                            borderColor: Colors.purple.withOpacity(0.2),
                            outlineColor: Colors.purple,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return loc.pleaseEnterPhoneNumber;
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Date
                      InputSection(
                        label: loc.date, // Localized
                        child: GestureDetector(
                          onTap: _selectDate,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.teal.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.teal,
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

                      // Medicines
                      DynamicInputSection(
                        label: loc.medicines, // Localized
                        controllers:_medicineControllers,
                        hint: loc.enterMedicineName, // Localized
                        icon: Icons.medication,
                      ),

                      const SizedBox(height: 24),

                      // Examinations
                      DynamicInputSection(
                       label: '${loc.examinations} (${loc.optional})', // Localized
                        controllers: _examinationControllers,
                        hint:  loc.enterExamination, // Localized
                        icon: Icons.science,
                      ),

                      const SizedBox(height: 24),

                      // Diagnoses
                      DynamicInputSection(
                        label: '${loc.diagnoses} (${loc.optional})', // Localized
                        controllers: _diagnosisControllers,
                        hint: loc.enterDiagnosis, // Localized
                        icon: Icons.medical_services,
                      ),

                      const SizedBox(height: 24),

                      // Notes
                      InputSection(
                        label: '${loc.notes} (${loc.optional})', // Localized
                        child: TextFormField(
                          controller: _notesController,
                          decoration: buildInputDecoration(
                            loc.enterNotes,
                            fillColor: const Color(0xFFF5F5F5),
                            borderColor: Colors.purple.withOpacity(0.2),
                            outlineColor: Colors.purple,
                          ),
                          maxLines: 3,
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Save Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _savePrescription,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
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
                        loc.savePrescription, // Localized
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

  void _selectDate() async {
    final picked = await DatePickerHelper.selectDate(
      context,
      initialDate: _selectedDate,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _savePrescription() {
    final loc = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      final medicineNames =
          _medicineControllers
              .map((controller) => controller.text)
              .where((text) => text.isNotEmpty)
              .toList();

      final medicines =
          medicineNames.map((name) => Medication(medicineName: name)).toList();

      final examinations =
          _examinationControllers
              .map((controller) => controller.text)
              .where((text) => text.isNotEmpty)
              .toList();

      final diagnoses =
          _diagnosisControllers
              .map((controller) => controller.text)
              .where((text) => text.isNotEmpty)
              .toList();

      final newPrescription = Prescription(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        doctorName: _doctorNameController.text,
        clinicAddress: _clinicAddressController.text,
        date: _selectedDate,
        phoneNumber: _phoneNumberController.text,
        specialization: _specializationController.text,
        medicines: medicines,
        examinations: examinations,
        diagnoses: diagnoses,
        notes: _notesController.text,
      );

      Navigator.pop(context, newPrescription);
    }
  }

  @override
  void dispose() {
    _doctorNameController.dispose();
    _clinicAddressController.dispose();
    _phoneNumberController.dispose();
    _specializationController.dispose();
    _notesController.dispose();

    for (var controller in _medicineControllers) {
      controller.dispose();
    }

    for (var controller in _examinationControllers) {
      controller.dispose();
    }

    for (var controller in _diagnosisControllers) {
      controller.dispose();
    }

    super.dispose();
  }
}
