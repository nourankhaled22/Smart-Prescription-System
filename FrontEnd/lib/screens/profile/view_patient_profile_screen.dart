import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/services/patient_service.dart';
import '/utils/age_helper.dart';

import '../../models/userModel.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/gradient_background.dart';
import '../../utils/date_formatter.dart';

class PatientProfileScreen extends StatefulWidget {
  final UserModel patient;
  final Function(String patientId, String newStatus)? onStatusChanged;

  const PatientProfileScreen({
    super.key,
    required this.patient,
    this.onStatusChanged,
  });

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  UserModel? currentPatient;
  bool _isUpdatingStatus = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentPatient = widget.patient;
    });
  }

  Future<void> _updatePatientStatus(String newStatus) async {
    setState(() {
      _isUpdatingStatus = true;
    });

    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      // Call your backend to update the status
      late UserModel updatedPatient;
      if (newStatus == 'active') {
        updatedPatient = await PatientService().activateUser(
          token!,
          currentPatient!.id,
        );
      } else {
        updatedPatient = await PatientService().suspendUser(
          token!,
          currentPatient!.id,
        );
      }

      setState(() {
        currentPatient = updatedPatient;
      });

      // Notify parent screen about the status change
      if (widget.onStatusChanged != null) {
        widget.onStatusChanged!(currentPatient!.id, newStatus);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update status: $e')));
    } finally {
      setState(() {
        _isUpdatingStatus = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      title: 'Patient Profile',
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
                Icons.person,
                size: 50,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            // Patient Name
            Text(
              '${currentPatient!.firstName} ${currentPatient!.lastName}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // Email
            Text(
              '${currentPatient!.firstName}@gmail.com',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            // Profile Information Cards
            _buildInfoCard(
              'Phone Number',
              currentPatient!.phoneNumber,
              Icons.phone,
            ),
            _buildInfoCard(
              'National ID',
              currentPatient!.nationalId!,
              Icons.credit_card,
            ),
            // if (currentPatient.Address != null)
            // _buildInfoCard(
            //   'Clinic Address',
            //   currentPatient!.clinicAddress!,
            //   Icons.location_on,
            // ),
            _buildInfoCard(
              'Date Of Birth',
              formatDate(currentPatient!.dateOfBirth),
              Icons.calendar_today,
            ),
            _buildInfoCard(
              'Age',
              AgeHelper.calculateAge(formatDate(currentPatient!.dateOfBirth)),
              Icons.cake,
            ),
            _buildInfoCard(
              'Status',
              currentPatient!.status!.toUpperCase(),
              currentPatient!.status == "active"
                  ? Icons.check_circle
                  : Icons.cancel,
              statusColor:
                  currentPatient!.status == "active"
                      ? Colors.green
                      : Colors.red,
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
                      currentPatient!.status == "active"
                          ? const Color(0xFFFF5252)
                          : const Color(0xFF4CAF50),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  currentPatient!.status == "active" ? 'Suspend' : 'Unsuspend',
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

  void _showStatusChangeDialog(BuildContext context) {
    final bool isCurrentlyActive = currentPatient!.status == "active";
    final String action = isCurrentlyActive ? 'suspend' : 'unsuspend';
    final String actionTitle = isCurrentlyActive ? 'Suspend' : 'Unsuspend';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            '$actionTitle Patient',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to $action ${currentPatient!.firstName} ${currentPatient!.lastName}?',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle status change
                      Navigator.of(context).pop();

                      // Update the patient status
                      final newStatus =
                          isCurrentlyActive ? 'inactive' : 'active';
                      _updatePatientStatus(newStatus);

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Patient ${isCurrentlyActive ? 'suspended' : 'unsuspended'} successfully',
                          ),
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
