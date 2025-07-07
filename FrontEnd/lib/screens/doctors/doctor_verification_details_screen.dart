import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '/models/userModel.dart';
import '/providers/auth_provider.dart';
import '/services/doctor_service.dart';
import '/utils/age_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import '../../utils/date_formatter.dart';
class DoctorVerificationDetailScreen extends StatefulWidget {
  final UserModel doctor;
  final Function(String doctorId, String newStatus)? onStatusChanged;

  const DoctorVerificationDetailScreen({
    super.key,
    required this.doctor,
    this.onStatusChanged,
  });

  @override
  State<DoctorVerificationDetailScreen> createState() =>
      _DoctorVerificationDetailScreenState();
}

class _DoctorVerificationDetailScreenState
    extends State<DoctorVerificationDetailScreen> {
  String? filePath = '';
  bool _licenseLoading = false;

  Future<void> verifyDoctor(BuildContext context, UserModel doctor) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    try {
      late UserModel updatedDoctor;
      updatedDoctor = await DoctorService().activateDoctor(token!, doctor.id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to update status: $e'),
        ),
      );
    }
  }

  Future<void> rejectDoctor(BuildContext context, UserModel doctor) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    try {
      await DoctorService().rejectDoctor(token!, doctor.id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to Reject Doctor: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GradientBackground(
      title: loc.doctorVerification,
      child: SizedBox.expand(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile Avatar
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryColor, width: 3),
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.local_hospital,
                  size: 50,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              // Doctor Name
              Text(
                '${widget.doctor.firstName} ${widget.doctor.lastName}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              // Specialization
              Text(
                widget.doctor.specialization ?? 'N/A',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),
              // Doctor Information Cards
              _buildInfoCard(
                loc.phoneNumber,
                widget.doctor.phoneNumber,
                Icons.phone,
              ),
              _buildInfoCard(
                loc.specialization,
                widget.doctor.specialization ?? 'N/A',
                Icons.medical_services,
              ),
              _buildInfoCard(
                loc.clinicAddress,
                widget.doctor.clinicAddress ?? 'N/A',
                Icons.location_on,
              ),
              _buildInfoCard(
                loc.dateOfBirth,
                formatDate(widget.doctor.dateOfBirth),
                Icons.calendar_today,
              ),
              _buildInfoCard(
                loc.age,
                AgeHelper.calculateAge(formatDate(widget.doctor.dateOfBirth)),
                Icons.cake,
              ),
              _buildLicenseCard(context, loc),
              const SizedBox(height: 30),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showVerificationDialog(context, false, loc),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        loc.accept,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showVerificationDialog(context, true, loc),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5252),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        loc.reject,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 18, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLicenseCard(BuildContext context, AppLocalizations loc) {
    print("Doctor License URL: ${widget.doctor.licenceUrl}");
    final isImage =
        widget.doctor.licenceUrl!.toLowerCase().endsWith('.jpg') ||
        widget.doctor.licenceUrl!.toLowerCase().endsWith('.jpeg') ||
        widget.doctor.licenceUrl!.toLowerCase().endsWith('.png');
    final isPdf = widget.doctor.licenceUrl!.toLowerCase().endsWith('.pdf');

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.medicalLicense,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // View License Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await viewLicensePDF(context, widget.doctor.id);
                              _viewLicense(context, widget.doctor);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2196F3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.visibility, color: Colors.white, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    loc.view,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Download License Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _downloadLicense(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.download, color: Colors.white, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    loc.download,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _viewLicense(BuildContext context, UserModel doctor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            margin: EdgeInsets.all(20),
            width: double.infinity,
            height: double.infinity, // Set a fixed height if needed
            child: Column(
              children: [
                // Header with close button
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'License',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // PDF view or loading message
                if (_licenseLoading)
                  Expanded(
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                if (!_licenseLoading)
                  Expanded(
                    child:
                        filePath != null
                            ? PDFView(filePath: filePath!)
                            : const Center(child: Text("pdf is Corrupted")),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> viewLicensePDF(BuildContext context, String doctorId) async {
    setState(() {
      _licenseLoading = true;
    });
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final pdfBytes = await DoctorService().fetchDoctorLicensePdf(
        doctorId: doctorId,
        token: token!,
      );
      if (pdfBytes == null) {
        throw Exception('Failed to load license.');
      }

      // Save to temp file
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/license_$doctorId.pdf');
      await file.writeAsBytes(pdfBytes!);
      setState(() {
        filePath = file.path;
        _licenseLoading = false;
      });
      print('Loading FilePath: $filePath');
    } catch (err) {
      setState(() {
        _licenseLoading = false;
        filePath = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to fetch License!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _downloadLicense(BuildContext context) async {
    try {
      // Request storage permission
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Storage permission is required to download files'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Downloading license...'),
              ],
            ),
          );
        },
      );

      // Get auth token
      final token = Provider.of<AuthProvider>(context, listen: false).token;

      // Fetch PDF bytes
      final pdfBytes = await DoctorService().fetchDoctorLicensePdf(
        token: token!,
        doctorId: widget.doctor.id,
      );

      if (pdfBytes == null) {
        throw Exception("Failed to fetch license PDF.");
      }

      // Get storage directory
      Directory downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else {
        downloadsDirectory = await getApplicationDocumentsDirectory();
      }

      // File path
      final fileName =
          'Dr_${widget.doctor.firstName}_${widget.doctor.lastName}_License.pdf';
      final filePath = '${downloadsDirectory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      // Close loading
      Navigator.of(context).pop();

      // Show success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('License downloaded to: $filePath'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Open',
            textColor: Colors.white,
            onPressed: () {
              OpenFile.open(filePath);
            },
          ),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showVerificationDialog(BuildContext context, bool isReject, AppLocalizations loc) {
    final action = isReject ? loc.reject.toLowerCase() : loc.accept.toLowerCase();
    final actionTitle = isReject ? loc.reject : loc.accept;

    showDialog(
      context: context,
      builder: (BuildContext DialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            '${actionTitle} ${loc.doctor}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text(
            '${loc.areYouSureYouWantTo} $action ${widget.doctor.firstName}?',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(DialogContext).pop(),
                    child: Text(
                      loc.cancel,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(DialogContext).pop();

                      // Update doctor status - accepted doctors become active
                      final newStatus = isReject ? 'rejected' : 'active';
                      if (actionTitle == "Reject") {
                        await rejectDoctor(context, widget.doctor);
                      } else {
                        await verifyDoctor(context, widget.doctor);
                      }
                      if (widget.onStatusChanged != null) {
                        widget.onStatusChanged!(widget.doctor.id, newStatus);
                      }

                      // Go back to verification list
                      Navigator.of(context).pop();

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isReject
                                ? 'Doctor rejected successfully'
                                : 'Doctor accepted and moved to active doctors list',
                          ),
                          backgroundColor:
                              isReject
                                  ? const Color(0xFFFF5252)
                                  : const Color(0xFF4CAF50),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isReject
                              ? const Color(0xFFFF5252)
                              : const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      actionTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
