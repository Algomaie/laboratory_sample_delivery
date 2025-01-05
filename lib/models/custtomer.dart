import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//model for users
class CusttomerModel {
  String? id;
  String? dname;
  String? address;
  String? pass;
  String? email;
  String? date;
  bool? isActive = false;
  int? phone;
  String? image;
  String? token;
  String? type;
  final DocumentSnapshot? documentSnapshot;
  CusttomerModel(
      {this.dname,
      this.email,
      this.address,
      this.date,
      this.isActive,
      this.phone,
      this.image,
      this.pass,
      this.type,
      this.token,
      this.documentSnapshot});

  CusttomerModel.withId(
      {this.id,
      this.dname,
      this.email,
      this.address,
      this.date,
      this.isActive,
      this.phone,
      this.image,
      this.pass,
      this.type,
      this.token,
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
    map['pass'] = pass;
    map['token'] = token;
    map['type'] = type;

    return map;
  }

  factory CusttomerModel.fromMap(Map<String, dynamic> map) {
    return CusttomerModel.withId(
        id: map['id'],
        dname: map['dname'],
        email: map['email'],
        date: map['date'],
        address: map['address'],
        phone: map['phone'],
        image: map['image'],
        pass: map['pass'],
        isActive: map['isActive'],
        token: map['token'],
        type: map['type']);
  }
}
