import 'package:flutter/material.dart';
import '../theme/app_theme.dart'; // adjust path as needed
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add for localization

class InputSection extends StatelessWidget {
  final String label;
  final Widget child;
  final String? localizationKey; // Optional localization key

  const InputSection({
    Key? key,
    required this.label,
    required this.child,
    this.localizationKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, // Localized if key provided
          style: AppTheme.subheadingStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.black,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
