import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add for localization

class NotesStep extends StatelessWidget {
  final TextEditingController controller;

  const NotesStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.1),
                      AppTheme.primaryColor.withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.note_alt,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.additionalNotes, // Localized
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    Text(
                      loc.addFollowUpInstructions, // Localized
                      style: AppTheme.subheadingStyle.copyWith(
                        color: AppTheme.textGrey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Notes Text Field
          TextFormField(
            controller: controller,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: loc.notesHint, // Localized
              hintStyle: TextStyle(color: Colors.grey.shade400, height: 1.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              filled: true,
              fillColor: Colors.purple.shade50.withOpacity(0.3),
              contentPadding: const EdgeInsets.all(20),
            ),
            style: AppTheme.subheadingStyle.copyWith(fontSize: 16, height: 1.5),
          ),

          const SizedBox(height: 24),

          // Quick Follow-up Options
          _buildFollowUpSection(loc),
        ],
      ),
    );
  }

  Widget _buildFollowUpSection(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.indigo.shade50.withOpacity(0.3)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.schedule, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                loc.quickFollowUpOptions, // Localized
                style: AppTheme.headingStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            loc.tapOptionToAdd, // Localized
            style: AppTheme.subheadingStyle.copyWith(
              fontSize: 12,
              color: AppTheme.primaryColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFollowUpOption(
                loc.followUp1Week, // Localized
                Icons.calendar_today,
                Colors.green,
              ),
              _buildFollowUpOption(
                loc.followUp2Weeks, // Localized
                Icons.event,
                Colors.blue,
              ),
              _buildFollowUpOption(
                loc.followUp1Month, // Localized
                Icons.date_range,
                Colors.purple,
              ),
              _buildFollowUpOption(
                loc.labTestsRequired, // Localized
                Icons.science,
                Colors.orange,
              ),
              _buildFollowUpOption(
                loc.specialistReferralNeeded, // Localized
                Icons.person_search,
                Colors.red,
              ),
              _buildFollowUpOption(
                loc.completeMedicationCourse, // Localized
                Icons.medication,
                Colors.teal,
              ),
              _buildFollowUpOption(
                loc.returnIfSymptomsWorsen, // Localized
                Icons.warning,
                Colors.amber,
              ),
              _buildFollowUpOption(
                loc.restAndHydration, // Localized
                Icons.local_drink,
                Colors.cyan,
              ),
              _buildFollowUpOption(
                loc.noFollowUpNeeded, // Localized
                Icons.check_circle,
                Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFollowUpOption(String text, IconData icon, Color color) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          String currentNotes = controller.text;
          if (currentNotes.isNotEmpty) {
            controller.text = '$currentNotes\n\n• $text';
          } else {
            controller.text = '• $text';
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                text,
                style: AppTheme.subheadingStyle.copyWith(
                  fontSize: 12,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
