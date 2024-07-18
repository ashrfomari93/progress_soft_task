import 'package:flutter/material.dart';
import 'package:progress_soft/data/app_constant.dart';
import 'package:progress_soft/widgets/custom_loading.dart';

class CustomButton extends StatelessWidget {
  final Function function;
  final String title;
  final double? width, height, raduis, fontSize;
  final Color? color, textColor;
  final FontWeight fontWeight;
  final bool border, loading;

  const CustomButton(
      {super.key,
      required this.function,
      this.color,
      this.width,
      this.height,
      this.raduis,
      this.textColor,
      this.fontSize,
      this.border = false,
      this.loading = false,
      required this.title,
      this.fontWeight = FontWeight.w700});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        height: height ?? 50,
        minWidth: width,
        onPressed: () {
          function();
        },
        elevation: border ? 0 : null,
        splashColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: border
                    ? color ?? appConstant.primaryColor
                    : Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(raduis ?? 15))),
        color: border ? null : color ?? appConstant.primaryColor,
        child: loading
            ? const CustomLoading()
            : Text(
                title,
                style: TextStyle(
                    fontSize: fontSize ?? 18,
                    color: textColor ?? Colors.white,
                    fontWeight: fontWeight),
              ));
  }
}
