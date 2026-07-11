import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alpha/controller/settings_controller.dart';
import 'package:alpha/utiles/app_constants.dart';

class DynamicLogo extends StatelessWidget {
  final double width;
  final double height;

  const DynamicLogo({Key? key, this.width = 200, this.height = 200}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();

    return Obx(() {
      final logoUrl = settingsController.labLogoUrl.value;
      if (logoUrl.isNotEmpty) {
        return Image.network(
          logoUrl,
          width: width,
          height: height,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(Resources.logo, width: width, height: height);
          },
        );
      } else {
        return Image.asset(Resources.logo, width: width, height: height);
      }
    });
  }
}
