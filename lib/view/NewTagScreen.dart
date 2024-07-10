import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jaljeevanmissiondynamic/apiservice/Apiservice.dart';
import 'package:permission_handler/permission_handler.dart';
import '../database/DataBaseHelperJalJeevan.dart';
import '../localdatamodel/Localmasterdatamodal.dart';
import '../localdatamodel/Localpwssourcemodal.dart';
import '../utility/Appcolor.dart';
import '../utility/Drawlatlong.dart';
import '../utility/Stylefile.dart';
import '../utility/Textfile.dart';
import 'Dashboard.dart';
import 'LoginScreen.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'VillageDetails.dart';
import 'firstnumerical.dart';
import 'package:image/image.dart' as img;

class NewTagScreen extends StatefulWidget {
  var selectscheme;
  var selecthabitation;
  var selecthabitationid;
  var selectlocationlanmark;
  var villageid;
  var assettaggingid;
  var StateId;
  var schemeid;
  var SourceId;
  var sourcetypelocal;
  var HabitationId;
  var SourceTypeId;
  var SourceTypeCategoryId;
  var villagename;
  var selectlatitude;
  var selectlongitude;
  var districtname;
  var blockname;
  var sourcetype;
  var panchayatname;

  NewTagScreen(
      {required this.selectscheme,
      required this.selecthabitation,
      required this.selecthabitationid,
      required this.selectlocationlanmark,
      required this.villageid,
      required this.assettaggingid,
      required this.StateId,
      required this.schemeid,
      required this.SourceId,
      required this.sourcetypelocal,
      required this.HabitationId,
      required this.SourceTypeId,
      required this.SourceTypeCategoryId,
      required this.villagename,
      required this.districtname,
      required this.blockname,
      required this.sourcetype,
      required this.panchayatname,
      super.key});

  @override
  State<NewTagScreen> createState() => _NewTagState();
}

class _NewTagState extends State<NewTagScreen> {
  CroppedFile? croppedFile;
  var accuracyofgetlocation;
  String? getsourcetype;
  String? getselectscheme;
  String? getselecthabitation;
  String? getselectlocationlanmark;
  String? getselectlatitude;
  String? getselectlongitude;
  String? getvillageid;
  String? stateid;
  String? getassettaggingid;
  String? getselecthabitaionid;
  TextEditingController locationlandmarkcontroller = TextEditingController();
  TextEditingController latcontroller = TextEditingController();
  TextEditingController longcontroller = TextEditingController();

  String? getstateid;
  String? gender;
  String dropdownvalue2 = 'Item 6';
  String select_sourcetypeid = "";

  String dropdownvalue = 'Item 1';
  bool capturepointlocation = true;
  bool sourcevisible = false;
  bool selectschemesource = false;
  GetStorage box = GetStorage();
  DatabaseHelperJalJeevan? databaseHelperJalJeevan;

  String fileNameofimg = "";
  String imagepath = "";
  File? imgFile;
  final imgPicker = ImagePicker();
  Position? _currentPosition;
  String base64Image = "";
  List<int> imageBytes = [];
  var getdistrictname = "";
  var getblockname = "";
  var Nolistpresent;

  var totalsibrecord;

  bool locationprogress = false;

  Future<void> cleartable_localmasterschemelisttable() async {
    await databaseHelperJalJeevan!.cleardb_localmasterschemelist();
    await databaseHelperJalJeevan!.cleardb_sourcetypecategorytable();
    await databaseHelperJalJeevan!.cleardb_sourcassettypetable();
    await databaseHelperJalJeevan!.cleartable_villagelist();
    await databaseHelperJalJeevan!.cleartable_villagedetails();
    await databaseHelperJalJeevan!.cleardb_localhabitaionlisttable();
    await databaseHelperJalJeevan!.cleardb_sourcedetailstable();
    await databaseHelperJalJeevan!.truncatetable_dashboardtable();
    await databaseHelperJalJeevan!.cleardb_sibmasterlist();
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
      });
    } catch (e) {
      debugPrintStack();
    }
  }

  Future<bool> checkLocationPermission() async {
    PermissionStatus permission = await Permission.location.status;
    if (permission != PermissionStatus.granted) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    databaseHelperJalJeevan = DatabaseHelperJalJeevan();
    getsourcetype = widget.sourcetype;
    getassettaggingid = widget.assettaggingid;
    getselecthabitaionid = widget.selecthabitationid;
    getdistrictname = widget.districtname;
    getblockname = widget.blockname;
    select_sourcetypeid = widget.SourceTypeId.toString();

    _getCurrentPosition(context);
    if (box.read("UserToken").toString() == "null") {
      box.remove("UserToken");
      box.remove('loginBool');
      cleartable_localmasterschemelisttable();
      Get.off(LoginScreen());

      Stylefile.showmessageforvalidationtrue(
          context, "Please login your token has been expired!");
    }

    getstateid = widget.StateId.toString();
    getselectscheme = widget.selectscheme;
    getselecthabitation = widget.selecthabitation;
    getselectlocationlanmark = widget.selectlocationlanmark;
    getselectlatitude = widget.selectlatitude;
    getselectlongitude = widget.selectlongitude;

    setState(() {
      locationlandmarkcontroller.text = getselectlocationlanmark.toString();
    });
    callfornumber();
    countdatain_sibtable();
  }

  callfornumber() async {
    if (Nolistpresent == null) {
      Nolistpresent = 0;
    }
    Nolistpresent = await databaseHelperJalJeevan!.countRows();
  }

  countdatain_sibtable() async {
    if (totalsibrecord == null) {
      totalsibrecord = 0;
    }

    totalsibrecord = await databaseHelperJalJeevan!.countRows_forsib();
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
      final targetPath = '${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40.0),
            child: AppBar(
              backgroundColor: const Color(0xFF0D3A98),
              iconTheme: const IconThemeData(
                color: Appcolor.white,
              ),
              title: const Text("Tag Water Source",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    Get.offAll(Dashboard(
                        stateid: box.read("stateid"),
                        userid: box.read("userid"),
                        usertoken: box.read("UserToken")));
                  },
                )
              ],
            )),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/header_bg.png'), fit: BoxFit.cover),
          ),
          child: FocusDetector(
            onFocusGained: () {
              setState(() {
              });
            },
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              child: Image.asset(
                                'images/bharat.png',
                                width: 60,
                                height: 60,
                              ),
                            ),
                            Container(
                              child: const Column(
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
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Village : " + widget.villagename,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Appcolor.headingcolor),
                          ),
                        )),
                    const SizedBox(
                      height: 5,
                    ),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                "Selected scheme :",
                                maxLines: 4,
                                style: TextStyle(
                                    color: Appcolor.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SizedBox(
                              child: Text(
                                '${getselectscheme}',
                                maxLines: 10,
                                style: const TextStyle(
                                    color: Appcolor.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: capturepointlocation,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
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
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(
                                          "Location of PWS source:",
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
                                          "Habitation",
                                          maxLines: 4,
                                          style: TextStyle(
                                              color: Appcolor.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Appcolor.lightyello,
                                        border: Border.all(
                                          color: Appcolor.lightyello,
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
                                          child: Text(
                                            '${getselecthabitation}',
                                            maxLines: 4,
                                            style: const TextStyle(
                                                color: Appcolor.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            bottom: 10,
                                            top: 5),
                                        child: Text(
                                          "Source location/landmark",
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          hintText:
                                              '${getselectlocationlanmark}',
                                          hintStyle: const TextStyle(
                                              color: Appcolor.grey,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        textInputAction: TextInputAction.done,
                                      ),
                                    ),
                                    const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                          ),
                                          child: Text(
                                            "if required, please correct location/ landmark",
                                            style: TextStyle(
                                                color: Appcolor.red,
                                                fontSize: 12),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
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
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: 10,
                                          right: 10,
                                          left: 5,
                                          bottom: 10,
                                        ),
                                        child: Text(
                                          "Geo-coordinates of PWS source",
                                          maxLines: 4,
                                          style: TextStyle(
                                            color: Appcolor.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
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
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Appcolor.lightyello,
                                        border: Border.all(
                                          color: Appcolor.lightyello,
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
                                                  child: SizedBox(
                                                      width: 15,
                                                      height: 15,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 1,
                                                      )),
                                                )
                                              : Text(
                                                  ' ${_currentPosition?.latitude ?? ""}',
                                                  maxLines: 4,
                                                  style: const TextStyle(
                                                    color: Appcolor.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
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
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Appcolor.lightyello,
                                        border: Border.all(
                                          color: Appcolor.lightyello,
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
                                                  child: SizedBox(
                                                      width: 15,
                                                      height: 15,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 1,
                                                      )),
                                                )
                                              : Text(
                                                  '${_currentPosition?.longitude ?? ""}',
                                                  maxLines: 4,
                                                  style: const TextStyle(
                                                    color: Appcolor.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        width: 2,
                                                        color: Appcolor
                                                            .COLOR_PRIMARY),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(3),
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
                                                      color: Appcolor
                                                          .COLOR_PRIMARY),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(3),
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
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: TextButton(
                                            onPressed: () {
                                              if (_currentPosition == null) {
                                                Stylefile
                                                    .showmessageforvalidationfalse(
                                                        context,
                                                        "Please enter latitude longitude ");
                                              } else {
                                                openCamera();
                                              }
                                            },
                                            child: const Text(
                                              'Capture photo',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
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
                              ),
                            ),
                            const SizedBox(
                              height: 10,
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
                                  onPressed: () async {
                                    if (locationlandmarkcontroller.text
                                        .toString()
                                        .isEmpty) {
                                      Stylefile.showmessageforvalidationfalse(
                                          context,
                                          "Please enter source location/landmark");
                                    } else if (_currentPosition == null ||
                                        _currentPosition!.latitude
                                            .toString()
                                            .isEmpty ||
                                        _currentPosition!.longitude
                                            .toString()
                                            .isEmpty) {
                                      Stylefile.showmessageforvalidationfalse(
                                          context,
                                          "Location data is not available. Please ensure location permission is granted.");
                                    } else if (imgFile == null) {
                                      Stylefile.showmessageforvalidationfalse(
                                          context, "Please select image.");
                                    } else {
                                      bool? exists =
                                          await databaseHelperJalJeevan
                                              ?.isRecordExistsLocallyaddnew(
                                        _currentPosition!.latitude.toString(),
                                        _currentPosition!.longitude.toString(),
                                        widget.schemeid.toString(),
                                        widget.SourceTypeCategoryId.toString(),
                                      );
                                      if (exists != null && exists) {
                                        Stylefile.showmessageforvalidationfalse(
                                            context,
                                            "The record with the same location is already exist.");
                                      } else {
                                        databaseHelperJalJeevan
                                            ?.insertpwssourcelocal(
                                                LocalPWSSavedData(
                                          userId: box.read("userid").toString(),
                                          villageId:
                                              widget.villageid.toString(),
                                          assetTaggingId:
                                              getassettaggingid.toString(),
                                          stateId:
                                              box.read("stateid").toString(),
                                          schemeId: widget.schemeid.toString(),
                                          schemename: widget.selectscheme,
                                          blockName: widget.blockname,
                                          villageName: widget.villagename,
                                          panchayatName: widget.panchayatname,
                                          sourceName: widget.sourcetypelocal,
                                          sourceType: widget.sourcetypelocal,
                                          sourceId: widget.SourceId,
                                          divisionId:
                                              box.read("DivisionId").toString(),
                                          habitationId:
                                              getselecthabitaionid.toString(),
                                          habitationName:
                                              getselecthabitation.toString(),
                                          landmark: locationlandmarkcontroller
                                              .text
                                              .toString(),
                                          latitude: _currentPosition!.latitude
                                              .toString(),
                                          longitude: _currentPosition!.longitude
                                              .toString(),
                                          accuracy:
                                              accuracyofgetlocation.toString(),
                                          image: base64Image,
                                          sourceTypeCategoryId: widget
                                              .SourceTypeCategoryId.toString(),
                                          subsourceaddnew: widget.SourceTypeId.toString(),
                                          Status: "Pending",
                                        ))
                                            .then((value) {
                                          showAlertDialog(context);
                                        });
                                      }
                                    }
                                  },
                                  child: const Text(
                                    'Save ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: SizedBox(
                                height: 40,
                                width: 200,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      primary: Appcolor.orange,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    label: const Text(
                                      'Save & sync',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Appcolor.white),
                                    ),
                                    onPressed: () async {
                                      try {
                                        final result =
                                            await InternetAddress.lookup(
                                                'example.com');
                                        if (result.isNotEmpty &&
                                            result[0].rawAddress.isNotEmpty) {
                                          if (locationlandmarkcontroller.text
                                              .toString()
                                              .isEmpty) {
                                            Stylefile.showmessageforvalidationfalse(
                                                context,
                                                "Please enter source location/landmark");

                                            Stylefile.showmessageforvalidationfalse(
                                                context,
                                                "Please enter source location/landmark.");
                                          } else if (_currentPosition == null ||
                                              _currentPosition!.latitude
                                                  .toString()
                                                  .isEmpty ||
                                              _currentPosition!.longitude
                                                  .toString()
                                                  .isEmpty) {
                                            Stylefile.showmessageforvalidationfalse(
                                                context,
                                                "Location data is not available. Please ensure location permission is granted.");
                                          } else if (imgFile == null) {
                                            Stylefile
                                                .showmessageforvalidationfalse(
                                                    context,
                                                    "Please select image.");
                                          } else {
                                            Apiservice.PWSSourceSavetaggingapi(
                                                    context,
                                                    box
                                                        .read("UserToken")
                                                        .toString(),
                                                    box
                                                        .read("userid")
                                                        .toString(),
                                                    widget.villageid.toString(),
                                                    getassettaggingid
                                                        .toString(),
                                                    box.read("stateid"),
                                                    widget.schemeid.toString(),
                                                    widget.SourceId,
                                                    box
                                                        .read("DivisionId")
                                                        .toString(),
                                                    getselecthabitaionid
                                                        .toString(),
                                                    widget.SourceTypeId
                                                        .toString(),
                                                    widget.SourceTypeCategoryId
                                                        .toString(),
                                                    locationlandmarkcontroller
                                                        .text
                                                        .toString(),
                                                    _currentPosition!.latitude
                                                        .toString(),
                                                    _currentPosition!.longitude
                                                        .toString(),
                                                    accuracyofgetlocation
                                                        .toString(),
                                                    base64Image)
                                                .then((value) {
                                              Get.back();
                                              if (value["Status"].toString() ==
                                                  "false") {
                                                Stylefile
                                                    .showmessageforvalidationtrue(
                                                        context,
                                                        value["msg"]
                                                            .toString());
                                              } else if (value["Status"]
                                                      .toString() ==
                                                  "true") {
                                                Stylefile
                                                    .showmessageforvalidationtrue(
                                                        context,
                                                        value["msg"]
                                                            .toString());

                                                cleartable_localmastertables();
                                                Apiservice.Getmasterapi(context)
                                                    .then((value) {
                                                  for (int i = 0;
                                                      i <
                                                          value.villagelist!
                                                              .length;
                                                      i++) {
                                                    var userid = value
                                                        .villagelist![i]!.userId;

                                                    var villageId = value
                                                        .villagelist![i]!
                                                        .villageId;
                                                    var stateId = value
                                                        .villagelist![i]!.stateId;
                                                    var villageName = value
                                                        .villagelist![i]!
                                                        .VillageName;

                                                    databaseHelperJalJeevan
                                                        ?.insertMastervillagelistdata(
                                                            Localmasterdatanodal(
                                                                UserId: userid
                                                                    .toString(),
                                                                villageId: villageId
                                                                    .toString(),
                                                                StateId: stateId
                                                                    .toString(),
                                                                villageName:
                                                                    villageName
                                                                        .toString()))
                                                        .then((value) {});
                                                  }
                                                  databaseHelperJalJeevan!
                                                      .removeDuplicateEntries();

                                                  for (int i = 0;
                                                      i <
                                                          value.villageDetails!
                                                              .length;
                                                      i++) {
                                                    var stateName = "Assam";

                                                    var districtName = value
                                                        .villageDetails![i]!
                                                        .districtName;
                                                    var stateid = value
                                                        .villageDetails![i]!
                                                        .stateId;
                                                    var blockName = value
                                                        .villageDetails![i]!
                                                        .blockName;
                                                    var panchayatName = value
                                                        .villageDetails![i]!
                                                        .panchayatName;
                                                    var stateidnew = value
                                                        .villageDetails![i]!
                                                        .stateId;
                                                    var userId = value
                                                        .villageDetails![i]!
                                                        .userId;
                                                    var villageIddetails = value
                                                        .villageDetails![i]!
                                                        .villageId;
                                                    var villageName = value
                                                        .villageDetails![i]!
                                                        .villageName;
                                                    var totalNoOfScheme = value
                                                        .villageDetails![i]!
                                                        .totalNoOfScheme;
                                                    var totalNoOfWaterSource =
                                                        value.villageDetails![i]!
                                                            .totalNoOfWaterSource;
                                                    var totalWsGeoTagged = value
                                                        .villageDetails![i]!
                                                        .totalWsGeoTagged;
                                                    var pendingWsTotal = value
                                                        .villageDetails![i]!
                                                        .pendingWsTotal;
                                                    var balanceWsTotal = value
                                                        .villageDetails![i]!
                                                        .balanceWsTotal;
                                                    var totalSsGeoTagged = value
                                                        .villageDetails![i]!
                                                        .totalSsGeoTagged;
                                                    var pendingApprovalSsTotal =
                                                        value.villageDetails![i]!
                                                            .pendingApprovalSsTotal;
                                                    var totalIbRequiredGeoTagged =
                                                        value.villageDetails![i]!
                                                            .totalIbRequiredGeoTagged;
                                                    var totalIbGeoTagged = value
                                                        .villageDetails![i]!
                                                        .totalIbGeoTagged;
                                                    var pendingIbTotal = value
                                                        .villageDetails![i]!
                                                        .pendingIbTotal;
                                                    var balanceIbTotal = value
                                                        .villageDetails![i]!
                                                        .balanceIbTotal;
                                                    var totalOaGeoTagged = value
                                                        .villageDetails![i]!
                                                        .totalOaGeoTagged;
                                                    var balanceOaTotal = value
                                                        .villageDetails![i]!
                                                        .balanceOaTotal;
                                                    var totalNoOfSchoolScheme =
                                                        value.villageDetails![i]!
                                                            .totalNoOfSchoolScheme;
                                                    var totalNoOfPwsScheme =
                                                        value.villageDetails![i]!
                                                            .totalNoOfPwsScheme;

                                                    databaseHelperJalJeevan
                                                        ?.insertMastervillagedetails(
                                                            Localmasterdatamodal_VillageDetails(
                                                      status: "0",
                                                      stateName: stateName,
                                                      districtName:
                                                          districtName,
                                                      blockName: blockName,
                                                      panchayatName:
                                                          panchayatName,
                                                      stateId:
                                                          stateidnew.toString(),
                                                      userId: userId.toString(),
                                                      villageId:
                                                          villageIddetails
                                                              .toString(),
                                                      villageName: villageName,
                                                      totalNoOfScheme:
                                                          totalNoOfScheme
                                                              .toString(),
                                                      totalNoOfWaterSource:
                                                          totalNoOfWaterSource
                                                              .toString(),
                                                      totalWsGeoTagged:
                                                          totalWsGeoTagged
                                                              .toString(),
                                                      pendingWsTotal:
                                                          pendingWsTotal
                                                              .toString(),
                                                      balanceWsTotal:
                                                          balanceWsTotal
                                                              .toString(),
                                                      totalSsGeoTagged:
                                                          totalSsGeoTagged
                                                              .toString(),
                                                      pendingApprovalSsTotal:
                                                          pendingApprovalSsTotal
                                                              .toString(),
                                                      totalIbRequiredGeoTagged:
                                                          totalIbRequiredGeoTagged
                                                              .toString(),
                                                      totalIbGeoTagged:
                                                          totalIbGeoTagged
                                                              .toString(),
                                                      pendingIbTotal:
                                                          pendingIbTotal
                                                              .toString(),
                                                      balanceIbTotal:
                                                          balanceIbTotal
                                                              .toString(),
                                                      totalOaGeoTagged:
                                                          totalOaGeoTagged
                                                              .toString(),
                                                      balanceOaTotal:
                                                          balanceOaTotal
                                                              .toString(),
                                                      totalNoOfSchoolScheme:
                                                          totalNoOfSchoolScheme
                                                              .toString(),
                                                      totalNoOfPwsScheme:
                                                          totalNoOfPwsScheme
                                                              .toString(),
                                                    ));
                                                  }

                                                  for (int i = 0;
                                                      i <
                                                          value
                                                              .schmelist!.length;
                                                      i++) {
                                                    var source_type = value
                                                        .schmelist![i]!.source_type;     var schemeidnew = value
                                                        .schmelist![i]!.schemeid;
                                                    var villageid = value
                                                        .schmelist![i]!.villageId;
                                                    var schemenamenew = value
                                                        .schmelist![i]!
                                                        .schemename;
                                                    var schemenacategorynew = value.schmelist![i]!.category;
                                                    var SourceTypeCategoryId = value.schmelist![i]!.SourceTypeCategoryId;
                                                    var source_typeCategory = value.schmelist![i]!.source_typeCategory;
                                                    databaseHelperJalJeevan
                                                        ?.insertMasterSchmelist(
                                                            Localmasterdatamoda_Scheme(
                                                              source_type: source_type
                                                          .toString(),   schemeid: schemeidnew
                                                          .toString(),
                                                      villageId:
                                                          villageid.toString(),
                                                      schemename: schemenamenew
                                                          .toString(),
                                                      category: schemenacategorynew.toString(),
                                                              SourceTypeCategoryId: SourceTypeCategoryId.toString(),
                                                              source_typeCategory: source_typeCategory.toString(),
                                                    ));
                                                  }

                                                  for (int i = 0;
                                                      i <
                                                          value.sourcelist!
                                                              .length;
                                                      i++) {
                                                    var sourceId = value
                                                        .sourcelist![i]!.sourceId;
                                                    var SchemeId = value
                                                        .sourcelist![i]!.schemeId;
                                                    var stateid = value
                                                        .sourcelist![i]!.stateid;
                                                    var Schemename = value
                                                        .sourcelist![i]!
                                                        .schemeName;
                                                    var villageid = value
                                                        .sourcelist![i]!
                                                        .villageId;
                                                    var sourceTypeId = value
                                                        .sourcelist![i]!
                                                        .sourceTypeId;
                                                    var statename = value
                                                        .sourcelist![i]!
                                                        .stateName;
                                                    var sourceTypeCategoryId =
                                                        value.sourcelist![i]!
                                                            .sourceTypeCategoryId;
                                                    var habitationId = value
                                                        .sourcelist![i]!
                                                        .habitationId;
                                                    var villageName = value
                                                        .sourcelist![i]!
                                                        .villageName;
                                                    var existTagWaterSourceId =
                                                        value.sourcelist![i]!
                                                            .existTagWaterSourceId;
                                                    var isApprovedState = value
                                                        .sourcelist![i]!
                                                        .isApprovedState;
                                                    var landmark = value
                                                        .sourcelist![i]!.landmark;
                                                    var latitude = value
                                                        .sourcelist![i]!.latitude;
                                                    var longitude = value
                                                        .sourcelist![i]!
                                                        .longitude;
                                                    var habitationName = value
                                                        .sourcelist![i]!
                                                        .habitationName;
                                                    var location = value
                                                        .sourcelist![i]!.location;
                                                    var sourceTypeCategory =
                                                        value.sourcelist![i]!
                                                            .sourceTypeCategory;
                                                    var sourceType = value
                                                        .sourcelist![i]!
                                                        .sourceType;
                                                    var districtName = value
                                                        .sourcelist![i]!
                                                        .districtName;
                                                    var districtId = value
                                                        .sourcelist![i]!
                                                        .districtId;
                                                    var panchayatNamenew = value
                                                        .sourcelist![i]!
                                                        .panchayatName;
                                                    var blocknamenew = value
                                                        .sourcelist![i]!
                                                        .blockName;

                                                    databaseHelperJalJeevan
                                                        ?.insertMasterSourcedetails(
                                                            LocalSourcelistdetailsModal(
                                                      schemeId:
                                                          SchemeId.toString(),
                                                      sourceId:
                                                          sourceId.toString(),
                                                      villageId:
                                                          villageid.toString(),
                                                      schemeName: Schemename,
                                                      sourceTypeId: sourceTypeId
                                                          .toString(),
                                                      sourceTypeCategoryId:
                                                          sourceTypeCategoryId
                                                              .toString(),
                                                      habitationId: habitationId
                                                          .toString(),
                                                      existTagWaterSourceId:
                                                          existTagWaterSourceId
                                                              .toString(),
                                                      isApprovedState:
                                                          isApprovedState
                                                              .toString(),
                                                      landmark: landmark,
                                                      latitude:
                                                          latitude.toString(),
                                                      longitude:
                                                          longitude.toString(),
                                                      habitationName:
                                                          habitationName,
                                                      location: location,
                                                      sourceTypeCategory:
                                                          sourceTypeCategory,
                                                      sourceType: sourceType,
                                                      stateName: statename,
                                                      districtName:
                                                          districtName,
                                                      blockName: blocknamenew,
                                                      panchayatName:
                                                          panchayatNamenew,
                                                      districtId:
                                                          districtId.toString(),
                                                      villageName: villageName,
                                                      stateId:
                                                          stateid.toString(),
                                                    ));
                                                  }

                                                  for (int i = 0;
                                                      i <
                                                          value.habitationlist!
                                                              .length;
                                                      i++) {
                                                    var villafgeid = value
                                                        .habitationlist![i]!
                                                        .villageId;
                                                    var habitationId = value
                                                        .habitationlist![i]!
                                                        .habitationId;
                                                    var habitationName = value
                                                        .habitationlist![i]!
                                                        .habitationName;

                                                    databaseHelperJalJeevan
                                                        ?.insertMasterhabitaionlist(
                                                            LocalHabitaionlistModal(
                                                                villageId:
                                                                    villafgeid
                                                                        .toString(),
                                                                HabitationId:
                                                                    habitationId
                                                                        .toString(),
                                                                HabitationName:
                                                                    habitationName
                                                                        .toString()));
                                                  }
                                                  for (int i = 0;
                                                      i <
                                                          value
                                                              .informationBoardList!
                                                              .length;
                                                      i++) {
                                                    databaseHelperJalJeevan?.insertmastersibdetails(LocalmasterInformationBoardItemModal(
                                                        userId: value.informationBoardList![i]!.userId
                                                            .toString(),
                                                        villageId:
                                                            value.informationBoardList![i]!.villageId
                                                                .toString(),
                                                        stateId: value.informationBoardList![i]!.stateId
                                                            .toString(),
                                                        schemeId: value.informationBoardList![i]!.schemeId
                                                            .toString(),
                                                        districtName: value
                                                            .informationBoardList![i]!.districtName,
                                                        blockName: value
                                                            .informationBoardList![i]!.blockName,
                                                        panchayatName: value
                                                            .informationBoardList![i]!
                                                            .panchayatName,
                                                        villageName: value.informationBoardList![i]!.villageName,
                                                        habitationName: value.informationBoardList![i]!.habitationName,
                                                        latitude: value.informationBoardList![i]!.latitude.toString(),
                                                        longitude: value.informationBoardList![i]!.longitude.toString(),
                                                        sourceName: value.informationBoardList![i]!.sourceName,
                                                        schemeName: value.informationBoardList![i]!.schemeName,
                                                        message: value.informationBoardList![i]!.message,
                                                        status: value.informationBoardList![i]!.status.toString()));
                                                  }
                                                });
                                              }
                                            });
                                          }
                                        }
                                      } on SocketException catch (_) {
                                        Stylefile.showmessageforvalidationfalse(
                                            context,
                                            "Unable to Connect to the Internet. Please check your network settings.");
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.upload,
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> cleartable_localmastertables() async {
    await databaseHelperJalJeevan!.truncateTable_localmasterschemelist();
    await databaseHelperJalJeevan!.cleardb_localmasterschemelist();
    await databaseHelperJalJeevan!.cleartable_villagelist();
    await databaseHelperJalJeevan!.cleartable_villagedetails();
    await databaseHelperJalJeevan!.cleardb_localhabitaionlisttable();
    await databaseHelperJalJeevan!.cleardb_sourcedetailstable();
    await databaseHelperJalJeevan!.cleardb_sibmasterlist();
  }

  void showAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Appcolor.white,
          titlePadding: const EdgeInsets.only(top: 0, left: 0, right: 00),
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
            child: const Padding(
              padding: EdgeInsets.only(left: 25, top: 10, bottom: 10),
              child: Text(
                'Alert! ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Appcolor.white),
              ),
            ),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 0, top: 0, bottom: 0),
                  child: Text(
                    "The record has been saved successfully.",
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
                  onPressed: () {
                    Get.to(VillageDetails(
                      stateid: box.read("stateid").toString(),
                      villageid: widget.villageid,
                      villagename: widget.villagename,
                      token: box.read("UserToken"),
                      userID: box.read("userid"),
                    ));


                    Stylefile.showmessageforvalidationtrue(
                        context, "This record has been saved successfully.");
                  },
                  child: const Text('OK',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Appcolor.black))),
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadLocalDataAndClear(BuildContext context) async {
    try {
      final List<LocalPWSSavedData>? localDataList =
          await databaseHelperJalJeevan?.getAllLocalPWSSavedData();
      if (localDataList!.isEmpty) {
        return;
      }

      for (final localData in localDataList) {
        final response = await Apiservice.PWSSourceSavetaggingapi(
            context,
            box.read("UserToken").toString(),
            localData.userId,
            localData.villageId,
            localData.assetTaggingId,
            localData.stateId,
            localData.schemeId,
            localData.sourceId,
            localData.divisionId,
            localData.habitationId,
            localData.subsourceaddnew,
            localData.sourceTypeCategoryId,
            localData.landmark,
            localData.latitude,
            localData.longitude,
            localData.accuracy,
            localData.image);

        if (response["Status"].toString() == false) {
        } else if (response["Status"].toString() == true) {
          Stylefile.showmessageforvalidationtrue(
              context, response["msg"].toString());
          await databaseHelperJalJeevan?.truncatetable_pwssourcesaveddata();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => super.widget));
        }
      }
    } catch (e) {
      debugPrintStack();
    }
  }
}

class FileConverter {
  static String getBase64FormateFile(String path) {
    File file = File(path);

    List<int> fileInByte = file.readAsBytesSync();
    String fileInBase64 = base64Encode(fileInByte);

    return fileInBase64;
  }
}
