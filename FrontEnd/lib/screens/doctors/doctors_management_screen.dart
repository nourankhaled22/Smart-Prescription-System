import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '/providers/auth_provider.dart';
import '/services/doctor_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/doctor_card.dart';
import '../../widgets/gradient_background.dart';
import 'view_doctor_profile_screen.dart';
import "../../models/userModel.dart";

class DoctorsManagementScreen extends StatefulWidget {
  const DoctorsManagementScreen({super.key});

  @override
  State<DoctorsManagementScreen> createState() =>
      _DoctorsManagementScreenState();
}

class _DoctorsManagementScreenState extends State<DoctorsManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _allDoctors = [];
  List<UserModel> _filteredDoctors = [];
  String _selectedSpecialization = 'All';
  List<String> _specializations = ['All'];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVerifiedDoctors();
    _searchController.addListener(_filterDoctors);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadVerifiedDoctors() async {
    // Load only verified doctors (active and inactive, not unverified)
    setState(() {
      _isLoading = true;
      _allDoctors = [];
      _filteredDoctors = [];
    });

    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final doctors = await DoctorService().getAllDoctors(token!);
      setState(() {
        _allDoctors = doctors;
        _filteredDoctors = List.from(_allDoctors);
      });
    } catch (e) {
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.failedToLoadDoctors)));
    } finally {
      _isLoading = false;
    }

    // Extract unique specializations
    _specializations = ['All'];
    _specializations.addAll(
      _allDoctors.map((d) => d.specialization!).toSet().toList(),
    );

    _filteredDoctors = List.from(_allDoctors);
  }


  void _filterDoctors() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDoctors =
          _allDoctors.where((doctor) {
            final String fullName = '${doctor.firstName} ${doctor.lastName}';
            final matchesSearch = fullName.toLowerCase().contains(query);
            final matchesSpecialization =
                _selectedSpecialization == 'All' ||
                doctor.specialization == _selectedSpecialization;
            return matchesSearch && matchesSpecialization;
          }).toList();
    });
  }

  void _updateDoctorStatus(String doctorId, String newStatus) {
    setState(() {
      final index = _allDoctors.indexWhere((d) => d.id == doctorId);
      if (index != -1) {
        final doctor = _allDoctors[index];
        _allDoctors[index] = UserModel(
          id: doctor.id,
          firstName: doctor.firstName,
          lastName: doctor.lastName,
          phoneNumber: doctor.phoneNumber,
          role: doctor.role,
          dateOfBirth: doctor.dateOfBirth,
          clinicAddress: doctor.clinicAddress,
          specialization: doctor.specialization,
          licenceUrl: doctor.licenceUrl,
          status: newStatus,
          token: doctor.token,
          // email: doctor.email,
        );
        _filterDoctors();
      }
    });
  }

  void _toggleDoctorStatus(UserModel doctor) async {
    final loc = AppLocalizations.of(context)!;
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final newStatus = doctor.status == "active" ? 'inactive' : 'active';
    _updateDoctorStatus(doctor.id, newStatus);
    setState(() {
      _isLoading = true;
    });

    try {
      late UserModel updatedDoctor;
      // Call your backend to activate/deactivate the user
      if (newStatus == 'active') {
        updatedDoctor = await DoctorService().activateDoctor(token!, doctor.id);
      } else {
        updatedDoctor = await DoctorService().suspendDoctor(token!, doctor.id);
      }
      setState(() {
        final index = _allDoctors.indexWhere((p) => p.id == doctor.id);
        if (index != -1) {
          _allDoctors[index] = updatedDoctor;
          _filterDoctors();
        }
      });

      // Use localized status
      String statusText = updatedDoctor.status == 'active' ? loc.active : loc.inactive;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(loc.patientStatusUpdated(statusText)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(loc.failedToUpdateStatus),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToProfile(UserModel doctor) async {
    await Navigator.push<UserModel>(
      context,
      MaterialPageRoute(
        builder:
            (context) => DoctorProfileScreen(
              doctor: doctor,
              onStatusChanged: _updateDoctorStatus,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GradientBackground(
      title: loc.doctors,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                        hintText: loc.searchDoctorName,
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
                // Specialization Filter
                Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _specializations.length,
                    itemBuilder: (context, index) {
                      final specialization = _specializations[index];
                      final isSelected = _selectedSpecialization == specialization;
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(specialization == 'All' ? loc.all : specialization),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedSpecialization = specialization;
                              _filterDoctors();
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? AppTheme.primaryColor : Colors.grey[700],
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Verified Doctors List
                Expanded(
                  child: _filteredDoctors.isEmpty
                      ? Center(
                          child: Text(
                            loc.noDoctorsFound,
                            style: const TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredDoctors.length,
                          itemBuilder: (context, index) {
                            final doctor = _filteredDoctors[index];
                            return DoctorCard(
                              doctor: doctor,
                              onTap: () => _navigateToProfile(doctor),
                              onStatusToggle: () => _toggleDoctorStatus(doctor),
                              showVerifyButton: false, // Only show suspend/unsuspend
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
