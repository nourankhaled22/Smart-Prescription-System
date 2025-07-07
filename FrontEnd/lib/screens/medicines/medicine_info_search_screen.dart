import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/services/medication_service.dart';

import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MedicineInfoSearchScreen extends StatefulWidget {
  final String? initialSearchTerm;

  const MedicineInfoSearchScreen({
    super.key,
    this.initialSearchTerm,
  });

  @override
  State<MedicineInfoSearchScreen> createState() =>
      _MedicineInfoSearchScreenState();
}

class _MedicineInfoSearchScreenState extends State<MedicineInfoSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? _medicineInfo;
  bool _isLoading = false;
  bool _hasSearched = false;
  bool _hasError = false;
  String _errorMessage = '';
  List<String> _suggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialSearchTerm != null) {
      _searchController.text = widget.initialSearchTerm!;
      // Auto-search when coming from a medicine card

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchMedicine();
      });
    }
  }

  bool isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final loc = AppLocalizations.of(context)!;
    return GradientBackground(
      title: loc.medicineInfo, // Localized
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
                    Icons.search,
                    color: AppTheme.primaryColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  loc.medicineInfo, // Localized
                  style: AppTheme.headingStyle.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

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
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: loc.searchForMedicineName, // Localized
                  prefixIcon: Icon(Icons.search, color: AppTheme.primaryColor),
                  suffixIcon:
                      _isLoading
                          ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                          : IconButton(
                            onPressed: () async {
                              _searchMedicine();
                            },
                            icon: Icon(
                              Icons.arrow_forward,
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
                onSubmitted: (_) => _searchMedicine(),
              ),
            ),

            // Suggestions
            if (_showSuggestions && _suggestions.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
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
                  children:
                      _suggestions
                          .map(
                            (suggestion) => ListTile(
                              title: Text(suggestion),
                              leading: Icon(
                                Icons.medication,
                                color: AppTheme.primaryColor,
                              ),
                              onTap: () {
                                setState(() {
                                  _searchController.text = suggestion;
                                  _showSuggestions = false;
                                });
                                _searchMedicine();
                              },
                            ),
                          )
                          .toList(),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Results
            Expanded(child: _buildContent(loc, isArabic)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(AppLocalizations loc, bool isArabic) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(loc.searchingMedicineInfo), // Localized
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
              loc.error, // Localized
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
                _searchMedicine();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                loc.tryAgain, // Localized
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    if (!_hasSearched) {
      return _buildInitialState(loc);
    }

    if (_medicineInfo == null) {
      return _buildNotFoundState(loc);
    }

    return _buildMedicineInfo(loc);
  }

  Widget _buildInitialState(AppLocalizations loc) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: AppTheme.textGrey),
          const SizedBox(height: 16),
          Text(
            loc.searchForMedicineInformation, // Localized
            style: AppTheme.headingStyle.copyWith(
              fontSize: 20,
              color: AppTheme.textGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            loc.enterMedicineNameInfo, // Localized
            style: AppTheme.subheadingStyle.copyWith(color: AppTheme.textGrey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            loc.examples, // Localized
            style: AppTheme.subheadingStyle.copyWith(
              color: AppTheme.primaryColor,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotFoundState(AppLocalizations loc) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.orange),
          const SizedBox(height: 16),
          Text(
            loc.medicineNotFound, // Localized
            style: AppTheme.headingStyle.copyWith(
              fontSize: 20,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            loc.medicineNotFoundDesc(_searchController.text), // Localized
            style: AppTheme.subheadingStyle.copyWith(color: AppTheme.textGrey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _hasSearched = false;
                _medicineInfo = null;
                _showSuggestions = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              loc.searchAgain, // Localized
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineInfo(AppLocalizations loc) {
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
                        _medicineInfo!["name"],
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
                Text(
                  _medicineInfo!['type'] ?? loc.medication, // Localized
                  style: AppTheme.subheadingStyle.copyWith(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Description
          if (_medicineInfo!['description'] != null)
            _buildInfoCard(
              loc.description, // Localized
              _medicineInfo!['description'] ?? loc.noDescription, // Localized
              Icons.description,
            ),

          const SizedBox(height: 16),

          // Active Ingredient
          if (_medicineInfo!['active_ingredients'] != null)
            _buildListCard(
              loc.activeIngredient, // Localized
              _medicineInfo!['active_ingredients'] is List
                  ? List<String>.from(_medicineInfo!['active_ingredients'])
                  : [_medicineInfo!['active_ingredients'].toString()],
              Icons.science,
              Colors.green,
            ),

          const SizedBox(height: 16),

          // Dosage
          if (_medicineInfo!['dosage_info'] != null)
            _buildInfoCard(
              loc.dosageAdmin, // Localized
              _medicineInfo!['dosage_info'],
              Icons.medication_liquid,
            ),

          const SizedBox(height: 16),

          if (_medicineInfo!['alternative_medicines'] != null)
            _buildListCard(
              loc.alternativeMedicines, // Localized
              _medicineInfo!['alternative_medicines'],
              Icons.arrow_forward,
              Colors.blue,
            ),

          const SizedBox(height: 16),

          // Side Effects
          if (_medicineInfo!['side_effects'] != null &&
              _medicineInfo!['side_effects'] is List)
            _buildListCard(
              loc.sideEffects, // Localized
              _medicineInfo!['side_effects'],
              Icons.warning,
              Colors.orange,
            ),
          if (_medicineInfo!['side_effects'] != null &&
              _medicineInfo!['side_effects'] is String)
            _buildInfoCard(
              loc.sideEffects, // Localized
              _medicineInfo!['side_effects'],
              Icons.warning,
            ),

          const SizedBox(height: 16),

          // Warnings
          if (_medicineInfo!['warnings'] != null)
            _buildListCard(
              loc.warnings, // Localized
              _medicineInfo!['warnings'],
              Icons.error,
              Colors.red,
            ),

          const SizedBox(height: 16),
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
            style: AppTheme.subheadingStyle.copyWith(
              fontSize: 18,
              color: AppTheme.textGrey,
              height: 1.5,
            ),
            textDirection:
                isArabic(content) ? TextDirection.rtl : TextDirection.ltr,
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
                            fontSize: 18,
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

  void _onSearchChanged(String value) async {
    String? token = Provider.of<AuthProvider>(context, listen: false).token;
    if (value.length < 3) {
      setState(() {
        _showSuggestions = false;
        _suggestions = [];
      });
      return;
    }
    try {
      final suggestions = await MedicationService().searchForMedicines(
        token!,
        value,
      );
      setState(() {
        _suggestions = List<String>.from(suggestions);
        _showSuggestions = suggestions.isNotEmpty;
      });
    } catch (e) {
      print('Error getting suggestions: $e');
    }
  }

  void _searchMedicine() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _showSuggestions = false;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      String? token = Provider.of<AuthProvider>(context, listen: false).token;
      bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
      Map<String, dynamic>? result = await MedicationService().getMedicineInfo(
        token!,
        query,
        isArabic ? "arabic" : "english",
      );
      setState(() {
        _medicineInfo = result;
        _medicineInfo!['name'] = query;
        _hasSearched = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _medicineInfo = null;
        _hasSearched = true;
        _isLoading = false;
        _errorMessage =
            AppLocalizations.of(context)!.fetchMedicineError; // Localized
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
