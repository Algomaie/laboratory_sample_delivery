import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:alpha/views/home/home_screen.dart';

import 'deliversdetials.dart';

class HomePage extends StatefulWidget {
  static const routeName = 'homePage';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.3,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(" قائمة المُوصلين",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 255, 255, 255))),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Delivers")
            .where('isActive', isEqualTo: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return !snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data!.docs[index];
                    return Deliver(
                      documentSnapshot: data,
                      address: data['address'],
                      id: data["d_id"],
                      isActive: data['isActive'],
                      phone: data['phone'],
                      name: data['dname'],
                      email: data['email'],
                      status: data["status"],
                      vehicenum: data['vehicenumber'],
                      password: data['pass'],
                      token: data['token'],
                    );
                  },
                );
        },
      ),
    );
  }
}
