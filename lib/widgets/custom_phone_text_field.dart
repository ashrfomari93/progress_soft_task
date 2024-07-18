import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_input/phone_input_package.dart';
import 'package:progress_soft/data/app_constant.dart';

class CustomPhoneTextField extends StatelessWidget {
  final Function? function;
  final bool border;

  final PhoneController? phoneController;
  const CustomPhoneTextField(
      {super.key, this.function, this.border = false, this.phoneController});

  @override
  Widget build(BuildContext context) {
    return PhoneInput(
        controller: phoneController,
        countrySelectorNavigator: CountrySelectorNavigator.draggableBottomSheet(
            bottomSheetDragHandlerColor: appConstant.primaryColor,
            searchInputHeight: 50,
            searchInputDecoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                hintText: 'search'.tr,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(appConstant.primaryBorderRadius)),
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(appConstant.primaryBorderRadius)),
                    borderSide: const BorderSide(color: Colors.white))),
            flagShape: BoxShape.rectangle,
            flagSize: 30),
        defaultCountry: IsoCode.JO,
        showFlagInInput: !border,
        flagShape: BoxShape.rectangle,
        showArrow: border,
        flagSize: 30,
        onChanged: (value) {
          if (function != null) {
            function!(value);
          }
        },
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
        countryCodeStyle: TextStyle(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w600,
            fontSize: 18),
        autovalidateMode: AutovalidateMode.disabled,
        validator: (phoneNumber) {
          if (phoneNumber == null) {
            return 'please_enter_your_phone_number'.tr;
          }
          if (!phoneNumber.isValid()) {
            return 'please_enter_your_phone_number'.tr;
          }

          return null;
        },
        cursorColor: appConstant.primaryColor,
        autofillHints: const [AutofillHints.telephoneNumber],
        decoration: InputDecoration(
          contentPadding: border ? null : const EdgeInsets.all(10),
          fillColor: Colors.transparent,
          filled: !border,
          errorStyle: border ? null : const TextStyle(color: Colors.white),
          border: border
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(appConstant.primaryBorderRadius)),
                  borderSide: BorderSide(color: appConstant.primaryColor))
              : OutlineInputBorder(
                  borderSide: BorderSide(color: appConstant.primaryColor)),
          focusedBorder: border
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(appConstant.primaryBorderRadius)),
                  borderSide: BorderSide(color: appConstant.primaryColor))
              : OutlineInputBorder(
                  borderSide: BorderSide(color: appConstant.primaryColor)),
          enabledBorder: border
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(appConstant.primaryBorderRadius)),
                  borderSide: BorderSide(color: appConstant.primaryColor))
              : OutlineInputBorder(
                  borderSide: BorderSide(color: appConstant.primaryColor)),
        ));
  }
}
