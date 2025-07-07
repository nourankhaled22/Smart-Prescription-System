import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add for localization
import '../theme/app_theme.dart';

class HeaderInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final double iconSize;
  final double fontSize;
  final String? localizationKey; // Add this for localization

  const HeaderInfo({
    super.key,
    required this.icon,
    required this.text,
    this.color = Colors.white,
    this.iconSize = 16,
    this.fontSize = 14,
    this.localizationKey, // Add this for localization
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Row(
      children: [
        Icon(icon, color: color.withOpacity(0.9), size: iconSize),
        const SizedBox(width: 6),
        Text(
        text, // Localized if key provided
          style: AppTheme.subheadingStyle.copyWith(
            fontSize: fontSize,
            color: color.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}
