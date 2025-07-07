import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '/screens/dashboard/doctor_dash_board.dart';
import '/screens/registration/role_selection_screen.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_background.dart';
import 'custom_input_field.dart';
import 'login_button.dart';
import '../dashboard/patient_dashboard_screen.dart';
import "../dashboard/admin_dashboard.dart";
import '../password_ressetting/forgot_password_screen.dart';
import '../../main.dart'; // To access MyApp.setLocale

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      body: GradientBackground(
        showBackButton: false,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 36.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Language switcher
                    Align(
                      alignment: Alignment.topRight,
                      child: DropdownButton<Locale>(
                        underline: const SizedBox(),
                        value: Localizations.localeOf(context),
                        icon: const Icon(Icons.language, color: Colors.black),
                        onChanged: (Locale? locale) {
                          if (locale != null) {
                            MyApp.setLocale(context, locale);
                          }
                        },
                        items: const [
                          DropdownMenuItem(
                            value: Locale('en'),
                            child: Text('English'),
                          ),
                          DropdownMenuItem(
                            value: Locale('ar'),
                            child: Text('العربية'),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      local.welcomeBack,
                      style: AppTheme.headingStyle.copyWith(
                        color: AppTheme.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      local.pleaseLogin,
                      style: AppTheme.subheadingStyle.copyWith(
                        color: AppTheme.black,
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomInputField(
                      controller: _phoneController,
                      label: local.phone,
                      hintText: '01001234567',
                      prefixIcon: Icons.phone_android,
                      keyboardType: TextInputType.phone,
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? local.enterPhone
                                  : null,
                    ),
                    const SizedBox(height: 20),
                    CustomInputField(
                      controller: _passwordController,
                      label: local.password,
                      hintText: local.enterPassword,
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppTheme.primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? local.enterPassword
                                  : null,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          local.forgotPassword,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    LoginButton(
                      isLoading: authProvider.isLoading,
                      onPressed: _login,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(local.noAccount),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const RoleSelectionScreen(),
                              ),
                            );
                          },
                          child: Text(
                            local.signUp,
                            style: const TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    final local = AppLocalizations.of(context)!;

    try {
      if (_formKey.currentState!.validate()) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.login(
          _phoneController.text.trim(),
          _passwordController.text.trim(),
        );

        final user = authProvider.user;
        if (user != null) {
          Widget dashboard;
          if (user.role == 'patient') {
            dashboard = const PatientBoardScreen();
          } else if (user.role == 'admin') {
            dashboard = const AdminDashboardScreen();
          } else if (user.role == 'doctor') {
            dashboard = const DoctorDashboardScreen();
          } else {
            dashboard = const RoleSelectionScreen();
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => dashboard),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(local.loginFailed),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst("Exception: ", "")),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
