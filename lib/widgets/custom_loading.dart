import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_soft/data/app_constant.dart';


class CustomLoading extends StatelessWidget {
  final double size;
  const CustomLoading({super.key, this.size = 0.5});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Lottie.asset(assets.loading,
            height: Get.width * size, width: Get.width * size));
  }
}
