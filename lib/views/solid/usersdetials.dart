// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:alpha/widgets/confirmation_dialog.dart';
// import 'package:alpha/widgets/custom_snackbar.dart';
// import 'package:url_launcher/url_launcher.dart';

// class user extends StatefulWidget {
//   final String name;
//   final String address;
//   final int phone;
//   final bool? isActive;
//   final String? id;
//   final String email;
//   final String password;
//   final String? impath;
//   final DocumentSnapshot documentSnapshot;
//   user({
//     required this.documentSnapshot,
//     this.id,
//     this.isActive = false,
//     required this.name,
//     required this.address,
//     required this.email,
//     required this.password,
//     required this.phone,
//     this.impath = "assets/image/logo.jpeg",
//   });

//   @override
//   _userState createState() => _userState();
// }

// class _userState extends State<user> {
//   void _openSocialMedia(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }
