import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_soft/data/filed_validator.dart';
import 'package:progress_soft/view/otp/otp_screen.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String message;
  RegisterFailure(this.message);
}

class OtpSent extends RegisterState {
  final String mobileNumber;
  final String verificationId;

  OtpSent({required this.mobileNumber, required this.verificationId});
}

abstract class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final String fullName;
  final String mobileNumber;
  final String age;
  final String gender;
  final String password;
  final String confirmPassword;
  final BuildContext context;

  RegisterSubmitted({
    required this.fullName,
    required this.mobileNumber,
    required this.age,
    required this.gender,
    required this.password,
    required this.confirmPassword,
    required this.context,
  });
}

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  RegisterBloc(this.firebaseAuth, this.firestore) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  void _onRegisterSubmitted(
      RegisterSubmitted event, Emitter<RegisterState> emit) async {
    final allFieldsEmpty = FieldValidators.allFieldsEmpty(event.fullName,
        event.mobileNumber, event.age, event.password, event.confirmPassword);
    final fullNameError = FieldValidators.validateFullName(event.fullName);
    final mobileError =
        FieldValidators.validateMobileNumber(event.mobileNumber);
    final ageError = FieldValidators.validateAge(event.age);
    final passwordError = FieldValidators.validatePassword(event.password);
    final confirmPasswordError = FieldValidators.validateConfirmPassword(
        event.password, event.confirmPassword);

    if (allFieldsEmpty != null ||
        fullNameError != null ||
        mobileError != null ||
        ageError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
      emit(RegisterFailure(
        allFieldsEmpty ??
            fullNameError ??
            mobileError ??
            ageError ??
            passwordError ??
            confirmPasswordError!,
      ));
      return;
    }

    try {
      emit(RegisterLoading());
      // Send OTP
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: event.mobileNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(RegisterFailure(e.message!));
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.of(event.context).push(
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                mobileNumber: event.mobileNumber,
                verificationId: verificationId,
                age: event.age,
                fullName: event.fullName,
                gender: event.gender,
                password: event.password,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
