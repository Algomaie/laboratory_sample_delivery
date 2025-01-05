import 'package:alpha/controller/auth_controller.dart';
import 'package:alpha/utiles/styles.dart';
import 'package:alpha/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class ConfirmationDialog extends StatelessWidget {
  final String icon;
  final String? title;
  final String description;
  final Function()? onYesPressed;
  final bool isYes;
  final Function()? onNoPressed;
  ConfirmationDialog(
      {required this.icon,
      this.title,
      required this.description,
      required this.onYesPressed,
      this.isYes = false,
      this.onNoPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      insetPadding: EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: PointerInterceptor(
        child: SizedBox(
            width: 500,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Image.asset(icon, width: 50, height: 50),
                ),
                title != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          title!,
                          textAlign: TextAlign.center,
                          style: robotoMedium.copyWith(
                              fontSize: 18, color: Colors.red),
                        ),
                      )
                    : SizedBox(),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(description,
                      style: robotoMedium.copyWith(fontSize: 16),
                      textAlign: TextAlign.center),
                ),
                SizedBox(height: 20.0),
                GetBuilder<AuthController>(builder: (userController) {
                  return userController.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Row(children: [
                          Expanded(
                              child: TextButton(
                            onPressed: isYes ? onYesPressed : onNoPressed,
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.3),
                              minimumSize: Size(1170, 40),
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            child: Text(
                              isYes ? 'yes'.tr : 'no'.tr,
                              textAlign: TextAlign.center,
                              style: robotoBold.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ),
                          )),
                          SizedBox(width: 20.0),
                          Expanded(
                              child: CustomButton(
                            buttonText: isYes ? 'no'.tr : 'yes'.tr,
                            onPressed: () => isYes ? Get.back() : onYesPressed,
                            radius: 5,
                            height: 40,
                          )),
                        ]);
                }),
              ]),
            )),
      ),
    );
  }
}
