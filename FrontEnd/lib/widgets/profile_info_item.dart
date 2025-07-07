import 'package:flutter/material.dart';
import '/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add for localization

class ProfileInfoItem extends StatelessWidget {
  final String label;
  final String? value;
  final TextEditingController? controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? labelLocalizationKey; // Optional localization key for label

  const ProfileInfoItem({
    super.key,
    required this.label,
    this.value,
    this.controller,
    required this.icon,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.labelLocalizationKey,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEditing = controller != null;
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, // Localized if key provided
          style: AppTheme.subheadingStyle.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black45,
          ),
        ),
        const SizedBox(height: 8),
        if (isEditing)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              readOnly: readOnly,
              onTap: onTap,
              style: AppTheme.subheadingStyle.copyWith(
                color: AppTheme.black,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  icon,
                  color: AppTheme.primaryColor.withOpacity(0.7),
                  size: 22,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppTheme.primaryColor.withOpacity(0.7),
                  size: 22,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    value ?? '',
                    style: AppTheme.subheadingStyle.copyWith(
                      color: AppTheme.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
