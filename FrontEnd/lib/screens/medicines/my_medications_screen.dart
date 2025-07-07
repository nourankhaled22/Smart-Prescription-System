import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/services/medication_service.dart';

import '../../models/medication.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart' show GradientBackground;
import '../../widgets/medication_card.dart';
import './medication_schdule_screen.dart';
import 'add_medication_screen.dart';
import 'medicine_info_search_screen.dart';
import 'medication_details_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // <-- Add this import

class MyMedicationsScreen extends StatefulWidget {
  const MyMedicationsScreen({super.key});

  @override
  State<MyMedicationsScreen> createState() => _MyMedicationsScreenState();
}

class _MyMedicationsScreenState extends State<MyMedicationsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<Medication> _medications = [];
  List<Medication> _filteredMedications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMedicines();
  }

  Future<void> _fetchMedicines() async {
    setState(() => _isLoading = true);
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final medicines = await MedicationService().getmedicines(token!);
    setState(() {
      _medications = medicines;
      _filterMedications("");
      _isLoading = false;
    });
  }

  void _filterMedications(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMedications = _medications;
      } else {
        _filteredMedications =
            _medications
                .where(
                  (medication) => medication.medicineName
                      .toLowerCase()
                      .contains(query.toLowerCase()),
                )
                .toList();
      }
    });
  }

  Future<void> _deleteMedicineWithSwipe(Medication medication) async {
    final loc = AppLocalizations.of(context)!;
    final token = Provider.of<AuthProvider>(context, listen: false).token;

    try {
      await MedicationService().deletemedicine(token!, medication.id!);
      setState(() {
        _medications.remove(medication);
        _filteredMedications =
            _medications
                .where(
                  (med) => med.medicineName.toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  ),
                )
                .toList();
      });

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.delete, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${medication.medicineName} ${loc.deleted}', // Localized
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

 
  void _updateMedicationStatus(String id, bool isActive) async {
    final loc = AppLocalizations.of(context)!;
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      await MedicationService().updateMedcineStatus(token!, id, isActive);
      setState(() {
        final index = _medications.indexWhere((med) => med.id == id);
        if (index != -1) {
          _medications[index] = _medications[index].copyWith(
            isActive: isActive,
          );
          _filteredMedications = _medications;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${loc.failedToUpdateExamination}: $e')),
      );
    }
  }

  void _updateMedicationSchedule(Medication updatedMedication) {
    setState(() {
      final index = _medications.indexWhere(
        (med) => med.id == updatedMedication.id,
      );
      if (index != -1) {
        _medications[index] = updatedMedication;
        _filteredMedications = _medications;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GradientBackground(
      withAppBar: true,
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Header
                    Text(
                      loc.medicine, // Localized
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Search Bar with Camera
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: _filterMedications,
                              decoration: InputDecoration(
                                hintText: loc.searchForMedicine, // Localized
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: AppTheme.primaryColor,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: _openCamera,
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF5F5F5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Add Medicine Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _addMedicine,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        label: Text(
                          loc.addNewMedicine, // Localized
                          style: AppTheme.subheadingStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Medications List Header
                    if (_filteredMedications.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            loc.yourMedications, // Localized
                            style: AppTheme.subheadingStyle.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.black,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_filteredMedications.length} ${loc.medicine}${_filteredMedications.length != 1 ? 's' : ''}',
                              style: AppTheme.subheadingStyle.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Medications List with Swipe to Delete
                    Expanded(
                      child:
                          _filteredMedications.isEmpty
                              ? _buildEmptyState(loc)
                              : ListView.separated(
                                itemCount: _filteredMedications.length,
                                separatorBuilder:
                                    (_, __) => const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  final medication =
                                      _filteredMedications[index];
                                  return _buildSwipeableMedicationCard(
                                    medication,
                                    loc,
                                  );
                                },
                              ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildSwipeableMedicationCard(
    Medication medication,
    AppLocalizations loc,
  ) {
    return Dismissible(
      key: Key(medication.id!),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_sweep, color: Colors.white, size: 32),
            const SizedBox(height: 4),
            Text(
              loc.delete, // Localized
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        _deleteMedicineWithSwipe(medication);
      },
      child: MedicationCard(
        medication: medication,
        onTap: () => _navigateToMedicationDetails(medication),
        onSchedule: () => _scheduleMedicine(medication),
        onInfo: () => _showMedicineInfoFromAPI(medication),
        onDelete: () => _deleteMedicineWithSwipe(medication),
        onActiveChanged:
            (isActive) => _updateMedicationStatus(medication.id!, isActive),
      ),
    );
  }

  void _navigateToMedicationDetails(Medication medication) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MedicationDetailsScreen(
              medication: medication,
              onDelete: _deleteMedicineWithSwipe,
              onStatusChanged:
                  (med, isActive) => _updateMedicationStatus(med.id!, isActive),
              onScheduleUpdated: _updateMedicationSchedule,
            ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations loc) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.medication_outlined,
              size: 64,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            loc.noMedicationsFound, // Localized
            style: AppTheme.headingStyle.copyWith(
              fontSize: 20,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            loc.addFirstMedicine, // Localized
            style: AppTheme.subheadingStyle.copyWith(color: AppTheme.textGrey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _addMedicine,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              loc.addMedicine, // Localized
              style: AppTheme.subheadingStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openCamera() async {
    final loc = AppLocalizations.of(context)!;
    try {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder:
            (context) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      loc.scanMedicine, // Localized
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 20,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCameraOption(
                            loc.takePhoto, // Localized
                            Icons.camera_alt,
                            () => _pickImage(ImageSource.camera),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildCameraOption(
                            loc.fromGallery, // Localized
                            Icons.photo_library,
                            () => _pickImage(ImageSource.gallery),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${loc.errorOpeningCamera}: $e'), // Localized
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildCameraOption(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTheme.subheadingStyle.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage(ImageSource source) async {
    final loc = AppLocalizations.of(context)!;
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    try {
      Navigator.pop(context);

      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );

        final File imageFile = File(image.path);
        Medication newMedicine = await MedicationService().scanMadicine(
          token: token!,
          file: imageFile,
        );

        Navigator.of(context, rootNavigator: true).pop();

        setState(() {
          _medications.add(newMedicine);
          _filteredMedications = _medications;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.medicineAdded), // Localized
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: loc.ok, // Localized
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      final errorMsg = e.toString().replaceFirst('Exception: ', '');
      Navigator.of(context, rootNavigator: true).maybePop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$errorMsg'), backgroundColor: Colors.red),
      );
    }
  }

  void _addMedicine() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddMedicationScreen()),
    ).then((newMedication) {
      if (newMedication != null) {
        setState(() {
          _medications.add(newMedication);
          _filteredMedications = _medications;
        });
      }
    });
  }

  void _scheduleMedicine(Medication medication) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicationScheduleScreen(medication: medication),
      ),
    ).then((updatedMedication) {
      if (updatedMedication != null) {
        setState(() {
          final index = _medications.indexWhere(
            (med) => med.id == medication.id,
          );
          if (index != -1) {
            _medications[index] = updatedMedication;
            _filteredMedications = _medications;
          }
        });
      }
    });
  }

  void _showMedicineInfoFromAPI(Medication medication) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MedicineInfoSearchScreen(
              initialSearchTerm: medication.medicineName,
            ),
      ),
    );
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
