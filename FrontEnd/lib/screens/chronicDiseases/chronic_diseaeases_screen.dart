import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/chronic.dart';
import '../../../providers/auth_provider.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/chronic_card.dart';
import '../../../widgets/gradient_background.dart';
import './add_chronic_disease_screen.dart';
import './edit_chronic_disease_screen.dart';
import '../../../services/chronic_service.dart'; // <-- Import your service
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ChronicsScreen extends StatefulWidget {
  const ChronicsScreen({super.key});

  @override
  State<ChronicsScreen> createState() => _chronicsScreenState();
}

class _chronicsScreenState extends State<ChronicsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filterType = 'all';
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  List<Chronic> _chronics = [];
  List<Chronic> _filteredchronics = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchchronics();
  }

  Future<void> _fetchchronics() async {
    setState(() => _isLoading = true);
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final chronics = await ChronicService().getChronics(token!);
    setState(() {
      _chronics = chronics;
      _applyFilters();
      _isLoading = false;
    });
  }

  void _applyFilters() {
    List<Chronic> filtered = List.from(_chronics);

    // Apply search filter
    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (chronic) =>
                    chronic.diseaseName.toLowerCase().contains(searchQuery),
                // ||
                // (chronic.notes?.toLowerCase().contains(searchQuery) ??
                //     false),
              )
              .toList();
    }

    // Apply date filter
    final now = DateTime.now();
    switch (_filterType) {
      case 'today':
        filtered =
            filtered
                .where(
                  (chronic) =>
                      chronic.date!.year == now.year &&
                      chronic.date!.month == now.month &&
                      chronic.date!.day == now.day,
                )
                .toList();
        break;
      case 'month':
        final oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
        filtered =
            filtered
                .where((chronic) => chronic.date!.isAfter(oneMonthAgo))
                .toList();
        break;
      case '3months':
        final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
        filtered =
            filtered
                .where((chronic) => chronic.date!.isAfter(threeMonthsAgo))
                .toList();
        break;
      case '6months':
        final sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);
        filtered =
            filtered
                .where((chronic) => chronic.date!.isAfter(sixMonthsAgo))
                .toList();
        break;
      case 'custom':
        if (_customStartDate != null && _customEndDate != null) {
          filtered =
              filtered
                  .where(
                    (chronic) =>
                        chronic.date!.isAfter(
                          _customStartDate!.subtract(const Duration(days: 1)),
                        ) &&
                        chronic.date!.isBefore(
                          _customEndDate!.add(const Duration(days: 1)),
                        ),
                  )
                  .toList();
        }
        break;
    }

    setState(() {
      _filteredchronics = filtered;
      _filteredchronics.sort((a, b) => b.date!.compareTo(a.date!));
    });
  }

  void _filterchronics(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredchronics = _chronics;
      } else {
        _filteredchronics =
            _chronics
                .where(
                  (chronic) => chronic.diseaseName.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
                )
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      withAppBar: true,
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
               AppLocalizations.of(context)!.chronics,
              style: AppTheme.headingStyle.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            // Search Bar
            Container(
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
                onChanged: _filterchronics,
                decoration: InputDecoration(
                  hintText: 'Search chronic diseases...',
                  prefixIcon: Icon(Icons.search, color: AppTheme.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                  Icon(
                    Icons.filter_list,
                    color: AppTheme.primaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                     AppLocalizations.of(context)!.filter,
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
                          _buildCompactFilterChip('All', 'all'),
                          _buildCompactFilterChip( AppLocalizations.of(context)!.today, 'today'),
                          _buildCompactFilterChip( AppLocalizations.of(context)!.month, 'month'),
                          _buildCompactFilterChip( AppLocalizations.of(context)!.threeMonths, '3months'),
                          _buildCompactFilterChip( AppLocalizations.of(context)!.sixMonths, '6months'),
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
                                        ? AppTheme.primaryColor
                                        : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                 AppLocalizations.of(context)!.custom,
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
            // Add chronic Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addchronic,
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
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
                label: Text(
                   AppLocalizations.of(context)!.addNewChronic,
                  style: AppTheme.subheadingStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Statistics
            if (_filteredchronics.isNotEmpty) ...[
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                       AppLocalizations.of(context)!.total,
                      _filteredchronics.length.toString(),
                      AppTheme.primaryColor,
                      Icons.list,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            // chronics List
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredchronics.isEmpty
                      ? _buildEmptyState()
                      : ListView.separated(
                        itemCount: _filteredchronics.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final chronic = _filteredchronics[index];
                          return ChronicDiseaseCard(
                            chronicDisease: chronic,
                            onTap: () => _showchronicDetails(chronic),
                            onEdit: () => _editchronic(chronic),
                            onDelete: () => _deletechronic(chronic.id),
                          );
                        },
                      ),
            ),
          ],
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTheme.headingStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: AppTheme.subheadingStyle.copyWith(
              fontSize: 10,
              color: AppTheme.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
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
              Icons.warning_amber,
              size: 64,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
             AppLocalizations.of(context)!.noChronicsFound,
            style: AppTheme.headingStyle.copyWith(
              fontSize: 20,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
             AppLocalizations.of(context)!.addNewChronic,
            style: AppTheme.subheadingStyle.copyWith(color: AppTheme.textGrey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _addchronic() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddChronicScreen()),
    ).then((newchronic) {
      if (newchronic != null) {
        setState(() {
          _chronics.add(newchronic);
          _filteredchronics = _chronics;
        });
      }
    });
  }

  void _editchronic(Chronic chronic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditChronicScreen(chronic: chronic),
      ),
    ).then((updatedchronic) {
      if (updatedchronic != null) {
        setState(() {
          final index = _chronics.indexWhere((a) => a.id == chronic.id);
          if (index != -1) {
            _chronics[index] = updatedchronic;
            _filteredchronics = _chronics;
          }
        });
      }
    });
  }

  Future<void> _deletechronic(String id) async {
    try {
      await ChronicService().deletechronic(
        Provider.of<AuthProvider>(context, listen: false).token!,
        id,
      );
      // Remove from UI lists after successful deletion
      setState(() {
        _chronics.removeWhere((a) => a.id == id);
        _filteredchronics.removeWhere((a) => a.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('chronic deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete chronic: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
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
        _filterType = 'custom';
      });
      _applyFilters();
    }
  }

  void _showchronicDetails(Chronic chronic) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.warning,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          chronic.diseaseName,
                          style: AppTheme.headingStyle.copyWith(
                            fontSize: 24,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (chronic.date != null)
                    _buildDetailRow(
                       AppLocalizations.of(context)!.date,
                      '${chronic.date!.day}/${chronic.date!.month}/${chronic.date!.year}',
                    ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _editchronic(chronic);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.edit, color: Colors.white),
                          label:  Text(
                             AppLocalizations.of(context)!.editChronic,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _deletechronic(chronic.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.delete, color: Colors.white),
                          label:  Text(
                             AppLocalizations.of(context)!.deleteChronic,
                            style: TextStyle(color: Colors.white),
                          ),
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

  Widget _buildCompactFilterChip(String label, String value) {
    final isSelected = _filterType == value;
    return Container(
      margin: const EdgeInsets.only(right: 4),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _filterType = value;
          });
          _applyFilters();
        },
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTheme.subheadingStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textGrey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.subheadingStyle.copyWith(color: AppTheme.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
