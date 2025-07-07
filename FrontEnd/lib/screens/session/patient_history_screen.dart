import 'package:flutter/material.dart';
import '/models/userModel.dart';
import '/widgets/history_content_tabs.dart';
import '/widgets/history_search_filters.dart';
import '/widgets/history_tab_bar.dart';
import '../../widgets/gradient_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatientHistoryScreen extends StatefulWidget {
  final UserModel patient;

  const PatientHistoryScreen({
    super.key,
    required this.patient,
  });

  @override
  State<PatientHistoryScreen> createState() => _PatientHistoryScreenState();
}

class _PatientHistoryScreenState extends State<PatientHistoryScreen> {
  int selectedTab = 0;
  String searchQuery = '';
  DateTime? selectedDate;
  String? bloodPressureFilter;
  bool? medicationActiveFilter;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      selectedTab = index;
      _clearFilters();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  void _onDateChanged(DateTime? date) {
    setState(() {
      selectedDate = date;
    });
  }

  void _onBloodPressureFilterChanged(String? filter) {
    setState(() {
      bloodPressureFilter = filter;
    });
  }

  void _onMedicationFilterChanged(bool? filter) {
    setState(() {
      medicationActiveFilter = filter;
    });
  }

  void _clearFilters() {
    setState(() {
      searchQuery = '';
      selectedDate = null;
      bloodPressureFilter = null;
      medicationActiveFilter = null;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GradientBackground(
      title: loc.medicalHistory, // Localized
      withAppBar: true,
      showBackButton: true,
      child: Column(
        children: [
          const SizedBox(height: 10),

          // Tab Bar
          HistoryTabBar(
            selectedTab: selectedTab,
            onTabChanged: _onTabChanged,
          ),

          const SizedBox(height: 16),

          // Search and Filters
          HistorySearchFilters(
            selectedTab: selectedTab,
            searchController: _searchController,
            searchQuery: searchQuery,
            selectedDate: selectedDate,
            bloodPressureFilter: bloodPressureFilter,
            medicationActiveFilter: medicationActiveFilter,
            onSearchChanged: _onSearchChanged,
            onDateChanged: _onDateChanged,
            onBloodPressureFilterChanged: _onBloodPressureFilterChanged,
            onMedicationFilterChanged: _onMedicationFilterChanged,
          ),

          const SizedBox(height: 16),

          // Content
          Expanded(
            child: HistoryContentTabs(
              selectedTab: selectedTab,
              searchQuery: searchQuery,
              selectedDate: selectedDate,
              bloodPressureFilter: bloodPressureFilter,
              medicationActiveFilter: medicationActiveFilter,
            ),
          ),
        ],
      ),
    );
  }
}