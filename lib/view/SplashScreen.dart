import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaljeevanmissiondynamic/view/Dashboard.dart';
import 'package:jaljeevanmissiondynamic/view/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isoffline = false;
  GetStorage box = GetStorage();

  @override
  void initState() {
    Timer(Duration(seconds: 2), () {


      if (box.read("UserToken").toString() == "null") {
        Get.off(LoginScreen());
      } else {
        Get.offAll(Dashboard(
            stateid: box.read("stateid"),
            userid: box.read("userid"),
            usertoken: box.read("UserToken")));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white, child: Image.asset("images/jjm_splash.jpg"));
  }
}
