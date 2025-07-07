import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add for localization

class NotesSection extends StatelessWidget {
  final String title;
  final String content;
  final Color color;
  final IconData icon;
  final String? titleLocalizationKey; // Optional localization key for title
  final String? contentLocalizationKey; // Optional localization key for content

  const NotesSection({
    super.key,
    required this.title,
    required this.content,
    this.color = Colors.orange,
    this.icon = Icons.note_alt,
    this.titleLocalizationKey,
    this.contentLocalizationKey,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
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
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title, // Localized if key provided
                style: AppTheme.subheadingStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              content, // Localized if key provided
              style: AppTheme.subheadingStyle.copyWith(
                fontSize: 15,
                color: AppTheme.black,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
