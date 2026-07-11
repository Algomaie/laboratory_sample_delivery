import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alpha/utiles/route_helper.dart';
import 'package:alpha/views/home/home_screen.dart';
import 'package:alpha/views/solid/simpledetials.dart';

import 'deliversdetials.dart';

class simpledata extends StatefulWidget {
  static const routeName = 'simpledata';
  @override
  _simpledataState createState() => _simpledataState();
}

class _simpledataState extends State<simpledata> {
  String? id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.3,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(" قائمة العينات",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 255, 255, 255))),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("simples").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return !snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data!.docs[index];
                    return simple(
                        documentSnapshot: data,
                        m1: data["m1"],
                        m2: data["m2"],
                        m3: data["m3"]);
                  },
                );
        },
      ),
    );
  }
}
