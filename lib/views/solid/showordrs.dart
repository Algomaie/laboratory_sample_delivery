import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alpha/controller/auth_controller.dart';
import 'package:alpha/utiles/preference.dart';
import 'package:alpha/views/home/home_screen.dart';
import 'package:alpha/widgets/custom_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Orders extends StatefulWidget {
  static const routeName = 'orders';

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Preference sharePref = Preference.shared;
  bool f = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.3,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "الطلبات",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("orders").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          try {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot data = snapshot.data!.docs[index];
                if (data["pickup_time"] != "" && data["date_requested"] != "") {
                  String customerId = data["customer_id"];
                  String deliverId = data["d_id"];

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('Customers')
                        .doc(customerId)
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> customerSnapshot) {
                      if (customerSnapshot.hasError) {
                        return Text("Error: ${customerSnapshot.error}");
                      }

                      if (customerSnapshot.connectionState ==
                          ConnectionState.done) {
                        String customerName = customerSnapshot.data!["dname"];

                        return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('Delivers')
                                .doc(deliverId)
                                .get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot>
                                    deliverSnapshot) {
                              if (deliverSnapshot.hasError) {
                                return Text("Error: ${deliverSnapshot.error}");
                              }

                              if (deliverSnapshot.connectionState ==
                                  ConnectionState.done) {
                                String deliverName =
                                    deliverSnapshot.data!["dname"];

                                return Card(
                                  color: Color.fromARGB(255, 229, 229, 233),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        color: Colors.black, width: 2),
                                  ),
                                  elevation: 4,
                                  margin: EdgeInsets.all(10),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          tileColor: Color.fromARGB(
                                              255, 196, 182, 220),
                                          title: Text(
                                            "اسم الموصل :${deliverSnapshot.data!["dname"]}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                        ListTile(
                                          tileColor: Colors.grey[300],
                                          title: Text(
                                            "اسم العميل :${customerSnapshot.data!["dname"]}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          tileColor:
                                              Color.fromARGB(255, 68, 118, 154),
                                          title: Text(
                                            "زمن طلب موصل:   ${DateFormat('yyyy-MM-dd\n الوقت : hh:mm:ss').format(data["date_requested"].toDate())} ${(DateFormat('a').format(data["date_requested"].toDate()) == 'AM') ? 'صباحًا' : 'مساءً'}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          tileColor: Colors.grey[300],
                                          title: Text(
                                            "تاريخ اخذ العينة:  ${DateFormat('yyyy-MM-dd\n الوقت : hh:mm:ss').format(data["pickup_time"].toDate())} ${(DateFormat('a').format(data["date_requested"].toDate()) == 'AM') ? 'صباحًا' : 'مساءً'}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: ElevatedButton(
                                              child: Text("تم إستلام العينة"),
                                              onPressed: data["receivedTime"] !=
                                                      ""
                                                  ? null
                                                  : () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("orders")
                                                          .doc(data["order_id"])
                                                          .update({
                                                        "receivedTime": FieldValue
                                                            .serverTimestamp(),
                                                      }).then((value) async {
                                                        AuthController.sendPushMessage(
                                                            "${customerSnapshot.data!["token"]}",
                                                            "عزيزي العميل / تم إيصال عينتك الى مختبرات ألفا\nالساعة:${DateFormat(' hh:mm:ss ').format(data["pickup_time"].toDate())} ${(DateFormat('a').format(data["date_requested"].toDate()) == 'AM') ? 'صباحًا' : 'مساءً'}\n  شاكرين تعاملكم وثقتكم بنا",
                                                            "إشعار وصول العينة");
                                                        showCustomSnackBar(
                                                            "تم استلام  الطلب بنجاح");
                                                      });
                                                    }),
                                        ),
                                        ListTile(
                                          title: ElevatedButton(
                                              child: Text("عرض تقرير العينة"),
                                              onPressed:
                                                  data["receivedTime"] == ""
                                                      ? null
                                                      : () async {
                                                          showreport(
                                                              data["order_id"],
                                                              deliverName,
                                                              customerName,
                                                              phone:
                                                                  customerSnapshot
                                                                          .data![
                                                                      "phone"]);
                                                        }),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              return CircularProgressIndicator(
                                strokeWidth: 0,
                                strokeCap: StrokeCap.round,
                                semanticsLabel: "",
                                color: Colors.white,
                                semanticsValue: "",
                              );
                            });
                      }

                      return CircularProgressIndicator(
                        strokeWidth: 0,
                        strokeCap: StrokeCap.round,
                        semanticsLabel: "",
                        color: Colors.white,
                        semanticsValue: "",
                      );
                    },
                  );
                }
              },
            );
          } catch (e) {}
          return Text("Error: ${snapshot.error}");
        },
      ),
    );
  }

  void showreport(String id, dname, cname, {phone}) async {
    final CollectionReference collection =
        await FirebaseFirestore.instance.collection('orders');
    final QuerySnapshot querySnapshot =
        await collection.where('order_id', isEqualTo: id).get();
    DocumentSnapshot document = querySnapshot.docs.first;
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    print("----------------------  ---------------------");
    Timestamp dateRequestedTimestamp = data["date_requested"] as Timestamp;
    Timestamp pickupTimeTimestamp = data["pickup_time"] as Timestamp;
    Timestamp receivedTimeTimeTimestamp = data["receivedTime"] as Timestamp;
// تحويل timestamps إلى DateTime
    DateTime dateRequested = dateRequestedTimestamp.toDate();
    DateTime pickupTime = pickupTimeTimestamp.toDate();
    DateTime receivedTime = receivedTimeTimeTimestamp.toDate();

// حساب الفرق
    final elapsedTime = pickupTime.difference(dateRequested);
    final receivedtime = receivedTime.difference(pickupTime);

// تحويل صيغة الساعة
    final df = DateFormat("dd/MM/yyyy hh:mm a");
    final formattedRequestTime = df.format(dateRequested);
    final formattedArrivalTime = df.format(pickupTime);
    final receivedArrivalTime = df.format(receivedTime);
    showDialog(
        useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              scrollable: true,
              title: ListTile(
                shape: BeveledRectangleBorder(side: BorderSide(width: 1)),
                trailing: CircleAvatar(
                    backgroundImage: AssetImage("assets/image/logo_icon.png")),
                leading: CircleAvatar(child: Text("ألفا")),
                tileColor: Colors.grey[300],
                title: Text(
                  overflow: TextOverflow.clip,
                  "تقرير العينة",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              content: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      tileColor: Colors.grey[300],
                      title: Text(
                        overflow: TextOverflow.clip,
                        "اسم العميل :\n $cname",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    ListTile(
                      tileColor: Colors.grey[300],
                      title: Text(
                        overflow: TextOverflow.clip,
                        "اسم المٌوصل :\n  ${dname}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    ListTile(
                      tileColor: Colors.grey[300],
                      title: Text(
                        "زمن طلب المُوصل  :\n$formattedRequestTime",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    ListTile(
                      tileColor: Colors.grey[300],
                      title: Text(
                        "زمن اخذ العينة :\n$formattedArrivalTime ",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    ListTile(
                      tileColor: Colors.grey[300],
                      title: Text(
                        "الزمن الكلي من طلب \nالموصل الى الوصول: ${formatDifference(elapsedTime)}",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    ListTile(
                      tileColor: Colors.grey[300],
                      title: Text(
                        "الزمن الكلي من اخذ العينة\n الى وصولها: ${formatDifference(receivedtime)}",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context).shadowColor),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(5)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context).primaryColor),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: BorderSide(color: Colors.white)))),
                            onPressed: () {
                              _openSocialMedia(
                                  'https://api.whatsapp.com/send?phone=+${775346074}&text=${Uri.encodeComponent(
                                "الزمن الكلي من طلب \nالموصل الى الوصول الى العميل: ${formatDifference(elapsedTime)}\n الزمن الكلي من اخذ العينة\n  الى وصولها الى المختبر: ${formatDifference(receivedtime)}",
                              )}');
                            },
                            child: Text("مشاركة")),
                        ElevatedButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context).shadowColor),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(5)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context).primaryColor),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: BorderSide(color: Colors.white)))),
                            onPressed: () => Get.back(),
                            child: Text("خــروج")),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }

  void _openSocialMedia(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String formatDifference(Duration difference) {
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    return "$hours ساعة:$minutes دقيقة:$seconds ثانية";
  }
}
