import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/userModel.dart';
import '/providers/auth_provider.dart';
import '/services/doctor_service.dart';
import '/widgets/doctor_search_card.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import 'doctor_find_view_screen.dart';
import '../../data/specializations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FindDoctorsScreen extends StatefulWidget {
  const FindDoctorsScreen({super.key});

  @override
  State<FindDoctorsScreen> createState() => _FindDoctorsScreenState();
}

class _FindDoctorsScreenState extends State<FindDoctorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _allDoctors = [];
  List<UserModel> _filteredDoctors = [];
  String _selectedSpecialization = 'All';
  List<String> _specializations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActiveDoctors();
    _searchController.addListener(_filterDoctors);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadActiveDoctors() async {
    setState(() {
      _isLoading = true;
      _allDoctors = [];
      _filteredDoctors = [];
    });

    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final doctors = await DoctorService().getAllActiveDoctors(token!);
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
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    _specializations = [
      'All',
      ...isArabic ? specializationsAr : specializationsEn,
    ];
    _filteredDoctors = List.from(_allDoctors);
  }

  void _filterDoctors() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDoctors =
          _allDoctors.where((doctor) {
            final String fullName = '${doctor.firstName} ${doctor.lastName}';
            final matchesSearch =
                fullName.toLowerCase().contains(query) ||
                doctor.specialization!.toLowerCase().contains(query);
            final matchesSpecialization =
                _selectedSpecialization == 'All' ||
                doctor.specialization == _selectedSpecialization;
            return matchesSearch && matchesSpecialization;
          }).toList();
    });
  }

  void _navigateToDoctorProfile(UserModel doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorProfileViewScreen(doctor: doctor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GradientBackground(
      title: loc.availableDoctors, // Localized
      child:
          _isLoading
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
                          hintText: loc.searchDoctorName, // Localized
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
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
                        final isSelected =
                            _selectedSpecialization == specialization;
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(specialization),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedSpecialization = specialization;
                                _filterDoctors();
                              });
                            },
                            backgroundColor: Colors.white,
                            selectedColor: AppTheme.primaryColor.withOpacity(
                              0.2,
                            ),
                            labelStyle: TextStyle(
                              color:
                                  isSelected
                                      ? AppTheme.primaryColor
                                      : Colors.grey[700],
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Results Count
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_hospital,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          loc.doctorsAvailable(
                            _filteredDoctors.length,
                          ), // ✅ Correct usage
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Doctors List
                  Expanded(
                    child:
                        _filteredDoctors.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    loc.noDoctorsFound, // Localized
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    loc.tryAdjustingSearch, // Localized
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: _filteredDoctors.length,
                              itemBuilder: (context, index) {
                                final doctor = _filteredDoctors[index];
                                return DoctorSearchCard(
                                  doctor: doctor,
                                  onTap: () => _navigateToDoctorProfile(doctor),
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }
}
