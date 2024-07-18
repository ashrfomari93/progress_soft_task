import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum LoginFailureReason { userNotFound, incorrectPassword }

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final LoginFailureReason reason;

  LoginFailure(this.reason);
}

abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String mobileNumber;
  final String password;

  LoginSubmitted({required this.mobileNumber, required this.password});
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore _firestore;

  LoginBloc(this.firebaseAuth, this._firestore) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      // Check if the user exists in Firestore with the provided phone number
      final userQuery = await _firestore
          .collection('users')
          .where('mobileNumber', isEqualTo: event.mobileNumber)
          .limit(50)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userData = userQuery.docs.first.data();
        final storedPhoneNumber = userData['mobileNumber'];
        final storedPassword = userData['password'];

        // Compare stored password with the provided password
        if (storedPassword == event.password &&
            storedPhoneNumber == event.mobileNumber) {
          emit(LoginSuccess());
        } else {
          emit(LoginFailure(LoginFailureReason.incorrectPassword));
        }
      } else {
        emit(LoginFailure(LoginFailureReason.userNotFound));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailure(LoginFailureReason.userNotFound));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailure(LoginFailureReason.incorrectPassword));
      } else {
        emit(LoginFailure(LoginFailureReason.incorrectPassword));
      }
    } catch (e) {
      emit(LoginFailure(LoginFailureReason.incorrectPassword));
    }
  }
}
