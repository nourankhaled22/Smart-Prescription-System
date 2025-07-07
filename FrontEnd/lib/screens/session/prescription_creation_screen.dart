import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/models/userModel.dart';
import '/screens/session/prescription_preview_screen.dart';
import '/widgets/diagnosis_step.dart';
import '/widgets/examination_step.dart';
import '/widgets/medication_step.dart';
import '/widgets/notes_step.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrescriptionWriterScreen extends StatefulWidget {
  final UserModel patient;

  const PrescriptionWriterScreen({super.key, required this.patient});

  @override
  State<PrescriptionWriterScreen> createState() =>
      _PrescriptionWriterScreenState();
}

class _PrescriptionWriterScreenState extends State<PrescriptionWriterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _diagnosisController = TextEditingController();
  final _notesController = TextEditingController();
  final _dosageController = TextEditingController();

  // Data
  List<Map<String, dynamic>> medications = [];
  List<Map<String, dynamic>> examinations = [];
  int currentStep = 0;

  @override
  void dispose() {
    _diagnosisController.dispose();
    _notesController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final List<String> stepTitles = [
      loc.diagnosis,
      loc.medicine,
      loc.examinations,
      loc.notes,
    ];
    final List<IconData> stepIcons = [
      Icons.medical_services,
      Icons.medication,
      Icons.assignment,
      Icons.note_alt,
    ];
    final List<Color> stepColors = [
      AppTheme.primaryColor,
      AppTheme.primaryColor,
      AppTheme.primaryColor,
      AppTheme.primaryColor,
    ];

    return GradientBackground(
      title: loc.typePrescription, // Localized
      withAppBar: true,
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Modern Step Indicator
            Container(
              margin: const EdgeInsets.fromLTRB(24, 24, 24, 1),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    stepColors[currentStep].withOpacity(0.1),
                    Colors.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: stepColors[currentStep].withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Progress Bar
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      children: List.generate(4, (index) {
                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
                            decoration: BoxDecoration(
                              color:
                                  index <= currentStep
                                      ? stepColors[currentStep]
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Current Step Info
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: stepColors[currentStep].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          stepIcons[currentStep],
                          color: stepColors[currentStep],
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.stepOf('${currentStep + 1}', '4'), // Localized
                              style: AppTheme.subheadingStyle.copyWith(
                                fontSize: 12,
                                color: AppTheme.textGrey,
                              ),
                            ),
                            Text(
                              stepTitles[currentStep],
                              style: AppTheme.headingStyle.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: stepColors[currentStep],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content Area
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SingleChildScrollView(child: _buildCurrentStepContent()),
              ),
            ),

            // Modern Navigation Buttons
            Container(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Row(
                children: [
                  if (currentStep > 0) ...[
                    Expanded(
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                currentStep--;
                              });
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  color: Colors.grey.shade600,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  loc.previous, // Localized
                                  style: AppTheme.subheadingStyle.copyWith(
                                    color: Colors.grey.shade600,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    flex: currentStep > 0 ? 1 : 1,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            stepColors[currentStep],
                            stepColors[currentStep].withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: stepColors[currentStep].withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _handleNextStep,
                          borderRadius: BorderRadius.circular(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                currentStep == 3
                                    ? loc.preview // Localized
                                    : loc.nextStep, // Localized
                                style: AppTheme.subheadingStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                currentStep == 3
                                    ? Icons.preview
                                    : Icons.arrow_forward,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (currentStep) {
      case 0:
        return DiagnosisStep(controller: _diagnosisController);
      case 1:
        return MedicineStepFixed(
          medications: medications,
          onMedicationsChanged: (newMedications) {
            setState(() {
              medications = newMedications;
            });
          },
        );
      case 2:
        return ExaminationsStepFixed(
          examinations: examinations,
          onExaminationsChanged: (newExaminations) {
            setState(() {
              examinations = newExaminations;
            });
          },
        );
      case 3:
        return NotesStep(controller: _notesController);
      default:
        return Container();
    }
  }

  void _handleNextStep() {
    final loc = AppLocalizations.of(context)!;
    if (currentStep < 3) {
      bool isValid = true;

      switch (currentStep) {
        case 0:
          if (_diagnosisController.text.isEmpty) {
            _showError(loc.pleaseEnterDiagnosis); // Localized
            isValid = false;
          }
          break;
        case 1:
          if (medications.isEmpty) {
            _showError(loc.pleaseAddAtLeastOneMedication); // Localized
            isValid = false;
          }
          break;
      }

      if (isValid) {
        setState(() {
          currentStep++;
        });
      }
    } else {
      _generatePrescription();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _generatePrescription() async {
    try {
      final prescriptionData = <String, dynamic>{
        'diagnoses': [_diagnosisController.text.trim()],
        'medicines': List<Map<String, dynamic>>.from(medications),
        'examinations':
            examinations.map((e) => e['examinationName'].toString()).toList(),
        'notes': _notesController.text.trim(),
        'dosage': [_dosageController.text],
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrescriptionPreviewScreen(
            prescriptionData: prescriptionData,
            patient: widget.patient,
          ),
        ),
      );
    } catch (e) {
      final loc = AppLocalizations.of(context)!;
      _showError(loc.failedToSavePrescription(e.toString())); // Localized
    }
  }
}
