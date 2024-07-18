import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

import '../data/app_constant.dart';

class LanguageDialog extends StatefulWidget {
  const LanguageDialog({super.key});

  @override
  State<LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('choose_app_language'.tr),
      content: SizedBox(
        height: 125,
        child: Column(
          children: [
            ListTile(
              title: const Text('English'),
              leading: Flag(Flags.united_kingdom),
              onTap: () {
                changeLanguage('en');
              },
            ),
            ListTile(
              title: const Text('اللغة العربية'),
              leading: Flag(Flags.jordan),
              onTap: () {
                changeLanguage('ar');
              },
            ),
          ],
        ),
      ),
    );
  }
}
