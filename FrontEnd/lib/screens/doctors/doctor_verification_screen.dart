import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '/models/userModel.dart';
import '/providers/auth_provider.dart';
import '/screens/doctors/doctor_verification_details_screen.dart';
import '/services/doctor_service.dart';
import '/widgets/doctor_card.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';

class DoctorsVerificationScreen extends StatefulWidget {
  const DoctorsVerificationScreen({super.key});

  @override
  State<DoctorsVerificationScreen> createState() =>
      _DoctorsVerificationScreenState();
}

class _DoctorsVerificationScreenState extends State<DoctorsVerificationScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _allDoctors = [];
  List<UserModel> _filteredDoctors = [];
  String _selectedSpecialization = 'All';
  List<String> _specializations = ['All'];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUnverifiedDoctors();
    _searchController.addListener(_filterDoctors);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadUnverifiedDoctors() async {
    // Load only unverified doctors
    setState(() {
      _isLoading = true;
      _allDoctors = [];
      _filteredDoctors = [];
    });

    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final doctors = await DoctorService().getAllUnverfiedDoctors(token!);
      setState(() {
        _allDoctors = doctors;
        _filteredDoctors = List.from(_allDoctors);
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load doctors: $e')));
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
      _filteredDoctors = _allDoctors.where((doctor) {
        final String doctorFullName = '${doctor.firstName} ${doctor.lastName}';
        final matchesSearch = doctorFullName.toLowerCase().contains(query);
        final matchesSpecialization = _selectedSpecialization == 'All' ||
            doctor.specialization == _selectedSpecialization;
        return matchesSearch && matchesSpecialization;
      }).toList();
    });
  }

  void _updateDoctorStatus(String doctorId, String newStatus) {
    setState(() {
      // Remove doctor from unverified list when accepted or rejected
      _allDoctors.removeWhere((d) => d.id == doctorId);
      _filterDoctors();
    });
  }

  void _navigateToVerification(UserModel doctor) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorVerificationDetailScreen(
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
      title: loc.verifyDoctors,
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
                    label: Text(
                        specialization == 'All' ? loc.all : specialization),
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
                      color:
                          isSelected ? AppTheme.primaryColor : Colors.grey[700],
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Pending Verification Count
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.pending_actions,
                  color: Colors.orange[700],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${_filteredDoctors.length} ${loc.pendingVerification}',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Unverified Doctors List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredDoctors.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.verified_user,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              loc.noDoctorsPendingVerification,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              loc.allApplicationsProcessed,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredDoctors.length,
                        itemBuilder: (context, index) {
                          final doctor = _filteredDoctors[index];
                          return DoctorCard(
                            doctor: doctor,
                            onTap: () => _navigateToVerification(doctor),
                            onStatusToggle: () {}, // No toggle for unverified
                            showVerifyButton: true, // Show verify button
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
