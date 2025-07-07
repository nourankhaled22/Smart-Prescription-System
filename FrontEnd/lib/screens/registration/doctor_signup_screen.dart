import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/screens/otp_verification_screen.dart';
import '/services/auth_service.dart';
import '/utils/date_picker_helper.dart';
import 'dart:io';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DoctorSignupScreen extends StatefulWidget {
  const DoctorSignupScreen({super.key});

  @override
  State<DoctorSignupScreen> createState() => _DoctorSignupScreenState();
}

class _DoctorSignupScreenState extends State<DoctorSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _specializationController = TextEditingController();
  final _dobController = TextEditingController();
  final _clinicAddressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _licenseFileName;
  File? _licenseFile;
  bool _isLoading = false;

  final List<Map<String, String>> _specializations = [
    {'en': 'Cardiology', 'ar': 'طب القلب'},
    {'en': 'Dermatology', 'ar': 'الأمراض الجلدية'},
    {'en': 'Endocrinology', 'ar': 'طب الغدد الصماء'},
    {'en': 'Gastroenterology', 'ar': 'أمراض الجهاز الهضمي'},
    {'en': 'General Surgery', 'ar': 'الجراحة العامة'},
    {'en': 'Geriatrics', 'ar': 'طب الشيخوخة'},
    {'en': 'Gynecology / Obstetrics', 'ar': 'طب النساء والتوليد'},
    {'en': 'Hematology', 'ar': 'أمراض الدم'},
    {'en': 'Infectious Diseases', 'ar': 'الأمراض المعدية'},
    {'en': 'Internal Medicine', 'ar': 'الباطنة'},
    {'en': 'Nephrology', 'ar': 'أمراض الكلى'},
    {'en': 'Neurology', 'ar': 'طب الأعصاب'},
    {'en': 'Neurosurgery', 'ar': 'جراحة الأعصاب'},
    {'en': 'Oncology', 'ar': 'الأورام'},
    {'en': 'Ophthalmology', 'ar': 'طب وجراحة العيون'},
    {'en': 'Orthopedic Surgery', 'ar': 'جراحة العظام'},
    {'en': 'Otorhinolaryngology (ENT)', 'ar': 'الأنف والأذن والحنجرة'},
    {'en': 'Pediatrics', 'ar': 'طب الأطفال'},
    {'en': 'Plastic Surgery', 'ar': 'الجراحة التجميلية'},
    {'en': 'Psychiatry', 'ar': 'الطب النفسي'},
    {'en': 'Pulmonology', 'ar': 'أمراض الصدر والرئة'},
    {'en': 'Radiology', 'ar': 'الأشعة'},
    {'en': 'Rheumatology', 'ar': 'أمراض الروماتيزم'},
    {'en': 'Urology', 'ar': 'جراحة المسالك البولية'},
    {'en': 'Anesthesiology', 'ar': 'التخدير'},
    {'en': 'Pathology', 'ar': 'علم الأمراض'},
    {'en': 'Family Medicine', 'ar': 'طب الأسرة'},
    {'en': 'Emergency Medicine', 'ar': 'طب الطوارئ'},
  ];
  String? _selectedSpecialization;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _specializationController.dispose();
    _dobController.dispose();
    _clinicAddressController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _selectFile() async {
    final loc = AppLocalizations.of(context)!;
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _licenseFileName = result.files.single.name;
          if (result.files.single.path != null) {
            _licenseFile = File(result.files.single.path!);
          }
        });

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc.fileUploadedSuccessfully), // Localized
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      // Handle any errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${loc.errorPickingFile}: $e',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _createAccount() async {
    final loc = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      if (_licenseFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.pleaseUploadMedicalLicense), // Localized
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Convert DOB to ISO format
        String dobIso;
        try {
          final parts = _dobController.text.split('/');
          if (parts.length == 3) {
            final day = int.parse(parts[0]);
            final month = int.parse(parts[1]);
            final year = int.parse(parts[2]);
            dobIso = DateTime(year, month, day).toIso8601String();
          } else {
            dobIso = _dobController.text;
          }
        } catch (e) {
          dobIso = _dobController.text;
        }

        await AuthService().registerDoctor(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          password: _passwordController.text.trim(),
          dateOfBirth: dobIso,
          clinicAddress: _clinicAddressController.text.trim(),
           specialization: _selectedSpecialization ?? '',
          licence: _licenseFile,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                loc.accountCreatedSuccessfully ,
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => OtpVerificationScreen(
                    phoneNumber: _phoneController.text.trim(),
                    sendOtp: AuthService().sendOtp,
                    verifyOtp:
                        Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        ).verifyOtp,
                  ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${loc.registrationFailed }: $e',
            ),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return GradientBackground(
      title: loc.doctorRegistration, // Localized
      withAppBar: true,
      showBackButton: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Personal Information Section
              _buildSectionHeader(loc.personalInformation), // Localized
              const SizedBox(height: 16),

              // First name and last name
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _firstNameController,
                      label: loc.firstName, // Localized
                      hintText: 'John',
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return loc.required; // Localized
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _lastNameController,
                      label: loc.lastName, // Localized
                      hintText: 'Doe',
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return loc.required; // Localized
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Date of Birth
              _buildTextField(
                controller: _dobController,
                label: loc.dateOfBirth, // Localized
                hintText: 'DD/MM/YYYY',
                prefixIcon: Icons.calendar_today,
                readOnly: true,
                onTap: () async {
                  final picked = await DatePickerHelper.selectDate(
                    context,
                    firstDate: DateTime.now(),
                    initialDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _dobController.text =
                          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.selectDateOfBirth; // Localized
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Professional Information Section
              _buildSectionHeader(loc.professionalInformation), // Localized
              const SizedBox(height: 16),

              // Specialization Dropdown
              _buildDropListInput(
                controller: _specializationController,
                prefixIcon: Icons.medical_information,
                hintText: loc.specialization, // Localized
                label: loc.specialization, // Localized
                items:
                    _specializations
                        .map((spec) => isArabic ? spec['ar']! : spec['en']!)
                        .toList(),
                onChange: (value) {
                  setState(() {
                    _selectedSpecialization = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Clinic Address
              _buildTextField(
                controller: _clinicAddressController,
                label: loc.clinicAddress, // Localized
                hintText: loc.enterClinicAddress, // Localized
                prefixIcon: Icons.location_on_outlined,
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.pleaseEnterClinicAddress; // Localized
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // License Upload
              _buildFileUpload(loc), // Localized
              const SizedBox(height: 24),

              // Account Information Section
              _buildSectionHeader(loc.accountInformation), // Localized
              const SizedBox(height: 16),

              // Phone Number
              _buildTextField(
                controller: _phoneController,
                label: loc.phoneNumber, // Localized
                hintText: '01189495787',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.pleaseEnterPhoneNumber ??
                        'Please enter your PhoneNumber';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password
              _buildTextField(
                controller: _passwordController,
                label: loc.password, // Localized
                hintText: '••••••••',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppTheme.textGrey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.enterPassword; // Localized
                  }
                  if (value.length < 6) {
                    return loc.passwordMinLength; // Localized
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirm Password
              _buildTextField(
                controller: _confirmPasswordController,
                label: loc.confirmPassword, // Localized
                hintText: '••••••••',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppTheme.textGrey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.confirmYourPassword; // Localized
                  }
                  if (value != _passwordController.text) {
                    return loc.passwordsDoNotMatch; // Localized
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Create Account Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
                          : Text(
                            loc.createAccount, // Localized
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 24),

              // Terms and Conditions
              Center(
                child: Text(
                  loc.termsAndConditions, // Localized
                  style: AppTheme.subheadingStyle.copyWith(
                    fontSize: 12,
                    color: AppTheme.textGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.headingStyle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 3,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.subheadingStyle.copyWith(
            color: AppTheme.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          style: AppTheme.subheadingStyle.copyWith(
            color: AppTheme.black,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(prefixIcon, color: AppTheme.primaryColor),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppTheme.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppTheme.primaryColor,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropListInput({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData prefixIcon,
    required List<String> items,
    ValueChanged<String?>? onChange,
  }) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.subheadingStyle.copyWith(
            color: AppTheme.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedSpecialization,
          items:
              items
                  .map(
                    (spec) => DropdownMenuItem(value: spec, child: Text(spec)),
                  )
                  .toList(),
          onChanged: onChange,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.medical_services_outlined,
              color: AppTheme.primaryColor,
            ),
            filled: true,
            fillColor: AppTheme.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppTheme.primaryColor,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return loc.pleaseSelectSpecialization; // Localized
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildFileUpload(AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.medicalLicense, // Localized
          style: AppTheme.subheadingStyle.copyWith(
            color: AppTheme.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectFile,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    _licenseFile != null
                        ? AppTheme.primaryColor
                        : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.upload_file,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _licenseFileName ??
                            loc.uploadMedicalLicense, // Localized
                        style: AppTheme.subheadingStyle.copyWith(
                          color:
                              _licenseFileName != null
                                  ? AppTheme.black
                                  : AppTheme.textGrey,
                          fontWeight:
                              _licenseFileName != null
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_licenseFileName != null)
                        Text(
                          'PDF file',
                          style: AppTheme.subheadingStyle.copyWith(
                            fontSize: 12,
                            color: AppTheme.textGrey,
                          ),
                        ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: _selectFile,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      loc.browse, // Localized
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_licenseFile != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 4),
                Text(
                  loc.fileUploadedSuccessfully, // Localized
                  style: AppTheme.subheadingStyle.copyWith(
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
