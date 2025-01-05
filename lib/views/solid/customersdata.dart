import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alpha/models/custtomer.dart';
import 'package:alpha/models/deliver.dart';
import 'package:alpha/widgets/confirmation_dialog.dart';
import 'package:alpha/widgets/custom_snackbar.dart';

class showcustomersdata extends StatefulWidget {
  static const routeName = 'Customers';

  const showcustomersdata({super.key});
  @override
  _showuserstate createState() => _showuserstate();
}

class _showuserstate extends State<showcustomersdata> {
  String? id;
  String selectedItem = "موصل";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.3,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(" قائمة الموصلين",
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
                    CusttomerModel custtomerModel = CusttomerModel.withId(
                        date: data['date'],
                        isActive: data['isActive'],
                        id: data["customer_id"],
                        token: data["token"],
                        email: data['email'],
                        address: data['address'],
                        dname: data["dname"],
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
                                    custtomerModel.image ??
                                        'assets/image/logo_icon.png'),
                              ),
                              tileColor: Colors.grey[300],
                              title: Text(
                                overflow: TextOverflow.clip,
                                "اسم العميل :\n  ${custtomerModel.dname!}",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              tileColor: Colors.grey[300],
                              title: Text(
                                "التفعيل  : ${(custtomerModel.isActive == false) ? "غير مفعل" : "مفعل"}",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              tileColor: Colors.grey[300],
                              title: Text(
                                "العنوان:${custtomerModel.address} ",
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
                                                  .collection("Customers")
                                                  .doc(custtomerModel.id)
                                                  .update({
                                                "isActive":
                                                    (custtomerModel.isActive ==
                                                            false)
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
                                            description: (custtomerModel
                                                        .isActive ==
                                                    false)
                                                ? " هل انت متاكد من تفعيل العميل الحالي ؟"
                                                : " هل انت متاكد من  إيقاف تفعيل العميل الحالي ؟"));
                                      },
                                      child: Text(
                                          (custtomerModel.isActive == false)
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
                                              .collection("Customers")
                                              .doc(custtomerModel.id)
                                              .delete()
                                              .then((value) {
                                            deleteOrdersByDeliveryPerson(
                                                custtomerModel.id!);
                                            showCustomSnackBar(
                                                "تم الحذف بنجاح");
                                            Get.back();
                                          });
                                        },
                                        onNoPressed: () => Get.back(),
                                        title: "تحذير !",
                                        icon: 'assets/image/support.png',
                                        description:
                                            "هل انت متاكد من حذف العميل بشكل نهائي؟ ",
                                      ));
                                    },
                                    child: Text("حــذف"),
                                  ),
                                ),
                              ],
                            ),
                            //   Row(
                            //     children: [
                            //       Expanded(
                            //           child: DropdownButton<String>(
                            //         borderRadius: BorderRadius.circular(20),
                            //         elevation: 20,
                            //         alignment: AlignmentDirectional.center,
                            //         isExpanded: true,
                            //         autofocus: true,
                            //         dropdownColor:
                            //             const Color.fromARGB(255, 152, 152, 151),
                            //         iconEnabledColor: Colors.blue,
                            //         focusColor: Color.fromARGB(255, 173, 127, 8),
                            //         style: TextStyle(
                            //             color: Color.fromARGB(255, 15, 58, 118),
                            //             fontWeight: FontWeight.bold,
                            //             fontSize: 20),
                            //         value: selectedItem,
                            //         onChanged: (String? newValue) {
                            //           Get.dialog(ConfirmationDialog(
                            //               isYes: true,
                            //               onYesPressed: () async {
                            //                 print(
                            //                     "----------------------  ---------------------");
                            //                 FirebaseFirestore.instance
                            //                     .collection("users")
                            //                     .doc(custtomerModel.id)
                            //                     .update({
                            //                   "type": selectedItem
                            //                 }).then((value) {});
                            //                 showCustomSnackBar(
                            //                     "تم التعديل بنجاح");
                            //                 Get.back();
                            //               },
                            //               onNoPressed: () => Get.back(),
                            //               title: "تحذير !",
                            //               icon: 'assets/image/support.png',
                            //               description:
                            //                   (" هل انت متاكد من تغير صلاحيات العميل الحالي ؟")));

                            //           setState(() {
                            //             selectedItem = newValue!;
                            //           });
                            //         },
                            //         items: <String>[
                            //           'موصل',
                            //           'مدير',
                            //           'عميل',
                            //         ].map<DropdownMenuItem<String>>(
                            //             (String value) {
                            //           return DropdownMenuItem<String>(
                            //             value: value,
                            //             child: Text(value),
                            //           );
                            //         }).toList(),
                            //       )),
                            //     ],
                            //   )
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

  void deleteOrdersByDeliveryPerson(String deliveryPersonId) async {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('orders');
    final QuerySnapshot querySnapshot =
        await collection.where('d_id', isEqualTo: deliveryPersonId).get();

    querySnapshot.docs.forEach((doc) {
      collection.doc(doc.id).delete();
    });
  }
}
