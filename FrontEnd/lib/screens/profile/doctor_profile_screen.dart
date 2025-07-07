import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/services/auth_service.dart';
import '/utils/age_helper.dart';
import '/utils/date_picker_helper.dart';
import '/widgets/profile_info_item.dart';
import '../../models/userModel.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import "../../utils/date_formatter.dart";

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  UserModel? _profile;

  late TextEditingController _nameController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _specializationController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _dobController;
  late TextEditingController _nationalIdController;
  late TextEditingController _ageController;
  bool _isEditing = false;
  bool _isLoading = true;
  bool _showChangePassword = false;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  bool _isChangingPassword = false;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  void _changePassword() async {
    final loc = AppLocalizations.of(context)!;
    if (!_passwordFormKey.currentState!.validate()) return;
    setState(() => _isChangingPassword = true);

    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;

      await AuthService().changePassword(
        token: token!,
        oldPassword: _oldPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );
      setState(() {
        _showChangePassword = false;
        _oldPasswordController.clear();
        _newPasswordController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.profileUpdated), // Localized
          backgroundColor: AppTheme.accentColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.failedToUpdateProfile(e.toString())), // Localized
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      setState(() => _isChangingPassword = false);
    }
  }

  Future<void> _fetchProfile() async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final profile = await AuthService().getProfile(token!, "doctor");
      setState(() {
        _profile = profile;
        _nameController = TextEditingController(text: _profile!.firstName);
        _firstNameController = TextEditingController(text: _profile!.firstName);

        _lastNameController = TextEditingController(text: _profile!.lastName);
        _phoneController = TextEditingController(text: _profile!.phoneNumber);
        _addressController = TextEditingController(
          text: _profile!.clinicAddress ?? "",
        );
        _dobController = TextEditingController(
          text: formatDate(_profile!.dateOfBirth),
        );
        _nationalIdController = TextEditingController(
          text: _profile!.nationalId,
        );
        _specializationController = TextEditingController(
          text: _profile!.specialization,
        );
        _ageController = TextEditingController(
          text:
              AgeHelper.calculateAge(
                formatDate(_profile!.dateOfBirth),
              ).toString(),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.failedToUpdateProfile(e.toString()),
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specializationController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _nationalIdController.dispose();
    _ageController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GradientBackground(
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.lightBlue.withOpacity(
                                        0.3,
                                      ),
                                      border: Border.all(
                                        color: AppTheme.primaryColor
                                            .withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      size: 50,
                                      color: AppTheme.primaryColor.withOpacity(
                                        0.7,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '${_profile!.firstName} ${_profile!.lastName}',
                                style: AppTheme.headingStyle.copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                ),
                              ),

                              const SizedBox(height: 40),
                              ProfileInfoItem(
                                label: loc.firstName, // Localized
                                value: _isEditing ? null : _profile!.firstName,
                                controller:
                                    _isEditing ? _firstNameController : null,
                                icon: Icons.person_outline,
                                keyboardType: TextInputType.text,
                              ),

                              const SizedBox(height: 20),
                              // Profile Fields
                              ProfileInfoItem(
                                label: loc.lastName, // Localized
                                value: _isEditing ? null : _profile!.lastName,
                                controller:
                                    _isEditing ? _lastNameController : null,
                                icon: Icons.person_outline,
                                keyboardType: TextInputType.text,
                              ),

                              const SizedBox(height: 20),

                              // Specialization
                              ProfileInfoItem(
                                label: loc.specialization, // Localized
                                value:
                                    _isEditing
                                        ? null
                                        : _profile!.specialization,
                                controller:
                                    _isEditing
                                        ? _specializationController
                                        : null,
                                icon: Icons.medical_services_outlined,
                              ),

                              const SizedBox(height: 20),

                              // Phone Number
                              ProfileInfoItem(
                                label: loc.phone, // Localized
                                value: _profile!.phoneNumber,
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                controller:
                                    _isEditing ? _phoneController : null,
                                readOnly: true,
                              ),

                              const SizedBox(height: 20),

                              // Clinic Address
                              ProfileInfoItem(
                                label: loc.clinicAddress, // Localized
                                value:
                                    _isEditing ? null : _addressController.text,
                                controller:
                                    _isEditing ? _addressController : null,
                                icon: Icons.location_on_outlined,
                              ),

                              const SizedBox(height: 20),

                              // Date of Birth
                              ProfileInfoItem(
                                label: loc.dateOfBirth, // Localized
                                value:
                                    _isEditing
                                        ? null
                                        : formatDate(_profile!.dateOfBirth),
                                controller: _isEditing ? _dobController : null,
                                icon: Icons.calendar_today_outlined,
                                readOnly: true,
                                onTap:
                                    _isEditing
                                        ? () => DatePickerHelper.selectDate(
                                          context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                        )
                                        : null,
                              ),

                              const SizedBox(height: 20),

                              ProfileInfoItem(
                                label: loc.age, // Localized
                                value: _isEditing ? null : _ageController.text,
                                controller: _isEditing ? _ageController : null,
                                icon: Icons.cake_outlined,
                                readOnly: true,
                              ),

                              SizedBox(height: 10),
                              if (!_isEditing)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _showChangePassword =
                                              !_showChangePassword;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.lock,
                                        color: AppTheme.primaryColor,
                                      ),
                                      label: Text(
                                        _showChangePassword
                                            ? loc
                                                .cancelChangePassword // Localized
                                            : loc.changePassword, // Localized
                                        style: TextStyle(
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    if (_showChangePassword)
                                      Form(
                                        key: _passwordFormKey,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              controller:
                                                  _oldPasswordController,
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                labelText:
                                                    loc.oldPassword, // Localized
                                                prefixIcon: Icon(
                                                  Icons.lock_outline,
                                                  color: AppTheme.primaryColor,
                                                  size: 24,
                                                ),
                                              ),
                                              validator:
                                                  (value) =>
                                                      value == null ||
                                                              value.isEmpty
                                                          ? loc
                                                              .enterOldPassword // Localized
                                                          : null,
                                            ),
                                            const SizedBox(height: 20),
                                            TextFormField(
                                              controller:
                                                  _newPasswordController,
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                labelText:
                                                    loc.newPassword, // Localized
                                                prefixIcon: Icon(
                                                  Icons.lock,
                                                  color: AppTheme.primaryColor,
                                                  size: 24,
                                                ),
                                              ),
                                              validator:
                                                  (value) =>
                                                      value == null ||
                                                              value.length < 6
                                                          ? loc
                                                              .enterAtLeast6Chars // Localized
                                                          : null,
                                            ),
                                            const SizedBox(height: 16),
                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed:
                                                    _isChangingPassword
                                                        ? null
                                                        : _changePassword,
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppTheme.accentColor,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 14,
                                                      ),
                                                ),
                                                child:
                                                    _isChangingPassword
                                                        ? const SizedBox(
                                                          width: 24,
                                                          height: 24,
                                                          child:
                                                              CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                        )
                                                        : Text(
                                                          loc.updatePassword, // Localized
                                                        ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              const SizedBox(height: 40),

                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),

                      if (_isEditing)
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _saveChanges,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                loc.saveChanges, // Localized
                                style: AppTheme.buttonTextStyle.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  Positioned(
                    top: 0,
                    right: 20,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = !_isEditing;
                          _showChangePassword = false;
                          if (!_isEditing) {
                            _specializationController.text =
                                _profile!.specialization ?? '';
                            _phoneController.text = _profile!.phoneNumber;
                            _addressController.text =
                                _profile!.clinicAddress ?? "";
                            _dobController.text = formatDate(
                              _profile!.dateOfBirth,
                            );
                            _nationalIdController.text = _profile!.nationalId!;
                            _ageController.text =
                                AgeHelper.calculateAge(
                                  formatDate(_profile!.dateOfBirth),
                                ).toString();
                          }
                        });
                      },
                      icon: Icon(
                        _isEditing ? Icons.close : Icons.edit,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  void _saveChanges() async {
    final loc = AppLocalizations.of(context)!;
    // Validate fields
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty ||
        _dobController.text.trim().isEmpty ||
        _specializationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.pleaseFillAllFields), // Localized
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      // Convert date of birth to ISO format if needed
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

      final updatedProfile = await AuthService().updateProfile(
        token: token!,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        nationalId: _nationalIdController.text.trim(),
        dateOfBirth: dobIso,
        clinicAddress: _addressController.text.trim(),
        specialization: _specializationController.text.trim(),
        role: "doctor",
      );

      setState(() {
        _profile = updatedProfile;
        _isEditing = false;
        _ageController.text =
            AgeHelper.calculateAge(
              formatDate(_profile!.dateOfBirth),
            ).toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.profileUpdated), // Localized
          backgroundColor: AppTheme.accentColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.failedToUpdateProfile(e.toString())), // Localized
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
