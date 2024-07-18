import 'package:get/get.dart';

class FieldValidators {
  static final RegExp mobileNumberRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
  static final RegExp passwordRegex =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  static String? allFieldsEmpty(String fullName, String mobileNumber,
      String age, String password, String confirmPassword) {
    if (fullName.isEmpty &&
        mobileNumber.isEmpty &&
        age.isEmpty &&
        password.isEmpty &&
        confirmPassword.isEmpty) {
      return 'all_fields_are_required'.tr;
    }
    return null;
  }

  static String? validateFullName(String fullName) {
    if (fullName.isEmpty) {
      return 'full_name_empty_error'.tr;
    }
    return null;
  }

  static String? validateMobileNumber(String mobile) {
    if (!mobileNumberRegex.hasMatch(mobile)) {
      return 'invalid_mobile_number'.tr;
    }
    return null;
  }

  static String? validateAge(String age) {
    if (int.tryParse(age) == null || int.parse(age) <= 0) {
      return 'invalid_age'.tr;
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (!passwordRegex.hasMatch(password)) {
      return 'password_length_error'.tr;
    }
    return null;
  }

  static String? validateConfirmPassword(
      String password, String confirmPassword) {
    if (password != confirmPassword) {
      return 'passwords_do_not_match'.tr;
    }
    return null;
  }
}
