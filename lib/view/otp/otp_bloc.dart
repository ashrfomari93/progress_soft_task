import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Define OTP states
abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpVerificationSuccess extends OtpState {}

class OtpVerificationFailure extends OtpState {}

// Define OTP events
abstract class OtpEvent {}

class OtpSubmitted extends OtpEvent {
  final String otp;
  final String verificationId;
  final String fullName;
  final String mobileNumber;
  final String age;
  final String gender;
  final String password;

  OtpSubmitted(
      {required this.otp,
      required this.verificationId,
      required this.fullName,
      required this.mobileNumber,
      required this.age,
      required this.gender,
      required this.password});
}

// OTP Bloc class
class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final FirebaseAuth firebaseAuth;

  OtpBloc(this.firebaseAuth) : super(OtpInitial()) {
    on<OtpSubmitted>(_onOtpSubmitted);
  }

  void _onOtpSubmitted(OtpSubmitted event, Emitter<OtpState> emit) async {
    emit(OtpLoading());
    try {
      // Verify OTP
      final credential = PhoneAuthProvider.credential(
        verificationId: event.verificationId,
        smsCode: event.otp,
      );
      await firebaseAuth.signInWithCredential(credential);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(event.mobileNumber)
          .set({
        'fullName': event.fullName,
        'mobileNumber': event.mobileNumber,
        'age': event.age,
        'gender': event.gender,
        'password': event.password
      });

      emit(OtpVerificationSuccess());
    } catch (e) {
      emit(OtpVerificationFailure());
    }
  }
}
