import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/screens/session/qr_scanner_screen.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatientSearchScreen extends StatefulWidget {
  const PatientSearchScreen({super.key});

  @override
  State<PatientSearchScreen> createState() => _PatientSearchScreenState();
}

class _PatientSearchScreenState extends State<PatientSearchScreen> {
  final TextEditingController _nationalIdController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GradientBackground(
      //title: loc.findPatient,
      withAppBar: true,
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Header
            Text(
              loc.patientIdentification, // Localized
              style: AppTheme.headingStyle.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 64),
            // QR Scanner Section
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.qr_code_2,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          loc.scanPatientQrCode, // Localized
                          style: AppTheme.subheadingStyle.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    ShaderMask(
                      shaderCallback:
                          (bounds) => LinearGradient(
                            colors: [
                              AppTheme.primaryColor,
                              Colors.blue.shade500,
                            ],
                          ).createShader(bounds),
                      child: const Icon(
                        Icons.qr_code_2,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryColor,
                            AppTheme.primaryColor.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: _openQRScanner,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          loc.openQrScanner, // Localized
                          style: AppTheme.subheadingStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
  void _openQRScanner() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRScannerScreen()),
    );
  }

  @override
  void dispose() {
    _nationalIdController.dispose();
    super.dispose();
  }
}
