import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alpha/models/user_model.dart';
import 'package:alpha/views/home/home_screen.dart';
import 'package:alpha/views/solid/custtomerdetials.dart';
import 'package:alpha/widgets/confirmation_dialog.dart';
import 'package:alpha/widgets/custom_snackbar.dart';

class showusers extends StatefulWidget {
  static const routeName = 'Customers';
  @override
  _showuserstate createState() => _showuserstate();
}

class _showuserstate extends State<showusers> {
  String? id;
  String selectedItem = "موصل";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.3,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(" قائمة المستخدمين",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 255, 255, 255))),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return !snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data!.docs[index];
                    UserModel user = UserModel.withId(
                        date: data['date'],
                        isVerfied: data['isVerfied'],
                        id: data["id"],
                        token: data["token"],
                        email: data['email'],
                        username: data["username"],
                        type: data["type"],
                        documentSnapshot: data);
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
                                backgroundImage: AssetImage(
                                    user.image ?? 'assets/image/logo.jpeg'),
                              ),
                              tileColor: Colors.grey[300],
                              title: Text(
                                overflow: TextOverflow.clip,
                                "اسم المستخدم :\n  ${user.username!}",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              tileColor: Colors.grey[300],
                              title: Text(
                                "التفعيل  : ${(user.isVerfied == false) ? "غير مفعل" : "مفعل"}",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              tileColor: Colors.grey[300],
                              title: Text(
                                "نوع المستخدم  :${user.type} ",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: 0,
                                    child: FloatingActionButton.small(
                                      onPressed: () async {
                                        Get.dialog(ConfirmationDialog(
                                            isYes: true,
                                            onYesPressed: () async {
                                              print(
                                                  "----------------------  ---------------------");
                                              FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(user.id)
                                                  .update({
                                                "isVerfied":
                                                    (user.isVerfied == false)
                                                        ? true
                                                        : false,
                                              }).then((value) {});
                                              showCustomSnackBar(
                                                  "تم التعديل بنجاح");
                                              Get.back();
                                            },
                                            onNoPressed: () => Get.back(),
                                            title: "تحذير !",
                                            icon: 'assets/image/support.png',
                                            description: (user.isVerfied ==
                                                    false)
                                                ? " هل انت متاكد من تفعيل المستخدم الحالي ؟"
                                                : " هل انت متاكد من  إيقاف تفعيل المستخدم الحالي ؟"));
                                      },
                                      child: Text((user.isVerfied == false)
                                          ? " تفعيل"
                                          : "إيقاف"),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Expanded(
                                  child: FloatingActionButton.small(
                                    onPressed: () async {
                                      Get.dialog(ConfirmationDialog(
                                        isYes: true,
                                        onYesPressed: () async {
                                          print(
                                              "----------------------  ---------------------");
                                          FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(user.id)
                                              .delete()
                                              .then((value) {
                                            showCustomSnackBar(
                                                "تم الحذف بنجاح");
                                            Get.back();
                                          });
                                        },
                                        onNoPressed: () => Get.back(),
                                        title: "تحذير !",
                                        icon: 'assets/image/support.png',
                                        description:
                                            "هل انت متاكد من حذف المستخدم بشكل نهائي؟ ",
                                      ));
                                    },
                                    child: Text("حــذف"),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: DropdownButton<String>(
                                  borderRadius: BorderRadius.circular(20),
                                  elevation: 20,
                                  alignment: AlignmentDirectional.center,
                                  isExpanded: true,
                                  autofocus: true,
                                  dropdownColor:
                                      const Color.fromARGB(255, 152, 152, 151),
                                  iconEnabledColor: Colors.blue,
                                  focusColor: Color.fromARGB(255, 173, 127, 8),
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 15, 58, 118),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  value: selectedItem,
                                  onChanged: (String? newValue) {
                                    Get.dialog(ConfirmationDialog(
                                        isYes: true,
                                        onYesPressed: () async {
                                          print(
                                              "----------------------  ---------------------");
                                          FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(user.id)
                                              .update({
                                            "type": selectedItem
                                          }).then((value) {});
                                          showCustomSnackBar(
                                              "تم التعديل بنجاح");
                                          Get.back();
                                        },
                                        onNoPressed: () => Get.back(),
                                        title: "تحذير !",
                                        icon: 'assets/image/support.png',
                                        description:
                                            (" هل انت متاكد من تغير صلاحيات المستخدم الحالي ؟")));

                                    setState(() {
                                      selectedItem = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'موصل',
                                    'مدير',
                                    'عميل',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                )),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
