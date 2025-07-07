import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add for localization

class HistorySearchFilters extends StatelessWidget {
  final int selectedTab;
  final TextEditingController searchController;
  final String searchQuery;
  final DateTime? selectedDate;
  final String? bloodPressureFilter;
  final bool? medicationActiveFilter;
  final Function(String) onSearchChanged;
  final Function(DateTime?) onDateChanged;
  final Function(String?) onBloodPressureFilterChanged;
  final Function(bool?) onMedicationFilterChanged;

  const HistorySearchFilters({
    super.key,
    required this.selectedTab,
    required this.searchController,
    required this.searchQuery,
    required this.selectedDate,
    required this.bloodPressureFilter,
    required this.medicationActiveFilter,
    required this.onSearchChanged,
    required this.onDateChanged,
    required this.onBloodPressureFilterChanged,
    required this.onMedicationFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightBlue.withOpacity(0.2),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search Bar (for applicable tabs)
          if (_shouldShowSearch()) _buildSearchBar(context, loc),

          // Date Filter (for blood pressure and examinations)
          if (_shouldShowDateFilter()) ...[
            if (_shouldShowSearch()) const SizedBox(height: 12),
            _buildDateFilter(context, loc),
          ],

          // Blood Pressure Filter
          if (selectedTab == 3) ...[
            if (_shouldShowSearch() || _shouldShowDateFilter()) const SizedBox(height: 12),
            _buildBloodPressureFilter(loc),
          ],

          // Medication Status Filter
          if (selectedTab == 5) ...[
            if (_shouldShowSearch()) const SizedBox(height: 12),
            _buildMedicationStatusFilter(loc),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, AppLocalizations loc) {
    return TextField(
      controller: searchController,
      onChanged: onSearchChanged,
      decoration: InputDecoration(
        hintText: _getSearchHint(loc), // Localized
        prefixIcon: Icon(Icons.search, color: AppTheme.primaryColor),
        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: AppTheme.textGrey),
                onPressed: () {
                  searchController.clear();
                  onSearchChanged('');
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primaryColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildDateFilter(BuildContext context, AppLocalizations loc) {
    final List<String> dateOptions = [
      loc.allTime,
      loc.today,
      loc.last7Days,
      loc.last30Days,
      loc.customDate
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.filterByDate, // Localized
          style: AppTheme.subheadingStyle.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        // Make date filter scrollable
        SizedBox(
          height: 35,
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(
              scrollbars: false,
              overscroll: false,
              physics: const BouncingScrollPhysics(),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: dateOptions.length,
              itemBuilder: (context, index) {
                final option = dateOptions[index];
                bool isSelected = _getSelectedDateOption(loc) == option;
                return Container(
                  margin: EdgeInsets.only(
                    right: index < dateOptions.length - 1 ? 8 : 0,
                  ),
                  child: GestureDetector(
                    onTap: () => _handleDateOptionTap(context, option, loc),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
                              )
                            : null,
                        color: isSelected ? null : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryColor : AppTheme.textGrey.withOpacity(0.3),
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        option,
                        style: AppTheme.subheadingStyle.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (selectedDate != null && _getSelectedDateOption(loc) == loc.customDate) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.lightBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              loc.selected(_formatDate(selectedDate!)), // Localized
              style: AppTheme.subheadingStyle.copyWith(
                fontSize: 11,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBloodPressureFilter(AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.filterByLevel, // Localized
          style: AppTheme.subheadingStyle.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        // Make blood pressure filter scrollable
        SizedBox(
          height: 35,
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(
              scrollbars: false,
              overscroll: false,
              physics: const BouncingScrollPhysics(),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildFilterChip(loc.all, bloodPressureFilter == null, () {
                  onBloodPressureFilterChanged(null);
                }, loc),
                const SizedBox(width: 8),
                _buildFilterChip(loc.normal, bloodPressureFilter == 'normal', () {
                  onBloodPressureFilterChanged('normal');
                }, loc),
                const SizedBox(width: 8),
                _buildFilterChip(loc.high, bloodPressureFilter == 'high', () {
                  onBloodPressureFilterChanged('high');
                }, loc),
                const SizedBox(width: 8),
                _buildFilterChip(loc.low, bloodPressureFilter == 'low', () {
                  onBloodPressureFilterChanged('low');
                }, loc),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicationStatusFilter(AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.filterByStatus, // Localized
          style: AppTheme.subheadingStyle.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        // Make medication filter scrollable
        SizedBox(
          height: 35,
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(
              scrollbars: false,
              overscroll: false,
              physics: const BouncingScrollPhysics(),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildFilterChip(loc.all, medicationActiveFilter == null, () {
                  onMedicationFilterChanged(null);
                }, loc),
                const SizedBox(width: 8),
                _buildFilterChip(loc.active, medicationActiveFilter == true, () {
                  onMedicationFilterChanged(true);
                }, loc),
                const SizedBox(width: 8),
                _buildFilterChip(loc.inactive, medicationActiveFilter == false, () {
                  onMedicationFilterChanged(false);
                }, loc),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap, AppLocalizations loc) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.textGrey.withOpacity(0.3),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTheme.subheadingStyle.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  bool _shouldShowSearch() {
    return [0, 1, 2, 4, 5].contains(selectedTab);
  }

  bool _shouldShowDateFilter() {
    return [3, 4].contains(selectedTab);
  }

  String _getSearchHint(AppLocalizations loc) {
    switch (selectedTab) {
      case 0:
        return loc.searchChronicDiseases;
      case 1:
        return loc.searchAllergies;
      case 2:
        return loc.searchVaccines;
      case 4:
        return loc.searchExaminations;
      case 5:
        return loc.searchMedications;
      default:
        return loc.search;
    }
  }

  String _getSelectedDateOption(AppLocalizations loc) {
    if (selectedDate == null) return loc.allTime;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day);

    if (selectedDay == today) return loc.today;
    if (selectedDay == today.subtract(const Duration(days: 7))) return loc.last7Days;
    if (selectedDay == today.subtract(const Duration(days: 30))) return loc.last30Days;

    return loc.customDate;
  }

  void _handleDateOptionTap(BuildContext context, String option, AppLocalizations loc) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (option == loc.allTime) {
      onDateChanged(null);
    } else if (option == loc.today) {
      onDateChanged(today);
    } else if (option == loc.last7Days) {
      onDateChanged(today.subtract(const Duration(days: 7)));
    } else if (option == loc.last30Days) {
      onDateChanged(today.subtract(const Duration(days: 30)));
    } else if (option == loc.customDate) {
      _showCustomDatePicker(context);
    }
  }

  void _showCustomDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.primaryColor,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateChanged(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}