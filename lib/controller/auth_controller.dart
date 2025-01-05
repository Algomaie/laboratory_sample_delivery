import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:alpha/models/deliver.dart';
import 'package:alpha/models/user_model.dart';
import 'package:alpha/utiles/app_constants.dart';
import 'package:alpha/utiles/preference.dart';
import 'package:alpha/utiles/route_helper.dart';
import 'package:alpha/widgets/custom_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as main_dio;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/profile/settings_screenadmin.dart';

class AuthController extends GetxController implements GetxService {
  bool isLoading = false;
  bool _notification = true;
  bool _acceptTerms = true;
  static String userToken = "";
  static Preference storage = Preference.shared;
  Future userLogin({
    required String email,
    required String password,
  }) async {
    final String? token = await FirebaseMessaging.instance.getToken();
    isLoading = true;
    update();

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      String id = FirebaseAuth.instance.currentUser!.uid;
      print("--------------------  -------------------------");
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DocumentReference docRef = firestore.collection('users').doc();
      final DocumentSnapshot<Object?> snapshot = await docRef.get();
      if (snapshot.exists) {
        final userData = snapshot.data() as Map<String, dynamic>;
        print("-------------------- -------------------------");
        update();
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "token": token,
        }).then((value) {});
        //initialize var userId to accessed and global from everywhere
        storage.setString(AppConstants.USER_ID, value.user!.uid);
        storage.setString(AppConstants.IS_LOGIN, '1');
        await userInfo(value.user!.uid).then((username) {
          isLoading = false;
          update();
          String id = FirebaseAuth.instance.currentUser!.uid;
          if (userData["isVerfied"] == true) {
            if (userData["type"] == "عميل") {
              print("-------------------- $token -------------------------");

              FirebaseFirestore.instance
                  .collection("Customers")
                  .doc(id)
                  .update({
                "token": token,
                "isActive": userData["isVerfied"]
              }).then((value) {});
              showCustomSnackBar('تم تسجيل الدخول بنجاح', isError: false);
              Get.offAndToNamed(
                  RouteHelper.getInitialRoute(username: username));
            } else if (userData["type"] == "موصل") {
              print("-------------------- $token -------------------------");

              FirebaseFirestore.instance.collection("Delivers").doc(id).update({
                "token": token,
                "isActive": userData["isVerfied"]
              }).then((value) {});
              showCustomSnackBar('تم تسجيل الدخول بنجاح', isError: false);
              Get.offAndToNamed(
                  RouteHelper.getInitialRoute(username: username));
            } else if (userData["type"] == "مدير") {
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .update({"token": token, "isActive": true}).then((value) {});
              showCustomSnackBar('تم تسجيل الدخول بنجاح', isError: false);
              Get.offAndToNamed(
                  RouteHelper.getInitialRoute(username: username));
            }
          } else
            showCustomSnackBar('لم يتم تفعيل حسابك تواصل مع مختبرات الفا',
                isError: false);
        });
      }
    }).catchError((error) {
      isLoading = false;
      update();
      if (error is FirebaseAuthException) {
        // Get the code property from the error.
        String code = error.code;
        switch (error.code) {
          case "ERROR_EMAIL_ALREADY_IN_USE.":
          case "account-exists-with-different-credential":
          case "email-already-in-use":
            error = "Email already used. Go to login page.";
            print(error);
            showCustomSnackBar(error.toString());
            break;
          case "ERROR_WRONG_PASSWORD":
          case "wrong-password":
            error = "Wrong email/password combination.";
            showCustomSnackBar(error.toString());
            break;
          case "ERROR_USER_NOT_FOUND":
          case "user-not-found":
            error = "No user found with this email.";
            showCustomSnackBar(error.toString());
            break;
          case "ERROR_USER_DISABLED":
          case "user-disabled":
            error = "User disabled.";
            showCustomSnackBar(error.toString());
            break;
          case "ERROR_TOO_MANY_REQUESTS":
          case "operation-not-allowed":
            error = "Too many requests to log into this account.";
            showCustomSnackBar(error.toString());
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
          case "operation-not-allowed":
            error = "Server error, please try again later.";
            showCustomSnackBar(error.toString());
            break;
          case "ERROR_INVALID_EMAIL":
          case "invalid-email":
            error = "Email address is invalid.";
            showCustomSnackBar(error.toString());
            break;
          default:
            error = "Register failed. Please try again.";
            showCustomSnackBar(error.toString());
            break;
        }
        print(error.toString());
        showCustomSnackBar(error.toString());
      } else {
        showCustomSnackBar('Something went wrong!');
      }
    });
  }

  Future userRegister({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    update();

//store data on firebase
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user);
      createUser(
        uId: value.user!.uid,
        name: name,
        email: email,
      ).then((value) {
        isLoading = false;
        update();
        storage.setString(AppConstants.IS_LOGIN, '1');
        storage.setString(AppConstants.USER_NAME, name);
        showCustomSnackBar('تم إنشاء حسابك انتظر ليتم تفعيله ', isError: false);
        Get.offAndToNamed(RouteHelper.getLoginRoute());
      });
    }).catchError((error) {
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          error = "Email already used. Go to login page.";
          print(error);
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          error = "Wrong email/password combination.";
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          error = "No user found with this email.";
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          error = "User disabled.";
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          error = "Too many requests to log into this account.";
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          error = "Server error, please try again later.";
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          error = "Email address is invalid.";
          showCustomSnackBar(error.toString());
          break;
        default:
          error = "Login failed. Please try again.";
          showCustomSnackBar(error.toString());
          break;
      }
      isLoading = false;
      update();
    });
  }

//function to create user
  Future createUser({
    required String name,
    required String email,
    required String uId,
  }) async {
    UserModel model = UserModel.withId(
      username: name,
      email: email,
      image: "assets/images/avatar.jpg",
      id: uId,
      isVerfied: false,
      date: DateTime.now().toIso8601String(),
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId.toString())
        .set(model.toMap())
        .then((value) {
      storage.setString(AppConstants.USER_ID, uId);
      print('Done');
    }).catchError((error) {
      //if something error in regiestration
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          error = "Email already used. Go to login page.";
          print(error);
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          error = "Wrong email/password combination.";
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          error = "No user found with this email.";
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          error = "User disabled.";
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          error = "Too many requests to log into this account.";
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          error = "Server error, please try again later.";
          showCustomSnackBar(error.toString());
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          error = "Email address is invalid.";
          showCustomSnackBar(error.toString());
          break;
        default:
          error = "Register failed. Please try again.";
          showCustomSnackBar(error.toString());
          break;
      }
      print(error.toString());
    });
  }

  Future signOut(context) async {
    storage
        .remove(
      'userId',
    )
        .then((value) async {
      userData = null;
      storage.setString(AppConstants.USER_NAME, "");
      storage.remove(AppConstants.USER_NAME);
      FirebaseAuth.instance.signOut();
      showCustomSnackBar('تم تسجيل خروج بنجاح', isError: false);
      Get.offAndToNamed(RouteHelper.getLoginRoute());
    });
  }

  UserModel? userData;

  bool isgetDataLoading = true;

  bool getUserById(String userId) {
    bool isVerfied = false;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic>? data;
      if (documentSnapshot.exists) {
        data = documentSnapshot.data() as Map<String, dynamic>?;
        isVerfied = data!["isVerfied"];
      }
    }).catchError((error) {
      print('Error getting user: $error');
    });
    return isVerfied;
  }

  bool getUserTypeById(String userId) {
    bool type = false;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic>? data;
      if (documentSnapshot.exists) {
        data = documentSnapshot.data() as Map<String, dynamic>?;
        type = data!["type"];
      }
    }).catchError((error) {
      print('Error getting user: $error');
    });
    return type;
  }

  Future<String> userInfo(userId) async {
    try {
      if (storage.getString(AppConstants.type) == "عميل") {
        final documentSnapshot = await FirebaseFirestore.instance
            .collection("Customers")
            .doc(userId ?? storage.getString(AppConstants.USER_ID))
            .get();
        userData = UserModel.fromMap(documentSnapshot.data()!);
        print("username: " + userData!.username!);
      }

      await storage.setString(AppConstants.USER_NAME, userData!.username!);
      isgetDataLoading = false;
      update();

      return userData!.username!;
    } catch (error) {
      isgetDataLoading = false;
      update();
      print(error.toString());
      throw error; // Rethrow the error to handle it higher up in the call stack if needed.
    }
  }

  Future updateUserInfo(userId, {username}) async {
    isLoading = true;
    update();
    FirebaseFirestore.instance.collection("users").doc(userId).update({
      "username": username,
    }).then((value) {
      userInfo(userId);
      isLoading = false;
      update();
      showCustomSnackBar('profile_updated_successfully'.tr, isError: false);
      Get.offAndToNamed(RouteHelper.getSettingsRoute());
    }).catchError((error) {
      isLoading = false;
      update();
      print(error.toString());
    });
  }

  void changePassword(
      context, String currentPassword, String newPassword) async {
    isLoading = true;
    update();
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: FirebaseAuth.instance.currentUser!.email!,
            password: currentPassword)
        .then((value) async {
      await value.user!.updatePassword(newPassword);
      showCustomSnackBar('password_changed_successfully'.tr, isError: false);
      Navigator.pop(context);
    }).catchError((err) {
      showCustomSnackBar('current_password_is_wrong'.tr);
    });

    isLoading = false;
    update();
  }

  removeUser(context) async {
    isLoading = true;
    update();
    final user = FirebaseAuth.instance.currentUser;
    await user!.delete().then((value) {
      isLoading = false;
      update();
      signOut(context);

      showCustomSnackBar('your_account_remove_successfully'.tr, isError: false);
    });
    isLoading = false;
    update();
    print('User account deleted');
    showCustomSnackBar('there_is_a_problem_on_removing_your_account'.tr);
  }

  // login(user) async {
  //   isLoading = true;
  //   update();
  //   FirebaseFirestore.instance.collection("users").doc(userId).update({
  //     "username": username,
  //   }).then((value) {
  //     userInfo(userId);
  //     isLoading = false;
  //     update();
  //     showCustomSnackBar('profile_updated_successfully'.tr, isError: false);
  //     Get.offAndToNamed(RouteHelper.getSettingsRoute());
  //   }).catchError((error) {
  //     isLoading = false;
  //     update();
  //     print(error.toString());
  //   });
  // }

  Future<void> printUserDataByName(name, email) async {
    print("--------------------${name}  -------------------------");

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference collectionRef = firestore.collection('Customers');

    final CollectionReference collection = firestore.collection('Delivers');
    final QuerySnapshot querySnapshot = await collectionRef
        .where('pass', isEqualTo: name)
        .where("email", isEqualTo: email)
        .get();
    final QuerySnapshot DeliversQSnapshot = await collection
        .where("pass", isEqualTo: name)
        .where('email', isEqualTo: email)
        .get();
    isLoading = false;
    print(
        "--------------------${storage.getString(AppConstants.USER_ID)}  -------------------------");

    if (querySnapshot.docs.isNotEmpty || DeliversQSnapshot.docs.isNotEmpty) {
      DocumentSnapshot document = (querySnapshot.docs.isNotEmpty)
          ? querySnapshot.docs.first
          : DeliversQSnapshot.docs.first;

      final data = document.data()! as Map<String, dynamic>;
      {
        final String? token = await FirebaseMessaging.instance.getToken();
        isLoading = true;

        update();
        String id = (querySnapshot.docs.isNotEmpty)
            ? data["customer_id"]
            : data["d_id"];

        storage.setString(AppConstants.USER_ID, id);
        storage.setString(AppConstants.USER_NAME, data["dname"]);
        storage.setString(AppConstants.IS_LOGIN, '1');
        storage.setString(AppConstants.type, data["type"]);
        storage.setString(AppConstants.pass, data["pass"]);
        (querySnapshot.docs.isNotEmpty)
            ? collectionRef.doc(id).update({
                "token": token,
              }).then((value) {})
            : collection.doc(id).update({
                "token": token,
              }).then((value) {});
        //initialize var userId to accessed and global from everywhere
        print("--------------------${data["type"]}  -------------------------");

        if (data["isActive"] == true) {
          if (data["type"] == "عميل") {
            print(
                "-------------------- ${data["type"]} -------------------------");
            FirebaseFirestore.instance
                .collection("Customers")
                .doc(id)
                .update({"token": token, "isActive": data["isActive"]}).then(
                    (value) {});

            Get.offAndToNamed(
                RouteHelper.getInitialRoute(username: data["dname"]));
          } else if (data["type"] == "موصل") {
            print("-------------------- $token -------------------------");
            FirebaseFirestore.instance
                .collection("Delivers")
                .doc(id)
                .update({"token": token, "isActive": data["isActive"]}).then(
                    (value) {});

            showCustomSnackBar('تم تسجيل الدخول بنجاح', isError: false);
            Get.offAndToNamed(
                RouteHelper.getInitialRoute(username: data["dname"]));
          }
        } else
          showCustomSnackBar('لم يتم تفعيل حسابك تواصل مع مختبرات الفا',
              isError: false);
      }

      isLoading = false;
      update();
      print('No user found with the name $name');
    } else {
      final CollectionReference usercollection = firestore.collection('users');
      final QuerySnapshot userquerySnapshot = await usercollection
          .where('pass', isEqualTo: name)
          .where("email", isEqualTo: email)
          .get();
      DocumentSnapshot userdoc = userquerySnapshot.docs.first;

      final userdata = userdoc.data() as Map<String, dynamic>;
      if (userdata["pass"] == name && userdata["email"] == email) {
        print(
            "------------------------------${storage.getString(AppConstants.USER_NAME)} -------------------------");

        FirebaseFirestore.instance.collection("users").doc(userdoc.id).update({
          "token": await FirebaseMessaging.instance.getToken(),
          "isActive": true
        }).then((value) {
          storage.setString(AppConstants.USER_ID, userdata["id"]);
          storage.setString(AppConstants.USER_NAME, userdata["username"]);
          storage.setString(AppConstants.type, userdata["type"]);
          storage.setString(AppConstants.pass, userdata["pass"]);
          storage.setBool(AppConstants.isVerfied, userdata["isVerfied"]);

          storage.setString(AppConstants.IS_LOGIN, '1');
          showCustomSnackBar('تم تسجيل الدخول بنجاح', isError: false);
          print(
              "------------------------------${storage.getString(AppConstants.USER_NAME)} -------------------------");

          Get.toNamed(
              RouteHelper.getInitialRoute(username: userdata["username"]));
        });
      }
    }
    isLoading = false;
  }

  static Future<Map<String, dynamic>> getdata(String id) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference docRef = firestore.collection('users').doc(id);
    final DocumentSnapshot<Object?> snapshot = await docRef.get();
    if (snapshot.exists) {
      final userData = snapshot.data() as Map<String, dynamic>;
      return userData;
    }
    return {};
  }

  static void sendPushMessage(String token, String body, String title) async {
    try {
      await FirebaseMessaging.instance
          .getToken()
          .then((value) => token = value!);
      print("--------------${token}-------------------------------");
      // FirebaseMessaging.instance.getToken().then((token) async {
      //   print("---------------------$token------------------------");
      // });

      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAET2Srss:APA91bF7c_q7B1gen7ff3dqh3jkQrBTVwsUNfBOH3TURnceM1mBJL-bziAhmWEY-aQDVusSBvbQwg3C45HoCE-Tt3Dv3hWfzVvfP_78Nz9UNwsz8XSOQ9L-bYBReOw8tRSx2cwXZyW96',
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': "apointment Confirme",
            'status': 'done',
            'body': body,
            'title': title
          },
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'to': token
        }),
      );
    } catch (e) {}
  }
}
