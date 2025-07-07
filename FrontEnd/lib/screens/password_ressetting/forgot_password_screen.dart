import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/services/auth_service.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/gradient_background.dart';
import '../otp_verification_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GradientBackground(
      title: loc.forgotPassword, // Localized
      child: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Icon
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.lightBlue.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_reset,
                      size: 50,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Title
                Text(
                  loc.resetPassword, // Localized
                  style: AppTheme.headingStyle.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),

                const SizedBox(height: 16),

                // Description
                Text(
                  loc.resetPasswordDesc, // Localized
                  style: AppTheme.subheadingStyle.copyWith(
                    fontSize: 16,
                    color: AppTheme.textGrey,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 40),

                // Phone Number Label
                Text(
                  loc.phoneNumber, // Localized
                  style: AppTheme.subheadingStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.black,
                  ),
                ),

                const SizedBox(height: 8),

                // Phone Number Input
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    style: AppTheme.subheadingStyle.copyWith(
                      color: AppTheme.black,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                        color: AppTheme.primaryColor.withOpacity(0.7),
                        size: 22,
                      ),
                      hintText: '01234567890',
                      hintStyle: AppTheme.subheadingStyle.copyWith(
                        color: AppTheme.textGrey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Send Code Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    //! remove function parenthests make just _sendVerificationCode
                    onPressed:
                        _isLoading
                            ? null
                            :
                            //  () {
                            //   // _sendVerificationCode,
                            //   print("sending");
                            // }
                            _sendVerificationCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
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
                              loc.sendVerificationCode, // Localized
                              style: AppTheme.buttonTextStyle.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ),

                const SizedBox(height: 20),

                // Back to Login
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      loc.backToLogin, // Localized
                      style: AppTheme.linkStyle.copyWith(
                        fontSize: 16,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendVerificationCode() async {
    final loc = AppLocalizations.of(context)!;
    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.pleaseEnterPhoneNumber), // Localized
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (_phoneController.text.trim().length < 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.pleaseEnterValidPhoneNumber), // Localized
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final phoneNumber = _phoneController.text.trim();
      final formattedPhone = '$phoneNumber';
      await AuthService().forgotPassword(formattedPhone);

      // Navigate to OTP verification
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => OtpVerificationScreen(
                phoneNumber: formattedPhone,
                sendOtp: AuthService().forgotPassword,
                verifyOtp: AuthService().verifyOtpForFogettingPassword,
                forgottenPassword: true,
              ),
        ),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.failedToResendOtp(e.toString())), // Localized
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
