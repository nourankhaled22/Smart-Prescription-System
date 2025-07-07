import 'package:flutter/material.dart';
import '/theme/app_theme.dart';

InputDecoration buildInputDecoration(
  String hint, {
  Color fillColor = const Color(0xFFF5F5F5),
  Color? borderColor,
  Color? outlineColor,
}) {
  final Color _borderColor = borderColor ?? AppTheme.primaryColor.withOpacity(0.2);
  final Color _outlineColor = outlineColor ?? AppTheme.primaryColor;

  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: fillColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: _borderColor, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: _outlineColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1),
    ),
    contentPadding: const EdgeInsets.all(16),
  );
}
