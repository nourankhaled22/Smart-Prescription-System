import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final bool withAppBar;
  final String? title;
  final bool showBackButton;

  const GradientBackground({
    super.key,
    required this.child,
    this.withAppBar = true,
    this.title,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          withAppBar
              ? AppBar(
                title:
                    title != null
                        ? Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            title!,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                        : null,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading:
                    showBackButton
                        ? Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFFFFFF,
                                    ).withOpacity(0.6),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Directionality(
                                textDirection: TextDirection.ltr,
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.black87,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        )
                        : null,
              )
              : null,
      extendBodyBehindAppBar: withAppBar,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundGradientStart,
              AppTheme.backgroundGradientEnd,
            ],
          ),
        ),
        child: SafeArea(child: child),
      ),
    );
  }
}
