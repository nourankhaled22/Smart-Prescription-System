import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '/widgets/input_decoration_helper.dart';
import '../theme/app_theme.dart';

class DynamicInputSection extends StatefulWidget {
  final String label;
  final List<TextEditingController> controllers;
  final String hint;
  final IconData icon;

  const DynamicInputSection({
    super.key,
    required this.label,
    required this.controllers,
    required this.hint,
    required this.icon,
  });

  @override
  State<DynamicInputSection> createState() => _DynamicInputSectionState();
}

class _DynamicInputSectionState extends State<DynamicInputSection> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label == 'Medicines' ? loc.medicines : widget.label, // Localized
              style: AppTheme.subheadingStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.black,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  widget.controllers.add(TextEditingController());
                });
              },
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.teal, size: 16),
              ),
              tooltip: loc.edit, // Localized tooltip for accessibility
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...widget.controllers.asMap().entries.map((entry) {
          final index = entry.key;
          final controller = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    decoration: buildInputDecoration(
                      widget.hint == 'Optional' ? loc.optional : widget.hint, // Localized
                      fillColor: const Color(0xFFF5F5F5),
                      borderColor: Colors.purple.withOpacity(0.2),
                      outlineColor: Colors.purple,
                    ).copyWith(prefixIcon: Icon(widget.icon, color: Colors.teal)),
                    validator: (value) {
                      if (widget.label.contains(loc.medicines) &&
                          index == 0 &&
                          (value == null || value.isEmpty)) {
                        return loc.pleaseEnterAtLeastOneMedicine; // Localized
                      }
                      return null;
                    },
                  ),
                ),
                if (widget.controllers.length > 1 ||
                    (widget.label.contains(loc.optional) && widget.controllers.isNotEmpty))
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.controllers.removeAt(index);
                      });
                    },
                    icon: const Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                      size: 20,
                    ),
                    tooltip: loc.delete, // Localized tooltip for accessibility
                  ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
