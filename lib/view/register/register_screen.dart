import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:phone_input/phone_input_package.dart';
import 'package:progress_soft/data/app_constant.dart';
import 'package:progress_soft/view/login/login_screen.dart';
import 'package:progress_soft/view/register/register_bloc.dart';
import 'package:progress_soft/widgets/custom_button.dart';
import 'package:progress_soft/widgets/custom_phone_text_field.dart';
import 'package:progress_soft/widgets/custom_text_field.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();

  final TextEditingController mobileController = TextEditingController();

  final TextEditingController ageController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  PhoneController? phoneController;

  @override
  Widget build(BuildContext context) {
    String selectedGender = 'male';
    return Scaffold(
      appBar: AppBar(
        title: Text('register'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                hintText: 'full_name'.tr,
                controller: fullNameController,
                maxLine: 1,
              ),
              SizedBox(
                height: screenHeight(context) * .02,
              ),
              CustomPhoneTextField(
                phoneController: phoneController,
                function: (PhoneNumber? value) {
                  if (value != null) {
                    setState(() {
                      mobileController.text =
                          '+${value.countryCode + value.nsn}';
                    });
                  }
                },
              ),
              SizedBox(
                height: screenHeight(context) * .02,
              ),
              CustomTextField(
                hintText: 'age'.tr,
                controller: ageController,
                textInputType: TextInputType.number,
                maxLine: 1,
              ),
              SizedBox(
                height: screenHeight(context) * .02,
              ),
              DropdownButtonFormField<String>(
                value: selectedGender,
                items: <String>['male', 'female']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.tr),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedGender = newValue;
                    });
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.grey.shade400,
                  ),
                  // hintText: widget.hintText,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(appConstant.primaryBorderRadius),
                    ),
                    borderSide: BorderSide(color: appConstant.primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(appConstant.primaryBorderRadius),
                    ),
                    borderSide: BorderSide(color: appConstant.primaryColor),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(appConstant.primaryBorderRadius),
                    ),
                    borderSide: BorderSide(color: appConstant.primaryColor),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight(context) * .02,
              ),
              CustomTextField(
                hintText: 'password'.tr,
                controller: passwordController,
                obscureText: true,
                maxLine: 1,
              ),
              SizedBox(
                height: screenHeight(context) * .02,
              ),
              CustomTextField(
                hintText: 'confirm_password'.tr,
                controller: confirmPasswordController,
                obscureText: true,
                maxLine: 1,
              ),
              SizedBox(
                height: screenHeight(context) * .1,
              ),
              BlocConsumer<RegisterBloc, RegisterState>(
                listener: (context, state) {
                  if (state is RegisterSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('registration_successful'.tr)));
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  } else if (state is RegisterFailure) {
                    showAlert(state.message, '');
                  }
                },
                builder: (context, state) {
                  return CustomButton(
                      width: screenWidth(context) * .9,
                      raduis: 10,
                      function: () {
                        context.read<RegisterBloc>().add(RegisterSubmitted(
                            fullName: fullNameController.text,
                            mobileNumber: mobileController.text,
                            age: ageController.text,
                            gender: selectedGender,
                            password: passwordController.text,
                            confirmPassword: confirmPasswordController.text,
                            context: context));
                      },
                      title: 'register'.tr);
                  // }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
