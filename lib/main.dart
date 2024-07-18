import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:progress_soft/data/app_constant.dart';
import 'package:progress_soft/data/languages.dart';
import 'package:progress_soft/view/profile/profile_bloc.dart';
import 'package:progress_soft/view/login/login_bloc.dart';
import 'package:progress_soft/view/otp/otp_bloc.dart';
import 'package:progress_soft/view/register/register_bloc.dart';
import 'package:progress_soft/view/splash/splash_bloc.dart';
import 'package:progress_soft/view/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SplashBloc()..add(StartSplash()),
          child: const SplashScreenHandler(),
        ),
        BlocProvider(
          create: (context) =>
              LoginBloc(FirebaseAuth.instance, FirebaseFirestore.instance),
        ),
        BlocProvider(
          create: (context) =>
              RegisterBloc(FirebaseAuth.instance, FirebaseFirestore.instance),
        ),
        BlocProvider(
          create: (context) => OtpBloc(
            FirebaseAuth.instance,
          ),
        ),
        BlocProvider(create: (context) => ProfileBloc()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        locale: Locale(getSavedLanguage()),
        translations: Languages(),
        home: const SplashScreenHandler(),
      ),
    );
  }
}
