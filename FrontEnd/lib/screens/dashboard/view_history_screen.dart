import 'package:flutter/material.dart';
import '/screens/blood_pressures/blood_pressure_screen.dart';
import '/screens/examinations/examinations_screen.dart';
import '/screens/history/history_screen.dart';
import '/screens/medicines/medications_screen.dart';
import '/screens/prescriptions/prescriptions_screen.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/history_item.dart';
import '../allergies/allergies_screen.dart';
import '../vaccines/vaccines_screen.dart';
import '../chronicDiseases/chronic_diseaeases_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatientHistoryScreen extends StatelessWidget {
  const PatientHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GradientBackground(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              loc.patientHistory, // Localized
              style: AppTheme.headingStyle.copyWith(fontSize: 30),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistorySearchScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.medical_information_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                label: Text(
                  loc.generateHistorySummary, // Localized
                  style: AppTheme.subheadingStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  HistoryItem(
                    icon: Image.asset('assets/icons/drug.png'),
                    label: loc.medications, // Localized
                    color: const Color(0xFFF7F7FF),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MedicationsScreen(),
                        ),
                      );
                    },
                  ),
                  HistoryItem(
                    icon: Image.asset('assets/icons/vacc.png'),
                    label: loc.vaccines, // Localized
                    color: const Color(0xFFF7F7FF),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VaccinesScreen(),
                        ),
                      );
                    },
                  ),
                  HistoryItem(
                    icon: Image.asset('assets/icons/presc.png'),
                    label: loc.prescriptions, // Localized
                    color: const Color(0xFFF7F7FF),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrescriptionsScreen(),
                        ),
                      );
                    },
                  ),
                  HistoryItem(
                    icon: Image.asset('assets/icons/blood.png'),
                    label: loc.bloodPressure, // Localized
                    color: const Color(0xFFF7F7FF),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BloodPressureScreen(),
                        ),
                      );
                    },
                  ),
                  HistoryItem(
                    icon: Image.asset('assets/icons/allergy.png'),
                    label: loc.allergies, // Localized
                    color: const Color(0xFFF7F7FF),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllergiesScreen(),
                        ),
                      );
                    },
                  ),
                  HistoryItem(
                    icon: Image.asset('assets/icons/examin.png'),
                    label: loc.examinations, // Localized
                    color: const Color(0xFFF7F7FF),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ExaminationsScreen(),
                        ),
                      );
                    },
                  ),
                  HistoryItem(
                    icon: Image.asset('assets/icons/chronic.png'),
                    label: loc.chronicDisease, // Localized
                    color: const Color(0xFFF7F7FF),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChronicsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
