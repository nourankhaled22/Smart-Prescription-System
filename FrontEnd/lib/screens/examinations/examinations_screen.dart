import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/widgets/examination_card.dart';
import '../../models/examination.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import 'add_examination_screen.dart';
import 'edit_examination_screen.dart';
import 'package:intl/intl.dart';
import '../../services/examination_service.dart';
import '../../providers/auth_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add this import

class ExaminationsScreen extends StatefulWidget {
  const ExaminationsScreen({super.key});

  @override
  State<ExaminationsScreen> createState() => _ExaminationsScreenState();
}

class _ExaminationsScreenState extends State<ExaminationsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filterType = 'all';
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  List<Examination> _examinations = [];
  List<Examination> _filteredExaminations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchExaminations();
  }

  Future<void> _fetchExaminations() async {
    setState(() => _isLoading = true);
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;

      final exams = await ExaminationService().getExaminations(token!);
      setState(() {
        _examinations = exams;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch examinations: $e')),
      );
    }
  }

  void _applyFilters() {
    List<Examination> filtered = List.from(_examinations);

    // Apply search filter
    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (examination) =>
                    examination.examinationName.toLowerCase().contains(
                      searchQuery,
                    ) ||
                    (examination.notes?.toLowerCase().contains(searchQuery) ??
                        false),
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
                  (examination) =>
                      examination.date.year == now.year &&
                      examination.date.month == now.month &&
                      examination.date.day == now.day,
                )
                .toList();
        break;
      case 'month':
        final oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
        filtered =
            filtered
                .where((examination) => examination.date.isAfter(oneMonthAgo))
                .toList();
        break;
      case '3months':
        final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
        filtered =
            filtered
                .where(
                  (examination) => examination.date.isAfter(threeMonthsAgo),
                )
                .toList();
        break;
      case '6months':
        final sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);
        filtered =
            filtered
                .where((examination) => examination.date.isAfter(sixMonthsAgo))
                .toList();
        break;
      case 'custom':
        if (_customStartDate != null && _customEndDate != null) {
          filtered =
              filtered
                  .where(
                    (examination) =>
                        examination.date.isAfter(
                          _customStartDate!.subtract(const Duration(days: 1)),
                        ) &&
                        examination.date.isBefore(
                          _customEndDate!.add(const Duration(days: 1)),
                        ),
                  )
                  .toList();
        }
        break;
    }

    setState(() {
      _filteredExaminations = filtered;
      _filteredExaminations.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Add this line
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
                    const SizedBox(height: 10),

                    // Header
                    Text(
                      loc.medicalExaminations, // <-- localized
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
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => _applyFilters(),
                        decoration: InputDecoration(
                          hintText: loc.searchExaminations, // <-- localized
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppTheme.primaryColor,
                            size: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                        style: const TextStyle(fontSize: 14),
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
                            loc.filter, // <-- localized
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
                                                ? AppTheme.primaryColor
                                                : Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        loc.custom, // <-- localized
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
                        onPressed: _addExamination,
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
                          loc.addNewExamination, // <-- localized
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
                    if (_filteredExaminations.isNotEmpty) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              loc.total, // <-- localized
                              _filteredExaminations.length.toString(),
                              AppTheme.primaryColor,
                              Icons.list,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],

                    // List
                    Expanded(
                      child:
                          _filteredExaminations.isEmpty
                              ? _buildEmptyState(loc) // Pass loc
                              : ListView.builder(
                                itemCount: _filteredExaminations.length,
                                itemBuilder: (context, index) {
                                  final examination =
                                      _filteredExaminations[index];
                                  return ExaminationCard(
                                    examination: examination,
                                    onTap:
                                        () => _showExaminationDetails(
                                          examination,
                                          loc, // Pass loc
                                        ),
                                    onEdit: () => _editExamination(examination),
                                    onDelete:
                                        () =>
                                            _deleteExamination(examination.id),
                                    onDownload:
                                        examination.pdfUrl != null
                                            ? () => _downloadExamination(
                                              examination,
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
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.medical_services_outlined,
              size: 48,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            loc.noExaminationsFound, // <-- localized
            style: AppTheme.headingStyle.copyWith(
              fontSize: 18,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            loc.addFirstExamination, // <-- localized
            style: AppTheme.subheadingStyle.copyWith(color: AppTheme.textGrey),
            textAlign: TextAlign.center,
          ),
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
        _filterType = 'custom';
      });
      _applyFilters();
    }
  }

  void _addExamination() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddExaminationScreen()),
    );

    if (result != null && result is Examination) {
      setState(() {
        _examinations.add(result);
      });
      _applyFilters();
    }
  }

  void _editExamination(Examination examination) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExaminationScreen(examination: examination),
      ),
    );
    print(result.examinationName);

    if (result != null && result is Examination) {
      print("djkhgjkghgjghj");
      setState(() {
        final index = _examinations.indexWhere((e) => e.id == result.id);
        if (index != -1) {
          _examinations[index] = result;
        }
      });
      _applyFilters();
    }
  }

  void _deleteExamination(String id) async {
    final deletedExamination = _examinations.firstWhere((e) => e.id == id);
    final originalIndex = _examinations.indexOf(deletedExamination);

    setState(() {
      _examinations.removeWhere((e) => e.id == id);
    });
    _applyFilters();

    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      await ExaminationService().deleteexamination(token!, id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${deletedExamination.examinationName} deleted'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Undo',
            textColor: Colors.white,
            onPressed: () async {
              setState(() {
                _examinations.insert(originalIndex, deletedExamination);
              });
              _applyFilters();
              // Optionally, re-add on backend if needed
              // await ExaminationService().addExamination(...);
            },
          ),
        ),
      );
    } catch (e) {
      // If deletion fails, restore the item in the list
      setState(() {
        _examinations.insert(originalIndex, deletedExamination);
      });
      _applyFilters();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _downloadExamination(Examination examination) async {
    try {
      // Get token from provider
      final token = Provider.of<AuthProvider>(context, listen: false).token;

      // Download the PDF using the service
      final filePath = await ExaminationService().downloadExaminationPdf(
        token: token!,
        examinationId: examination.id,
        fileName: '${examination.examinationName}.pdf',
      );
      // print(filePath);
      // Show success message with option to open
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${examination.examinationName} downloaded successfully!',
          ),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Open',
            textColor: Colors.white,
            onPressed: () async {
              if (filePath != null) {
                await OpenFile.open(filePath);
              }
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to download ${examination.examinationName}: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showExaminationDetails(Examination examination, AppLocalizations loc) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final formattedDate = dateFormat.format(examination.date);

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
                  // Handle bar
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

                  // Header with icon and title
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.medical_services,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            examination.examinationName,
                            style: AppTheme.headingStyle.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Details section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(loc.date, formattedDate), // <-- localized
                        if (examination.notes != null &&
                            examination.notes!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _buildDetailRow(loc.notes, examination.notes!), // <-- localized
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _downloadExamination(examination);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(
                            Icons.download,
                            color: Colors.white,
                            size: 18,
                          ),
                          label: Text(
                            loc.download, // <-- localized
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _editExamination(examination);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                          label: Text(
                            loc.editExamination, // <-- localized
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _deleteExamination(examination.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 18,
                          ),
                          label: Text(
                            loc.deleteExamination, // <-- localized
                            style: const TextStyle(color: Colors.white, fontSize: 16),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.subheadingStyle.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textGrey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.subheadingStyle.copyWith(
            fontSize: 14,
            color: AppTheme.black,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
