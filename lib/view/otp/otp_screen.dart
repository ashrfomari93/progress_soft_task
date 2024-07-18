import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:progress_soft/data/app_constant.dart';
import 'package:progress_soft/view/login/login_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:progress_soft/widgets/custom_button.dart';
import 'package:progress_soft/widgets/custom_loading.dart';
import 'otp_bloc.dart';

// ignore: must_be_immutable
class OtpScreen extends StatefulWidget {
  final String mobileNumber;
  final String age;
  final String gender;
  final String fullName;
  final String password;
  final String verificationId;

  const OtpScreen(
      {Key? key,
      required this.mobileNumber,
      required this.verificationId,
      required this.age,
      required this.fullName,
      required this.gender,
      required this.password})
      : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String otp = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${'enter_the_otp_sent_to'.tr} ${widget.mobileNumber}'),
            const SizedBox(height: 20),
            PinCodeTextField(
              length: 6,
              appContext: context,
              autoFocus: true,
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
                selectedFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                activeColor: appConstant.primaryColor,
                selectedColor: Colors.black,
                inactiveColor: Colors.grey,
              ),
              onChanged: (value) {
                print('Entered OTP1111111: $value');
                // setState(() {
                //   otp = value;
                // });
              },
              onCompleted: (value) {
                // Use the OTP value here
                setState(() {
                  otp = value;
                });
                print('Entered OTP: $value');
              },
            ),
            SizedBox(height: screenHeight(context) * .04),
            BlocConsumer<OtpBloc, OtpState>(
              listener: (context, state) {
                if (state is OtpVerificationSuccess) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                  showAlert('otp_verified'.tr, '');
                } else if (state is OtpVerificationFailure) {
                  showAlert('otp_verification_failed'.tr, '');
                }
              },
              builder: (context, state) {
                if (state is OtpLoading) {
                  return const CustomLoading();
                }
                return CustomButton(
                    width: screenWidth(context) * .8,
                    function: () {
                      context.read<OtpBloc>().add(OtpSubmitted(
                            otp: otp, // OTP is handled by onCompleted
                            verificationId: widget.verificationId,
                            fullName: widget
                                .fullName, // Replace with actual full name
                            mobileNumber: widget.mobileNumber,
                            age: widget.age, // Replace with actual age
                            gender: widget.gender, // Replace with actual gender
                            password: widget.password,
                          ));
                    },
                    title: 'verify_otp'.tr);
              },
            ),
          ],
        ),
      ),
    );
  }
}
