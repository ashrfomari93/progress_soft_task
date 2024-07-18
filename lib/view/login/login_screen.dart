import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/utils.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:phone_input/phone_input_package.dart';
import 'package:progress_soft/data/app_constant.dart';
import 'package:progress_soft/view/dashboard/dashboard_screen.dart';
import 'package:progress_soft/widgets/custom_button.dart';
import 'package:progress_soft/widgets/custom_language_dialog.dart';
import 'package:progress_soft/widgets/custom_loading.dart';
import 'package:progress_soft/widgets/custom_phone_text_field.dart';
import 'package:progress_soft/widgets/custom_text_field.dart';
import 'login_bloc.dart';
import '../register/register_screen.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  PhoneController? phoneController;
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(assets.logo),
              CustomPhoneTextField(
                phoneController: phoneController,
                function: (PhoneNumber? value) {
                  if (value != null) {
                    mobileController.text = '+${value.countryCode + value.nsn}';
                  }
                },
              ),
              SizedBox(
                height: screenHeight(context) * .02,
              ),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return CustomTextField(
                    hintText: 'password'.tr,
                    controller: passwordController,
                    maxLine: 1,
                    obscureText: true,
                  );
                },
              ),
              SizedBox(
                height: screenHeight(context) * .02,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RegisterScreen()));
                    },
                    child: Text(
                      'register'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        color: appConstant.primaryColor,
                        decorationColor: appConstant.primaryColor,
                      ),
                    )),
              ),
              SizedBox(
                height: screenHeight(context) * .06,
              ),
              BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    // Navigate to home screen or another screen on success
                    getStorage.write(
                        'phoneNumber', mobileController.text.trim());

                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const DashboardScreen()));
                  } else if (state is LoginFailure) {
                    if (state.reason == LoginFailureReason.userNotFound) {
                      _showUserNotFoundDialog(context);
                    } else if (state.reason ==
                        LoginFailureReason.incorrectPassword) {
                      _showErrorMessage(context, 'incorrect_password'.tr);
                    }
                  }
                },
                builder: (context, state) {
                  if (state is LoginLoading) {
                    return const CustomLoading();
                  }
                  return CustomButton(
                      width: screenWidth(context) * .8,
                      function: () {
                        context.read<LoginBloc>().add(LoginSubmitted(
                              mobileNumber: mobileController.text.trim(),
                              password: passwordController.text.trim(),
                            ));
                      },
                      title: 'login'.tr);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUserNotFoundDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('user_not_found'.tr),
        content: Text('the_user_is_not_registered'.tr),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RegisterScreen()));
            },
            child: Text('register'.tr),
          ),
        ],
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
