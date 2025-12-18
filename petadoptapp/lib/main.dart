// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadoptapp/core/theme/app_theme.dart';
import 'package:petadoptapp/features/adoptpet/data/repository/api_adopt_repo.dart';
import 'package:petadoptapp/features/adoptpet/presentation/cubit/adoption_cubit.dart';
import 'package:petadoptapp/features/auth/data/repository/api_auth_repo.dart';
import 'package:petadoptapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:petadoptapp/features/pet/data/repository/api_pet_repo.dart';
import 'package:petadoptapp/features/pet/presentation/cubit/pet_cubit.dart';
import 'package:petadoptapp/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final authRepo = ApiAuthRepository();
  final petRepo = ApiPetRepository();
  final adoptionRepo = ApiAdoptionRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(authRepository: authRepo)),
        BlocProvider(create: (context) => PetCubit(petRepository: petRepo)),
        BlocProvider(
          create: (context) => AdoptionCubit(adoptionRepository: adoptionRepo),
        ),
      ],
      child: MaterialApp(
        title: 'PetAdopt',
        theme: AppTheme.lightTheme,
        home: const SplashPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
