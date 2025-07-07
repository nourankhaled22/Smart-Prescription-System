import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/services/prescription_service.dart';
import '../../models/prescription.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import 'prescription_details_screen.dart';
import 'package:intl/intl.dart';
import '../../widgets/prescription_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrescriptionsScreen extends StatefulWidget {
  const PrescriptionsScreen({super.key});

  @override
  State<PrescriptionsScreen> createState() => _PrescriptionsScreenState();
}

class _PrescriptionsScreenState extends State<PrescriptionsScreen> {
  final ImagePicker _picker = ImagePicker();
  String _filterType = 'all';
  DateTime? _customStartDate;
  DateTime? _customEndDate;
  bool _isLoading = true;

  // Sample data
  List<Prescription> _prescriptions = [];

  List<Prescription> _filteredPrescriptions = [];

  @override
  void initState() {
    super.initState();
    _fetchPrescriptions();
  }

  Future<void> _fetchPrescriptions() async {
    setState(() => _isLoading = true);
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;

      final prescriptions = await PrescriptionService().getPrescriptions(
        token!,
      );
      setState(() {
        _prescriptions = prescriptions;
        _applyDateFilter(_filterType);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.failedToFetchPrescriptions ?? 'Failed to fetch Prescriptions: $e')),
      );
    }
  }

  void _applyDateFilter(String filterType) {
    setState(() {
      _filterType = filterType;
      final now = DateTime.now();

      switch (filterType) {
        case 'all':
          _filteredPrescriptions = List.from(_prescriptions);
          break;
        case 'today':
          _filteredPrescriptions =
              _prescriptions
                  .where(
                    (prescription) =>
                        prescription.date.year == now.year &&
                        prescription.date.month == now.month &&
                        prescription.date.day == now.day,
                  )
                  .toList();
          break;
        case 'month':
          final oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
          _filteredPrescriptions =
              _prescriptions
                  .where(
                    (prescription) => prescription.date.isAfter(oneMonthAgo),
                  )
                  .toList();
          break;
        case '3months':
          final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
          _filteredPrescriptions =
              _prescriptions
                  .where(
                    (prescription) => prescription.date.isAfter(threeMonthsAgo),
                  )
                  .toList();
          break;
        case '6months':
          final sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);
          _filteredPrescriptions =
              _prescriptions
                  .where(
                    (prescription) => prescription.date.isAfter(sixMonthsAgo),
                  )
                  .toList();
          break;
        case 'custom':
          if (_customStartDate != null && _customEndDate != null) {
            _filteredPrescriptions =
                _prescriptions
                    .where(
                      (prescription) =>
                          prescription.date.isAfter(
                            _customStartDate!.subtract(const Duration(days: 1)),
                          ) &&
                          prescription.date.isBefore(
                            _customEndDate!.add(const Duration(days: 1)),
                          ),
                    )
                    .toList();
          }
          break;
      }

      _filteredPrescriptions.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GradientBackground(
      // title: loc.prescriptions,
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
                    const SizedBox(height: 10),

                    // Header
                    Text(
                      loc.medicalPrescriptions, // Localized
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Compact Filter Section
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.filter_list,
                            color: AppTheme.primaryColor,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            loc.filter, // Localized
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildCompactFilterChip(loc.all, 'all'),
                                  _buildCompactFilterChip(loc.today, 'today'),
                                  _buildCompactFilterChip(loc.month, 'month'),
                                  _buildCompactFilterChip(loc.threeMonths, '3months'),
                                  _buildCompactFilterChip(loc.sixMonths, '6months'),
                                  GestureDetector(
                                    onTap: _selectCustomDateRange,
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 4),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            _filterType == 'custom'
                                                ? Colors.teal
                                                : Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        loc.custom, // Localized
                                        style: TextStyle(
                                          fontSize: 10,
                                          color:
                                              _filterType == 'custom'
                                                  ? Colors.white
                                                  : Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Add Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _showAddOptions,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: Text(
                          loc.addNewPrescription, // Localized
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Statistics
                    if (_filteredPrescriptions.isNotEmpty) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              loc.total, // Localized
                              _filteredPrescriptions.length.toString(),
                              AppTheme.primaryColor,
                              Icons.list,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatCard(
                              loc.range, // Localized
                              _getDateRangeText(),
                              Colors.blue,
                              Icons.date_range,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],

                    // List
                    Expanded(
                      child:
                          _filteredPrescriptions.isEmpty
                              ? _buildEmptyState(loc)
                              : ListView.builder(
                                itemCount: _filteredPrescriptions.length,
                                itemBuilder: (context, index) {
                                  final prescription =
                                      _filteredPrescriptions[index];
                                  return PrescriptionCard(
                                    prescription: prescription,
                                    onTap:
                                        () => _viewPrescriptionDetails(
                                          prescription,
                                        ),
                                    onDelete:
                                        () => _deletePrescription(
                                          prescription.id,
                                        ),
                                    onDownload:
                                        prescription.pdfUrl != null ||
                                                prescription.imageUrl != null
                                            ? () => _downloadPrescription(
                                              prescription,
                                            )
                                            : null,
                                  );
                                },
                              ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildCompactFilterChip(String label, String value) {
    final isSelected = _filterType == value;
    return Container(
      margin: const EdgeInsets.only(right: 4),
      child: GestureDetector(
        onTap: () => _applyDateFilter(value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? Colors.white : Colors.grey.shade600,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 9, color: AppTheme.textGrey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations loc) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.medical_information_outlined,
              size: 48,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            loc.noPrescriptionsFound, // Localized
            style: AppTheme.headingStyle.copyWith(
              fontSize: 18,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            loc.noPrescriptionsFoundRange, // Localized
            style: AppTheme.subheadingStyle.copyWith(color: AppTheme.textGrey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getDateRangeText() {
    if (_filteredPrescriptions.isEmpty) return AppLocalizations.of(context)!.noData ?? 'No data';

    final dates = _filteredPrescriptions.map((p) => p.date).toList();
    dates.sort();

    final earliest = dates.first;
    final latest = dates.last;

    if (earliest == latest) {
      return DateFormat('dd/MM').format(earliest);
    }

    return '${DateFormat('dd/MM').format(earliest)} - ${DateFormat('dd/MM').format(latest)}';
  }

  void _selectCustomDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange:
          _customStartDate != null && _customEndDate != null
              ? DateTimeRange(start: _customStartDate!, end: _customEndDate!)
              : null,
    );

    if (picked != null) {
      setState(() {
        _customStartDate = picked.start;
        _customEndDate = picked.end;
      });
      _applyDateFilter('custom');
    }
  }

  void _showAddOptions() {
    final loc = AppLocalizations.of(context)!;
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
                    loc.addPrescription, // Localized
                    style: AppTheme.headingStyle.copyWith(
                      fontSize: 20,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAddOption(
                          loc.takePhoto, // Localized
                          Icons.camera_alt,
                          loc.scanPrescription, // Localized
                          () {
                            Navigator.pop(context);
                            _takePrescriptionPhoto(ImageSource.camera);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildAddOption(
                          loc.uploadImage, // Localized
                          Icons.upload_file,
                          loc.uploadImageFile, // Localized
                          () {
                            Navigator.pop(context);
                            _takePrescriptionPhoto(ImageSource.gallery);
                          },
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
  }

  Widget _buildAddOption(
    String title,
    IconData icon,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTheme.subheadingStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTheme.subheadingStyle.copyWith(
                fontSize: 12,
                color: AppTheme.textGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePrescriptionPhoto(ImageSource source) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (image != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
        final File imageFile = File(image.path);

        Prescription newPrescription = await PrescriptionService()
            .scanPrescription(token: token!, file: imageFile);

        Navigator.of(context).pop(); // Close loading dialog
        setState(() {
          _prescriptions.add(newPrescription);
          _filteredPrescriptions = _prescriptions;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.prescriptionCaptured), // Localized
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'OK',
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

  void _uploadPrescriptionPDF() async {
    final loc = AppLocalizations.of(context)!;
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null) {
        _showSuccessMessage(loc.pdfUploadedSuccessfully );
      }
    } catch (e) {
      _showErrorMessage(loc.failedToUploadPdf );
    }
  }

  void _viewPrescriptionDetails(Prescription prescription) async {
    final loc = AppLocalizations.of(context)!;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PrescriptionDetailsScreen(
              prescription: prescription,
              deletePrescription: _deletePrescription,
            ),
      ),
    );

    // Handle delete result
    if (result == 'delete') {
      final deletedPrescription = _prescriptions.firstWhere(
        (p) => p.id == prescription.id,
      );
      final originalIndex = _prescriptions.indexOf(deletedPrescription);

      setState(() {
        _prescriptions.removeWhere((p) => p.id == prescription.id);
        _applyDateFilter(_filterType);
      });

      // Show confirmation with undo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loc.prescriptionDeleted.replaceFirst('{doctorName}', deletedPrescription.doctorName??"N/A"), // Localized
          ),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: loc.undo, // Localized
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                _prescriptions.insert(originalIndex, deletedPrescription);
                _applyDateFilter(_filterType);
              });
            },
          ),
        ),
      );
    }
  }

  Future<void> _deletePrescription(String id) async {
    final loc = AppLocalizations.of(context)!;
    try {
      await PrescriptionService().deletePrescription(
        Provider.of<AuthProvider>(context, listen: false).token!,
        id,
      );
      final deletedPrescription = _prescriptions.firstWhere((p) => p.id == id);
      final originalIndex = _prescriptions.indexOf(deletedPrescription);

      setState(() {
        _prescriptions.removeWhere((p) => p.id == id);
        _applyDateFilter(_filterType);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.prescriptionDeleted), // Localized
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.failedToDeletePrescription?.replaceFirst('{error}', e.toString()) ?? 'Failed to delete prescription: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }

  void _downloadPrescription(Prescription prescription) {
    final loc = AppLocalizations.of(context)!;
    _showSuccessMessage(
      loc.downloadingPrescription?.replaceFirst('{doctorName}', prescription.doctorName??"N/A") ??
          'Downloading prescription from Dr. ${prescription.doctorName}...',
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
