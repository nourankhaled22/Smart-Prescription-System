import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '/utils/age_helper.dart';
import '../../models/userModel.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import "../../utils/date_formatter.dart";

class DoctorProfileScreen extends StatefulWidget {
  final UserModel doctor;
  final Function(String doctorId, String newStatus)? onStatusChanged;

  const DoctorProfileScreen({
    super.key,
    required this.doctor,
    this.onStatusChanged,
  });

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  late UserModel currentDoctor;

  @override
  void initState() {
    super.initState();
    currentDoctor = widget.doctor;
  }

  void _updateDoctorStatus(String newStatus) {
    setState(() {
      currentDoctor = UserModel(
        id: currentDoctor.id,
        firstName: currentDoctor.firstName,
        lastName: currentDoctor.lastName,
        phoneNumber: currentDoctor.phoneNumber,
        role: currentDoctor.role,
        dateOfBirth: currentDoctor.dateOfBirth,
        clinicAddress: currentDoctor.clinicAddress,
        specialization: currentDoctor.specialization,
        licenceUrl: currentDoctor.licenceUrl,
        status: newStatus,
        token: currentDoctor.token,
        // email: currentDoctor.email,
      );
    });

    if (widget.onStatusChanged != null) {
      widget.onStatusChanged!(currentDoctor.id, newStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return GradientBackground(
      title: localizations.doctorProfile,
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
              '${currentDoctor.firstName} ${currentDoctor.lastName}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // Email and Specialization
            // if (currentDoctor.email != null)
            //   Text(
            //     currentDoctor.email!,
            //     style: TextStyle(
            //       fontSize: 16,
            //       color: Colors.grey[600],
            //     ),
            //   ),
            Text(
              currentDoctor.specialization!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
            // Profile Information Cards
            _buildInfoCard(
              localizations.phoneNumber,
              currentDoctor.phoneNumber,
              Icons.phone,
            ),
            _buildInfoCard(
              localizations.specialization,
              currentDoctor.specialization!,
              Icons.medical_services,
            ),
            _buildInfoCard(
              localizations.clinicAddress,
              currentDoctor.clinicAddress!,
              Icons.location_on,
            ),
            _buildInfoCard(
              localizations.dateOfBirth,
              formatDate(currentDoctor.dateOfBirth),
              Icons.calendar_today,
            ),
            _buildInfoCard(
              localizations.age,
              AgeHelper.calculateAge(formatDate(currentDoctor.dateOfBirth)),
              Icons.cake,
            ),
            _buildInfoCard(
              localizations.status,
              currentDoctor.status == "active"
                  ? localizations.active
                  : localizations.inactive,
              currentDoctor.status == "active"
                  ? Icons.check_circle
                  : Icons.cancel,
              statusColor:
                  currentDoctor.status == "active" ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 30),
            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showStatusChangeDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      currentDoctor.status == "Active"
                          ? const Color(0xFFFF5252)
                          : const Color(0xFF4CAF50),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  currentDoctor.status == "active"
                      ? localizations.suspend
                      : localizations.unsuspend,
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
      ),
    );
  }

  Widget _buildInfoCard(
    String label,
    String value,
    IconData icon, {
    Color? statusColor,
  }) {
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
                  color: (statusColor ?? AppTheme.primaryColor).withOpacity(
                    0.1,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: statusColor ?? AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
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

  void _showStatusChangeDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final bool isCurrentlyActive = currentDoctor.status == "active";
    final String actionTitle = isCurrentlyActive
        ? localizations.suspend
        : localizations.unsuspend;
    final String dialogTitle = isCurrentlyActive
        ? localizations.suspendDoctor
        : localizations.unsuspendDoctor;
    final String confirmMessage = isCurrentlyActive
        ? localizations.areYouSureSuspend(currentDoctor.firstName)
        : localizations.areYouSureUnsuspend(currentDoctor.firstName);
    final String successMessage = isCurrentlyActive
        ? localizations.doctorSuspendedSuccessfully
        : localizations.doctorUnsuspendedSuccessfully;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            dialogTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text(
            confirmMessage,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      localizations.cancel,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();

                      final newStatus =
                          isCurrentlyActive ? 'inactive' : 'active';
                      _updateDoctorStatus(newStatus);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(successMessage),
                          backgroundColor:
                              isCurrentlyActive
                                  ? const Color(0xFFFF5252)
                                  : const Color(0xFF4CAF50),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isCurrentlyActive
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
                        fontSize: 15,
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
