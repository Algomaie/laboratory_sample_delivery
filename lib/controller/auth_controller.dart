import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:alpha/utiles/app_constants.dart';
import 'package:alpha/utiles/preference.dart';
import 'package:alpha/utiles/route_helper.dart';
import 'package:alpha/widgets/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../helper/auth_service.dart';
import '../helper/error_handler.dart';
import '../data/repository/customer_repository.dart';
import '../data/repository/deliver_repository.dart';
import '../data/repository/user_repository.dart';
import '../models/user_model.dart';
import '../models/customer_model.dart';
import '../models/deliver_model.dart';
import '../services/fcm_service.dart';

class AuthController extends GetxController implements GetxService {
  final AuthService _authService = Get.find<AuthService>();
  final CustomerRepository _customerRepo = Get.find<CustomerRepository>();
  final DeliverRepository _deliverRepo = Get.find<DeliverRepository>();
  final UserRepository _userRepo = Get.find<UserRepository>();

  bool isLoading = false;
  static Preference storage = Preference.shared;

  Future<void> login(String email, String password) async {
    isLoading = true;
    update();

    try {
      try {
        await _authService.signIn(email, password);
      } catch (e) {
        if (e is FirebaseAuthException && 
           (e.code == 'user-not-found' || e.code == 'invalid-credential' || e.code == 'wrong-password')) {
          final migrated = await _autoMigrateUser(email, password);
          if (migrated) {
            await _authService.signIn(email, password);
          } else {
            rethrow;
          }
        } else {
          rethrow;
        }
      }

      await _handleSuccessfulLogin(email);
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<bool> _autoMigrateUser(String email, String password) async {
    final firestore = FirebaseFirestore.instance;
    // Check Customers
    final custSnapshot = await firestore.collection('Customers').where('email', isEqualTo: email).limit(1).get();
    if (custSnapshot.docs.isNotEmpty) {
      final data = custSnapshot.docs.first.data();
      if (data['pass'] == password) {
        await _authService.createAccountForUser(email, password);
        await custSnapshot.docs.first.reference.update({'pass': FieldValue.delete()});
        return true;
      }
    }
    
    // Check Delivers
    final delSnapshot = await firestore.collection('Delivers').where('email', isEqualTo: email).limit(1).get();
    if (delSnapshot.docs.isNotEmpty) {
      final data = delSnapshot.docs.first.data();
      if (data['pass'] == password) {
        await _authService.createAccountForUser(email, password);
        await delSnapshot.docs.first.reference.update({'pass': FieldValue.delete()});
        return true;
      }
    }

    // Check users
    final userSnapshot = await firestore.collection('users').where('email', isEqualTo: email).limit(1).get();
    if (userSnapshot.docs.isNotEmpty) {
      final data = userSnapshot.docs.first.data();
      if (data['pass'] == password) {
        await _authService.createAccountForUser(email, password);
        await userSnapshot.docs.first.reference.update({'pass': FieldValue.delete()});
        return true;
      }
    }
    return false;
  }

  Future<void> _handleSuccessfulLogin(String email) async {
    final token = await FirebaseMessaging.instance.getToken();

    // Search Customers
    final customer = await _customerRepo.getCustomerByEmail(email);
    if (customer != null) {
      return await _completeLogin(customer.id!, customer.toMap(), 'Customers', token);
    }

    // Search Delivers
    final deliver = await _deliverRepo.getDeliverByEmail(email);
    if (deliver != null) {
      return await _completeLogin(deliver.id!, deliver.toMap(), 'Delivers', token);
    }

    // Search users
    final user = await _userRepo.getUserByEmail(email);
    if (user != null) {
      return await _completeLogin(user.id!, user.toMap(), 'users', token);
    }
    
    showCustomSnackBar('لا توجد بيانات مستخدم مطابقة');
  }

  Future<void> _completeLogin(String id, Map<String, dynamic> data, String collection, String? token) async {
    if (data['isActive'] != true && data['isVerfied'] != true) {
      showCustomSnackBar('لم يتم تفعيل حسابك، تواصل مع مختبرات الفا', isError: false);
      await _authService.signOut();
      return;
    }

    if (collection == 'Customers') {
      await _customerRepo.updateCustomer(id, {"token": token, "isActive": true});
    } else if (collection == 'Delivers') {
      await _deliverRepo.updateDeliver(id, {"token": token, "isActive": true});
    } else {
      await _userRepo.updateUser(id, {"token": token, "isActive": true});
    }

    final type = data["type"] ?? "عميل";
    final username = data["dname"] ?? data["username"] ?? "";

    storage.setString(AppConstants.USER_ID, id);
    storage.setString(AppConstants.USER_NAME, username);
    storage.setString(AppConstants.type, type);
    storage.setString(AppConstants.IS_LOGIN, '1');
    storage.setBool(AppConstants.isVerfied, true);

    showCustomSnackBar('تم تسجيل الدخول بنجاح', isError: false);
    Get.offAndToNamed(RouteHelper.getInitialRoute(username: username));
  }

  Future userRegister({
    required String type,
    required String name,
    required String email,
    required String password,
    String? phone,
    String? address,
    String? vehicleNum,
    String? medicalRecord,
  }) async {
    isLoading = true;
    update();

    try {
      final cred = await _authService.register(email, password);
      await createUser(
        uId: cred.user!.uid,
        type: type,
        name: name,
        email: email,
        phone: phone,
        address: address,
        vehicleNum: vehicleNum,
        medicalRecord: medicalRecord,
      );
      
      storage.setString(AppConstants.IS_LOGIN, '1');
      storage.setString(AppConstants.USER_NAME, name);
      showCustomSnackBar('تم إنشاء حسابك انتظر ليتم تفعيله ', isError: false);
      Get.offAndToNamed(RouteHelper.getLoginRoute());
    } catch (error) {
      ErrorHandler.handleError(error);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future createUser({
    required String uId,
    required String type,
    required String name,
    required String email,
    String? phone,
    String? address,
    String? vehicleNum,
    String? medicalRecord,
  }) async {
    try {
      if (type == 'موصل') {
        DeliverModel model = DeliverModel.withId(
          dname: name,
          email: email,
          image: "assets/images/avatar.jpg",
          id: uId,
          isActive: false, // needs to be verified
          type: type,
          phone: phone != null ? int.tryParse(phone) : null,
          address: address,
          status: "طلب مُوصل",
          vehicenum: vehicleNum,
          date: DateTime.now().toIso8601String(),
        );
        await _deliverRepo.addDeliver(model, uId);
      } else {
        CustomerModel model = CustomerModel.withId(
          dname: name,
          email: email,
          image: "assets/images/avatar.jpg",
          id: uId,
          isActive: false, // needs to be verified
          type: type, // "عميل"
          phone: phone != null ? int.tryParse(phone) : null,
          address: address,
          medicalRecord: medicalRecord,
          date: DateTime.now().toIso8601String(),
        );
        await _customerRepo.addCustomer(model, uId);
      }
      
      storage.setString(AppConstants.USER_ID, uId);
    } catch (error) {
      ErrorHandler.handleError(error);
    }
  }

  Future signOut(context) async {
    await storage.remove('userId');
    storage.setString(AppConstants.USER_NAME, "");
    storage.remove(AppConstants.USER_NAME);
    await _authService.signOut();
    showCustomSnackBar('تم تسجيل خروج بنجاح', isError: false);
    Get.offAndToNamed(RouteHelper.getLoginRoute());
  }

  static Future<void> sendPushMessage(String token, String body, String title, {Map<String, String>? data}) async {
    print('Sending push message to $token: $title - $body');
    await FcmService().sendPushMessage(token, body, title, data: data);
  }
}
