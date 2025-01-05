import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//model for users
class UserModel {
  String? id;
  String? username;
  String? email;
  String? date;
  bool? isVerfied;
  String? image;
  String? type;
  String? token;
  final DocumentSnapshot? documentSnapshot;
  UserModel(
      {this.username,
      this.email,
      this.date,
      this.isVerfied,
      this.image = "assets/image/logo.jpeg",
      this.type,
      this.token,
      this.documentSnapshot});
  get getdata => documentSnapshot;
  UserModel.withId(
      {this.id,
      this.username,
      this.email,
      this.date,
      this.isVerfied,
      this.image,
      this.type,
      this.token,
      this.documentSnapshot});

//convert text to map to be stored
  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map[''] = username;
    map['email'] = email;
    map['date'] = date;
    map['isVerfied'] = isVerfied;
    map['image'] = image;
    map['type'] = type;
    map['token'] = token;
    return map;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel.withId(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      date: map['date'],
      isVerfied: map['isVerfied'],
      image: map['image'],
      type: map['type'],
      token: map['token'],
    );
  }
}
