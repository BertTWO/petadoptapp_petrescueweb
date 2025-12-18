// lib/presentation/pages/splash_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petadoptapp/core/theme/app_theme.dart';
import 'package:lottie/lottie.dart';
import 'package:petadoptapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:petadoptapp/features/auth/presentation/pages/login.dart';
import 'package:petadoptapp/features/hompage/presentation/pages/homepage.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const SplashScreen();
        }

        if (state is AuthAuthenticated) {
          return const HomePage();
        }

        return const LoginPage();
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.softGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/paw_animation.json', // You can download from LottieFiles
                controller: _controller,
                height: 200,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..repeat();
                },
              ),

              const SizedBox(height: 30),

              // App logo with cute font
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.primaryGradient.createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                child: Text(
                  '🐾 PetAdopt',
                  style: GoogleFonts.comicNeue(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Subtitle
              Text(
                'Find your furry friend!',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: AppTheme.textMedium,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
