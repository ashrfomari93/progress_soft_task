import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

// Profile State
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic>? userData;

  ProfileLoaded(this.userData);
}

class ProfileError extends ProfileState {
  final String error;

  ProfileError(this.error);
}

// Profile Event
abstract class ProfileEvent {}

class FetchUserProfile extends ProfileEvent {
  final String mobileNumber;

  FetchUserProfile(this.mobileNumber);
}

// Profile Bloc
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProfileBloc() : super(ProfileInitial()) {
    on<FetchUserProfile>(_mapFetchUserProfileToState);
  }

  Future<void> _mapFetchUserProfileToState(
      FetchUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      // Fetch user data from Firestore
      var userQuery = await _firestore
          .collection('users')
          .where('mobileNumber', isEqualTo: event.mobileNumber)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        var userData = userQuery.docs.first.data();
        print(userData);
        emit(ProfileLoaded(userData));
      } else {
        emit(ProfileError('user_not_found'.tr));
      }
    } catch (e) {
      emit(ProfileError('failed_to_fetch_user_data'.tr));
    }
  }
}
