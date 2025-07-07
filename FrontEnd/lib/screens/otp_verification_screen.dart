import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/screens/password_ressetting/reset_password_screen.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final Future<void> Function(String phoneNumber) sendOtp;
  final Future<void> Function(String otp, String phoneNumber) verifyOtp;
  final bool forgottenPassword;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.sendOtp,
    required this.verifyOtp,
    this.forgottenPassword = false,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  bool _canResend = false;
  bool _isResending = false;
  int _resendTimer = 60;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
        _startResendTimer();
      } else if (mounted) {
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _verifyCode() async {
    final loc = AppLocalizations.of(context)!;
    String otp = _otpControllers.map((controller) => controller.text).join();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.pleaseEnterCompleteVerificationCode),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }
    if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.otpMustBeNumeric),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await widget.verifyOtp(widget.phoneNumber, otp);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.otpVerified), backgroundColor: Colors.green),
      );
      if (widget.forgottenPassword) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    ResetPasswordScreen(phoneNumber: widget.phoneNumber),
          ),
        );
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.otpVerificationFailed(e.toString())),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    final loc = AppLocalizations.of(context)!;
    setState(() => _isResending = true);
    try {
      await widget.sendOtp(widget.phoneNumber);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(loc.otpResentSuccessfully),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(loc.failedToResendOtp(e.toString())),
        ),
      );
    } finally {
      setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GradientBackground(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            // Icon
            Center(
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  color: AppTheme.lightBlue.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.sms_outlined,
                  size: 50,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Title
            Text(
              loc.enterVerificationCode,
              textAlign: TextAlign.center,
              style: AppTheme.headingStyle.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentColor,
              ),
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              loc.verificationDesc(widget.phoneNumber),
              textAlign: TextAlign.center,
              style: AppTheme.subheadingStyle.copyWith(
                fontSize: 16,
                color: AppTheme.textGrey,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 40),

            // OTP Input Fields (LTR always)
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    height: 60,
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppTheme.primaryColor,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 40),

            // Resend Code
            Center(
              child:
                  _canResend
                      ? TextButton(
                        onPressed: _resendOtp,
                        child: Text(
                          loc.resendCode,
                          style: AppTheme.linkStyle.copyWith(
                            fontSize: 16,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      )
                      : Text(
                        loc.resendCodeIn('$_resendTimer'),
                        style: AppTheme.subheadingStyle.copyWith(
                          color: AppTheme.textGrey,
                        ),
                      ),
            ),

            const Spacer(),

            // Verify Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyCode,
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
                          loc.verifyCode,
                          style: AppTheme.buttonTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
