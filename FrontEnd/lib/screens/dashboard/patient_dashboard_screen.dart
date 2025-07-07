import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/screens/chat/chat.dart';
import '/screens/doctors/find_doctors_screen.dart';
import '/screens/profile/patient_profile_screen.dart';

import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import '../login/login_screen.dart';
import 'view_history_screen.dart';
import '../../../providers/auth_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // <-- Add this import

class PatientBoardScreen extends StatelessWidget {
  const PatientBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance
    return GradientBackground(
      withAppBar: false,
      child: SafeArea(
        child: Column(
          children: [
            _buildProfileHeader(context, loc),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                children: [
                  const SizedBox(height: 24),
                  Text(
                    loc.howCanWeHelp, // Localized
                    style: AppTheme.subheadingStyle.copyWith(
                      fontSize: 16,
                      color: AppTheme.textGrey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildActionCard(
                        context,
                        loc.viewProfile, // Localized
                        Icons.person,
                        AppTheme.primaryColor,
                        () {
                          HapticFeedback.lightImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientProfileScreen(),
                            ),
                          );
                        },
                      ),
                      _buildActionCard(
                        context,
                        loc.medicalHistory, // Localized
                        Icons.history,
                        AppTheme.accentColor,
                        () {
                          HapticFeedback.lightImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const PatientHistoryScreen(),
                            ),
                          );
                        },
                      ),
                      _buildActionCard(
                        context,
                        loc.findDoctors, // Localized
                        Icons.people,
                        const Color(0xFF9C27B0),
                        () {
                          HapticFeedback.lightImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FindDoctorsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildActionCard(
                        context,
                        loc.askChatbot, // Localized
                        Icons.chat_bubble,
                        const Color(0xFFFF9800),
                        () {
                          HapticFeedback.lightImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MedicalChatBot(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildHealthTipsSection(context, loc),
                  const SizedBox(height: 32),
                  _buildSignOutButton(context, loc),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, AppLocalizations loc) {
    // Get patient name from provider
    final patientName =
        '${Provider.of<AuthProvider>(context, listen: false).user!.firstName} ';
    print(context.watch<AuthProvider>().user);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
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
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.welcome(patientName), // Localized
                  style: AppTheme.headingStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: AppTheme.primaryColor),
            onPressed: () {
              HapticFeedback.lightImpact();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SizedBox(
                width: 50,
                height: 50,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Icon(icon, color: color, size: 40),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthTipsSection(BuildContext context, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.healthTips, // Localized
          style: AppTheme.headingStyle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF5AC8FA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4A90E2).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.lightbulb, color: Colors.white, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.stayHydrated, // Localized
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      loc.drinkWaterTip, // Localized
                      style: AppTheme.subheadingStyle.copyWith(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignOutButton(BuildContext context, AppLocalizations loc) {
    return Container(
      width: double.infinity,
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
      child: TextButton.icon(
        icon: const Icon(Icons.logout, color: Color(0xFFE53935)),
        label: Text(
          loc.signOut, // Localized
          style: AppTheme.buttonTextStyle.copyWith(
            color: const Color(0xFFE53935),
            fontWeight: FontWeight.w500,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          HapticFeedback.mediumImpact();
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text(loc.signOut), // Localized
                  content: Text(loc.areYouSureSignOut), // Localized
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(loc.cancel), // Localized
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        ).logout();
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(loc.signOut), // Localized
                    ),
                  ],
                ),
          );
        },
      ),
    );
  }
}
