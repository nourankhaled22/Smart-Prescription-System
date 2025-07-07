import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/services/blood_pressure_service.dart';
import '/widgets/blood_pressure_card.dart';

import '../../models/blood_pressure.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import './add_blood_pressure.dart';
import './edit_blood_pressure.dart';
import './blood_pressure_details_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // <-- Add this import

class BloodPressureScreen extends StatefulWidget {
  const BloodPressureScreen({super.key});

  @override
  State<BloodPressureScreen> createState() => _BloodPressureScreenState();
}

class _BloodPressureScreenState extends State<BloodPressureScreen> {
  String _dateFilter = 'all';
  String _levelFilter = 'all';
  DateTime? _customStartDate;
  DateTime? _customEndDate;
  bool _isLoading = true;

  // Sample data
  List<BloodPressure> _bloodPressures = [];

  List<BloodPressure> _filteredBloodPressures = [];

  @override
  void initState() {
    super.initState();
    _fetchBloodPressures();
  }

  Future<void> _fetchBloodPressures() async {
    setState(() => _isLoading = true);
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;

      final exams = await BloodPressureService().getbloodPressures(token!);
      setState(() {
        _bloodPressures = exams;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.failedToUpdateBloodPressure(e.toString()))),
      );
    }
  }

  void _applyFilters() {
    List<BloodPressure> filtered = List.from(_bloodPressures);

    // Apply date filter
    final now = DateTime.now();
    switch (_dateFilter) {
      case 'today':
        filtered =
            filtered
                .where(
                  (bp) =>
                      bp.date.year == now.year &&
                      bp.date.month == now.month &&
                      bp.date.day == now.day,
                )
                .toList();
        break;
      case 'month':
        final oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
        filtered =
            filtered.where((bp) => bp.date.isAfter(oneMonthAgo)).toList();
        break;
      case '3months':
        final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
        filtered =
            filtered.where((bp) => bp.date.isAfter(threeMonthsAgo)).toList();
        break;
      case '6months':
        final sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);
        filtered =
            filtered.where((bp) => bp.date.isAfter(sixMonthsAgo)).toList();
        break;
      case 'custom':
        if (_customStartDate != null && _customEndDate != null) {
          filtered =
              filtered
                  .where(
                    (bp) =>
                        bp.date.isAfter(
                          _customStartDate!.subtract(const Duration(days: 1)),
                        ) &&
                        bp.date.isBefore(
                          _customEndDate!.add(const Duration(days: 1)),
                        ),
                  )
                  .toList();
        }
        break;
    }

    // Apply level filter
    switch (_levelFilter) {
      case 'normal':
        filtered =
            filtered
                .where((bp) => bp.systolic < 120 && bp.diastolic < 80)
                .toList();
        break;
      case 'high':
        filtered =
            filtered
                .where((bp) => bp.systolic >= 130 || bp.diastolic >= 80)
                .toList();
        break;
      case 'low':
        filtered =
            filtered
                .where((bp) => bp.systolic < 90 || bp.diastolic < 60)
                .toList();
        break;
    }

    setState(() {
      _filteredBloodPressures = filtered;
      _filteredBloodPressures.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance
    return GradientBackground(
      //title: loc.bloodPressure,
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
                      loc.bloodPressure, // Localized
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
                      child: Column(
                        children: [
                          // Date filters
                          Row(
                            children: [
                              const Icon(
                                Icons.date_range,
                                color: Colors.purple,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${loc.date}:', // Localized
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.purple,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _buildCompactChip(
                                        loc.all, // Localized
                                        'all',
                                        _dateFilter,
                                        (value) => setState(() {
                                          _dateFilter = value;
                                          _applyFilters();
                                        }),
                                      ),
                                      _buildCompactChip(
                                        loc.today, // Localized
                                        'today',
                                        _dateFilter,
                                        (value) => setState(() {
                                          _dateFilter = value;
                                          _applyFilters();
                                        }),
                                      ),
                                      _buildCompactChip(
                                        loc.month, // Localized
                                        'month',
                                        _dateFilter,
                                        (value) => setState(() {
                                          _dateFilter = value;
                                          _applyFilters();
                                        }),
                                      ),
                                      _buildCompactChip(
                                        loc.threeMonths, // Localized
                                        '3months',
                                        _dateFilter,
                                        (value) => setState(() {
                                          _dateFilter = value;
                                          _applyFilters();
                                        }),
                                      ),
                                      _buildCompactChip(
                                        loc.sixMonths, // Localized
                                        '6months',
                                        _dateFilter,
                                        (value) => setState(() {
                                          _dateFilter = value;
                                          _applyFilters();
                                        }),
                                      ),
                                      GestureDetector(
                                        onTap: _selectCustomDateRange,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            left: 4,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                _dateFilter == 'custom'
                                                    ? Colors.purple
                                                    : Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            loc.custom, // Localized
                                            style: TextStyle(
                                              fontSize: 10,
                                              color:
                                                  _dateFilter == 'custom'
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
                          const SizedBox(height: 8),
                          // Level filters
                          Row(
                            children: [
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${loc.level}:', // Localized
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _buildCompactChip(
                                        loc.all, // Localized
                                        'all',
                                        _levelFilter,
                                        (value) => setState(() {
                                          _levelFilter = value;
                                          _applyFilters();
                                        }),
                                      ),
                                      _buildCompactChip(
                                        loc.normal, // Localized
                                        'normal',
                                        _levelFilter,
                                        (value) => setState(() {
                                          _levelFilter = value;
                                          _applyFilters();
                                        }),
                                      ),
                                      _buildCompactChip(
                                        loc.high, // Localized
                                        'high',
                                        _levelFilter,
                                        (value) => setState(() {
                                          _levelFilter = value;
                                          _applyFilters();
                                        }),
                                      ),
                                      _buildCompactChip(
                                        loc.low, // Localized
                                        'low',
                                        _levelFilter,
                                        (value) => setState(() {
                                          _levelFilter = value;
                                          _applyFilters();
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Add Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _addBloodPressure,
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
                          loc.addNewReading, // Localized
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
                    if (_filteredBloodPressures.isNotEmpty) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              loc.total, // Localized
                              _filteredBloodPressures.length.toString(),
                              Colors.purple,
                              Icons.list,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatCard(
                              loc.avgSys, // Localized
                              _calculateAverageSystolic(),
                              Colors.blue,
                              Icons.arrow_upward,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatCard(
                              loc.avgDia, // Localized
                              _calculateAverageDiastolic(),
                              Colors.red,
                              Icons.arrow_downward,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],

                    // List
                    Expanded(
                      child:
                          _filteredBloodPressures.isEmpty
                              ? _buildEmptyState(loc)
                              : ListView.builder(
                                itemCount: _filteredBloodPressures.length,
                                itemBuilder: (context, index) {
                                  final bloodPressure =
                                      _filteredBloodPressures[index];
                                  return BloodPressureCard(
                                    bloodPressure: bloodPressure,
                                    onTap: () => _viewDetails(bloodPressure),

                                    onEdit:
                                        () => _editBloodPressure(bloodPressure),
                                    onDelete:
                                        () => _deleteBloodPressure(
                                          bloodPressure.id,
                                        ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildCompactChip(
    String label,
    String value,
    String currentValue,
    Function(String) onSelected,
  ) {
    final isSelected = currentValue == value;
    return Container(
      margin: const EdgeInsets.only(right: 4),
      child: GestureDetector(
        onTap: () => onSelected(value),
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
          ),
          Text(title, style: TextStyle(fontSize: 9, color: AppTheme.textGrey)),
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
              color: Colors.purple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border,
              size: 48,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            loc.noReadingsFound, // Localized
            style: AppTheme.headingStyle.copyWith(
              fontSize: 18,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            loc.noReadingsFoundFilters, // Localized
            style: AppTheme.subheadingStyle.copyWith(color: AppTheme.textGrey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _calculateAverageSystolic() {
    if (_filteredBloodPressures.isEmpty) return '0';
    final total = _filteredBloodPressures.fold(
      0,
      (sum, bp) => sum + bp.systolic,
    );
    return (total / _filteredBloodPressures.length).round().toString();
  }

  String _calculateAverageDiastolic() {
    if (_filteredBloodPressures.isEmpty) return '0';
    final total = _filteredBloodPressures.fold(
      0,
      (sum, bp) => sum + bp.diastolic,
    );
    return (total / _filteredBloodPressures.length).round().toString();
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
        _dateFilter = 'custom';
      });
      _applyFilters();
    }
  }

  void _addBloodPressure() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddBloodPressureScreen()),
    );

    if (result != null && result is BloodPressure) {
      setState(() {
        _bloodPressures.add(result);
        _applyFilters();
      });
    }
  }

  void _editBloodPressure(BloodPressure bloodPressure) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => EditBloodPressureScreen(bloodPressure: bloodPressure),
      ),
    );

    if (result != null && result is BloodPressure) {
      setState(() {
        // Find and replace the edited blood pressure
        final index = _bloodPressures.indexWhere((bp) => bp.id == result.id);
        if (index != -1) {
          _bloodPressures[index] = result;
          _applyFilters();
        }
      });

      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.bloodPressureUpdated), // Localized
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _viewDetails(BloodPressure bloodPressure) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BloodPressureDetailsScreen(
              bloodPressure: bloodPressure,
              deleteBlood: _deleteBloodPressure,
            ),
      ),
    );

    // Handle edit result
    if (result != null && result is BloodPressure) {
      setState(() {
        final index = _bloodPressures.indexWhere((bp) => bp.id == result.id);
        if (index != -1) {
          _bloodPressures[index] = result;
          _applyFilters();
        }
      });

      // Show confirmation
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(AppLocalizations.of(context)!.bloodPressureUpdated),
      //     backgroundColor: Colors.green,
      //   ),
      // );
    }
    // Handle delete result - show undo option in main screen
    else if (result == 'delete') {
      // Store the deleted item for undo
      final deletedBP = bloodPressure;

      // Remove from list
      setState(() {
        _bloodPressures.removeWhere((bp) => bp.id == bloodPressure.id);
        _applyFilters();
      });

      // Show SnackBar with undo option in main screen
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(AppLocalizations.of(context)!.bloodPressureDeleted),
      //     backgroundColor: Colors.red,
      //     duration: const Duration(seconds: 4),
      //     action: SnackBarAction(
      //       label: AppLocalizations.of(context)!.undo,
      //       textColor: Colors.white,
      //       onPressed: () {
      //         // Restore the deleted item
      //         setState(() {
      //           _bloodPressures.add(deletedBP);
      //           _applyFilters();
      //         });
      //       },
      //     ),
      //   ),
      // );
    }
  }

  Future<void> _deleteBloodPressure(String id) async {
    try {
      await BloodPressureService().deletebloodPressure(
        Provider.of<AuthProvider>(context, listen: false).token!,
        id,
      );
      // Remove from UI lists after successful deletion
      setState(() {
        _bloodPressures.removeWhere((a) => a.id == id);
        _filteredBloodPressures.removeWhere((a) => a.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.bloodPressureDeleted), // Localized
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.failedToDeleteBloodPressure(e.toString())), // Localized
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }
}
