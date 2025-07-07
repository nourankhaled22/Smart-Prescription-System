import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/services/auth_service.dart';
import '/utils/age_helper.dart';
import '/widgets/profile_info_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

import '../../models/userModel.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/gradient_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import "../../utils/date_formatter.dart";

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  UserModel? _profile;

  late TextEditingController _nameController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _dobController;
  late TextEditingController _nationalIdController;
  late TextEditingController _ageController;
  bool _isEditing = false;
  bool _isLoading = true;
  bool _isSaving = false;
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

  Future<void> _fetchProfile() async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final profile = await AuthService().getProfile(token!, "patient");
      setState(() {
        _profile = profile;
        _nameController = TextEditingController(text: _profile!.firstName);
        _firstNameController = TextEditingController(text: _profile!.firstName);
        _lastNameController = TextEditingController(text: _profile!.lastName);
        _phoneController = TextEditingController(text: _profile!.phoneNumber);
        _addressController = TextEditingController(
          text: _profile!.address ?? "",
        );
        _dobController = TextEditingController(
          text: formatDate(_profile!.dateOfBirth),
        );
        _nationalIdController = TextEditingController(
          text: _profile!.nationalId,
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

  Future<String> fetchQrUrl(String nationalId) async {
    String token = Provider.of<AuthProvider>(context, listen: false).token!;
    // Replace with your actual API endpoint
    final response = await http.get(
      Uri.parse(
        'https://graduationproject-production-6bc5.up.railway.app/api/patient/generate-qr/',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['qrUrl'];
    } else {
      throw Exception('Failed to fetch QR');
    }
  }

  Future<Uint8List> fetchQrBytes(String nationalId) async {
    String token = Provider.of<AuthProvider>(context, listen: false).token!;
    final response = await http.get(
      Uri.parse(
        'https://graduationproject-production-6bc5.up.railway.app/api/patient/generate-qr/',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      // If the API returns raw bytes:
      return response.bodyBytes;
      // If the API returns base64 string:
      // return base64Decode(json.decode(response.body)['qr']);
    } else {
      throw Exception('Failed to fetch QR');
    }
  }

  void _showQrDialog() async {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    try {
      final qrBytes = await fetchQrBytes(_profile!.nationalId!);
      Navigator.of(context).pop(); // Close loading dialog
      showDialog(
        context: context,
        builder:
            (context) => Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      loc.patientQrCode, // Localized
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 20,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Image.memory(
                      qrBytes,
                      width: 220,
                      height: 220,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${_profile!.firstName} ${_profile!.lastName}',
                      style: AppTheme.subheadingStyle.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Text(
                    //   '${loc.nationalId}: ${_profile!.nationalId}', // Localized
                    //   style: AppTheme.subheadingStyle.copyWith(
                    //     color: AppTheme.textGrey,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.failedToUpdateProfile(e.toString()))),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _nationalIdController.dispose();
    _ageController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
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
          content: Text(loc.profileUpdated),
          backgroundColor: AppTheme.accentColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.failedToUpdateProfile(e.toString())),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      setState(() => _isChangingPassword = false);
    }
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
                              // Profile Picture
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
                              // Name
                              Text(
                                '${_profile!.firstName} ${_profile!.lastName}',
                                style: AppTheme.headingStyle.copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                ),
                              ),

                              const SizedBox(height: 44),
                              // Profile Fields
                              ProfileInfoItem(
                                label: loc.firstName, // Localized
                                value: _isEditing ? null : _profile!.firstName,
                                controller:
                                    _isEditing ? _firstNameController : null,
                                icon: Icons.person_outline,
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(height: 20),
                              ProfileInfoItem(
                                label: loc.lastName, // Localized
                                value: _isEditing ? null : _profile!.lastName,
                                controller:
                                    _isEditing ? _lastNameController : null,
                                icon: Icons.person_outline,
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(height: 20),
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
                              ProfileInfoItem(
                                label: loc.address, // Localized
                                value: _profile!.address ?? "",
                                controller:
                                    _isEditing ? _addressController : null,
                                icon: Icons.location_on_outlined,
                              ),
                              const SizedBox(height: 20),
                              ProfileInfoItem(
                                label: loc.nationalId, // Localized
                                value: _isEditing ? null : _profile!.nationalId,
                                controller:
                                    _isEditing ? _nationalIdController : null,
                                icon: Icons.badge_outlined,
                                keyboardType: TextInputType.number,
                                readOnly: true,
                              ),
                              const SizedBox(height: 20),
                              ProfileInfoItem(
                                label: loc.dateOfBirth, // Localized
                                value:
                                    _isEditing
                                        ? null
                                        : formatDate(_profile!.dateOfBirth),
                                controller: _isEditing ? _dobController : null,
                                icon: Icons.calendar_today_outlined,
                                // readOnly: true,
                                onTap:
                                    _isEditing
                                        ? () => _selectDate(context)
                                        : null,
                              ),
                              const SizedBox(height: 20),
                              // Age field (read-only)
                              ProfileInfoItem(
                                label: loc.age, // Localized
                                value: _isEditing ? null : _ageController.text,
                                controller: _isEditing ? _ageController : null,
                                icon: Icons.cake_outlined,
                                readOnly: true,
                              ),
                              const SizedBox(height: 24),
                              // Change Password Section
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

                              // QR Button
                              if (!_isEditing && !_showChangePassword)
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _showQrDialog,
                                    icon: const Icon(Icons.qr_code),
                                    label: Text(loc.showQrCode), // Localized
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      // Save Button
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
                              child:
                                  _isSaving
                                      ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                      : Text(
                                        loc.saveChanges, // Localized
                                        style: AppTheme.buttonTextStyle
                                            .copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  // Edit button
                  Positioned(
                    top: 0,
                    right: 20,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = !_isEditing;
                          _showChangePassword =
                              false; // Reset change password state
                          if (!_isEditing) {
                            _firstNameController.text = _profile!.firstName;
                            _lastNameController.text = _profile!.lastName;
                            _dobController.text = formatDate(
                              _profile!.dateOfBirth,
                            );
                            _phoneController.text = _profile!.phoneNumber;
                            _addressController.text = _profile!.address ?? "";
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text = '${picked.day}/${picked.month}/${picked.year}';
        _ageController.text =
            AgeHelper.calculateAge(_dobController.text).toString();
      });
    }
  }

  void _saveChanges() async {
    final loc = AppLocalizations.of(context)!;
    // Validate fields
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty ||
        _nationalIdController.text.trim().isEmpty ||
        _dobController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.pleaseFillAllFields), // Localized
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
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
        address: _addressController.text.trim(),
        role: "patient",
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
        _isSaving = false;
      });
    }
  }
}
