import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/services/patient_service.dart';

import '../models/userModel.dart';
import '../widgets/patient_card.dart';
import '../../widgets/gradient_background.dart';
import 'profile/view_patient_profile_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatientsListScreen extends StatefulWidget {
  const PatientsListScreen({super.key});

  @override
  State<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _allPatients = [];
  List<UserModel> _filteredPatients = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPatients();
    _searchController.addListener(_filterPatients);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadPatients() async {
    setState(() {
      _isLoading = true;
      _allPatients = [];
      _filteredPatients = [];
    });

    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final patients = await PatientService().getAllPatients(token!);
      setState(() {
        _allPatients = patients;
        _filteredPatients = List.from(_allPatients);
      });
    } catch (e) {
          final loc = AppLocalizations.of(context)!;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.failedToLoadPatients)));
    } finally {
      _isLoading = false;
    }
  }

  void _filterPatients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPatients =
          _allPatients.where((patient) {
            String patientFullname = '${patient.firstName} ${patient.lastName}';
            return patientFullname.toLowerCase().contains(query);
          }).toList();
    });
  }

  void _updatePatientStatus(String patientId, String newStatus) {
    setState(() {
      final index = _allPatients.indexWhere((p) => p.id == patientId);
      if (index != -1) {
        final patient = _allPatients[index];
        _allPatients[index] = UserModel(
          id: patient.id,
          firstName: patient.firstName,
          lastName: patient.lastName,
          nationalId: patient.nationalId,
          phoneNumber: patient.phoneNumber,
          role: patient.role,
          dateOfBirth: patient.dateOfBirth,
          status: newStatus,
          token: patient.token,
        );
        _filterPatients();
      }
    });
  }

  void _togglePatientStatus(UserModel patient) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final newStatus = patient.status == "active" ? 'suspended' : 'active';

    setState(() {
      _isLoading = true;
    });

    try {
      late UserModel updatedPatient;
      // Call your backend to activate/deactivate the user
      if (newStatus == 'active') {
        updatedPatient = await PatientService().activateUser(
          token!,
          patient.id,
        );
      } else {
        updatedPatient = await PatientService().suspendUser(token!, patient.id);
      }
      setState(() {
        final index = _allPatients.indexWhere((p) => p.id == patient.id);
        if (index != -1) {
          _allPatients[index] = updatedPatient;
          _filterPatients();
        }
      });

      String statusKey = (updatedPatient.status ?? 'inactive').toLowerCase();
      String statusLocalized;
      switch (statusKey) {
        case 'active':
          statusLocalized = AppLocalizations.of(context)!.active;
          break;
        case 'suspended':
          statusLocalized = AppLocalizations.of(context)!.suspend;
          break;
        case 'inactive':
          statusLocalized = AppLocalizations.of(context)!.inactive;
          break;
        default:
          statusLocalized = statusKey;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.patientStatusUpdated(statusLocalized),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.failedToUpdateStatus)));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToProfile(UserModel patient) async {
    // Wait for the profile screen to return and get the updated patient
    final updatedPatient = await Navigator.push<UserModel>(
      context,
      MaterialPageRoute(
        builder:
            (context) => PatientProfileScreen(
              patient: patient,
              onStatusChanged: _updatePatientStatus,
            ),
      ),
    );

    // If patient was updated, refresh the list
    if (updatedPatient != null) {
      _updatePatientStatus(updatedPatient.id, updatedPatient.status!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GradientBackground(
      title: loc.managePatients,
      showBackButton: true,
      child: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: loc.searchDoctorName, // Reuse doctor search key for patients
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),
          ),
          // Patients List
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredPatients.length,
                      itemBuilder: (context, index) {
                        final patient = _filteredPatients[index];
                        return PatientCard(
                          patient: patient,
                          onTap: () => _navigateToProfile(patient),
                          onStatusToggle: () => _togglePatientStatus(patient),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
