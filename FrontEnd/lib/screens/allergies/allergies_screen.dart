import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/allergy.dart';
import '../../../providers/auth_provider.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/allergy_card.dart';
import '../../../widgets/gradient_background.dart';
import 'add_allergy_screen.dart';
import 'edit_allergy_screen.dart';
import '../../../services/allergy_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllergiesScreen extends StatefulWidget {
  const AllergiesScreen({super.key});

  @override
  State<AllergiesScreen> createState() => _AllergiesScreenState();
}

class _AllergiesScreenState extends State<AllergiesScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  DateTime? _customStartDate;
  DateTime? _customEndDate;
  List<Allergy> _allergies = [];
  List<Allergy> _filteredAllergies = [];
  String _filterType = 'all';

  @override
  void initState() {
    super.initState();
    _fetchAllergies();
  }

  Future<void> _fetchAllergies() async {
    setState(() => _isLoading = true);
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final allergies = await AllergyService().getAllergies(token!);
    setState(() {
      _allergies = allergies;
      // _filteredAllergies = allergies;
      _applyFilters();
      _isLoading = false;
    });
  }

  void _applyFilters() {
    List<Allergy> filtered = List.from(_allergies);

    // Apply search filter
    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (allergy) =>
                    allergy.allergyName.toLowerCase().contains(searchQuery),
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
                  (allergy) =>
                      allergy.date!.year == now.year &&
                      allergy.date!.month == now.month &&
                      allergy.date!.day == now.day,
                )
                .toList();
        break;
      case 'month':
        final oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
        filtered =
            filtered
                .where((allergy) => allergy.date!.isAfter(oneMonthAgo))
                .toList();
        break;
      case '3months':
        final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
        filtered =
            filtered
                .where((allergy) => allergy.date!.isAfter(threeMonthsAgo))
                .toList();
        break;
      case '6months':
        final sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);
        filtered =
            filtered
                .where((allergy) => allergy.date!.isAfter(sixMonthsAgo))
                .toList();
        break;
      case 'custom':
        if (_customStartDate != null && _customEndDate != null) {
          filtered =
              filtered
                  .where(
                    (allergy) =>
                        allergy.date!.isAfter(
                          _customStartDate!.subtract(const Duration(days: 1)),
                        ) &&
                        allergy.date!.isBefore(
                          _customEndDate!.add(const Duration(days: 1)),
                        ),
                  )
                  .toList();
        }
        break;
    }

    setState(() {
      _filteredAllergies = filtered;
      _filteredAllergies.sort((a, b) => b.date!.compareTo(a.date!));
    });
  }

  void _filterAllergies(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredAllergies = _allergies;
      } else {
        _filteredAllergies =
            _allergies
                .where(
                  (allergy) => allergy.allergyName.toLowerCase().contains(
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
              AppLocalizations.of(context)!.allergies,
              style: AppTheme.headingStyle.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
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
                onChanged: _filterAllergies,
                decoration: InputDecoration(
                  hintText:  AppLocalizations.of(context)!.searchAllergies,
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

            const SizedBox(height: 12),

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

            // Add Allergy Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addAllergy,
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
                  AppLocalizations.of(context)!.addNewAllergy,
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
            if (_filteredAllergies.isNotEmpty) ...[
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      AppLocalizations.of(context)!.total,
                      _filteredAllergies.length.toString(),
                      AppTheme.primaryColor,
                      Icons.list,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            // Allergies List
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredAllergies.isEmpty
                      ? _buildEmptyState()
                      : ListView.separated(
                        itemCount: _filteredAllergies.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final allergy = _filteredAllergies[index];
                          return AllergyCard(
                            allergy: allergy,
                            onTap: () => _showAllergyDetails(allergy),
                            onEdit: () => _editAllergy(allergy),
                            onDelete: () => _deleteAllergy(allergy.id),
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
            AppLocalizations.of(context)!.noAllergiesFound,
            style: AppTheme.headingStyle.copyWith(
              fontSize: 20,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.addFirstAllergy,
            style: AppTheme.subheadingStyle.copyWith(color: AppTheme.textGrey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
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
        _filterType = "custom";
      });
      _applyFilters();
    }
  }

  void _addAllergy() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddAllergyScreen()),
    ).then((newAllergy) {
      if (newAllergy != null) {
        setState(() {
          _allergies.add(newAllergy);
          _filteredAllergies = _allergies;
        });
      }
    });
  }

  void _editAllergy(Allergy allergy) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAllergyScreen(allergy: allergy),
      ),
    ).then((updatedAllergy) {
      if (updatedAllergy != null) {
        setState(() {
          final index = _allergies.indexWhere((a) => a.id == allergy.id);
          if (index != -1) {
            _allergies[index] = updatedAllergy;
            _filteredAllergies = _allergies;
          }
        });
      }
    });
  }

  Future<void> _deleteAllergy(String id) async {
    try {
      await AllergyService().deleteAllergy(
        Provider.of<AuthProvider>(context, listen: false).token!,
        id,
      );
      // Remove from UI lists after successful deletion
      setState(() {
        _allergies.removeWhere((a) => a.id == id);
        _filteredAllergies.removeWhere((a) => a.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Allergy deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete allergy: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }

  void _showAllergyDetails(Allergy allergy) {
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
                          allergy.allergyName,
                          style: AppTheme.headingStyle.copyWith(
                            fontSize: 24,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (allergy.date != null)
                    _buildDetailRow(
                      AppLocalizations.of(context)!.date,
                      // 'Date',
                      '${allergy.date!.day}/${allergy.date!.month}/${allergy.date!.year}',
                    ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _editAllergy(allergy);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.edit, color: Colors.white),
                          label: const Text(
                            'Edit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _deleteAllergy(allergy.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.delete, color: Colors.white),
                          label:  Text(
                            AppLocalizations.of(context)!.deleteAllergy,
                            // 'Delete',
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
