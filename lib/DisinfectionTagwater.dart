import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jaljeevanmissiondynamic/model/Adddisinfectionhouseholdmodal.dart';
import 'package:jaljeevanmissiondynamic/view/firstnumerical.dart';
import 'package:permission_handler/permission_handler.dart';

import 'CommanScreen.dart';
import 'Selectedvillagelist.dart';
import 'database/DataBaseHelperJalJeevan.dart';
import 'model/Habitationlistmodal.dart';
import 'model/Schememodal.dart';
import 'utility/Appcolor.dart';
import 'utility/Stylefile.dart';
import 'utility/Textfile.dart';
import 'view/Dashboard.dart';
import 'view/LoginScreen.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class PointsAndLines extends StatelessWidget {
  final int numberOfPoints = 4;
  GetStorage box = GetStorage();
  var str = ['1', '2', '3', '4'];

  PointsAndLines({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: _buildPointsAndLines(),
      ),
    );
  }

  List<Widget> _buildPointsAndLines() {
    List<Widget> widgets = [];
    for (int i = 0; i < numberOfPoints; i++) {
      widgets.add(_buildPoint(str[i]));
      if (i < numberOfPoints - 1) {
        widgets.add(_buildLine());
      }
    }
    return widgets;
  }

  Widget _buildPoint(String title) {
    return GestureDetector(
      onTap: () {
        if (title == "1") {
          Get.offAll(Dashboard(
            stateid: box.read("stateid").toString(),
            userid: box.read("userid").toString(),
            usertoken: box.read("UserToken").toString(),
          ));
        }
        if (title == "2") {
          Get.to(Selectedvillaglist(
              stateId: box.read("stateid").toString(),
              userId: box.read("userid").toString(),
              usertoken: box.read("UserToken").toString()));
        }
        if (title == "3") Get.back();
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: title == "4" ? Colors.blue : Colors.grey,
        ),
        child: Center(
            child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        )),
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      width: 12,
      height: 2,
      color: Colors.black,
    );
  }
}

class DisinfectionTagwater extends StatefulWidget {
  var villageid = "";
  var villagename = "";
  var stateid = "";
  var userID;
  var token;

  DisinfectionTagwater(
      {required this.villageid,
      required this.villagename,
      required this.stateid,
      required this.userID,
      required this.token,
      Key? key});

  @override
  State<DisinfectionTagwater> createState() => _DisinfectionTagwaterState();
}

class _DisinfectionTagwaterState extends State<DisinfectionTagwater> {
  TextEditingController locationlandmarkcontroller = TextEditingController();
  final List<TextEditingController> namecontroller = [TextEditingController()];
  final List<TextEditingController> fathernamecontroller = [];
  final List<TextEditingController> addresscontroller = [];
  List<String> nameinputs = List.generate(4, (index) => "");
  List<String> fatherinputs = List.generate(4, (index) => "");
  List<String> addressinputs = List.generate(4, (index) => "");

  var increasehousehold;

  var getclickedstatus;
  var Othersmain;
  var Othersmethodbasedvalue;
  bool locationprogress = false;
  bool visiblebtnadd = false;
  Position? _currentPosition;
  var locationdisinfectradio;
  var accuracyofgetlocation;
  String imagepath = "";
  File? imgFile;
  final imgPicker = ImagePicker();
  var latitude;
  var longitude;

  String newCategory = "";
  String newschameid = "";
  String newschemename = "";
  String messageofscheme_mvs = "";
  late Schememodal schememodal;
  Schememodal? initialSchememodal;
  String _mySchemeid = "-- Select Scheme --";
  List<Schememodal> schemelist = [];
  String selectschamename = "";
  String selectcategoryname = "";
  List<String> _schemeDropdownItems = [];
  DatabaseHelperJalJeevan? databaseHelperJalJeevan;
  GetStorage box = GetStorage();
  List<Habitaionlistmodal> habitationlist = [];
  late Habitaionlistmodal habitaionlistmodal;
  var selecthabitaionid;
  var selecthabitaionname = "-- Select Habitation --";
  List<String> _habitaiondropdownitem = [];
  String _selectedhabitaion = '--Select Habitaion--';

  String dropdownvalue = '--Select chlorine reagent--';
  List<int> imageBytes = [];
  String base64Image = "";
  late Adddisinfectionhouseholdmodal adddisinfectionhouseholdmodal;
  List<int> Adddisinfectionconatiner = [];
  List<Adddisinfectionhouseholdmodal> adddisinfectionhouseholdlist = [];

  bool viewVisible = true;
  bool assetvisibility = false;
  bool existreservselectschemevisible = false;
  bool methoddisinfectvisible = false;

  bool chlorinebasedvisibility = false;

  bool habitaionvisibility = false;
  bool Geotagdisinfectvisible = false;
  bool Clickimagevisibile = false;
  bool othermethodbasedvisibility = false;
  var methoddisinfectvalue;
  bool locationdis = true;

  bool chlrinationreagentdropdownvisible = true;
  bool householdlistvisibility = true;
  bool locationdisvisibility = true;
  bool Selectexistingreservoirvisibility = true;

  // List of items in our dropdown menu
  var items = [
    '--Select chlorine reagent--',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  @override
  void dispose() {
    for (var controller in namecontroller) {
      controller.dispose();
    }
    for (var controller in fathernamecontroller) {
      controller.dispose();
    }
    for (var controller in addresscontroller) {
      controller.dispose();
    }

    super.dispose();
  }

  Future<void> cleartable_localmasterschemelisttable() async {
    await databaseHelperJalJeevan!.cleardb_localmasterschemelist();
    await databaseHelperJalJeevan!.cleartable_villagelist();
    await databaseHelperJalJeevan!.cleartable_villagedetails();
    await databaseHelperJalJeevan!.cleardb_sourcetypecategorytable();
    await databaseHelperJalJeevan!.cleardb_sourcassettypetable();
    await databaseHelperJalJeevan!.cleardb_localhabitaionlisttable();
    await databaseHelperJalJeevan!.cleardb_sourcedetailstable();
    await databaseHelperJalJeevan!.truncatetable_dashboardtable();
    await databaseHelperJalJeevan!.cleardb_sibmasterlist();
  }

  Future<void> _fetchSchemeDropdownItems(String villageId) async {
    List<Map<String, dynamic>>? distinctSchemes = await databaseHelperJalJeevan!
        .getAllRecordsForschemelist(villageId.toString());

    distinctSchemes.map((map) => map['Schemename'].toString());

    schemelist.clear();
    schemelist.add(schememodal);
    for (int i = 0; i < distinctSchemes.length; i++) {
      newschameid = distinctSchemes[i]["SchemeId"].toString();
      newschemename = distinctSchemes[i]["Schemename"].toString();
      newCategory = distinctSchemes[i]["Category"].toString();

      schemelist.add(Schememodal(newschameid, newschemename, newCategory));
    }

    setState(() {
      _schemeDropdownItems = [
        '-- Select Scheme --',
        ...distinctSchemes.map((map) => map['Schemename'].toString())
      ];
    });
  }

  void resetDropdownState() {
    setState(() {
      schemelist.clear();
      schememodal = schemelist.isNotEmpty
          ? schemelist[0]
          : Schememodal("-- Select id  --", "-- Select Scheme --", "");

      assetvisibility = false;
      methoddisinfectvisible = false;
      existreservselectschemevisible = false;
      chlorinebasedvisibility = false;
      chlrinationreagentdropdownvisible = false;
      householdlistvisibility = false;
      locationdisvisibility = false;

      habitaionvisibility = false;
      Geotagdisinfectvisible = false;
      Clickimagevisibile = false;

      Selectexistingreservoirvisibility = false;
    });
  }

  Future<void> _fetchhabitaiondropdownDropdownItems(String villageId) async {
    List<Map<String, dynamic>>? distinctSchemes =
        await databaseHelperJalJeevan!.getDistinctHabitaion(villageId);
    habitationlist.clear();
    habitationlist.add(habitaionlistmodal);
    for (int i = 0; i < distinctSchemes!.length; i++) {
      var habitaionid = distinctSchemes[i]["HabitationId"].toString();
      var habitaionname = distinctSchemes[i]["HabitationName"].toString();

      habitationlist.add(Habitaionlistmodal(habitaionname, habitaionid));
    }

    setState(() {
      _habitaiondropdownitem = [
        '-- Select Habitaion --',
        ...distinctSchemes.map((map) => map['HabitationName'].toString())
      ];
      _selectedhabitaion = _habitaiondropdownitem.first;
    });
  }

  Future<bool> checkLocationPermission() async {
    PermissionStatus permission = await Permission.location.status;
    if (permission != PermissionStatus.granted) {
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition(BuildContext context) async {
    setState(() {
      locationprogress = true;
    });

    bool hasPermission = await checkLocationPermission();

    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enable location permission in settings"),
          action: SnackBarAction(
            label: 'SETTINGS',
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
      );
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      accuracyofgetlocation = position.accuracy;

      locationprogress = false;
      setState(() {
        _currentPosition = position;

        latitude = _currentPosition?.latitude.toString();
        longitude = _currentPosition?.longitude.toString();
      });
    } catch (e) {
      debugPrintStack();
    }
  }

  void openCamera() async {
    try {
      final imgCamera = await imgPicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100, // Highest quality to start with
      );

      if (imgCamera == null) return;

      final bytes = await imgCamera.readAsBytes();
      final kb = bytes.length / 1024;
      final mb = kb / 1024;

      if (kDebugMode) {
        print('Original image size: ${mb.toStringAsFixed(2)} MB');
      }

      final dir = await path_provider.getTemporaryDirectory();
      final targetPath =
          '${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Compress the image
      final result = await FlutterImageCompress.compressAndGetFile(
        imgCamera.path,
        targetPath,
        minWidth: 1080,
        minHeight: 1080,
        quality: 90, // Adjust this value if needed
      );

      if (result != null) {
        final data = await result.readAsBytes();
        final newKb = data.length / 1024;
        final newMb = newKb / 1024;

        if (kDebugMode) {
          print('Compressed image size: ${newMb.toStringAsFixed(2)} MB');
        }

        setState(() {
          imgFile = File(result.path);
          imageBytes = imgFile!.readAsBytesSync();
          base64Image = base64Encode(imageBytes);
        });
      } else {
        throw Exception("Image compression failed");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /* setState(() {
      selectschamename = schemelist[0].toString();
    });*/

    habitaionvisibility = true;
    Geotagdisinfectvisible = true;
    habitaionlistmodal = Habitaionlistmodal(
        "-- Select Habitation --", "-- Select Habitation --");
    setState(() {
      increasehousehold = 1;
      Adddisinfectionconatiner.add(increasehousehold);
    });

    adddisinfectionhouseholdmodal = Adddisinfectionhouseholdmodal("", "", "");
    // adddisinfectionhouseholdlist.add(Adddisinfectionhouseholdmodal("dsa", "sd", "ds"));
    schememodal = Schememodal(
        "-- Select Scheme --", "-- Select Scheme --", "-- Select Scheme --");
    databaseHelperJalJeevan = DatabaseHelperJalJeevan();
    initialSchememodal = schemelist.isNotEmpty ? schemelist[0] : null;

    _fetchhabitaiondropdownDropdownItems(widget.villageid.toString());
    _fetchSchemeDropdownItems(widget.villageid);
    _getCurrentPosition(context);
    resetDropdownState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: const Color(0xFF0D3A98),
          iconTheme: const IconThemeData(
            color: Appcolor.white,
          ),
          title: const Text("Disinfection system details",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          actions: <Widget>[],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/header_bg.png'), fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'images/bharat.png',
                        width: 60,
                        height: 60,
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(Textfile.headingjaljeevan,
                              textAlign: TextAlign.justify,
                              style: Stylefile.mainheadingstyle),
                          SizedBox(
                            child: Text(Textfile.subheadingjaljeevan,
                                textAlign: TextAlign.justify,
                                style: Stylefile.submainheadingstyle),
                          ),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Appcolor.white,
                            titlePadding: const EdgeInsets.only(
                                top: 0, left: 0, right: 00),
                            buttonPadding: const EdgeInsets.all(10),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  5.0,
                                ),
                              ),
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            title: Container(
                              color: Appcolor.red,
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Jal jeevan mission",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Appcolor.white),
                                  ),
                                ),
                              ),
                            ),
                            content: const SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Are you sure want to sign out from this application ?",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Appcolor.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              Container(
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Appcolor.red,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextButton(
                                  child: const Text(
                                    'No',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Appcolor.black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Appcolor.red,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextButton(
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Appcolor.black),
                                  ),
                                  onPressed: () async {
                                    box.remove("UserToken");
                                    box.remove('loginBool');
                                    cleartable_localmasterschemelisttable();
                                    Get.offAll(LoginScreen());
                                    Stylefile.showmessageapisuccess(
                                        context, "Sign out successfully");
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: const Icon(
                        Icons.logout,
                        size: 35,
                        color: Appcolor.btncolor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              NewScreenPoints(
                villageName: widget.villagename,
                villageId: widget.villageid,
                no: 4,
              ),
              Row(
                children: [
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Village :",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Appcolor.headingcolor),
                        ),
                      )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          widget.villagename,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Appcolor.headingcolor),
                        ),
                      )),
                ],
              ),
              Visibility(
                visible: viewVisible,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Appcolor.white,
                          border: Border.all(
                            color: Appcolor.lightgrey,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              10.0,
                            ),
                          ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Material(
                              borderRadius: BorderRadius.circular(10.0),
                              child: InkWell(
                                splashColor: Appcolor.splashcolor,
                                onTap: () {},
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Select Scheme",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                    const Divider(
                                      height: 10,
                                      color: Appcolor.lightgrey,
                                      thickness: 1,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 70,
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      margin: const EdgeInsets.only(
                                          bottom: 10.0, right: 10, left: 10),
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                              color: Appcolor.lightgrey,
                                              width: .5),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: DropdownButton<Schememodal>(
                                          itemHeight: 100,
                                          alignment: Alignment.center,
                                          elevation: 10,
                                          dropdownColor: Appcolor.white,
                                          underline: const SizedBox(),
                                          isExpanded: true,
                                          hint: const Text(
                                            "-- Select Scheme --",
                                          ),
                                          value: schememodal,
                                          items: schemelist.map((concernnames) {
                                            return DropdownMenuItem<
                                                Schememodal>(
                                              value: concernnames,
                                              child: Container(
                                                width: double.infinity,
                                                alignment: Alignment.centerLeft,
                                                decoration: const BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey,
                                                            width: 1))),
                                                child: Text(
                                                  concernnames.Schemename,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Appcolor.black),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (Schememodal? newValue) {
                                            setState(() {
                                              schememodal = newValue!;
                                              _mySchemeid =
                                                  newValue.Schemeid.toString();
                                              selectschamename =
                                                  newValue.Schemename;
                                              selectcategoryname =
                                                  newValue.Category.toString();
                                            });

                                            if (newValue!.Schemename ==
                                                "-- Select Scheme --") {
                                              setState(() {
                                                assetvisibility = false;
                                                methoddisinfectvisible = false;
                                                existreservselectschemevisible =
                                                    false;
                                                chlorinebasedvisibility = false;
                                                chlrinationreagentdropdownvisible =
                                                    false;
                                                householdlistvisibility = false;
                                                locationdisvisibility = false;

                                                habitaionvisibility = false;
                                                Geotagdisinfectvisible = false;
                                                Clickimagevisibile = false;

                                                Selectexistingreservoirvisibility =
                                                    false;
                                              });
                                            } else {
                                              /*
                                                   methoddisinfectvisible=false;
                                                   existreservselectschemevisible=false;

                                                   chlrinationreagentdropdownvisible=false;
                                                   householdlistvisibility=false;
                                                   locationdisvisibility=false;

                                                   habitaionvisibility=false;
                                                   Geotagdisinfectvisible=false;
                                                   Clickimagevisibile=false;
                                          */
                                              setState(() {
                                                assetvisibility = true;
                                                methoddisinfectvisible = true;
                                                existreservselectschemevisible =
                                                    false;
                                                //  Selectexistingreservoirvisibility=true;
                                              });
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: assetvisibility,
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Appcolor.white,
                    border: Border.all(
                      color: Appcolor.lightgrey,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        10.0,
                      ),
                    ),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    child: InkWell(
                        splashColor: Appcolor.splashcolor,
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Already tagged Selected scheme : ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Divider(
                              height: 10,
                              color: Appcolor.lightgrey,
                              thickness: 1,
                            ),
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text: "Assets location/landmark:",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Appcolor.btncolor),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: "Test Data",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: Appcolor.btncolor)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    height: 10,
                                    color: Appcolor.lightgrey,
                                    thickness: 1,
                                  ),
                                  Column(
                                    children: [
                                      ListView.builder(
                                          itemCount: 2,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, int index) {
                                            return Card(
                                              surfaceTintColor: Colors.white,
                                              elevation: 5,
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Appcolor.splashcolor,
                                                  onTap: () {},
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      bottom: 5,
                                                                      top: 5),
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                maxLines: 5,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                "Type of chlorination :",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14,
                                                                    color: Appcolor
                                                                        .black),
                                                              )),
                                                          Flexible(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      bottom: 5,
                                                                      top: 5),
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                maxLines: 5,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                "Electro chlorination safdsfdffasd",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        14,
                                                                    color: Appcolor
                                                                        .black),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      bottom: 5,
                                                                      top: 5),
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                maxLines: 5,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                "chlorination reagent :",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14,
                                                                    color: Appcolor
                                                                        .black),
                                                              )),
                                                          Flexible(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      bottom: 5,
                                                                      top: 5),
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                maxLines: 5,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                "Chlorine gas",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        14,
                                                                    color: Appcolor
                                                                        .black),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Flexible(
                                                            child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10,
                                                                        bottom:
                                                                            5,
                                                                        top: 5),
                                                                child: Text(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  maxLines: 5,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  "Habitation :",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14,
                                                                      color: Appcolor
                                                                          .black),
                                                                )),
                                                          ),
                                                          Flexible(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      bottom: 5,
                                                                      top: 5),
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                maxLines: 5,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                "64 MILE CAMP",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        14,
                                                                    color: Appcolor
                                                                        .black),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      bottom: 5,
                                                                      top: 5),
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                maxLines: 5,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                "Latitude :",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14,
                                                                    color: Appcolor
                                                                        .black),
                                                              )),
                                                          Flexible(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      bottom: 5,
                                                                      top: 5),
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                maxLines: 5,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                "28.5900519",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        14,
                                                                    color: Appcolor
                                                                        .black),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      bottom: 5,
                                                                      top: 5),
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                maxLines: 5,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                "Longitude :",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14,
                                                                    color: Appcolor
                                                                        .black),
                                                              )),
                                                          Flexible(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      bottom: 5,
                                                                      top: 5),
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                maxLines: 5,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                "77.2290081",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        14,
                                                                    color: Appcolor
                                                                        .black),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          height: 25,
                                                          child: ElevatedButton
                                                              .icon(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Appcolor.pink,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              //_showAlertDialogforuntaggeoloc(localsibpendinglist[index].id.toString(), index);
                                                            },
                                                            icon: const Icon(
                                                              size: 18.0,
                                                              Icons
                                                                  .delete_outline_outlined,
                                                              color: Appcolor
                                                                  .white,
                                                            ),
                                                            label: const Text(
                                                              "Remove",
                                                              style: TextStyle(
                                                                  color: Appcolor
                                                                      .white,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                ),
              ),
              Visibility(
                visible: methoddisinfectvisible,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Appcolor.white,
                        border: Border.all(
                          color: Appcolor.lightgrey,
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            10.0,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Method of disinfection',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          const Divider(
                            height: 10,
                            color: Appcolor.lightgrey,
                            thickness: 1,
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Appcolor.lightgrey),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RadioListTile(
                                  visualDensity: const VisualDensity(
                                      horizontal: VisualDensity.minimumDensity,
                                      vertical: VisualDensity.minimumDensity),
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text("Chlorine based"),
                                  value: "1",
                                  groupValue: methoddisinfectvalue,
                                  onChanged: (value) {
                                    setState(() {
                                      methoddisinfectvalue = value.toString();
                                      chlorinebasedvisibility = true;
                                      othermethodbasedvisibility = false;

                                      existreservselectschemevisible = false;
                                      householdlistvisibility = false;
                                      locationdisvisibility = false;
                                      chlrinationreagentdropdownvisible = false;
                                      Clickimagevisibile = false;
                                    });
                                  },
                                ),
                                RadioListTile(
                                  visualDensity: const VisualDensity(
                                      horizontal: VisualDensity.minimumDensity,
                                      vertical: VisualDensity.minimumDensity),
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text("Other"),
                                  value: "2",
                                  groupValue: methoddisinfectvalue,
                                  onChanged: (value) {
                                    setState(() {
                                      methoddisinfectvalue = value.toString();
                                      print("ffff" + methoddisinfectvalue);
                                      chlorinebasedvisibility = false;
                                      othermethodbasedvisibility = true;
                                      existreservselectschemevisible = false;
                                      householdlistvisibility = false;
                                      locationdisvisibility = false;
                                      chlrinationreagentdropdownvisible = false;
                                      Clickimagevisibile = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: chlorinebasedvisibility,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Appcolor.white,
                        border: Border.all(
                          color: Appcolor.lightgrey,
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            10.0,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Type of chlorination',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          const Divider(
                            height: 10,
                            color: Appcolor.lightgrey,
                            thickness: 1,
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Appcolor.lightgrey),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RadioListTile(
                                  visualDensity: const VisualDensity(
                                      horizontal: VisualDensity.minimumDensity,
                                      vertical: VisualDensity.minimumDensity),
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text("Electro chlorination"),
                                  value: "1",
                                  groupValue: Othersmain,
                                  onChanged: (value) {
                                    setState(() {
                                      Othersmain = value.toString();
                                      print("type_of_chlo" + Othersmain);

                                      chlrinationreagentdropdownvisible = true;
                                      householdlistvisibility = true;
                                      locationdisvisibility = true;
                                    });
                                  },
                                ),
                                RadioListTile(
                                  visualDensity: const VisualDensity(
                                      horizontal: VisualDensity.minimumDensity,
                                      vertical: VisualDensity.minimumDensity),
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text("Gas chlorination"),
                                  value: "2",
                                  groupValue: Othersmain,
                                  onChanged: (value) {
                                    setState(() {
                                      Othersmain = value.toString();
                                      chlrinationreagentdropdownvisible = true;
                                      householdlistvisibility = true;
                                      locationdisvisibility = true;
                                    });
                                  },
                                ),
                                RadioListTile(
                                  visualDensity: const VisualDensity(
                                      horizontal: VisualDensity.minimumDensity,
                                      vertical: VisualDensity.minimumDensity),
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text("Liquid chlorination"),
                                  value: "3",
                                  groupValue: Othersmain,
                                  onChanged: (value) {
                                    setState(() {
                                      Othersmain = value.toString();
                                      chlrinationreagentdropdownvisible = true;
                                      householdlistvisibility = true;
                                      locationdisvisibility = true;
                                    });
                                  },
                                ),
                                RadioListTile(
                                  visualDensity: const VisualDensity(
                                      horizontal: VisualDensity.minimumDensity,
                                      vertical: VisualDensity.minimumDensity),
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text("Mechanised chlorination"),
                                  value: "4",
                                  groupValue: Othersmain,
                                  onChanged: (value) {
                                    setState(() {
                                      Othersmain = value.toString();
                                      chlrinationreagentdropdownvisible = true;
                                      householdlistvisibility = true;
                                      locationdisvisibility = true;
                                    });
                                  },
                                ),
                                RadioListTile(
                                  visualDensity: const VisualDensity(
                                      horizontal: VisualDensity.minimumDensity,
                                      vertical: VisualDensity.minimumDensity),
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text("Manual dosing"),
                                  value: "5",
                                  groupValue: Othersmain,
                                  onChanged: (value) {
                                    setState(() {
                                      Othersmain = value.toString();
                                      chlrinationreagentdropdownvisible = true;
                                      householdlistvisibility = true;
                                      locationdisvisibility = true;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: othermethodbasedvisibility,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Appcolor.white,
                        border: Border.all(
                          color: Appcolor.lightgrey,
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            10.0,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Other',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          const Divider(
                            height: 10,
                            color: Appcolor.lightgrey,
                            thickness: 1,
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Appcolor.lightgrey),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RadioListTile(
                                  visualDensity: const VisualDensity(
                                      horizontal: VisualDensity.minimumDensity,
                                      vertical: VisualDensity.minimumDensity),
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text("Silver ion disinfection"),
                                  value: "1",
                                  groupValue: Othersmethodbasedvalue,
                                  onChanged: (value) {
                                    setState(() {
                                      Othersmethodbasedvalue = value.toString();
                                      locationdisvisibility = true;
                                    });
                                  },
                                ),
                                RadioListTile(
                                  visualDensity: const VisualDensity(
                                      horizontal: VisualDensity.minimumDensity,
                                      vertical: VisualDensity.minimumDensity),
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text("Ozonisation"),
                                  value: "2",
                                  groupValue: Othersmethodbasedvalue,
                                  onChanged: (value) {
                                    setState(() {
                                      Othersmethodbasedvalue = value.toString();
                                      locationdisvisibility = true;
                                    });
                                  },
                                ),
                                RadioListTile(
                                  visualDensity: const VisualDensity(
                                      horizontal: VisualDensity.minimumDensity,
                                      vertical: VisualDensity.minimumDensity),
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text("U. V. disinfection"),
                                  value: "3",
                                  groupValue: Othersmethodbasedvalue,
                                  onChanged: (value) {
                                    setState(() {
                                      Othersmethodbasedvalue = value.toString();
                                      locationdisvisibility = true;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: chlrinationreagentdropdownvisible,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  decoration: BoxDecoration(
                      color: Appcolor.white,
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Appcolor.lightgrey, width: .5),
                      borderRadius: BorderRadius.circular(6)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Select chlorination reagent *',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 10,
                        color: Appcolor.lightgrey,
                        thickness: 1,
                      ),
                      Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                            bottom: 10.0, right: 5, left: 5),
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                color: Appcolor.lightgrey, width: .5),
                            borderRadius: BorderRadius.circular(6)),
                        child: DropdownButton(
                          elevation: 10,
                          dropdownColor: Appcolor.white,
                          underline: const SizedBox(),
                          isExpanded: true,

                          // Initial Value
                          value: dropdownvalue,

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),

                          // Array list of items
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Text(
                                  items,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Appcolor.black),
                                ),
                              ),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: householdlistvisibility,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Appcolor.white,
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Appcolor.lightgrey, width: .5),
                      borderRadius: BorderRadius.circular(6)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Identify household for testing residual chlorine (preferable from tail end)',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 10,
                        color: Appcolor.lightgrey,
                        thickness: 1,
                      ),
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        child: ListView.builder(
                            itemCount: Adddisinfectionconatiner.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, int index) {
                              return Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                margin: const EdgeInsets.only(
                                    top: 5, left: 0, bottom: 10, right: 0),
                                elevation: 8,
                                shadowColor: Appcolor.black,
                                surfaceTintColor: Colors.white.withOpacity(.5),
                                //surfaceTintColor:    Colors.yellow ,
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.black,
                                    width: .5,
                                  ),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5)),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, left: 0, bottom: 5, right: 0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 5, bottom: 10, right: 5),
                                          width: double.infinity,
                                          height: 45,
                                          child: TextFormField(
                                            inputFormatters: <TextInputFormatter>[
                                              FirstNonNumericalFormatter(),
                                            ],
                                            //   controller: namecontroller[index],
                                            decoration: InputDecoration(
                                              fillColor: Colors.grey.shade100,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              hintText: "Enter name",
                                              hintStyle: const TextStyle(
                                                  color: Appcolor.grey,
                                                  fontWeight: FontWeight.w400),
                                            ),

                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            textInputAction:
                                                TextInputAction.done,
                                            onChanged: (value) {
                                              nameinputs[index] = value;
                                              print("fot" +
                                                  nameinputs.toString());
                                            },
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 5, bottom: 10, right: 5),
                                          width: double.infinity,
                                          height: 45,
                                          child: TextFormField(
                                            inputFormatters: <TextInputFormatter>[
                                              FirstNonNumericalFormatter(),
                                            ],
                                            //controller: fathernamecontroller[index],
                                            decoration: InputDecoration(
                                              fillColor: Colors.grey.shade100,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              hintText: "Enter father name",
                                              hintStyle: const TextStyle(
                                                  color: Appcolor.grey,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            textInputAction:
                                                TextInputAction.done,
                                            onChanged: (value) {
                                              fatherinputs[index] = value;
                                            },
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 5, bottom: 10, right: 5),
                                          width: double.infinity,
                                          height: 45,
                                          child: TextFormField(
                                            inputFormatters: <TextInputFormatter>[
                                              FirstNonNumericalFormatter(),
                                            ],
                                            //controller: addresscontroller[index],
                                            decoration: InputDecoration(
                                              fillColor: Colors.grey.shade100,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              hintText: "Enter address",
                                              hintStyle: const TextStyle(
                                                  color: Appcolor.grey,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            textInputAction:
                                                TextInputAction.done,
                                            onChanged: (value) {
                                              addressinputs[index] = value;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Adddisinfectionconatiner.length == 4
                              ? SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    bool isValidate = false;
                                    if (Adddisinfectionconatiner.length < 4) {
                                      isValidate = true;
                                      for (int i = 0;
                                          i < Adddisinfectionconatiner.length;
                                          i++) {
                                        if (nameinputs[i].isEmpty) {
                                          Stylefile
                                              .showmessageforvalidationfalse(
                                                  context, "Enter name");
                                          isValidate = false;
                                          print(
                                              "namos" + isValidate.toString());
                                          print("namos_nameinputs[i]" +
                                              nameinputs[i].toString());
                                          break;
                                        } else if (fatherinputs[i].isEmpty) {
                                          Stylefile
                                              .showmessageforvalidationfalse(
                                                  context, "Enter father's name");
                                          isValidate = false;
                                          break;
                                        } else if (addressinputs[i].isEmpty) {
                                          Stylefile
                                              .showmessageforvalidationfalse(
                                                  context, "Enter address");
                                          isValidate = false;
                                          break;
                                        } else {
                                          adddisinfectionhouseholdlist.add(
                                              Adddisinfectionhouseholdmodal(
                                                  nameinputs[i],
                                                  fatherinputs[i],
                                                  addressinputs[i]));

                                          print("addedlist" +
                                              adddisinfectionhouseholdlist
                                                  .toString());
                                        }
                                      }

                                      if (isValidate) {
                                        setState(() {
                                          print("namos_00" +
                                              isValidate.toString());
                                          Adddisinfectionconatiner.add(increasehousehold);
                                        });
                                      }
                                    } else {
                                      Stylefile.showmessageforvalidationfalse(
                                          context, "You cannot add more");
                                    }
                                  },
                                  child: const Icon(
                                    Icons.add_circle,
                                    size: 30,
                                    color: Appcolor.greenmessagecolor,
                                  )),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {});
                                increasehousehold = increasehousehold--;

                                if (Adddisinfectionconatiner.length > 1) {
                                  Adddisinfectionconatiner.removeAt(
                                      increasehousehold);
                                  for (int i = 0; i < Adddisinfectionconatiner.length; i++) {
                                    adddisinfectionhouseholdlist.removeAt(i);
                                    print("removedata" +adddisinfectionhouseholdlist.toString());
                                  }
                                } else {
                                  Stylefile.showmessageforvalidationfalse(
                                      context, "Can not be remove");
                                }
                              },
                              child: const Icon(
                                Icons.close ,
                                size: 30,
                                color: Appcolor.redone,
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: locationdisvisibility,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Appcolor.white,
                        border: Border.all(
                          color: Appcolor.lightgrey,
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            10.0,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Location of disinfection system*',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          const Divider(
                            height: 10,
                            color: Appcolor.lightgrey,
                            thickness: 1,
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Appcolor.lightgrey),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RadioListTile(
                                  visualDensity: const VisualDensity(
                                      horizontal: VisualDensity.minimumDensity,
                                      vertical: VisualDensity.minimumDensity),
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text("New"),
                                  value: "1",
                                  groupValue: locationdisinfectradio,
                                  onChanged: (value) {
                                    setState(() {
                                      locationdisinfectradio = value.toString();
                                      existreservselectschemevisible = false;
                                      habitaionvisibility = true;
                                      Geotagdisinfectvisible = true;
                                      Clickimagevisibile = true;
                                    });
                                  },
                                ),
                                RadioListTile(
                                  visualDensity: const VisualDensity(
                                      horizontal: VisualDensity.minimumDensity,
                                      vertical: VisualDensity.minimumDensity),
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text("Existing Reservoir"),
                                  value: "2",
                                  groupValue: locationdisinfectradio,
                                  onChanged: (value) {
                                    setState(() {
                                      locationdisinfectradio = value.toString();
                                      existreservselectschemevisible = true;
                                      habitaionvisibility = false;
                                      Geotagdisinfectvisible = false;
                                      Clickimagevisibile = true;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: existreservselectschemevisible,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Appcolor.white,
                          border: Border.all(
                            color: Appcolor.lightgrey,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              10.0,
                            ),
                          ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Material(
                              borderRadius: BorderRadius.circular(10.0),
                              child: InkWell(
                                splashColor: Appcolor.splashcolor,
                                onTap: () {},
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Select existing reservoir of selected Scheme ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                    const Divider(
                                      height: 10,
                                      color: Appcolor.lightgrey,
                                      thickness: 1,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 70,
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      margin: const EdgeInsets.only(
                                          bottom: 10.0, right: 10, left: 10),
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                              color: Appcolor.lightgrey,
                                              width: .5),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: DropdownButton<Schememodal>(
                                          itemHeight: 100,
                                          alignment: Alignment.center,
                                          elevation: 10,
                                          dropdownColor: Appcolor.white,
                                          underline: const SizedBox(),
                                          isExpanded: true,
                                          hint: const Text(
                                            "-- Select Scheme --",
                                          ),
                                          value: schememodal,
                                          items: schemelist.map((concernnames) {
                                            return DropdownMenuItem<
                                                Schememodal>(
                                              value: concernnames,
                                              child: Container(
                                                width: double.infinity,
                                                alignment: Alignment.centerLeft,
                                                decoration: const BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey,
                                                            width: 1))),
                                                child: Text(
                                                  concernnames.Schemename,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Appcolor.black),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (Schememodal? newValue) {
                                            setState(() {
                                              schememodal = newValue!;
                                              _mySchemeid =
                                                  newValue.Schemeid.toString();
                                              selectschamename =
                                                  newValue.Schemename;
                                              selectcategoryname =
                                                  newValue.Category.toString();
                                            });
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: habitaionvisibility,
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Appcolor.white,
                    border: Border.all(
                      color: Appcolor.lightgrey,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        10.0,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, bottom: 10, top: 5),
                        child: Text(
                          "Select habitation",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: 55,
                        margin: const EdgeInsets.only(
                            bottom: 5.0, right: 5, left: 5),
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                color: Appcolor.lightgrey, width: .5),
                            borderRadius: BorderRadius.circular(6)),
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.all(5),
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 1))),
                          child: DropdownButton<Habitaionlistmodal>(
                              itemHeight: 60,
                              elevation: 10,
                              dropdownColor: Appcolor.light,
                              underline: const SizedBox(),
                              isExpanded: true,
                              hint: const Text(
                                "-- Select Habitation --",
                              ),
                              value: habitaionlistmodal,
                              items: habitationlist.map((habitations) {
                                return DropdownMenuItem<Habitaionlistmodal>(
                                  value: habitations,
                                  child: Text(
                                    habitations.HabitationName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 4,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Appcolor.black),
                                  ),
                                );
                              }).toList(),
                              onChanged: (Habitaionlistmodal? newValue) {
                                setState(() {
                                  habitaionlistmodal = newValue!;
                                  selecthabitaionid = newValue.HabitationId;
                                  selecthabitaionname = newValue.HabitationName;
                                });
                              }),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10, top: 5),
                                child: Text(
                                  "Assets location/landmark *",
                                  maxLines: 4,
                                  style: TextStyle(
                                      color: Appcolor.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 5, bottom: 10, right: 5),
                              width: double.infinity,
                              height: 45,
                              child: TextFormField(
                                inputFormatters: <TextInputFormatter>[
                                  FirstNonNumericalFormatter(),
                                ],
                                controller: locationlandmarkcontroller,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: "Enter landmark/location",
                                  hintStyle: const TextStyle(
                                      color: Appcolor.grey,
                                      fontWeight: FontWeight.w400),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: Geotagdisinfectvisible,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Appcolor.white,
                    border: Border.all(
                      color: Appcolor.lightgrey,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        10.0,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 10, right: 10, left: 5, bottom: 10),
                            child: Text(
                              "Geo-coordinate of disinfection system",
                              maxLines: 4,
                              style: TextStyle(
                                  color: Appcolor.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 10,
                          color: Appcolor.lightgrey,
                          thickness: 1,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              "Latitude",
                              maxLines: 4,
                              style: TextStyle(
                                  color: Appcolor.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _getCurrentPosition(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Appcolor.lightblue,
                              border: Border.all(
                                color: Appcolor.lightgrey,
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  10.0,
                                ),
                              ),
                            ),
                            width: double.infinity,
                            height: 40,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: locationprogress == true
                                    ? const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: SizedBox(
                                              height: 15,
                                              width: 15,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1,
                                              )),
                                        ),
                                      )
                                    : Text(
                                        ' ${_currentPosition?.latitude ?? ""}',
                                        maxLines: 4,
                                        style: const TextStyle(
                                            color: Appcolor.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              "Longitude",
                              maxLines: 4,
                              style: TextStyle(
                                  color: Appcolor.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _getCurrentPosition(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Appcolor.lightblue,
                              border: Border.all(
                                color: Appcolor.lightgrey,
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  10.0,
                                ),
                              ),
                            ),
                            width: double.infinity,
                            height: 40,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: locationprogress == true
                                    ? const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: SizedBox(
                                              height: 15,
                                              width: 15,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1,
                                              )),
                                        ),
                                      )
                                    : Text(
                                        ' ${_currentPosition?.longitude ?? ""}',
                                        maxLines: 4,
                                        style: const TextStyle(
                                            color: Appcolor.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: Clickimagevisibile,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Appcolor.white,
                        border: Border.all(
                          color: Appcolor.lightgrey,
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            10.0,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            children: [
                              imgFile == null
                                  ? Center(
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                width: 2,
                                                color: Appcolor.COLOR_PRIMARY),
                                          ),
                                          padding: const EdgeInsets.all(3),
                                          margin: const EdgeInsets.only(
                                              left: 0, top: 10),
                                          width: 260,
                                          height: 200,
                                          child: const Image(
                                            width: 260,
                                            height: 200,
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                              'images/imagenot.png',
                                            ),
                                          )),
                                    )
                                  : Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              width: 2,
                                              color: Appcolor.COLOR_PRIMARY),
                                        ),
                                        padding: const EdgeInsets.all(3),
                                        margin: const EdgeInsets.only(
                                            left: 10, top: 10),
                                        width: 260,
                                        height: 200,
                                        child: Image.file(
                                          imgFile!,
                                          width: 260,
                                          height: 200,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                              const SizedBox(
                                height: 25,
                              ),
                              Center(
                                child: Container(
                                  height: 40,
                                  width: 200,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF0D3A98),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: TextButton(
                                    onPressed: () {
                                      if (_currentPosition == null) {
                                        Stylefile.showmessageforvalidationfalse(
                                            context,
                                            "Please enter latitude longitude ");
                                      } else {
                                        openCamera();
                                      }
                                    },
                                    child: const Text(
                                      'Capture photo',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        height: 40,
                        width: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: const Color(0xFF0D3A98),
                            borderRadius: BorderRadius.circular(8)),
                        child: TextButton(
                          onPressed: () {
                            if (adddisinfectionhouseholdlist.isEmpty) {
                              Stylefile.showmessageforvalidationfalse(
                                  context, "Please enter householders");
                            } else {
                              Stylefile.showmessageforvalidationtrue(
                                  context, "success");
                              print("listingof " +
                                  adddisinfectionhouseholdlist.toString());
                              setState(() {});
                              adddisinfectionhouseholdlist.clear();
                              namecontroller.clear();
                              fathernamecontroller.clear();
                              addresscontroller.clear();
                            }

                          },  /*   if (selecthabitaionname ==
                            "-- Select Habitation --") {
                            Stylefile
                                .showmessageforvalidationfalse(
                            context,
                            "Please select habitaion");
                            } else if (locationlandmarkcontroller
                                .text
                                .trim()
                                .toString()
                                .isEmpty) {
                            Stylefile
                                .showmessageforvalidationfalse(
                            context,
                            "Please enter location/landmark");
                            } else if (imgFile == null) {
                            Stylefile
                                .showmessageforvalidationfalse(
                            context,
                            "Please select image");
                            }*/
                          child: const Text(
                            'Save ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
