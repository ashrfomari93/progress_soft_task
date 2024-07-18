import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:progress_soft/data/assets.dart';

AppConstant appConstant = AppConstant();
Assets assets = Assets();
final getStorage = GetStorage();

class AppConstant {
  final primaryBorderRadius = 15.0;
  final Color primaryColor = const Color(0xff003366);
}

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

String locale = 'en';

String getSavedLanguage() {
  final cachedLanguageCode = getStorage.read('locale');

  if (cachedLanguageCode != null) {
    return cachedLanguageCode;
  } else {
    return 'en';
  }
}

void changeLanguage(String languageCode) {
  getStorage.write('locale', languageCode);
  Get.updateLocale(Locale(languageCode));
  locale = languageCode;
}

showAlert(String title, String message) {
  final snackBar = GetSnackBar(
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      messageText: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                color: Color(0xFFC72C41),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              children: [
                const SizedBox(
                  width: 48,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title.isNotEmpty)
                      Text(
                        title.tr,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    if (message.isNotEmpty)
                      Text(
                        message.tr,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                  ],
                ))
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 5,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.only(bottomLeft: Radius.circular(20)),
              child: Stack(
                children: [
                  SvgPicture.asset(
                    assets.errorSnackBar,
                    height: 48,
                    width: 40,
                  )
                ],
              ),
            ),
          )
        ],
      ));

  Get.showSnackbar(snackBar);
}
