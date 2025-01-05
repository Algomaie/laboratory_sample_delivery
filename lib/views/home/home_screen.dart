import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:alpha/utiles/app_constants.dart';
import 'package:alpha/utiles/preference.dart';
import 'package:alpha/utiles/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class HomeScreen extends StatefulWidget {
  final String? username;
  const HomeScreen({Key? key, this.username}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Preference sharePref = Preference.shared;
  String? userId;
  String _username = '';

  @override
  initState() {
    getLogin();
    super.initState();
  }

  getLogin() async {
    userId = sharePref.getString(AppConstants.USER_ID) ?? "";
    _username = widget.username == 'null'
        ? sharePref.getString(AppConstants.USER_NAME) ?? ''
        : (widget.username ?? '');
    debugPrint('userID===>${userId.toString()}');
    String isLogin = sharePref.getString(AppConstants.IS_LOGIN) ?? "0";
    debugPrint('===>$isLogin');

    if (userId != "" || userId != "0") {}
  }

  @override
  Widget build(BuildContext context) {
    print(widget.username);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 310,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/dash_bg.png"),
                fit: BoxFit.cover,
              ),
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.elliptical(50.0, 50.0)),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [getAppbar(), buildBody()],
            ),
          ),
        ],
      ),
    );
  }

  getAppbar() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsetsDirectional.only(start: 8.0),
        child: Image.asset(
          Resources.logo_icon,
          width: 60,
          height: 60,
        ),
      ),
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        Visibility(
          visible: (sharePref.getBool(AppConstants.isVerfied) == true &&
                  sharePref.getString(AppConstants.USER_ID) ==
                      "4SJIexwgWAhARbAXgGOdOcrUesv2")
              ? true
              : false,
          child: InkWell(
            onTap: () async {
              Get.toNamed(RouteHelper.getadminhometRoute());
            },
            child: const Padding(
              padding: EdgeInsetsDirectional.only(top: 10, bottom: 8, end: 0),
              child: CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(
                    'assets/image/avatar.jpg',
                  )),
            ),
          ),
        )
      ],
    );
  }

  buildBody() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 19,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 5),
            child: Text("Welcome_Back".tr,
                style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 5),
            child: Row(
              children: [
                Text(
                  _username,
                  style: GoogleFonts.cairo(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                const SizedBox(
                  width: 3,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          getDashboard(),
          const SizedBox(
            height: 10,
          ),
        ]),
      ),
    );
  }

  getDashboard() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              width: 5,
            ),
            cartWidget(
                title: "طلب موصل",
                subTitle: " اتصل نصل".tr,
                bgImage: 'bg11.jpg',
                onTap: () {
                  if (sharePref.getString(AppConstants.type) == "عميل" ||
                      sharePref.getString(AppConstants.type) == "مدير") {
                    Get.toNamed(RouteHelper.getdreviers());
                  } else {
                    // Get.toNamed(RouteHelper.getHomeScreenRoute());
                  }
                }),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              width: 5,
            ),
            cartWidget(
                title: "عرض طلباتي",
                subTitle: "ألفا الاسرع".tr,
                bgImage: 'bg11.jpg',
                onTap: () async {
                  if (sharePref.getString(AppConstants.type) == "عميل") {
                    Get.toNamed(RouteHelper.getOrdersScreenRoute());
                  }
                })
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget cartWidget({onTap, title, subTitle, bgImage}) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: MediaQuery.of(context).size.height * 0.2,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              repeat: ImageRepeat.repeatX,
              image: AssetImage("assets/image/$bgImage"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              )),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title,
                        style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600)),
                    Text(subTitle,
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 18,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
