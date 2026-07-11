import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alpha/utiles/route_helper.dart';
import 'package:alpha/views/home/home_screen.dart';
import 'package:alpha/views/solid/custtomerdetials.dart';

import 'deliversdetials.dart';

class showCusttomers extends StatefulWidget {
  static const routeName = 'Customers';
  @override
  _showCusttomerState createState() => _showCusttomerState();
}

class _showCusttomerState extends State<showCusttomers> {
  String? id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.3,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(" قائمة العملاء",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 255, 255, 255))),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Customers").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return !snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data!.docs[index];
                    Map<String, dynamic>? docData = data.data() as Map<String, dynamic>? ?? {};
                    return Custtomer(
                      documentSnapshot: data,
                      address: docData['address'],
                      id: data.id,
                      isActive: docData['isActive'],
                      phone: docData['phone'],
                      name: docData['dname'],
                      email: docData['email'],
                      password: docData['pass'] ?? '***',
                    );
                  },
                );
        },
      ),
    );
  }
}
