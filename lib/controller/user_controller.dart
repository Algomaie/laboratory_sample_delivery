import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:alpha/models/user_model.dart';
import 'package:alpha/utiles/app_constants.dart';
import 'package:alpha/utiles/preference.dart';
import 'package:alpha/utiles/route_helper.dart';
import 'package:alpha/widgets/custom_snackbar.dart';

import '../data/repository/user_repository.dart';
import '../data/repository/customer_repository.dart';
import '../data/repository/deliver_repository.dart';

class UserController extends GetxController implements GetxService {
  final UserRepository _userRepo = Get.find<UserRepository>();
  final CustomerRepository _customerRepo = Get.find<CustomerRepository>();
  final DeliverRepository _deliverRepo = Get.find<DeliverRepository>();
  final Preference storage = Preference.shared;

  UserModel? userData;
  bool isLoading = false;
  bool isgetDataLoading = true;

  Future<bool> getUserById(String userId) async {
    try {
      final user = await _userRepo.getUserById(userId);
      return user?.isVerfied ?? false;
    } catch (error) {
      //debugPrint('Error getting user: $error');
    }
    return false;
  }

  Future<String?> getUserTypeById(String userId) async {
    try {
      final user = await _userRepo.getUserById(userId);
      return user?.type;
    } catch (error) {
      //debugPrint('Error getting user type: $error');
    }
    return null;
  }

  Future<String> userInfo(String? userId) async {
    try {
      final String userType = storage.getString(AppConstants.type) ?? "";
      final String uid = userId ?? storage.getString(AppConstants.USER_ID) ?? "";

      if (userType == "عميل") {
        final customer = await _customerRepo.getCustomerById(uid);
        if (customer != null) {
          userData = UserModel.withId(
            id: uid,
            username: customer.dname,
            email: customer.email,
            image: customer.image,
            type: customer.type,
            token: customer.token,
          );
        }
      } else if (userType == "موصل") {
        final deliver = await _deliverRepo.getDeliverById(uid);
        if (deliver != null) {
          userData = UserModel.withId(
            id: uid,
            username: deliver.dname,
            email: deliver.email,
            image: deliver.image,
            type: deliver.type,
            token: deliver.token,
          );
        }
      } else {
        final user = await _userRepo.getUserById(uid);
        if (user != null) {
          userData = user;
        }
      }

      if (userData?.username != null) {
        await storage.setString(AppConstants.USER_NAME, userData!.username!);
      }
      isgetDataLoading = false;
      update();

      return userData?.username ?? '';
    } catch (error) {
      isgetDataLoading = false;
      update();
      //debugPrint('userInfo error: ${error.toString()}');
      rethrow;
    }
  }

  Future updateUserInfo(String userId, {String? username}) async {
    isLoading = true;
    update();
    try {
      await _userRepo.updateUser(userId, {"username": username});
      await userInfo(userId);
      showCustomSnackBar('profile_updated_successfully'.tr, isError: false);
      Get.offAndToNamed(RouteHelper.getSettingsRoute());
    } catch (error) {
      //debugPrint('updateUserInfo error: ${error.toString()}');
    } finally {
      isLoading = false;
      update();
    }
  }
}
