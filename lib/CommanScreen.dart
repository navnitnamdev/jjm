import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaljeevanmissiondynamic/utility/Appcolor.dart';
import 'package:jaljeevanmissiondynamic/view/Dashboard.dart';
import 'package:jaljeevanmissiondynamic/view/VillageDetails.dart';

import 'Selectedvillagelist.dart';

class NewScreenPoints extends StatelessWidget {
  int no;
  String villageId;
  var villageName;

  NewScreenPoints(
      {required this.no, required this.villageId, required this.villageName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScreenPoints(no: no, villageId: villageId, villageName: villageName),
        PointsAndLines(
          numberOfPoints: no,
          villageId: villageId,
          villageName: villageName,
        )
      ],
    );
  }
}

class ScreenPoints extends StatelessWidget {
  var no;
  String villageId;
  var villageName;

  ScreenPoints(
      {required this.no, required this.villageId, required this.villageName});

  final int numberOfPoints = 2;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12,
          ),
          child: Text(
            buildText(),
            style: TextStyle(
              color: Appcolor.btncolor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }

  String buildText() {
    String screen = "Screen:- ";
    return screen;
  }
}

class PointsAndLines extends StatelessWidget {
  int numberOfPoints = 4;
  GetStorage box = GetStorage();
  var str = ['1', '2', '3', '4', '5'];
  String villageId;
  var villageName;

  PointsAndLines(
      {required this.numberOfPoints,
      required this.villageId,
      required this.villageName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.only(left: 10),
      child: Row(
        children: _buildPointsAndLines(),
      ),
    );
  }

  List<Widget> _buildPointsAndLines() {
    List<Widget> widgets = [];
    for (int i = 1; i <= numberOfPoints; i++) {
      if (i == numberOfPoints)
        widgets.add(_buildPoint(i.toString(), true));
      else
        widgets.add(_buildPoint(i.toString(), false));

      if (i <= numberOfPoints - 1) {
        widgets.add(_buildLine());
      }
    }

    return widgets;
  }

  Widget _buildPoint(String title, bool done) {
    return GestureDetector(
      onTap: () {
        if (title == "1") {
          Get.offAll(Dashboard(
              stateid: box.read("stateid").toString(),
              userid: box.read("userid").toString(),
              usertoken: box.read("UserToken").toString()));
        }
        if (title == "2") {
          Get.to(Selectedvillaglist(
              stateId: box.read("stateid").toString(),
              userId: box.read("userid").toString(),
              usertoken: box.read("UserToken").toString()));
        }
        if (title == "3") {
          Get.to(VillageDetails(
              villageid: villageId,
              villagename: villageName,
              stateid: box.read("stateid").toString(),
              userID: box.read("userid").toString(),
              token: box.read("UserToken").toString()));
        }
        if (title == "4") {
          Get.back();
        }
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: done == true ? Appcolor.btncolor : Colors.grey,
        ),
        child: Center(
            child: Text(
          title,
          style: TextStyle(color: Colors.white),
        )),
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      width: 20,
      height: 2,
      color: Colors.black,
    );
  }
}
