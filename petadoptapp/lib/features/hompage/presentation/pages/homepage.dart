// lib/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadoptapp/features/adopters/presentation/pages/adopter_homepage.dart';
import 'package:petadoptapp/features/auth/presentation/cubit/auth_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const AdopterHomePage();
        }

        // Should not reach here if authenticated
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
