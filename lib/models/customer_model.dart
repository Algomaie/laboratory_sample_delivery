import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//model for users
class CustomerModel {
  String? id;
  String? dname;
  String? address;
  String? email;
  String? date;
  bool? isActive = false;
  int? phone;
  String? image;
  String? token;
  String? type;
  String? medicalRecord; // Added for medical record
  final DocumentSnapshot? documentSnapshot;
  CustomerModel(
      {this.dname,
      this.email,
      this.address,
      this.date,
      this.isActive,
      this.phone,
      this.image,
      this.type,
      this.token,
      this.medicalRecord,
      this.documentSnapshot});

  CustomerModel.withId(
      {this.id,
      this.dname,
      this.email,
      this.address,
      this.date,
      this.isActive,
      this.phone,
      this.image,
      this.type,
      this.token,
      this.medicalRecord,
      this.documentSnapshot});

//convert text to map to be stored
  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['customer_id'] = id;
    map['dname'] = dname;
    map['address'] = address;
    map['phone'] = phone;
    map['email'] = email;
    map['date'] = date;
    map['isActive'] = isActive;
    map['image'] = image;
    map['token'] = token;
    map['type'] = type;
    map['medical_record'] = medicalRecord;

    return map;
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel.withId(
        id: map['customer_id'] ?? map['id'],
        dname: map['dname'],
        email: map['email'],
        date: map['date'],
        address: map['address'],
        phone: map['phone'],
        image: map['image'],
        isActive: map['isActive'],
        token: map['token'],
        type: map['type'],
        medicalRecord: map['medical_record']?.toString());
  }
}
