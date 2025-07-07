import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/services/history_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistorySearchScreen extends StatefulWidget {
  const HistorySearchScreen({super.key});

  @override
  State<HistorySearchScreen> createState() =>
      _HistorySummarySearchScreenState();
}

class _HistorySummarySearchScreenState extends State<HistorySearchScreen> {
  Map<String, dynamic>? _historySummary;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getHistorySummary();
    });
  }

  bool isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return GradientBackground(
      // title: 'Medicine Info',
      withAppBar: true,
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Header with icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.summarize_outlined,
                    color: AppTheme.primaryColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  AppLocalizations.of(context)!.historySummaryTitle,
                  style: AppTheme.headingStyle.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            const SizedBox(height: 24),

            // Results
            Expanded(child: _buildContent(isArabic)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(bool isArabic) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.generatingHistorySummary),
          ],
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.error,
              style: AppTheme.headingStyle.copyWith(
                fontSize: 20,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: AppTheme.subheadingStyle.copyWith(
                color: AppTheme.textGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                _getHistorySummary();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.tryAgain,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    if (_historySummary == null) {
      return _buildNotFoundState();
    }

    return _buildHistorySummary();
  }

  Widget _buildNotFoundState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.orange),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noAvailableHistory,
            style: AppTheme.headingStyle.copyWith(
              fontSize: 20,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.noHistorySummaryGenerated,
            style: AppTheme.subheadingStyle.copyWith(color: AppTheme.textGrey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHistorySummary() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Medicine Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.medication, color: Colors.white, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.historySummaryTitle,
                        style: AppTheme.headingStyle.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // health_summary
          if (_historySummary!['tips_and_guides'] != null)
            _buildInfoCard(
              AppLocalizations.of(context)!.healthSummary,
              _historySummary!['health_summary'] ??
                  AppLocalizations.of(context)!.noHealthSummaryAvailable,
              Icons.description,
            ),

          const SizedBox(height: 16),

          if (_historySummary!['manage_blood_pressure'] != null)
            _buildInfoCard(
              AppLocalizations.of(context)!.bloodPressureInsights,
              _historySummary!['health_summary'] ??
                  AppLocalizations.of(context)!.noHealthSummaryAvailable,
              Icons.description,
            ),

          const SizedBox(height: 16),
          // tips and guides
          if (_historySummary!['tips_and_guides'] != null)
            _buildListCard(
              AppLocalizations.of(context)!.tipsAndGuides,
              _historySummary!['tips_and_guides'],
              Icons.science,
              Colors.blue,
            ),
          const SizedBox(height: 16),
          // tips and guides
          if (_historySummary!['general_advices_about_medicines'] != null)
            _buildListCard(
              AppLocalizations.of(context)!.generalAdvicesAboutMedicines,
              _historySummary!['general_advices_about_medicines'],
              Icons.science,
              Colors.blue,
            ),
          const SizedBox(height: 16),

          if (_historySummary!['information_about_each_vaccine'] != null)
            _buildItemInfoList(
              (_historySummary!['information_about_each_vaccine'] as List)
                  .map((e) => e as Map<String, dynamic>)
                  .toList(),
              AppLocalizations.of(context)!.vaccineInformation,
            ),
          const SizedBox(height: 16),

          if (_historySummary!['information_about_each_allergy'] != null)
            _buildItemInfoList(
              (_historySummary!['information_about_each_allergy'] as List)
                  .map((e) => e as Map<String, dynamic>)
                  .toList(),
              AppLocalizations.of(context)!.allergyInformation,
            ),
          if (_historySummary!['current_medicines'] != null)
            _buildItemInfoList(
              (_historySummary!['current_medicines'] as List)
                  .map((e) => e as Map<String, dynamic>)
                  .toList(),
              AppLocalizations.of(context)!.medicinesInformation,
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTheme.subheadingStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            textAlign: isArabic(content) ? TextAlign.right : TextAlign.left,
            textDirection:
                isArabic(content) ? TextDirection.rtl : TextDirection.ltr,
            style: AppTheme.subheadingStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              // height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard(
    String title,
    List<dynamic> items,
    IconData icon,
    Color color,
  ) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTheme.subheadingStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    textDirection:
                        isArabic(item.toString())
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                    crossAxisAlignment:
                        isArabic(item.toString())
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 6, right: 8),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.toString(),
                          textAlign:
                              isArabic(item.toString())
                                  ? TextAlign.right
                                  : TextAlign.left,
                          style: AppTheme.subheadingStyle.copyWith(
                            fontSize: 16,
                            color: AppTheme.textGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  void _getHistorySummary() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      String? token = Provider.of<AuthProvider>(context, listen: false).token;
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';
      final result = await HistoryService().getHistorySummary(
        token!,
        isArabic ? "arabic" : "english",
      );
      setState(() {
        _isLoading = false;
        _historySummary = result;
      });
    } catch (e) {
      setState(() {
        _historySummary = null;
        _isLoading = false;
        // _hasError = true;
        _errorMessage =
            AppLocalizations.of(context)!.failedToFetchHistorySummary;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildItemInfoList(List<Map<String, dynamic>> vaccines, String title) {
    if (vaccines.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.headingStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        ...vaccines.map((item) {
          return ExpandableItemCard(
            itemName:
                item['vaccine_name'] ??
                item['allergy_name'] ??
                item['medicine_name'] ??
                '',
            information: item['info'] ?? '',
          );
        }).toList(),
      ],
    );
  }
}

class ExpandableItemCard extends StatefulWidget {
  final String itemName;
  final String information;

  const ExpandableItemCard({
    super.key,
    required this.itemName,
    required this.information,
  });

  @override
  State<ExpandableItemCard> createState() => _ExpandableItemCardState();
}

class _ExpandableItemCardState extends State<ExpandableItemCard> {
  bool _expanded = false;

  bool isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.vaccines,
                color: Theme.of(context).primaryColor,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.itemName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ],
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                textAlign:
                    isArabic(widget.information)
                        ? TextAlign.right
                        : TextAlign.left,
                widget.information,
                style: AppTheme.subheadingStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  // color: AppTheme.black,
                ),
              ),
            ),
            crossFadeState:
                _expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}
