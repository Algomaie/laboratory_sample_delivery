import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

class FcmService {
  Future<String> _getAccessToken() async {
    try {
      final serviceAccountJson =
          await rootBundle.loadString('assets/service-account.json');
      final accountCredentials =
          ServiceAccountCredentials.fromJson(serviceAccountJson);
      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
      final authClient = await clientViaServiceAccount(accountCredentials, scopes);
      final token = authClient.credentials.accessToken.data;
      authClient.close();
      return token;
    } catch (e) {
      //debugPrint('Error getting access token: $e');
      return '';
    }
  }

  Future<void> sendPushMessage(String token, String body, String title, {Map<String, String>? data}) async {
    try {
      final String serverToken = await _getAccessToken();
      if (serverToken.isEmpty) {
        //debugPrint('Failed to get server token for FCM');
        return;
      }

      final serviceAccountJson =
          await rootBundle.loadString('assets/service-account.json');
      final String projectId = jsonDecode(serviceAccountJson)['project_id'];

      final String endpoint =
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

      final response = await http.post(
        Uri.parse(endpoint),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverToken',
        },
        body: jsonEncode({
          'message': {
            'token': token,
            'notification': {
              'title': title,
              'body': body,
            },
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
              ...?data,
            }
          }
        }),
      );
      
      //debugPrint('FCM HTTP v1 Response status: ${response.statusCode}');
      //debugPrint('FCM HTTP v1 Response body: ${response.body}');
    } catch (e) {
      //debugPrint('sendPushMessage error: $e');
    }
  }
}
