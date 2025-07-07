import 'package:flutter/material.dart';
import '/providers/auth_provider.dart';
import '/services/auth_service.dart';
import '/utils/date_picker_helper.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import 'package:provider/provider.dart';
import './signup_section_header.dart';
import './signup_text_field.dart';
import '../otp_verification_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatientSignupScreen extends StatefulWidget {
  const PatientSignupScreen({super.key});

  @override
  State<PatientSignupScreen> createState() => _PatientSignupScreenState();
}

class _PatientSignupScreenState extends State<PatientSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  DateTime? _selectedDob;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _createAccount() async {
    try {
      if (_formKey.currentState!.validate()) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        await authProvider.register(
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          _phoneController.text.trim(),
          _passwordController.text.trim(),
          _nationalIdController.text.trim(),
          _selectedDob != null
              ? _selectedDob!.toIso8601String()
              : '', // <-- ISO format
          _addressController.text.trim(),
        );
        if (mounted) {
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
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst("Exception: ", "")),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isLoading = context.watch<AuthProvider>().isLoading;
    return GradientBackground(
      title: loc.patientRegistration, // Localized
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

                // Personal Information Section
                SignupSectionHeader(
                  title: loc.personalInformation,
                ), // Localized
                const SizedBox(height: 16),

                // First name and last name
                Row(
                  children: [
                    Expanded(
                      child: SignupTextField(
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
                      child: SignupTextField(
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

                // Phone number
                SignupTextField(
                  controller: _phoneController,
                  label: loc.phoneNumber, // Localized
                  hintText: '+20 122 333 1444',
                  prefixIcon: Icons.phone_android,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return loc.enterPhone; // Localized
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // National ID
                SignupTextField(
                  controller: _nationalIdController,
                  label: loc.nationalId, // Localized
                  hintText: loc.enterNationalId, // Localized
                  prefixIcon: Icons.badge_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return loc.pleaseEnterNationalId ??
                          'Please enter your national ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date of Birth
                SignupTextField(
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
                        _selectedDob = picked; // Store as DateTime
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

                // Account Information Section
                SignupSectionHeader(title: loc.accountInformation), // Localized
                const SizedBox(height: 16),

                // Address (optional)
                SignupTextField(
                  controller: _addressController,
                  label: loc.address, // Localized
                  hintText: 'Giza, Egypt',
                  prefixIcon: Icons.location_city_outlined,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return loc.pleaseEnterAddress; // Localized
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                SignupTextField(
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
                SignupTextField(
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
                    onPressed: isLoading ? null : _createAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child:
                        isLoading
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
                      fontSize: 14,
                      color: AppTheme.textGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
