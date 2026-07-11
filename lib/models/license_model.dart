import 'package:cloud_firestore/cloud_firestore.dart';

class LicenseModel {
  String? id;
  String? key;
  bool? isActive;
  String? deviceId;
  String? type; // 'lifetime', 'monthly', 'yearly'
  Timestamp? expiryDate;
  Timestamp? createdAt;

  LicenseModel({
    this.id,
    this.key,
    this.isActive,
    this.deviceId,
    this.type,
    this.expiryDate,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'isActive': isActive,
      'deviceId': deviceId,
      'type': type,
      'expiryDate': expiryDate,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory LicenseModel.fromMap(Map<String, dynamic> map, String documentId) {
    return LicenseModel(
      id: documentId,
      key: map['key'],
      isActive: map['isActive'],
      deviceId: map['deviceId'],
      type: map['type'],
      expiryDate: map['expiryDate'],
      createdAt: map['createdAt'],
    );
  }
}
