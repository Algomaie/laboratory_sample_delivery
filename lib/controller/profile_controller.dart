import 'package:get/get.dart';
import 'package:alpha/helper/auth_service.dart';
import 'package:alpha/helper/error_handler.dart'; // Will be renamed soon
import 'package:alpha/widgets/custom_snackbar.dart';
import 'package:alpha/controller/auth_controller.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController implements GetxService {
  final AuthService _authService = Get.find<AuthService>();
  bool isLoading = false;

  void changePassword(BuildContext context, String currentPassword, String newPassword) async {
    isLoading = true;
    update();
    try {
      await _authService.changePassword(currentPassword, newPassword);
      showCustomSnackBar('password_changed_successfully'.tr, isError: false);
      Navigator.pop(context);
    } catch (err) {
      ErrorHandler.handleError(err);
    } finally {
      isLoading = false;
      update();
    }
  }

  void removeUser(BuildContext context) async {
    isLoading = true;
    update();
    try {
      await _authService.deleteAccount();
      await Get.find<AuthController>().signOut(context);
      showCustomSnackBar('your_account_remove_successfully'.tr, isError: false);
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      isLoading = false;
      update();
    }
  }
}
