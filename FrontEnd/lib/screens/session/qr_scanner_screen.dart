import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import '/models/userModel.dart';
import '/providers/auth_provider.dart';
import '/screens/session/patient_selection_screen.dart';
import '/services/auth_service.dart';
import '/services/history_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool flashOn = false;
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GradientBackground(
      title: loc.scanQrCode, // Localized
      withAppBar: true,
      showBackButton: true,
      child: Column(
        children: [
          // Instructions Header
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF0EA5E9), width: 1),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: const Color(0xFF0EA5E9),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    loc.positionQrCode, // Localized
                    style: AppTheme.subheadingStyle.copyWith(
                      fontSize: 14,
                      color: const Color(0xFF0EA5E9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // QR Scanner
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF6366F1), width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: const Color(0xFF6366F1),
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: MediaQuery.of(context).size.width * 0.7,
                  ),
                ),
              ),
            ),
          ),

          // Controls
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Control Buttons Row
                Row(
                  children: [
                    // Flash Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _toggleFlash,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              flashOn
                                  ? const Color(0xFFF59E0B)
                                  : Colors.grey.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        icon: Icon(
                          flashOn ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: Text(
                          flashOn ? loc.flashOn : loc.flashOff, // Localized
                          style: AppTheme.subheadingStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Capture Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _captureQR,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: Text(
                          loc.capture, // Localized
                          style: AppTheme.subheadingStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Manual Entry Button
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                    icon: Icon(
                      Icons.keyboard,
                      color: Colors.grey.shade600,
                      size: 18,
                    ),
                    label: Text(
                      loc.manualEntry, // Localized
                      style: AppTheme.subheadingStyle.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null && !isProcessing) {
        _handleQRResult(scanData.code!);
      }
    });
  }

  void _handleQRResult(String qrData) async {
    if (isProcessing) return;

    setState(() => isProcessing = true);

    controller?.pauseCamera();
    HapticFeedback.mediumImpact();

    _showProcessingDialog();

    try {
      await AuthService().isValidToken(qrData.trim());
      Provider.of<AuthProvider>(
        context,
        listen: false,
      ).setSessionToken(qrData.trim());

      String? sessionToken =
          Provider.of<AuthProvider>(context, listen: false).sessionToken;

      String? token = Provider.of<AuthProvider>(context, listen: false).token;

      UserModel patient = await HistoryService().getPatient(
        token!,
        sessionToken!,
      );

      Navigator.of(
        context,
      ).pop(); // 👈 Close processing dialog before navigating

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PatientSelectionScreen(patients: [patient]),
        ),
      );
    } catch (err) {
      Navigator.of(
        context,
      ).pop(); // 👈 Close processing dialog before showing error
      _showErrorDialog(
        AppLocalizations.of(context)!.invalidQrCode, // Localized
        '$err',
      );
      controller?.resumeCamera();
      setState(() => isProcessing = false);
    }
  }

  void _toggleFlash() {
    controller?.toggleFlash();
    setState(() => flashOn = !flashOn);
    HapticFeedback.lightImpact();
  }

  void _captureQR() {
    // Simulate capture functionality
    HapticFeedback.mediumImpact();

    // In a real implementation, this would capture the current frame
    // For now, we'll show a capture animation
    _showCaptureAnimation();
  }

  void _showCaptureAnimation() {
    // Show a brief white overlay to simulate camera capture
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white.withOpacity(0.8),
      builder: (context) => Container(),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.processingQrCode), // Localized
          backgroundColor: const Color(0xFF22C55E),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  void _showProcessingDialog() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFF6366F1)),
              const SizedBox(height: 16),
              Text(
                loc.processingQrCode, // Localized
                style: AppTheme.subheadingStyle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showErrorDialog(String title, String message) {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTheme.headingStyle.copyWith(
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: AppTheme.subheadingStyle.copyWith(color: AppTheme.textGrey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                loc.tryAgain, // Localized
                style: AppTheme.subheadingStyle.copyWith(
                  color: const Color(0xFF6366F1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
