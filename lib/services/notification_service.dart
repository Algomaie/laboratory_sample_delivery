import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  /// Save a notification locally or to Firestore
  static Future<void> saveNotification(Map<String, dynamic> data) async {
    // Example implementation
    await FirebaseFirestore.instance.collection('notifications').add(data);
  }

  /// Mark notification as read
  static Future<void> markAsRead(String id) async {
    await FirebaseFirestore.instance.collection('notifications').doc(id).update({'isRead': true});
  }
}
