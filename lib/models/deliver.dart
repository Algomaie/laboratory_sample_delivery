import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//model for users
class DeliverModel {
  String? id;
  String? dname;
  String? address;
  String? pass;
  String? email;
  String? date;
  bool? isActive = false;
  int? phone;
  String? image;
  int? vehicenum;
  String? token;
  String? type;
  String? status;
  final DocumentSnapshot? documentSnapshot;
  DeliverModel(
      {this.dname,
      this.email,
      this.address,
      this.date,
      this.isActive,
      this.phone,
      this.image,
      this.vehicenum,
      this.pass,
      this.token,
      this.type,
      this.id,
      this.status,
      this.documentSnapshot});

  DeliverModel.withId(
      {this.id,
      this.dname,
      this.email,
      this.address,
      this.date,
      this.isActive,
      this.phone,
      this.image,
      this.vehicenum,
      this.pass,
      this.token,
      this.type,
      this.status,
      this.documentSnapshot});

//convert text to map to be stored
  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['d_id'] = id;
    map['dname'] = dname;
    map['address'] = address;
    map['phone'] = phone;
    map['email'] = email;
    map['date'] = date;
    map['isActive'] = isActive;
    map['image'] = image;
    map['pass'] = pass;
    map['vehicenumber'] = vehicenum;
    map['token'] = token;
    map['type'] = type;
    map['status'] = status;

    return map;
  }

  factory DeliverModel.fromMap(Map<String, dynamic> map) {
    return DeliverModel.withId(
        id: map['d_id'],
        dname: map['dname'],
        email: map['email'],
        vehicenum: map['vehicenumber'],
        date: map['date'],
        address: map['address'],
        phone: map['phone'],
        image: map['image'],
        pass: map['pass'],
        isActive: map['isActive'],
        token: map['token'],
        type: map['type'],
        status: map['status']);
  }
}
