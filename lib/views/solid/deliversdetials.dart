import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:alpha/controller/auth_controller.dart';
import 'package:alpha/utiles/app_constants.dart';
import 'package:alpha/utiles/preference.dart';
import 'package:alpha/widgets/confirmation_dialog.dart';
import 'package:alpha/widgets/custom_button.dart';
import 'package:alpha/widgets/custom_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Deliver extends StatefulWidget {
  final String name;
  final String address;
  final int phone;
  final bool? isActive;
  final String? id;
  final String email;
  final String password;
  final String? vehicenum;
  final String? impath;
  final String? status;
  final String? token;
  final DocumentSnapshot documentSnapshot;
  Deliver({
    required this.documentSnapshot,
    this.id,
    this.isActive = false,
    required this.name,
    required this.address,
    required this.email,
    required this.password,
    required this.phone,
    required this.vehicenum,
    this.status,
    this.token,
    this.impath = "assets/image/logo_icon.jpg",
  });

  @override
  _DeliverState createState() => _DeliverState();
}

class _DeliverState extends State<Deliver> {
  void _openSocialMedia(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _addressController = TextEditingController();
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('orders').doc();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String orderid = "";
  @override
  void initState() {
    super.initState();
  }

  Preference sharePref = Preference.shared;
  String name = "طلب موصل";
  VoidCallback? fun1;
  VoidCallback? fun2;

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
        child: Column(children: [
          ListTile(
            trailing: CircleAvatar(
              backgroundImage: AssetImage(widget.impath!),
            ),
            tileColor: Colors.grey[300],
            title: Text(
              overflow: TextOverflow.clip,
              "اسم الموصل :\n  ${widget.name}",
              //textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            tileColor: Color.fromARGB(255, 42, 69, 80),
            title: InkWell(
              onTap: () => _openSocialMedia('tel:775346074'),
              child: Text(
                "رقم الجوال  : ${widget.phone}",
                //   textDirection: TextDirection.rtl,
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
              //   textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            tileColor: Color.fromARGB(255, 42, 69, 80),
            title: Text(
              " الحــالة: ${widget.status ?? 'طلب مُوصل'}",
              //textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
              // trailing: ElevatedButton(onPressed: fun1, child: Text("وصلت")),
              leading: ElevatedButton(
                  onPressed: (widget.status != "طلب مُوصل" &&
                          widget.status != "تم أخذ العينة")
                      ? () async {
                          updateDeliveryPerson(widget.id!, "تم أخذ العينة");
                        }
                      : null,
                  child: Text("اُخذت")),
              title: ElevatedButton(
                  child: Text(widget.status ?? "طلب مُوصل"),
                  onPressed: (widget.status != "طلب مُوصل")
                      ? null
                      : () async {
                          //طلب موصل
                          showDialog(
                              useSafeArea: true,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    scrollable: true,
                                    title: Text(
                                      name,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextFormField(
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                              maxLines: 3,
                                              autofocus: true,
                                              controller: _messageController,
                                              decoration: const InputDecoration(
                                                labelStyle: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                labelText: 'وصف رسالة للموصل',
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'الرجاء تعبئة الحقل';
                                                }
                                                return null;
                                              },
                                            ),
                                            TextFormField(
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                              maxLines: 2,
                                              autofocus: true,
                                              keyboardType: TextInputType.text,
                                              controller: _addressController,
                                              decoration: const InputDecoration(
                                                labelText: 'عنوانك الحالي',
                                                labelStyle: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'الرجاء تحديد عنوان العينة';
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(height: 16.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: FloatingActionButton
                                                      .small(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 255, 255, 255),
                                                    shape: CircleBorder(),
                                                    onPressed: () =>
                                                        _openSocialMedia(
                                                            'tel:${widget.phone}'),
                                                    child: const Icon(
                                                      Icons.call,
                                                      color: Color.fromARGB(
                                                          255, 38, 104, 3),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: FloatingActionButton
                                                      .small(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 255, 255, 255),
                                                    shape: CircleBorder(),
                                                    onPressed: () =>
                                                        _openSocialMedia(
                                                            'https://api.whatsapp.com/send?phone=+967775346074'),
                                                    child: const Icon(
                                                      Icons.message,
                                                      color: Color.fromARGB(
                                                          255, 15, 0, 180),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: CustomButton(
                                                    width: 80,
                                                    radius: 50,
                                                    fontSize: 14,
                                                    height: 40,
                                                    border: BorderSide(
                                                        width: 2,
                                                        color: Color.fromARGB(
                                                            255, 231, 255, 77)),
                                                    buttonText: "اشعار",
                                                    onPressed: () async {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        Get.dialog(
                                                            ConfirmationDialog(
                                                          isYes: true,
                                                          onYesPressed:
                                                              () async {
                                                            Get.back();
                                                            // takesample();
                                                            if (widget.token != null && widget.token!.isNotEmpty) {
                                                              AuthController.sendPushMessage(
                                                                  widget.token!,
                                                                  "${_messageController.text}",
                                                                  "${_addressController.text}",
                                                                  data: {'order_id': docRef.id, 'type': 'new_order'});
                                                            }
                                                            sendorder();
                                                            firestore
                                                                .collection(
                                                                    "Delivers")
                                                                .doc(widget.id)
                                                                .update({
                                                              "status":
                                                                  "تم طلب مُوصل",
                                                            }).then((value) {});
                                                            _addressController
                                                                    .text =
                                                                _messageController
                                                                    .text = "";
                                                            Get.back();

                                                            showCustomSnackBar(
                                                                "تم طلب الموصل بنجاح");
                                                            print(
                                                                "----------------------  ---------------------");
                                                          },
                                                          onNoPressed: () =>
                                                              Get.back(),
                                                          title: "تحذير !",
                                                          icon:
                                                              'assets/image/support.png',
                                                          description:
                                                              "  هل متاكد من طلب الموصل سيتم ارسال رسالة للوصل المحدد",
                                                        ));
                                                      } //   _showStudents();
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  child: CustomButton(
                                                      width: 80,
                                                      radius: 50,
                                                      fontSize: 14,
                                                      height: 40,
                                                      border: const BorderSide(
                                                          width: 2,
                                                          color: Color.fromARGB(
                                                              255,
                                                              231,
                                                              255,
                                                              77)),
                                                      buttonText: "نصية SMS",
                                                      onPressed: () {
                                                        print(
                                                            "-----${docRef.id}------------$orderid-----------------------");

                                                        print(
                                                            "--------------------${sharePref.getString(AppConstants.USER_ID)}");
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          sendorder();
                                                          Get.back();
                                                          Get.dialog(
                                                              ConfirmationDialog(
                                                            isYes: true,
                                                            onYesPressed:
                                                                () async {
                                                              Get.back();
                                                              // takesample();
                                                              _openSocialMedia(
                                                                  "sms:${widget.phone}?body= ${_messageController.text.trim()}\n العنوان:${_addressController.text.trim()}");

                                                              sendorder();
                                                              firestore
                                                                  .collection(
                                                                      "Delivers")
                                                                  .doc(
                                                                      widget.id)
                                                                  .update({
                                                                "status":
                                                                    "تم طلب مُوصل",
                                                              }).then((value) {});
                                                              _addressController
                                                                      .text =
                                                                  _messageController
                                                                      .text = "";
                                                              Get.back();

                                                              showCustomSnackBar(
                                                                  "تم طلب الموصل بنجاح");
                                                              print(
                                                                  "----------------------  ---------------------");
                                                            },
                                                            onNoPressed: () =>
                                                                Get.back(),
                                                            title: "تحذير !",
                                                            icon:
                                                                'assets/image/support.png',
                                                            description:
                                                                "  هل متاكد من طلب الموصل سيتم ارسال رسالة للوصل المحدد",
                                                          ));
                                                        }
                                                      }),
                                                ),
                                                Expanded(
                                                  child: CustomButton(
                                                    width: 80,
                                                    radius: 50,
                                                    fontSize: 14,
                                                    height: 40,
                                                    border: const BorderSide(
                                                        width: 2,
                                                        color: Color.fromARGB(
                                                            255, 231, 255, 77)),
                                                    buttonText: "تراجع",
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                              });
                        }))
        ]),
      ),
    );
  }

  void updateDeliveryPerson(
      String deliveryPersonId, String newDeliveryPersonId) async {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('orders');
    final QuerySnapshot querySnapshot =
        await collection.where('d_id', isEqualTo: deliveryPersonId).get();

    WriteBatch batch = firestore.batch();

    for (var doc in querySnapshot.docs) {
      batch.update(collection.doc(doc.id), {
        "pickup_time": FieldValue.serverTimestamp(),
        "status": newDeliveryPersonId
      });
    }

    batch.update(firestore.collection("Delivers").doc(widget.id), {
      "status": "تم أخذ العينة",
    });

    await batch.commit().then((value) {
      showCustomSnackBar("تم ارسال الطلب بنجاح");
    });
  }

  void sendorder() async {
    try {
      await firestore.collection('orders').doc(docRef.id).set({
        'customer_id': sharePref.getString(AppConstants.USER_ID),
        'customer_name': sharePref.getString(AppConstants.USER_NAME) ?? 'غير معروف',
        'd_id': widget.id,
        'deliver_name': widget.name,
        'date_requested': FieldValue.serverTimestamp(),
        'order_id': docRef.id,
        'pickup_time': "",
        'receivedTime': "",
        'simple_id': docRef.id,
        'status': 'تم طلب موصل',
      });
      print('Data added to the collection successfully.');
    } catch (e) {
      print('Error adding data to the collection: $e');
    }
  }

  //
  takesample() {
    fun2 = () async {
      await firestore.collection("orders").doc(docRef.id).update({
        "pickup_time": FieldValue.serverTimestamp(),
        "status": "تم أخذ العينة"
      }).then((value) {
        setState(() {
          fun2 = null;
          print("----------------------  ---------------------");
          showCustomSnackBar("تم ارسال الطلب بنجاح");
        });
      });
    };
  }
}
