import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alpha/widgets/confirmation_dialog.dart';
import 'package:alpha/widgets/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class Custtomer extends StatefulWidget {
  final String name;
  final String address;
  final int phone;
  final bool? isActive;
  final String? id;
  final String email;
  final String password;
  final String? impath;
  final DocumentSnapshot documentSnapshot;
  Custtomer({
    required this.documentSnapshot,
    this.id,
    this.isActive = false,
    required this.name,
    required this.address,
    required this.email,
    required this.password,
    required this.phone,
    this.impath = "assets/image/logo.jpeg",
  });

  @override
  _CusttomerState createState() => _CusttomerState();
}

class _CusttomerState extends State<Custtomer> {
  void _openSocialMedia(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 229, 229, 233),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.black, width: 2),
      ),
      elevation: 4,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              trailing: CircleAvatar(
                backgroundImage: AssetImage(widget.impath!),
              ),
              tileColor: Colors.grey[300],
              title: Text(
                overflow: TextOverflow.clip,
                "اسم العميل :\n  ${widget.name}",
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              tileColor: Color.fromARGB(255, 42, 69, 80),
              title: InkWell(
                onTap: () => _openSocialMedia('tel:775346074'),
                child: Text(
                  "رقم الجوال  : ${widget.phone}",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              tileColor: Colors.grey[300],
              title: Text(
                "العنوان  : ${widget.address}",
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              tileColor: Colors.grey[300],
              title: Text(
                "الايميل : ${widget.email}",
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton.small(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      shape: CircleBorder(),
                      onPressed: () => _openSocialMedia('tel:775346074'),
                      child: const Icon(
                        Icons.call,
                        color: Color.fromARGB(255, 38, 104, 3),
                      ),
                    ),
                    FloatingActionButton.small(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      shape: CircleBorder(),
                      onPressed: () => _openSocialMedia("sms:775346074"),
                      child: const Icon(
                        Icons.messenger,
                        color: Color.fromARGB(255, 38, 104, 3),
                      ),
                    ),
                    FloatingActionButton.small(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      shape: CircleBorder(),
                      onPressed: () => _openSocialMedia(
                          'https://api.whatsapp.com/send?phone=+967775346074'),
                      child: const Icon(
                        Icons.message,
                        color: Color.fromARGB(255, 15, 0, 180),
                      ),
                    ),
                    FloatingActionButton.small(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      shape: CircleBorder(),
                      onPressed: () => _openSocialMedia('tel:775346074'),
                      child: const Icon(
                        Icons.favorite,
                        color: Color.fromARGB(255, 255, 0, 0),
                      ),
                    ),
                    ElevatedButton.icon(
                        onPressed: () async {
                          widget.isActive == false
                              ? Get.dialog(ConfirmationDialog(
                                  isYes: true,
                                  onYesPressed: () {
                                    showCustomSnackBar("تم ارسال الطلب بنجاح");
                                    Get.back();
                                  },
                                  onNoPressed: () => Get.back(),
                                  title: "تحذير !",
                                  icon: 'assets/image/support.png',
                                  description:
                                      " هل متاكد من طلب الموصل سيتم ارسال بياناتك وستدفع رسوم التوصيل ",
                                ))
                              : null;
                        },
                        icon: Icon(
                          Icons.warning_amber_rounded,
                          color: Color.fromARGB(255, 255, 0, 0),
                        ),
                        label: Text("طلب توصيل"))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
