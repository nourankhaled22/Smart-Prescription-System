import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add for localization

class HistoryTabBar extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;

  const HistoryTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  static const List<String> tabKeys = [
    'chronic',
    'allergies',
    'vaccines',
    'bloodPressure',
    'examinations',
    'medications',
  ];

  static const List<IconData> tabIcons = [
    Icons.medical_services,
    Icons.warning_amber_rounded,
    Icons.vaccines,
    Icons.favorite,
    Icons.assignment,
    Icons.medication,
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance
    final List<String> localizedTabs = [
      loc.chronic,
      loc.allergies,
      loc.vaccines,
      loc.bloodPressure,
      loc.examinations,
      loc.medications,
    ];

    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          scrollbars: false,
          overscroll: false,
          physics: const BouncingScrollPhysics(),
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: localizedTabs.length,
          itemBuilder: (context, index) {
            bool isSelected = selectedTab == index;
            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onTabChanged(index);
              },
              child: Container(
                margin: EdgeInsets.only(
                  right: index < localizedTabs.length - 1 ? 12 : 0,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [Colors.white, AppTheme.grey.withOpacity(0.3)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? AppTheme.primaryColor : AppTheme.textGrey.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected 
                        ? AppTheme.primaryColor.withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                      blurRadius: isSelected ? 12 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tabIcons[index],
                      size: 20,
                      color: isSelected ? Colors.white : AppTheme.primaryColor,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      localizedTabs[index], // Localized
                      style: AppTheme.subheadingStyle.copyWith(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppTheme.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}