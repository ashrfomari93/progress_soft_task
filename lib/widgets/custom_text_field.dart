import 'package:flutter/material.dart';
import 'package:progress_soft/data/app_constant.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText, customPadding;
  final IconData? icon;
  final int? maxLine;
  final TextInputType? textInputType;
  final String? Function(String?)? validator;
  final Widget? suffix;

  const CustomTextField(
      {super.key,
      this.controller,
      this.icon,
      required this.hintText,
      this.obscureText = false,
      this.customPadding = false,
      this.maxLine,
      this.textInputType,
      this.suffix,
      this.validator});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showPassword = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText ? showPassword : false,
      maxLines: widget.maxLine,
      keyboardType: widget.textInputType,
      validator: widget.validator,
      autocorrect: false,
      decoration: InputDecoration(
          prefixIcon: widget.icon == null
              ? null
              : Icon(
                  widget.icon,
                  color: Colors.grey.shade400,
                ),
          suffixIcon: widget.suffix ??
              (widget.obscureText
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      icon: Icon(
                        showPassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey.shade400,
                      ))
                  : null),
          hintText: widget.hintText,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(appConstant.primaryBorderRadius)),
              borderSide: BorderSide(color: appConstant.primaryColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(appConstant.primaryBorderRadius)),
              borderSide: BorderSide(color: appConstant.primaryColor)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(appConstant.primaryBorderRadius)),
              borderSide: BorderSide(color: appConstant.primaryColor))),
    );
  }
}
