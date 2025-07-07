import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/services/prescription_service.dart';
import '/utils/age_helper.dart';
import '/providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import "../../utils/date_formatter.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SessionRecordsScreen extends StatefulWidget {
  const SessionRecordsScreen({super.key});

  @override
  State<SessionRecordsScreen> createState() => _SessionRecordsScreenState();
}

class _SessionRecordsScreenState extends State<SessionRecordsScreen> {
  String selectedFilter = 'Today';
  DateTime? customStartDate;
  DateTime? customEndDate;
  String searchQuery = '';
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _doctorPrescriptions = [];

  final List<String> filterOptions = [
    'All',
    'Today',
    'Last 4 Days',
    'Last 15 Days',
    'Last Month',
    'Custom Date',
  ];

  // Mock session data - in real app, this would come from API
  List<Map<String, dynamic>> get filteredSessions {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _doctorPrescriptions.where((session) {
        final sessionDate = DateTime.parse(session['date']);
        final date = DateTime(
          sessionDate.year,
          sessionDate.month,
          sessionDate.day,
        );
        // Date filter
        bool dateMatch = true;
        switch (selectedFilter) {
          case 'All':
            dateMatch = true;
            break;
          case 'Today':
            dateMatch = date.isAfter(today.subtract(const Duration(days: 1)));
            break;
          case 'Last 4 Days':
            dateMatch = date.isAfter(today.subtract(const Duration(days: 4)));
            break;
          case 'Last 15 Days':
            dateMatch = date.isAfter(today.subtract(const Duration(days: 15)));
            break;
          case 'Last Month':
            dateMatch = date.isAfter(today.subtract(const Duration(days: 30)));
            break;
          case 'Custom Date':
            if (customStartDate != null && customEndDate != null) {
              dateMatch =
                  date.isAfter(
                    customStartDate!.subtract(const Duration(days: 1)),
                  ) &&
                  date.isBefore(customEndDate!.add(const Duration(days: 1)));
            }
            break;
        }

        // Search filter
        String fullName = '${session['patientName']}';
        bool searchMatch =
            searchQuery.isEmpty ||
            fullName.toLowerCase().contains(searchQuery.toLowerCase()) ||
            session['nationalId']!.contains(searchQuery);

        return dateMatch && searchMatch;
      }).toList()
      ..sort((a, b) => b['date'].compareTo(a['date']));
  }

  // Statistics
  Map<String, dynamic> get sessionStats {
    final sessions = filteredSessions;
    final totalSessions = sessions.length;
    final todaySessions =
        sessions.where((s) {
          final today = DateTime.now();
          final sessionDate = DateTime.parse(s['date']);
          final date = DateTime(
            sessionDate.year,
            sessionDate.month,
            sessionDate.day,
          );
          final todayDate = DateTime(today.year, today.month, today.day);
          return date == todayDate;
        }).length;

    final uniquePatients = sessions.map((s) => s['nationalId']).toSet().length;

    return {
      'total': totalSessions,
      'today': todaySessions,
      'patients': uniquePatients,
    };
  }

  @override
  void initState() {
    super.initState();
    _fetchDoctorPrescriptions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = sessionStats;
    final loc = AppLocalizations.of(context)!;

    return GradientBackground(
      title: loc.sessionRecords, // Localized
      withAppBar: true,
      showBackButton: true,
      child: Column(
        children: [
          // Statistics Cards
          Container(
            margin: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    loc.totalSessions, // Localized
                    stats['total'].toString(),
                    AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    loc.today, // Localized
                    stats['today'].toString(),
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    loc.patients, // Localized
                    stats['patients'].toString(),
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: loc.searchByPatient, // Localized
                prefixIcon: const Icon(Icons.search, color: Color(0xFF2196F3)),
                suffixIcon:
                    searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              searchQuery = '';
                            });
                          },
                        )
                        : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppTheme.primaryColor,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor.withOpacity(0.1), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.filter_list,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        loc.filterSessions, // Localized
                        style: AppTheme.headingStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Horizontally Scrollable Filter Options
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filterOptions.length,
                    itemBuilder: (context, index) {
                      final filter = filterOptions[index];
                      bool isSelected = selectedFilter == filter;
                      return Container(
                        margin: EdgeInsets.only(
                          right: index < filterOptions.length - 1 ? 8 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            if (filter == 'Custom Date') {
                              _showCustomDatePicker();
                            } else {
                              setState(() {
                                selectedFilter = filter;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient:
                                  isSelected
                                      ? const LinearGradient(
                                        colors: [
                                          Color(0xFF2196F3),
                                          Color(0xFF1976D2),
                                        ],
                                      )
                                      : null,
                              color: isSelected ? null : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? AppTheme.primaryColor
                                        : Colors.grey.shade300,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                filter,
                                style: AppTheme.subheadingStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (selectedFilter == 'Custom Date' &&
                    customStartDate != null &&
                    customEndDate != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.date_range,
                          color: Color(0xFF2196F3),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${formatDate(customStartDate!.toIso8601String()!)} - ${formatDate(customEndDate!.toIso8601String())}',
                          style: AppTheme.subheadingStyle.copyWith(
                            fontSize: 12,
                            color: const Color(0xFF2196F3),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Sessions List
          Expanded(
            child:
                filteredSessions.isEmpty
                    ? _buildEmptyState(loc)
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredSessions.length,
                      itemBuilder: (context, index) {
                        return _buildSessionCard(filteredSessions[index], loc);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTheme.headingStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTheme.subheadingStyle.copyWith(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> session, AppLocalizations loc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, const Color(0xFFF8F9FA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            _showSessionDetails(session, loc);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Patient Avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF6366F1).withOpacity(0.1),
                        const Color(0xFF8B5CF6).withOpacity(0.1),
                      ],
                    ),
                    border: Border.all(
                      color: const Color(0xFF6366F1).withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 24,
                    color: Color(0xFF6366F1),
                  ),
                ),
                const SizedBox(width: 16),

                // Patient Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${session['patientName']}',
                        style: AppTheme.headingStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDateTime(DateTime.parse(session['date']), loc),
                            style: AppTheme.subheadingStyle.copyWith(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Session Actions
              ],
            ),
          ),
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
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.history, size: 48, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 24),
          Text(
            loc.noSessionsFound, // Localized
            style: AppTheme.headingStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isNotEmpty
                ? loc.noSessionsFoundMatching(searchQuery)
                : loc.noPatientSessionsFound,
            style: AppTheme.subheadingStyle.copyWith(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime, AppLocalizations loc) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateStr;
    if (date == today) {
      dateStr = loc.today; // Localized
    } else if (date == today.subtract(const Duration(days: 1))) {
      dateStr = loc.yesterday; // Localized
    } else {
      dateStr = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }

    String timeStr =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return loc.atTime(dateStr, timeStr); // Localized
  }

  void _showCustomDatePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange:
          customStartDate != null && customEndDate != null
              ? DateTimeRange(start: customStartDate!, end: customEndDate!)
              : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: const Color(0xFF2196F3)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedFilter = 'Custom Date';
        customStartDate = picked.start;
        customEndDate = picked.end;
      });
    }
  }

  void _showSessionDetails(Map<String, dynamic> session, AppLocalizations loc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF6366F1).withOpacity(0.1),
                              const Color(0xFF8B5CF6).withOpacity(0.1),
                            ],
                          ),
                          border: Border.all(
                            color: const Color(0xFF6366F1).withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 30,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${session['patientName']} ',
                              style: AppTheme.headingStyle.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${loc.age}: ${AgeHelper.calculateAge(formatDate(session['dateOfBirth']))}',
                              style: AppTheme.subheadingStyle.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // Session Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                          loc.sessionDate, // Localized
                          _formatDateTime(DateTime.parse(session['date']), loc),
                        ),
                        if (session['notes'].isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            loc.sessionNotes, // Localized
                            style: AppTheme.subheadingStyle.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              session['notes'] ?? loc.noNotesAvailable, // Localized
                              style: AppTheme.subheadingStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTheme.subheadingStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: AppTheme.subheadingStyle.copyWith(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchDoctorPrescriptions() async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    try {
      print("hellooooos");
      final prescriptionsRaw = await PrescriptionService()
          .getDoctorPrescriptions(token!);

      setState(() {
        _doctorPrescriptions = prescriptionsRaw;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: ${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ),
      );
    }
  }
}
