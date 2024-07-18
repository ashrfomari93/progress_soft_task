import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

// Splash State
abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoaded extends SplashState {}
class SplashAuthenticated extends SplashState {}

class SplashUnauthenticated extends SplashState {}

// Splash Event
abstract class SplashEvent {}

class StartSplash extends SplashEvent {}
class CheckUserLoggedIn extends SplashEvent {}

// Splash Bloc
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<StartSplash>((event, emit) async {
      await Future.delayed(const Duration(seconds: 2));
      emit(SplashLoaded());
    });
  }
}
