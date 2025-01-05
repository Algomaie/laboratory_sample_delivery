import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alpha/widgets/confirmation_dialog.dart';
import 'package:alpha/widgets/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class simple extends StatefulWidget {
  final String m1;
  final String m2;
  final String m3;
  final String? id;
  final DocumentSnapshot documentSnapshot;
  simple({
    required this.documentSnapshot,
    this.id,
    required this.m1,
    required this.m2,
    required this.m3,
  });

  @override
  _simpleState createState() => _simpleState();
}

class _simpleState extends State<simple> {
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
        child: Column(children: [
          ListTile(
            tileColor: Colors.grey[300],
            title: Text(
              overflow: TextOverflow.clip,
              "الرسالة الاولى:\n  ${widget.m1}",
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.update, color: Colors.blue),
            trailing: IconButton(
              onPressed: () async {
                Get.dialog(ConfirmationDialog(
                  isYes: true,
                  onYesPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('simples')
                        .doc(widget.documentSnapshot["sample_id"])
                        .delete()
                        .then((value) => {
                              Get.back(),
                              showCustomSnackBar("تم الحذف بنجاح"),
                            })
                        .catchError((error) =>
                            print('Failed to delete sample: $error'));
                  },
                  onNoPressed: () => Get.back(),
                  title: "تحذير !",
                  icon: 'assets/image/support.png',
                  description: " هل متاكد من حذف العينة ",
                ));
              },
              icon: Icon(Icons.delete, color: Colors.red),
            ),
            tileColor: Colors.grey[300],
            title: Text(
              "السعر  : ${widget.m2}",
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ]),
      ),
    );
  }
}
