import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:progress_soft/data/app_constant.dart';
import 'package:progress_soft/view/login/login_screen.dart';
import 'package:progress_soft/widgets/custom_button.dart';
import 'package:progress_soft/widgets/custom_language_dialog.dart';
import 'package:progress_soft/widgets/custom_loading.dart';
import 'profile_bloc.dart';

class ProfileScreen extends StatelessWidget {
  final String mobileNumber;

  const ProfileScreen({Key? key, required this.mobileNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(FetchUserProfile(mobileNumber)),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Scaffold(
              body: Center(
                child: CustomLoading(),
              ),
            );
          } else if (state is ProfileLoaded) {
            var userData = state.userData ?? {};
            return Scaffold(
              appBar: AppBar(
                title: Text('profile'.tr),
                actions: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const LanguageDialog();
                          },
                        );
                      },
                      icon: const Icon(
                        IonIcons.language,
                        size: 28,
                      ))
                ],
              ),
              body: Card(
                elevation: 5,
                margin: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.all(16.0), // Padding inside the card
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildUserInfoText('full_name'.tr, userData['fullName'],
                          Icons.person, context),
                      _buildUserInfoText('age'.tr, userData['age'],
                          Icons.calendar_today, context),
                      _buildUserInfoText('gender'.tr, userData['gender'],
                          Icons.transgender, context),
                      _buildUserInfoText('mobile_number'.tr,
                          userData['mobileNumber'], Icons.phone, context),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomButton(
                            width: screenWidth(context) * .8,
                            function: () {
                              getStorage.remove('phoneNumber');
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            title: 'logout'.tr),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else if (state is ProfileError) {
            return Scaffold(
              body: Center(
                child: Text(state.error),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: Text('unknown_state'.tr),
              ),
            );
          }
        },
      ),
    );
  }
}

Widget _buildUserInfoText(
    String label, dynamic value, IconData icon, BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(bottom: screenHeight(context) * .03),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.blueGrey,
            ),
            const SizedBox(width: 8),
            Text(
              '$label ',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
        Text(
          '${value ?? 'Unknown'}',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.start,
        ),
      ],
    ),
  );
}
