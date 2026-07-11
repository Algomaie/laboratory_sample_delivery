import 'package:alpha/widgets/custom_snackbar.dart';
import 'package:flutter/foundation.dart';

/// Centralized Firebase Auth error handler.
/// Replaces 5 duplicated switch blocks (~150 lines) with a single reusable function.
class ErrorHandler {
  static String handleError(dynamic error) {
    //debugPrint('ErrorHandler: $error (${error.runtimeType})');

    String message;
    String code = '';
    try {
      code = error.code ?? '';
    } catch (_) {
      showCustomSnackBar('حدث خطأ غير متوقع: $error');
      return 'حدث خطأ غير متوقع';
    }

  switch (code) {
    case 'email-already-in-use':
    case 'account-exists-with-different-credential':
    case 'ERROR_EMAIL_ALREADY_IN_USE':
      message = 'البريد الإلكتروني مستخدم بالفعل';
      break;
    case 'wrong-password':
    case 'ERROR_WRONG_PASSWORD':
      message = 'كلمة المرور غير صحيحة';
      break;
    case 'user-not-found':
    case 'ERROR_USER_NOT_FOUND':
      message = 'لا يوجد حساب بهذا البريد الإلكتروني';
      break;
    case 'user-disabled':
    case 'ERROR_USER_DISABLED':
      message = 'هذا الحساب معطّل';
      break;
    case 'too-many-requests':
    case 'ERROR_TOO_MANY_REQUESTS':
      message = 'محاولات كثيرة. حاول لاحقاً';
      break;
    case 'operation-not-allowed':
    case 'ERROR_OPERATION_NOT_ALLOWED':
      message = 'العملية غير مسموحة. تواصل مع الدعم';
      break;
    case 'invalid-email':
    case 'ERROR_INVALID_EMAIL':
      message = 'البريد الإلكتروني غير صالح';
      break;
    case 'weak-password':
      message = 'كلمة المرور ضعيفة جداً';
      break;
    case 'invalid-credential':
      message = 'بيانات الدخول غير صحيحة';
      break;
    default:
      message = 'حدث خطأ. حاول مرة أخرى';
  }

    showCustomSnackBar(message);
    return message;
  }
}
