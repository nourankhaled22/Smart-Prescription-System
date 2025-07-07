import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add this import
import '../../../theme/app_theme.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final List<Map<String, dynamic>> steps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: List.generate(steps.length, (index) {
          return Expanded(
            child: Row(
              children: [
                Expanded(child: _buildStepItem(index)),
                if (index < steps.length - 1) _buildConnector(index),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepItem(int step) {
    bool isActive = currentStep == step;
    bool isCompleted = currentStep > step;

    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: isCompleted || isActive
                ? LinearGradient(
                    colors: [
                      isCompleted ? Colors.green : AppTheme.primaryColor,
                      isCompleted ? Colors.green.shade300 : AppTheme.secondaryColor,
                    ],
                  )
                : null,
            color: isCompleted || isActive ? null : Colors.grey.shade300,
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            isCompleted ? Icons.check : steps[step]['icon'],
            color: isCompleted || isActive ? Colors.white : Colors.grey.shade600,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
        steps[step]['title'],
          style: AppTheme.subheadingStyle.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? AppTheme.primaryColor : Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildConnector(int index) {
    bool isCompleted = currentStep > index;
    return Container(
      height: 3,
      width: 30,
      margin: const EdgeInsets.only(bottom: 30, left: 8, right: 8),
      decoration: BoxDecoration(
        gradient: isCompleted
            ? LinearGradient(
                colors: [Colors.green, Colors.green.shade300],
              )
            : null,
        color: isCompleted ? null : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
