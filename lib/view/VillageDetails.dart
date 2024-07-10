import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:jaljeevanmissiondynamic/apiservice/Apiservice.dart';
import 'package:jaljeevanmissiondynamic/model/Savevillagedetails.dart';
import 'package:jaljeevanmissiondynamic/utility/Appcolor.dart';
import 'package:jaljeevanmissiondynamic/view/NewTagWater.dart';
import 'package:jaljeevanmissiondynamic/view/Otherassets/Otherassetsgeotaggedpendingapprove.dart';
import 'package:jaljeevanmissiondynamic/view/SIB/Schemeinformationboard.dart';
import 'package:jaljeevanmissiondynamic/view/pws/PWSPendingapproval.dart';

import '../CommanScreen.dart';
import '../Selectedvillagelist.dart';
import '../database/DataBaseHelperJalJeevan.dart';
import '../localdatamodel/Localmasterdatamodal.dart';
import '../localdatamodel/Localpwspendinglistmodal.dart';
import '../utility/Stylefile.dart';
import '../utility/Textfile.dart';
import 'Dashboard.dart';
import 'LoginScreen.dart';
import 'Offlineentries.dart';
import 'Otherassets/OfflineentriesOtherassets.dart';
import 'SIB/OfflinentriesSIB.dart';
import 'SS/Offlineentriesforstoragestructure.dart';
import 'SS/Storagestructurependingapproved.dart';

class VillageDetails extends StatefulWidget {
  var villageid = "";
  var villagename = "";
  var stateid = "";
  var userID;
  var token;

  VillageDetails(
      {required this.villageid,
      required this.villagename,
      required this.stateid,
      required this.userID,
      required this.token,
      Key? key})
      : super(key: key);

  @override
  State<VillageDetails> createState() =>
      _VillageDetailsState(userId: userID, token: token);
}

class _VillageDetailsState extends State<VillageDetails> {
  var token;
  var userId;

  _VillageDetailsState({required this.userId, required this.token});

  var getstateid;
  var getsvillageid;
  var updatedatetime;
  GetStorage box = GetStorage();
  var HeadingMessage;
  var totalotdatavillagewisess;
  var PanchayatName;
  var VillageName;
  var totalsibrecord;
  var totalsibrecordvillagewise;
  var totalpwsdatavillagewise;

  Offset fabPosition = const Offset(1, 600);
  var PendingIBTotal = "0";
  var TotalOAGeoTagged;
  var BalanceOATotal;
  var TotalNoOfWaterSource;
  late Savevillagedetails savevillagedetails;
  bool _loading = false;
  DatabaseHelperJalJeevan? databaseHelperJalJeevan;
  List<dynamic> listassetone = [];
  List<dynamic> list = [];
  List<Localmasterdatamodal_VillageDetails> listvillagedetails = [];
  String? District = "";
  String? VillageIdDB = "";
  var totalschemes;

  String? Block_village = "";
  String? Panchayat_Name = "";
  var Total_no_pws_schemes = "";
  var Total_no_aws_schemes = "";

  String? Total_no_pws_source = "";
  String? pendingWsTotal = "";
  String? balanceWsTotal = "";
  String? BalanceIBTotal = "";
  var pendingIBTotal;
  String? totalIBGeoTagged = "";
  String? PendingApprovalSSTotal = "";
  String? TotalSSGeoTagged = "";
  String? totalOaGeoTagged = "";
  String? balanceOaTotal = "";
  var totalotdatavillagewiseot;
  bool floatingloader = false;
  String? totalWsGeoTagged = "";
  List<Localpwspendinglistmodal> localpwspendingDataList = [];
  var Headingmessage;
  var Panchayat;
  var Block;
  var district;
  var getvillageid;
  String totalpendingdata = "0";
  var Nolistpresent;
  bool _isLoading = false;

  Future<void> cleartable_localmastertables() async {
    await databaseHelperJalJeevan!.truncateTable_localmasterschemelist();
    await databaseHelperJalJeevan!.cleardb_localmasterschemelist();
    await databaseHelperJalJeevan!.cleartable_villagelist();
    await databaseHelperJalJeevan!.cleartable_villagedetails();
    await databaseHelperJalJeevan!.cleardb_localhabitaionlisttable();
    await databaseHelperJalJeevan!.cleardb_sourcedetailstable();
    await databaseHelperJalJeevan!.cleardb_sibmasterlist();
  }

  @override
  void initState() {
    getsvillageid = widget.villageid;

    databaseHelperJalJeevan = DatabaseHelperJalJeevan();

    setState(() {
      fetchDataAndUpdateUI();
    });

    savevillagedetails = Savevillagedetails();
    callfornumber();

    if (box.read("UserToken").toString() == "null") {
      cleartable_localmasterschemelisttable();
      Get.off(LoginScreen());

      Stylefile.showmessageforvalidationfalse(
          context, "Please login your token has been expired!");
    }
    assettypesource();

    fetchDateAndTimeFromTable(box.read("userid").toString());
    super.initState();
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
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 0, top: 0, bottom: 0),
                  child: Text(
                    "All master data has been successfully downloaded in the application.",
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
                    fetchDataAndUpdateUI();
                    fetchDateAndTimeFromTable(box.read("userid").toString());
                    Navigator.pop(context);
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

  void fetchDateAndTimeFromTable(String userId) async {
    List<Map<String, dynamic>> data =
        await databaseHelperJalJeevan!.getDatatime(userId);

    if (data.isNotEmpty) {
      Map<String, dynamic> lastRow = data.last;

      int id = lastRow['id'];
      String apiDateTime = lastRow['API_DateTime'];

      DateTime dateTime = DateTime.parse(apiDateTime);

      DateTime indianDateTime = dateTime.toLocal();

      String formattedDateTime =
          DateFormat('dd-MM-yyyy hh:mm a').format(indianDateTime);

      updatedatetime = formattedDateTime;
    }
  }

  String _addLeadingZero(int value) {
    return value.toString().padLeft(2, '0');
  }

  Future<void> fetchDataAndUpdateUI() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Map<String, dynamic>? villageDetails =
          await databaseHelperJalJeevan?.getVillageDetailsById(getsvillageid);

      if (villageDetails != null && villageDetails.isNotEmpty) {
        await updatePWSDataVillageWise();
        await countdata_offlinevillagewise();

        await updateotherassetsDataVillageWise();
        await updatestoragestructureoflinedataVillageWise();
        setState(() {
          VillageIdDB = (villageDetails['villageId'] as String?) ?? '';
          District = (villageDetails['districtName'] as String?) ?? '';
          Block_village = (villageDetails['blockName'] as String?) ?? '';
          Panchayat_Name = (villageDetails['panchayatName'] as String?) ?? '';
          Total_no_pws_schemes =
              (villageDetails['totalNoOfPwsScheme'] as String?) ?? '';
          Total_no_aws_schemes =
              (villageDetails['totalNoOfSchoolScheme'] as String?) ?? '';
          Total_no_pws_source =
              (villageDetails['totalNoOfWaterSource'] as String?) ?? '';
          pendingWsTotal = (villageDetails['pendingWsTotal'] as String?) ?? '';
          balanceWsTotal = (villageDetails['balanceWsTotal'] as String?) ?? '';
          totalWsGeoTagged =
              (villageDetails['totalWsGeoTagged'] as String?) ?? '';
          BalanceIBTotal = (villageDetails['balanceIbTotal'] as String?) ?? '';
          pendingIBTotal = (villageDetails['pendingIbTotal'] as String?) ?? '';
          totalIBGeoTagged =
              (villageDetails['totalIbGeoTagged'] as String?) ?? '';
          PendingApprovalSSTotal =
              (villageDetails['pendingApprovalSsTotal'] as String?) ?? '';
          TotalSSGeoTagged =
              (villageDetails['totalSsGeoTagged'] as String?) ?? '';
          totalOaGeoTagged =
              (villageDetails['totalOaGeoTagged'] as String?) ?? '';

          balanceOaTotal = (villageDetails['balanceOaTotal'] as String?) ?? '';

          totalschemes =
              int.parse(Total_no_pws_schemes) + int.parse(Total_no_aws_schemes);
        });
      } else {
        setState(() {
          District = '';
          Block_village = '';
          Panchayat_Name = '';
          Total_no_pws_schemes = '';
          Total_no_aws_schemes = '';
          Total_no_pws_source = '';
          pendingWsTotal = '';
          balanceWsTotal = '';
          totalWsGeoTagged = '';
          BalanceIBTotal = '';
          pendingIBTotal = '';
          totalIBGeoTagged = '';
          PendingApprovalSSTotal = '';
          TotalSSGeoTagged = '';
          totalOaGeoTagged = '';
          balanceOaTotal = '';
        });
      }
    } catch (e) {
      debugPrintStack();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  callfornumber() async {
    if (Nolistpresent == null) {
      Nolistpresent = 0;
    }

    Nolistpresent = await databaseHelperJalJeevan!.countRows();
  }

  countdata_offlinevillagewise() async {
    if (totalsibrecordvillagewise == null) {
      totalsibrecordvillagewise = 0;
    }

    totalsibrecordvillagewise = await databaseHelperJalJeevan!
        .countRowsByVillageId_siblocal(widget.villageid);
  }

  updatePWSDataVillageWise() async {
    if (totalpwsdatavillagewise == null) {
      totalpwsdatavillagewise = 0;
    }

    totalpwsdatavillagewise = await databaseHelperJalJeevan!
        .countRowsByVillageId_pwslocal(widget.villageid!);
  }

  updatestoragestructureoflinedataVillageWise() async {
    if (totalotdatavillagewisess == null) {
      totalotdatavillagewisess = 0;
    }
    totalotdatavillagewisess = await databaseHelperJalJeevan!
        .countRowsByVillageId_sslocal(widget.villageid!);
  }

  updateotherassetsDataVillageWise() async {
    if (totalotdatavillagewiseot == null) {
      totalotdatavillagewiseot = 0;
    }

    totalotdatavillagewiseot = await databaseHelperJalJeevan!
        .countRowsByVillageId_otherassetlocal(widget.villageid);
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

  assettypesource() async {
    for (int i = 0; i < list!.length; i++) {
      var one = list[0];
      for (int j = 0; j < one.length; j++) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Selectedvillaglist(
                stateId: widget.stateid,
                userId: widget.userID,
                usertoken: widget.token)));
        return true;
      },
      child: FocusDetector(
        onFocusGained: () {
          setState(() {
            fetchDataAndUpdateUI();
            fetchDateAndTimeFromTable(box.read("userid").toString());
          });
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40.0),
            child: AppBar(
              backgroundColor: const Color(0xFF0D3A98),
              iconTheme: const IconThemeData(
                color: Appcolor.white,
              ),
              title: const Text("Village summary",
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
            ),
          ),
          body: Stack(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/header_bg.png'),
                        fit: BoxFit.cover),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Row(
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(Textfile.headingjaljeevan,
                                                textAlign: TextAlign.justify,
                                                style:
                                                    Stylefile.mainheadingstyle),
                                            Text(Textfile.subheadingjaljeevan,
                                                textAlign: TextAlign.start,
                                                style: Stylefile
                                                    .submainheadingstyle),
                                          ],
                                        ),
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
                                        actionsAlignment:
                                            MainAxisAlignment.center,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                                    context,
                                                    "Sign out successfully");
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
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        NewScreenPoints(
                          villageName: widget.villagename,
                          villageId: widget.villageid,
                          no: 3,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Last updated on : ${updatedatetime}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.deepOrange),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFC2C2C2).withOpacity(0.3),
                              border: Border.all(
                                color: Colors.green,
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  10.0,
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Village : ${widget.villagename}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Appcolor.headingcolor),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.all(0),
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
                                    padding: const EdgeInsets.only(
                                        left: 5,
                                        top: 5.0,
                                        right: 5.0,
                                        bottom: 5.0),
                                    child: Material(
                                      child: InkWell(
                                        splashColor: Appcolor.splashcolor,
                                        onTap: () {},
                                        child: Container(
                                            child: Column(children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text(
                                                  'District : ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  District!,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    color: Color(0xFF0D3A98),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text(
                                                  'Block : ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  Block_village.toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    color: Color(0xFF0D3A98),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text(
                                                  'Panchayat : ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  Panchayat_Name.toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    color: Color(0xFF0D3A98),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text(
                                                  'Total no of PWS Schemes : ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  Total_no_pws_schemes
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    color: Color(0xFF0D3A98),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text(
                                                  'No of School/AWCs Schemes :  ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  Total_no_aws_schemes
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    color: Color(0xFF0D3A98),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text(
                                                  'No of PWS Sources :  ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  Total_no_pws_source
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    color: Color(0xFF0D3A98),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ])),
                                      ),
                                    )),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Status of Geo-tag PWS assets',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Appcolor.headingcolor),
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
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
                                  padding: const EdgeInsets.only(
                                      left: 5,
                                      top: 5.0,
                                      right: 5.0,
                                      bottom: 5.0),
                                  child: Material(
                                    child: InkWell(
                                      splashColor: Appcolor.splashcolor,
                                      onTap: () {},
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                top: 10, bottom: 10, left: 5),
                                            child: Text(
                                              '(A).PWS source',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 1,
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: const Color(
                                                                0xffb3C53C2)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5,
                                                            right: 5,
                                                            bottom: 10,
                                                            top: 0),
                                                    child:
                                                        totalWsGeoTagged != "0"
                                                            ? Material(
                                                                elevation: 2.0,
                                                                color: Appcolor
                                                                    .greeenlight,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                child: InkWell(
                                                                  splashColor:
                                                                      Appcolor
                                                                          .splashcolor,
                                                                  customBorder:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      10.0,
                                                                    ),
                                                                  ),
                                                                  onTap:
                                                                      () async {
                                                                    try {
                                                                      final result =
                                                                          await InternetAddress.lookup(
                                                                              'example.com');
                                                                      if (result
                                                                              .isNotEmpty &&
                                                                          result[0]
                                                                              .rawAddress
                                                                              .isNotEmpty) {
                                                                        Get.to(PWSPendingapproval(
                                                                            send_district:
                                                                                District!,
                                                                            send_block:
                                                                                Block_village.toString(),
                                                                            send_panchayat: Panchayat_Name.toString(),
                                                                            villageid: widget.villageid,
                                                                            villagename: widget.villagename,
                                                                            stateid: widget.stateid,
                                                                            token: box.read("UserToken"),
                                                                            statusapproved: "1"));
                                                                      }
                                                                    } on SocketException catch (_) {
                                                                      Stylefile.showmessageforvalidationfalse(
                                                                          context,
                                                                          "Unable to Connect to the Internet. Please check your network settings.");
                                                                    }
                                                                  },
                                                                  child: Ink(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              5),
                                                                          child: const Center(
                                                                              child: Text(
                                                                            'Geo-tagged \n     and \napproved',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                                                                          )),
                                                                        ),
                                                                        const Divider(
                                                                          thickness:
                                                                              1,
                                                                          height:
                                                                              10,
                                                                          color:
                                                                              Appcolor.lightgrey,
                                                                        ),
                                                                        Center(
                                                                            child:
                                                                                Text(
                                                                          totalWsGeoTagged!,
                                                                          style: const TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Appcolor.btncolor),
                                                                        ))
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Material(
                                                                elevation: 2.0,
                                                                color: Appcolor
                                                                    .greeenlight,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                                child: InkWell(
                                                                  splashColor:
                                                                      Appcolor
                                                                          .splashcolor,
                                                                  customBorder:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      5.0,
                                                                    ),
                                                                  ),
                                                                  child: Ink(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              5),
                                                                          child: const Center(
                                                                              child: Text(
                                                                            'Geo-tagged \n     and \napproved',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                                                                          )),
                                                                        ),
                                                                        const Divider(
                                                                          thickness:
                                                                              1,
                                                                          height:
                                                                              10,
                                                                          color:
                                                                              Appcolor.lightgrey,
                                                                        ),
                                                                        Center(
                                                                            child:
                                                                                Text(
                                                                          totalWsGeoTagged
                                                                              .toString(),
                                                                          style: const TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Appcolor.btncolor),
                                                                        ))
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child:
                                                      pendingWsTotal
                                                                  .toString() !=
                                                              "0"
                                                          ? Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: const Color(
                                                                          0xffb3C53C2)),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 2,
                                                                      right: 5,
                                                                      bottom:
                                                                          10,
                                                                      top: 0),
                                                              child: Material(
                                                                elevation: 2.0,
                                                                color: Appcolor
                                                                    .lightyello,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                                child: InkWell(
                                                                    splashColor:
                                                                        Appcolor
                                                                            .splashcolor,
                                                                    customBorder:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                        10.0,
                                                                      ),
                                                                    ),
                                                                    onTap:
                                                                        () async {
                                                                      try {
                                                                        final result =
                                                                            await InternetAddress.lookup('example.com');
                                                                        if (result.isNotEmpty &&
                                                                            result[0].rawAddress.isNotEmpty) {
                                                                          Get.to(PWSPendingapproval(
                                                                              send_district: District!,
                                                                              send_block: Block_village.toString(),
                                                                              send_panchayat: Panchayat_Name.toString(),
                                                                              villageid: widget.villageid,
                                                                              villagename: widget.villagename,
                                                                              stateid: widget.stateid,
                                                                              token: box.read("UserToken").toString(),
                                                                              statusapproved: "0"));
                                                                        }
                                                                      } on SocketException catch (_) {
                                                                        Stylefile.showmessageforvalidationfalse(
                                                                            context,
                                                                            "Unable to Connect to the Internet. Please check your network settings.");
                                                                      }
                                                                    },
                                                                    child: Ink(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            padding:
                                                                                const EdgeInsets.all(5),
                                                                            child: const Center(
                                                                                child: Text(
                                                                              'Pending \n     for \napproval',
                                                                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                                                                            )),
                                                                          ),
                                                                          const Divider(
                                                                            thickness:
                                                                                1,
                                                                            height:
                                                                                10,
                                                                            color:
                                                                                Appcolor.lightgrey,
                                                                          ),
                                                                          Center(
                                                                              child: Text(
                                                                            pendingWsTotal.toString(),
                                                                            style: const TextStyle(
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Appcolor.btncolor),
                                                                          ))
                                                                        ],
                                                                      ),
                                                                    )),
                                                              ),
                                                            )
                                                          : Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: const Color(
                                                                          0xffb3C53C2)),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 2,
                                                                      right: 5,
                                                                      bottom:
                                                                          10,
                                                                      top: 0),
                                                              child: Material(
                                                                elevation: 2.0,
                                                                color: Appcolor
                                                                    .lightyello,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                                child: InkWell(
                                                                  splashColor:
                                                                      Appcolor
                                                                          .splashcolor,
                                                                  customBorder:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      10.0,
                                                                    ),
                                                                  ),
                                                                  child: Ink(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              5),
                                                                          child: const Center(
                                                                              child: Text(
                                                                            'Pending \n     for \napproval',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                                                                          )),
                                                                        ),
                                                                        const Divider(
                                                                          thickness:
                                                                              1,
                                                                          height:
                                                                              10,
                                                                          color:
                                                                              Appcolor.lightgrey,
                                                                        ),
                                                                        Center(
                                                                            child:
                                                                                Text(
                                                                          pendingWsTotal
                                                                              .toString(),
                                                                          style: const TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Appcolor.btncolor),
                                                                        ))
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
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 5,
                                                      right: 5,
                                                      bottom: 10,
                                                      top: 0),
                                                  decoration: BoxDecoration(
                                                      color: Appcolor.pinklight,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: const Color(
                                                                0xffb3C53C2)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: const Center(
                                                              child: Text(
                                                            ' \n Balance     \n',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 16),
                                                          )),
                                                        ),
                                                        const Divider(
                                                          thickness: 1,
                                                          height: 10,
                                                          color: Appcolor
                                                              .lightgrey,
                                                        ),
                                                        balanceWsTotal == "0"
                                                            ? Center(
                                                                child: Text(
                                                                balanceWsTotal
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Appcolor
                                                                        .btncolor),
                                                              ))
                                                            : GestureDetector(
                                                                onTap: () {},
                                                                child: Center(
                                                                    child: Text(
                                                                  balanceWsTotal
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Appcolor
                                                                          .btncolor),
                                                                ))),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Get.to(Offlineentries(
                                                        villageid:
                                                            widget.villageid,
                                                        villagename:
                                                            widget.villagename,
                                                        stateid: widget.stateid,
                                                        block: Block_village
                                                            .toString(),
                                                        panchyat: Panchayat_Name
                                                            .toString(),
                                                        district:
                                                            District.toString(),
                                                        token: box
                                                            .read("UserToken")
                                                            .toString(),
                                                        statusapproved: "0"));
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: const Color(
                                                                0xffb3C53C2)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 2,
                                                            right: 5,
                                                            bottom: 10,
                                                            top: 0),
                                                    child: Material(
                                                      elevation: 2.0,
                                                      color:
                                                          Appcolor.greylightsec,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      child: InkWell(
                                                        customBorder:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            5.0,
                                                          ),
                                                        ),
                                                        child: Ink(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Get.to(Offlineentries(
                                                                      villageid:
                                                                          widget
                                                                              .villageid,
                                                                      villagename:
                                                                          widget
                                                                              .villagename,
                                                                      stateid:
                                                                          widget
                                                                              .stateid,
                                                                      block: Block_village
                                                                          .toString(),
                                                                      panchyat:
                                                                          Panchayat_Name
                                                                              .toString(),
                                                                      district:
                                                                          District
                                                                              .toString(),
                                                                      token: box
                                                                          .read(
                                                                              "UserToken")
                                                                          .toString(),
                                                                      statusapproved:
                                                                          "0"));
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5),
                                                                  child:
                                                                      const Center(
                                                                          child:
                                                                              Text(
                                                                    'Entries \n  to be\nuploaded',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            16),
                                                                  )),
                                                                ),
                                                              ),
                                                              const Divider(
                                                                thickness: 1,
                                                                height: 10,
                                                                color: Appcolor
                                                                    .lightgrey,
                                                              ),
                                                              Center(
                                                                  child: Text(
                                                                totalpwsdatavillagewise
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Appcolor
                                                                        .btncolor),
                                                              ))
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          totalschemes != 0
                                              ? Center(
                                                  child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: const Color(
                                                          0xffb3C53C2),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  margin:
                                                      const EdgeInsets.all(10),
                                                  child: Material(
                                                    color:
                                                        const Color(0xFF0D3A98),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    child: InkWell(
                                                      splashColor:
                                                          Appcolor.splashcolor,
                                                      customBorder:
                                                          RoundedRectangleBorder(
                                                        side: const BorderSide(
                                                          width: 2,
                                                          color:
                                                              Appcolor.btncolor,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      onTap: () {
                                                        Get.to(NewTagWater(
                                                          clcikedstatus: "1",
                                                          stateid:
                                                              widget.stateid,
                                                          villageid:
                                                              getsvillageid,
                                                          villagename: widget
                                                              .villagename,
                                                          districtname: District
                                                              .toString(),
                                                          blockname:
                                                              Block_village
                                                                  .toString(),
                                                          panchayatname:
                                                              Panchayat_Name
                                                                  .toString(),
                                                        ));
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text(
                                                            'Add/Geo-tag PWS Source',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          IconButton(
                                                            color: Colors.white,
                                                            onPressed: () {
                                                              Get.to(
                                                                  NewTagWater(
                                                                clcikedstatus:
                                                                    "1",
                                                                stateid: widget
                                                                    .stateid,
                                                                villageid: widget
                                                                    .villageid,
                                                                villagename: widget
                                                                    .villagename,
                                                                districtname:
                                                                    District
                                                                        .toString(),
                                                                blockname:
                                                                    Block_village
                                                                        .toString(),
                                                                panchayatname:
                                                                    Panchayat_Name
                                                                        .toString(),
                                                              ));
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .double_arrow_outlined,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ))
                                              : Center(
                                                  child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Material(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: InkWell(
                                                          splashColor: Appcolor
                                                              .splashcolor,
                                                          customBorder:
                                                              RoundedRectangleBorder(
                                                            side: const BorderSide(
                                                                width: 2,
                                                                color: Appcolor
                                                                    .btncolor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              5.0,
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            Stylefile
                                                                .showmessageforvalidationfalse(
                                                                    context,
                                                                    "There is no scheme available in this village please contact to division officer.");
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Text(
                                                                'Add/Geo-tag PWS Source',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                              IconButton(
                                                                color: Colors
                                                                    .black,
                                                                onPressed: () {
                                                                  Stylefile.showmessageforvalidationfalse(
                                                                      context,
                                                                      "There is no scheme available in this village please contact to division officer.");
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .double_arrow_outlined,
                                                                  size: 20,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.all(0),
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
                                  padding: const EdgeInsets.only(
                                      left: 5,
                                      top: 5.0,
                                      right: 5.0,
                                      bottom: 5.0),
                                  child: Material(
                                    child: InkWell(
                                      splashColor: Appcolor.splashcolor,
                                      onTap: () {},
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                top: 10, bottom: 10, left: 5),
                                            child: Text(
                                              '(B).Scheme information board',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xffb3C53C2)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  margin: const EdgeInsets.only(
                                                      left: 5,
                                                      right: 5,
                                                      bottom: 10,
                                                      top: 0),
                                                  child: totalIBGeoTagged == "0"
                                                      ? Material(
                                                          elevation: 2.0,
                                                          color: Appcolor
                                                              .greeenlight,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          child: InkWell(
                                                            splashColor: Appcolor
                                                                .splashcolor,
                                                            customBorder:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                5.0,
                                                              ),
                                                            ),
                                                            child: Ink(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            5),
                                                                    child: const Center(
                                                                        child: Text(
                                                                      'Geo-tagged \n     and \napproved',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    )),
                                                                  ),
                                                                  const Divider(
                                                                    thickness:
                                                                        1,
                                                                    height: 10,
                                                                    color: Appcolor
                                                                        .lightgrey,
                                                                  ),
                                                                  Center(
                                                                      child:
                                                                          Text(
                                                                    totalIBGeoTagged
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Appcolor
                                                                            .btncolor),
                                                                  )),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Material(
                                                          elevation: 2.0,
                                                          color: Appcolor
                                                              .greeenlight,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          child: InkWell(
                                                            splashColor: Appcolor
                                                                .splashcolor,
                                                            customBorder:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                5.0,
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              try {
                                                                final result =
                                                                    await InternetAddress
                                                                        .lookup(
                                                                            'example.com');
                                                                if (result
                                                                        .isNotEmpty &&
                                                                    result[0]
                                                                        .rawAddress
                                                                        .isNotEmpty) {
                                                                  Get.to(Schemeinformationboard(
                                                                      send_district:
                                                                          District!,
                                                                      send_block:
                                                                          Block_village
                                                                              .toString(),
                                                                      send_panchayat:
                                                                          Panchayat_Name
                                                                              .toString(),
                                                                      villageid:
                                                                          widget
                                                                              .villageid,
                                                                      VillageName:
                                                                          widget
                                                                              .villagename,
                                                                      stateid:
                                                                          widget
                                                                              .stateid,
                                                                      token: box
                                                                          .read(
                                                                              "UserToken"),
                                                                      statusapproved:
                                                                          "1"));
                                                                }
                                                              } on SocketException catch (_) {
                                                                Stylefile
                                                                    .showmessageforvalidationfalse(
                                                                        context,
                                                                        "Unable to Connect to the Internet. Please check your network settings.");
                                                              }
                                                            },
                                                            child: Ink(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            5),
                                                                    child: const Center(
                                                                        child: Text(
                                                                      'Geo-tagged \n     and \napproved',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    )),
                                                                  ),
                                                                  const Divider(
                                                                    thickness:
                                                                        1,
                                                                    height: 10,
                                                                    color: Appcolor
                                                                        .lightgrey,
                                                                  ),
                                                                  Center(
                                                                      child:
                                                                          Text(
                                                                    totalIBGeoTagged
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Appcolor
                                                                            .btncolor),
                                                                  )),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xffb3C53C2)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  margin: const EdgeInsets.only(
                                                      left: 5,
                                                      right: 5,
                                                      bottom: 10,
                                                      top: 0),
                                                  child: GestureDetector(
                                                    onTap: pendingIBTotal == "0"
                                                        ? null
                                                        : () async {
                                                            try {
                                                              final result =
                                                                  await InternetAddress
                                                                      .lookup(
                                                                          'example.com');
                                                              if (result
                                                                      .isNotEmpty &&
                                                                  result[0]
                                                                      .rawAddress
                                                                      .isNotEmpty) {
                                                                Get.to(
                                                                    Schemeinformationboard(
                                                                  send_district:
                                                                      District!,
                                                                  send_block:
                                                                      Block_village
                                                                          .toString(),
                                                                  send_panchayat:
                                                                      Panchayat_Name
                                                                          .toString(),
                                                                  villageid: widget
                                                                      .villageid,
                                                                  VillageName:
                                                                      widget
                                                                          .villagename,
                                                                  stateid: widget
                                                                      .stateid,
                                                                  token: box.read(
                                                                      "UserToken"),
                                                                  statusapproved:
                                                                      "0",
                                                                ));
                                                              }
                                                            } on SocketException catch (_) {
                                                              Stylefile
                                                                  .showmessageforvalidationfalse(
                                                                      context,
                                                                      "Unable to Connect to the Internet. Please check your network settings.");
                                                            }
                                                          },
                                                    child: Material(
                                                      elevation: 2.0,
                                                      color:
                                                          Appcolor.lightyello,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      child: Ink(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                  'Pending \n     for \napproval',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                            ),
                                                            const Divider(
                                                              thickness: 1,
                                                              height: 10,
                                                              color: Appcolor
                                                                  .lightgrey,
                                                            ),
                                                            Center(
                                                              child: Text(
                                                                pendingIBTotal
                                                                    .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Appcolor
                                                                      .btncolor,
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
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 5,
                                                      right: 5,
                                                      bottom: 10,
                                                      top: 0),
                                                  decoration: BoxDecoration(
                                                      color: Appcolor.pinklight,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: const Color(
                                                                0xffb3C53C2)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: const Center(
                                                              child: Text(
                                                            ' \n   Balance   \n',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          )),
                                                        ),
                                                        const Divider(
                                                          thickness: 1,
                                                          height: 10,
                                                          color: Appcolor
                                                              .lightgrey,
                                                        ),
                                                        Center(
                                                            child: Text(
                                                          BalanceIBTotal
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Appcolor
                                                                  .btncolor),
                                                        )),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Get.to(OfflinentriesSIB(
                                                        villageid:
                                                            widget.villageid,
                                                        villagename:
                                                            widget.villagename,
                                                        stateid: widget.stateid,
                                                        block: Block_village
                                                            .toString(),
                                                        panchyat: Panchayat_Name
                                                            .toString(),
                                                        district:
                                                            District.toString(),
                                                        token: box
                                                            .read("UserToken")
                                                            .toString(),
                                                        statusapproved: "0"));
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: const Color(
                                                                0xffb3C53C2)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 2,
                                                            right: 5,
                                                            bottom: 10,
                                                            top: 0),
                                                    child: Material(
                                                      elevation: 2.0,
                                                      color:
                                                          Appcolor.greylightsec,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      child: InkWell(
                                                        customBorder:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            10.0,
                                                          ),
                                                        ),
                                                        child: Ink(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Get.to(OfflinentriesSIB(
                                                                      villageid:
                                                                          widget
                                                                              .villageid,
                                                                      villagename:
                                                                          widget
                                                                              .villagename,
                                                                      stateid:
                                                                          widget
                                                                              .stateid,
                                                                      block: Block_village
                                                                          .toString(),
                                                                      panchyat:
                                                                          Panchayat_Name
                                                                              .toString(),
                                                                      district:
                                                                          District
                                                                              .toString(),
                                                                      token: box
                                                                          .read(
                                                                              "UserToken")
                                                                          .toString(),
                                                                      statusapproved:
                                                                          "0"));
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5),
                                                                  child:
                                                                      const Center(
                                                                          child:
                                                                              Text(
                                                                    'Entries \n  to be\nuploaded',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  )),
                                                                ),
                                                              ),
                                                              const Divider(
                                                                thickness: 1,
                                                                height: 10,
                                                                color: Appcolor
                                                                    .lightgrey,
                                                              ),
                                                              Center(
                                                                  child: Text(
                                                                totalsibrecordvillagewise
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Appcolor
                                                                        .btncolor),
                                                              ))
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          totalschemes == 0
                                              ? Center(
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                      margin:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: const Color(
                                                                  0xffb3C53C2)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Material(
                                                        child: InkWell(
                                                          splashColor: Appcolor
                                                              .splashcolor,
                                                          customBorder:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          onTap: () {
                                                            Stylefile
                                                                .showmessageforvalidationfalse(
                                                                    context,
                                                                    "There is no scheme available in this village please contact to division officer.");
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Text(
                                                                'Add/Geo-tag Information Boards',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                              IconButton(
                                                                color: Colors
                                                                    .black,
                                                                onPressed:
                                                                    () async {
                                                                  Stylefile.showmessageforvalidationfalse(
                                                                      context,
                                                                      "There is no scheme available in this village please contact to division officer.");
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .double_arrow_outlined,
                                                                  size: 18,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )),
                                                )
                                              : Center(
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                      margin:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Material(
                                                        color: const Color(
                                                            0xFF0D3A98),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: InkWell(
                                                          splashColor: Appcolor
                                                              .splashcolor,
                                                          customBorder:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          onTap: () {
                                                            Get.to(NewTagWater(
                                                              clcikedstatus:
                                                                  "2",
                                                              stateid: widget
                                                                  .stateid,
                                                              villageid: widget
                                                                  .villageid,
                                                              villagename: widget
                                                                  .villagename,
                                                              districtname:
                                                                  District
                                                                      .toString(),
                                                              blockname:
                                                                  Block_village
                                                                      .toString(),
                                                              panchayatname:
                                                                  Panchayat_Name
                                                                      .toString(),
                                                            ));
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Text(
                                                                'Add/Geo-tag Information Boards',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              IconButton(
                                                                color: Colors
                                                                    .white,
                                                                onPressed:
                                                                    () async {
                                                                  Get.to(
                                                                      NewTagWater(
                                                                    clcikedstatus:
                                                                        "2",
                                                                    stateid: widget
                                                                        .stateid,
                                                                    villageid:
                                                                        widget
                                                                            .villageid,
                                                                    villagename:
                                                                        widget
                                                                            .villagename,
                                                                    districtname:
                                                                        District
                                                                            .toString(),
                                                                    blockname:
                                                                        Block_village
                                                                            .toString(),
                                                                    panchayatname:
                                                                        Panchayat_Name
                                                                            .toString(),
                                                                  ));
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .double_arrow_outlined,
                                                                  size: 18,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.all(0),
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
                                  padding: const EdgeInsets.only(
                                      left: 5,
                                      top: 5.0,
                                      right: 5.0,
                                      bottom: 5.0),
                                  child: Material(
                                    child: InkWell(
                                      splashColor: Appcolor.splashcolor,
                                      onTap: () {},
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                top: 10, bottom: 10, left: 5),
                                            child: Text(
                                              '(C). Storage Structure',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: TotalSSGeoTagged != "0"
                                                      ? Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: const Color(
                                                                      0xffb3C53C2)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: Material(
                                                            elevation: 2.0,
                                                            color: Appcolor
                                                                .greeenlight,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                            child: InkWell(
                                                              onTap: () async {
                                                                try {
                                                                  final result =
                                                                      await InternetAddress
                                                                          .lookup(
                                                                              'example.com');
                                                                  if (result
                                                                          .isNotEmpty &&
                                                                      result[0]
                                                                          .rawAddress
                                                                          .isNotEmpty) {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => Storagestructurependingapproved(
                                                                              villageid: widget.villageid,
                                                                              stateid: widget.stateid,
                                                                              token: box.read("UserToken"),
                                                                              villagename: widget.villagename,
                                                                              statusapproved: "1")),
                                                                    );
                                                                  }
                                                                } on SocketException catch (_) {
                                                                  Stylefile.showmessageforvalidationfalse(
                                                                      context,
                                                                      "Unable to Connect to the Internet. Please check your network settings.");
                                                                }
                                                              },
                                                              child: Ink(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              5),
                                                                      child: const Center(
                                                                          child: Text(
                                                                        'Geo-tagged\n     and \napproved',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontSize: 16),
                                                                      )),
                                                                    ),
                                                                    const Divider(
                                                                      thickness:
                                                                          1,
                                                                      height:
                                                                          10,
                                                                      color: Appcolor
                                                                          .lightgrey,
                                                                    ),
                                                                    Center(
                                                                        child:
                                                                            Text(
                                                                      TotalSSGeoTagged
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Appcolor.btncolor),
                                                                    )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: const Color(
                                                                      0xffb3C53C2)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: Material(
                                                            elevation: 2.0,
                                                            color: Appcolor
                                                                .greeenlight,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            child: InkWell(
                                                              splashColor: Appcolor
                                                                  .splashcolor,
                                                              customBorder:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  10.0,
                                                                ),
                                                              ),
                                                              child: Ink(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              5),
                                                                      child: const Center(
                                                                          child: Text(
                                                                        'Geo-tagged\n     and \napproved',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontSize: 16),
                                                                      )),
                                                                    ),
                                                                    const Divider(
                                                                      thickness:
                                                                          1,
                                                                      height:
                                                                          10,
                                                                      color: Appcolor
                                                                          .lightgrey,
                                                                    ),
                                                                    Center(
                                                                        child:
                                                                            Text(
                                                                      TotalSSGeoTagged
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Appcolor.btncolor),
                                                                    )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xffb3C53C2)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child:
                                                      PendingApprovalSSTotal !=
                                                              "0"
                                                          ? Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 0),
                                                              child: Material(
                                                                elevation: 2.0,
                                                                color: Appcolor
                                                                    .lightyello,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                                child: InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    try {
                                                                      final result =
                                                                          await InternetAddress.lookup(
                                                                              'example.com');
                                                                      if (result
                                                                              .isNotEmpty &&
                                                                          result[0]
                                                                              .rawAddress
                                                                              .isNotEmpty) {
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => Storagestructurependingapproved(villageid: widget.villageid, stateid: widget.stateid, token: box.read("UserToken"), villagename: widget.villagename, statusapproved: "0")),
                                                                        );
                                                                      }
                                                                    } on SocketException catch (_) {
                                                                      Stylefile.showmessageforvalidationfalse(
                                                                          context,
                                                                          "Unable to Connect to the Internet. Please check your network settings.");
                                                                    }
                                                                  },
                                                                  child: Ink(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              5),
                                                                          child: const Center(
                                                                              child: Text(
                                                                            'Pending \n     for \napproval',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                                                                          )),
                                                                        ),
                                                                        const Divider(
                                                                          thickness:
                                                                              1,
                                                                          height:
                                                                              10,
                                                                          color:
                                                                              Appcolor.lightgrey,
                                                                        ),
                                                                        Center(
                                                                            child:
                                                                                Text(
                                                                          PendingApprovalSSTotal
                                                                              .toString(),
                                                                          style: const TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Appcolor.btncolor),
                                                                        )),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                              decoration: BoxDecoration(
                                                                  color: Appcolor
                                                                      .lightyello,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: Material(
                                                                elevation: 2.0,
                                                                color: Appcolor
                                                                    .lightyello,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                                child: InkWell(
                                                                  splashColor:
                                                                      Appcolor
                                                                          .splashcolor,
                                                                  customBorder:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      10.0,
                                                                    ),
                                                                  ),
                                                                  child: Ink(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              5),
                                                                          child: const Center(
                                                                              child: Text(
                                                                            'Pending \n     for \napproval',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                                                                          )),
                                                                        ),
                                                                        const Divider(
                                                                          thickness:
                                                                              1,
                                                                          height:
                                                                              10,
                                                                          color:
                                                                              Appcolor.lightgrey,
                                                                        ),
                                                                        Center(
                                                                            child:
                                                                                Text(
                                                                          PendingApprovalSSTotal
                                                                              .toString(),
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                Appcolor.btncolor,
                                                                          ),
                                                                        )),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Get.to(
                                                        Offlineentriesforstoragestructure(
                                                            villageid: widget
                                                                .villageid,
                                                            villagename: widget
                                                                .villagename,
                                                            stateid:
                                                                widget.stateid,
                                                            block: Block_village
                                                                .toString(),
                                                            panchyat:
                                                                Panchayat_Name
                                                                    .toString(),
                                                            district: District
                                                                .toString(),
                                                            token: box
                                                                .read(
                                                                    "UserToken")
                                                                .toString(),
                                                            statusapproved:
                                                                "0"));
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: const Color(
                                                                0xffb3C53C2)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5,
                                                            right: 5,
                                                            bottom: 10,
                                                            top: 0),
                                                    child: Material(
                                                      elevation: 2.0,
                                                      color:
                                                          Appcolor.greylightsec,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      child: InkWell(
                                                        customBorder:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            5.0,
                                                          ),
                                                        ),
                                                        child: Ink(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Get.to(Offlineentriesforstoragestructure(
                                                                      villageid:
                                                                          widget
                                                                              .villageid,
                                                                      villagename:
                                                                          widget
                                                                              .villagename,
                                                                      stateid:
                                                                          widget
                                                                              .stateid,
                                                                      block: Block_village
                                                                          .toString(),
                                                                      panchyat:
                                                                          Panchayat_Name
                                                                              .toString(),
                                                                      district:
                                                                          District
                                                                              .toString(),
                                                                      token: box
                                                                          .read(
                                                                              "UserToken")
                                                                          .toString(),
                                                                      statusapproved:
                                                                          "0"));
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5),
                                                                  child:
                                                                      const Center(
                                                                          child:
                                                                              Text(
                                                                    'Entries \n  to be\nuploaded',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            16),
                                                                  )),
                                                                ),
                                                              ),
                                                              const Divider(
                                                                thickness: 1,
                                                                height: 10,
                                                                color: Appcolor
                                                                    .lightgrey,
                                                              ),
                                                              Center(
                                                                  child: Text(
                                                                totalotdatavillagewisess
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Appcolor
                                                                        .btncolor),
                                                              ))
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const Expanded(child: SizedBox()),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Center(
                                            child: Container(
                                                margin: const EdgeInsets.all(5),
                                                child: Material(
                                                  color:
                                                      const Color(0xFF0D3A98),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: InkWell(
                                                    splashColor:
                                                        Appcolor.splashcolor,
                                                    customBorder:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    onTap: () {
                                                      Get.to(NewTagWater(
                                                          clcikedstatus: "3",
                                                          stateid:
                                                              widget.stateid,
                                                          villageid:
                                                              widget.villageid,
                                                          villagename: widget
                                                              .villagename,
                                                          districtname: District
                                                              .toString(),
                                                          blockname:
                                                              Block_village
                                                                  .toString(),
                                                          panchayatname:
                                                              Panchayat_Name
                                                                  .toString()));
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Text(
                                                          'Add/Geo-tag Storage Structure',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        IconButton(
                                                          color: Colors.white,
                                                          onPressed: () {
                                                            Get.to(NewTagWater(
                                                                clcikedstatus:
                                                                    "3",
                                                                stateid: widget
                                                                    .stateid,
                                                                villageid: widget
                                                                    .villageid,
                                                                villagename: widget
                                                                    .villagename,
                                                                districtname:
                                                                    District
                                                                        .toString(),
                                                                blockname:
                                                                    Block_village
                                                                        .toString(),
                                                                panchayatname:
                                                                    Panchayat_Name
                                                                        .toString()));
                                                          },
                                                          icon: const Icon(
                                                            Icons
                                                                .double_arrow_outlined,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.all(0),
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
                                  padding: const EdgeInsets.only(
                                      left: 5,
                                      top: 5.0,
                                      right: 5.0,
                                      bottom: 5.0),
                                  child: Material(
                                    child: InkWell(
                                      splashColor: Appcolor.splashcolor,
                                      onTap: () {},
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                top: 10, bottom: 10, left: 5),
                                            child: Text(
                                              '(D). Other assets',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  left: 0,
                                                  right: 0,
                                                  bottom: 0,
                                                  top: 0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5,
                                                                  right: 5,
                                                                  bottom: 10,
                                                                  top: 0),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child:
                                                              totalOaGeoTagged !=
                                                                      "0"
                                                                  ? Container(
                                                                      decoration: BoxDecoration(
                                                                          border:
                                                                              Border.all(color: const Color(0xffb3C53C2)),
                                                                          borderRadius: BorderRadius.circular(5)),
                                                                      child:
                                                                          Material(
                                                                        elevation:
                                                                            2.0,
                                                                        color: Appcolor
                                                                            .greeenlight,
                                                                        borderRadius:
                                                                            BorderRadius.circular(5.0),
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            try {
                                                                              final result = await InternetAddress.lookup('example.com');
                                                                              if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                                                                Get.to(Otherassetsgeotaggedpendingapprove(villageid: widget.villageid, stateid: widget.stateid, token: box.read("UserToken"), villagename: widget.villagename, statusapproved: "1"));
                                                                              }
                                                                            } on SocketException catch (_) {
                                                                              Stylefile.showmessageforvalidationfalse(context, "Unable to Connect to the Internet. Please check your network settings.");
                                                                            }
                                                                          },
                                                                          child:
                                                                              Ink(
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Container(
                                                                                  width: MediaQuery.of(context).size.width,
                                                                                  padding: const EdgeInsets.all(5),
                                                                                  child: const Center(
                                                                                      child: Text(
                                                                                    'Geo-tagged\n     and \napproved',
                                                                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                                                                                  )),
                                                                                ),
                                                                                const Divider(
                                                                                  thickness: 1,
                                                                                  height: 10,
                                                                                  color: Appcolor.lightgrey,
                                                                                ),
                                                                                Center(
                                                                                    child: Text(
                                                                                  totalOaGeoTagged.toString(),
                                                                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Appcolor.btncolor),
                                                                                ))
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      decoration: BoxDecoration(
                                                                          border:
                                                                              Border.all(color: const Color(0xffb3C53C2)),
                                                                          borderRadius: BorderRadius.circular(5)),
                                                                      child:
                                                                          Material(
                                                                        elevation:
                                                                            2.0,
                                                                        color: Appcolor
                                                                            .greeenlight,
                                                                        borderRadius:
                                                                            BorderRadius.circular(5.0),
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              Appcolor.splashcolor,
                                                                          customBorder:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(
                                                                              10.0,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Ink(
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Container(
                                                                                  width: MediaQuery.of(context).size.width,
                                                                                  padding: const EdgeInsets.all(5),
                                                                                  child: const Center(
                                                                                      child: Text(
                                                                                    ' Geo-tagged \n     and \napproved',
                                                                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                                                                                  )),
                                                                                ),
                                                                                const Divider(
                                                                                  thickness: 1,
                                                                                  height: 10,
                                                                                  color: Appcolor.lightgrey,
                                                                                ),
                                                                                const Center(
                                                                                    child: Text(
                                                                                  "0",
                                                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Appcolor.btncolor),
                                                                                )),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: const Color(
                                                                      0xffb3C53C2)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5,
                                                                  right: 5,
                                                                  bottom: 10,
                                                                  top: 0),
                                                          child:
                                                              balanceOaTotal !=
                                                                      "0"
                                                                  ? Material(
                                                                      elevation:
                                                                          2.0,
                                                                      color: Appcolor
                                                                          .lightyello,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          try {
                                                                            final result =
                                                                                await InternetAddress.lookup('example.com');
                                                                            if (result.isNotEmpty &&
                                                                                result[0].rawAddress.isNotEmpty) {
                                                                              Get.to(Otherassetsgeotaggedpendingapprove(villageid: widget.villageid, stateid: widget.stateid, token: box.read("UserToken"), villagename: widget.villagename, statusapproved: "0"));
                                                                            }
                                                                          } on SocketException catch (_) {
                                                                            Stylefile.showmessageforvalidationfalse(context,
                                                                                "Unable to Connect to the Internet. Please check your network settings.");
                                                                          }
                                                                        },
                                                                        child:
                                                                            Ink(
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width,
                                                                                padding: const EdgeInsets.all(5),
                                                                                child: const Center(
                                                                                  child: Text(
                                                                                    'Pending \n     for \napproval',
                                                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const Divider(
                                                                                thickness: 1,
                                                                                height: 10,
                                                                                color: Appcolor.lightgrey,
                                                                              ),
                                                                              Center(
                                                                                child: Text(
                                                                                  balanceOaTotal.toString(),
                                                                                  style: const TextStyle(
                                                                                    fontSize: 18,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Appcolor.btncolor,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5)),
                                                                      child:
                                                                          Material(
                                                                        elevation:
                                                                            2.0,
                                                                        color: Appcolor
                                                                            .lightyello,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              Appcolor.splashcolor,
                                                                          customBorder:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(
                                                                              10.0,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Ink(
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Container(
                                                                                  width: MediaQuery.of(context).size.width,
                                                                                  padding: const EdgeInsets.all(5),
                                                                                  child: const Center(
                                                                                    child: Text(
                                                                                      'Pending \n     for \napproval',
                                                                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                const Divider(
                                                                                  thickness: 1,
                                                                                  height: 10,
                                                                                  color: Appcolor.lightgrey,
                                                                                ),
                                                                                Center(
                                                                                  child: Text(
                                                                                    balanceOaTotal.toString(),
                                                                                    style: const TextStyle(
                                                                                      fontSize: 18,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color: Appcolor.btncolor,
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
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Get.to(OfflineentriesOtherassets(
                                                                villageid: widget
                                                                    .villageid,
                                                                villagename: widget
                                                                    .villagename,
                                                                stateid: widget
                                                                    .stateid,
                                                                block: Block_village
                                                                    .toString(),
                                                                panchyat:
                                                                    Panchayat_Name
                                                                        .toString(),
                                                                district: District
                                                                    .toString(),
                                                                token: box
                                                                    .read(
                                                                        "UserToken")
                                                                    .toString(),
                                                                statusapproved:
                                                                    "0"));
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: const Color(
                                                                        0xffb3C53C2)),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 2,
                                                                    right: 5,
                                                                    bottom: 10,
                                                                    top: 0),
                                                            child: Material(
                                                              elevation: 2.0,
                                                              color: Appcolor
                                                                  .greylightsec,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                              child: InkWell(
                                                                customBorder:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    5.0,
                                                                  ),
                                                                ),
                                                                child: Ink(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Get.to(OfflineentriesOtherassets(
                                                                              villageid: widget.villageid,
                                                                              villagename: widget.villagename,
                                                                              stateid: widget.stateid,
                                                                              block: Block_village.toString(),
                                                                              panchyat: Panchayat_Name.toString(),
                                                                              district: District.toString(),
                                                                              token: box.read("UserToken").toString(),
                                                                              statusapproved: "0"));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              5),
                                                                          child: const Center(
                                                                              child: Text(
                                                                            'Entries \n  to be\nuploaded',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                                                                          )),
                                                                        ),
                                                                      ),
                                                                      const Divider(
                                                                        thickness:
                                                                            1,
                                                                        height:
                                                                            10,
                                                                        color: Appcolor
                                                                            .lightgrey,
                                                                      ),
                                                                      Center(
                                                                          child:
                                                                              Text(
                                                                        totalotdatavillagewiseot
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Appcolor.btncolor),
                                                                      ))
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const Expanded(
                                                          child: SizedBox()),
                                                    ],
                                                  )
                                                ],
                                              )),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Center(
                                            child: Container(
                                                margin: const EdgeInsets.all(5),
                                                child: Material(
                                                  color:
                                                      const Color(0xFF0D3A98),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: InkWell(
                                                    splashColor:
                                                        Appcolor.splashcolor,
                                                    customBorder:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    onTap: () {
                                                      Get.to(NewTagWater(
                                                          clcikedstatus: "4",
                                                          stateid:
                                                              widget.stateid,
                                                          villageid:
                                                              widget.villageid,
                                                          villagename: widget
                                                              .villagename,
                                                          districtname: District
                                                              .toString(),
                                                          blockname:
                                                              Block_village
                                                                  .toString(),
                                                          panchayatname:
                                                              Panchayat_Name
                                                                  .toString()));
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Text(
                                                          'Add/Geo-tag Other assets ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        IconButton(
                                                          color: Colors.white,
                                                          onPressed: () {
                                                            Get.to(NewTagWater(
                                                                clcikedstatus:
                                                                    "4",
                                                                stateid: widget
                                                                    .stateid,
                                                                villageid: widget
                                                                    .villageid,
                                                                villagename: widget
                                                                    .villagename,
                                                                districtname:
                                                                    District
                                                                        .toString(),
                                                                blockname:
                                                                    Block_village
                                                                        .toString(),
                                                                panchayatname:
                                                                    Panchayat_Name
                                                                        .toString()));
                                                          },
                                                          icon: const Icon(
                                                            Icons
                                                                .double_arrow_outlined,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  )),
              Positioned(
                left: fabPosition.dx
                    .clamp(0.0, MediaQuery.of(context).size.width - 56),
                top: fabPosition.dy
                    .clamp(0.0, MediaQuery.of(context).size.height - 56),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      fabPosition += details.delta;
                      fabPosition = Offset(
                        fabPosition.dx
                            .clamp(0.0, MediaQuery.of(context).size.width - 56),
                        fabPosition.dy.clamp(
                            0.0, MediaQuery.of(context).size.height - 56),
                      );
                    });
                  },
                  child: Container(
                    child: FloatingActionButton(
                      backgroundColor: Appcolor.btncolor,
                      child: floatingloader == true
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: Image.asset("images/loading.gif"))
                          : const Icon(Icons.refresh, color: Colors.white),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          final result =
                              await InternetAddress.lookup('example.com');
                          if (result.isNotEmpty &&
                              result[0].rawAddress.isNotEmpty) {
                            setState(() {
                              fetchDataAndUpdateUI();
                              fetchDateAndTimeFromTable(
                                  box.read("userid").toString());
                            });
                            cleartable_localmastertables();
                            setState(() {
                              floatingloader = true;
                            });
                            Apiservice.Getmasterapi(context).then((value) {
                              setState(() {
                                floatingloader = false;
                              });
                              setState(() {
                                _isLoading = false;
                              });

                              databaseHelperJalJeevan!.insertMasterapidatetime(
                                  Localmasterdatetime(
                                      UserId: box.read("userid").toString(),
                                      API_DateTime:
                                          value.API_DateTime.toString()));

                              for (int i = 0;
                                  i < value.villagelist!.length;
                                  i++) {
                                var userid = value.villagelist![i]!.userId;
                                var villageId = value.villagelist![i]!.villageId;
                                var stateId = value.villagelist![i]!.stateId;
                                var villageName =
                                    value.villagelist![i]!.VillageName;

                                databaseHelperJalJeevan
                                    ?.insertMastervillagelistdata(
                                        Localmasterdatanodal(
                                            UserId: userid.toString(),
                                            villageId: villageId.toString(),
                                            StateId: stateId.toString(),
                                            villageName:
                                                villageName.toString()))
                                    .then((value) {});
                              }
                              databaseHelperJalJeevan!.removeDuplicateEntries();

                              for (int i = 0;
                                  i < value.villageDetails!.length;
                                  i++) {
                                var stateName = "";

                                var districtName =
                                    value.villageDetails![i]!.districtName;
                                var stateid = value.villageDetails![i]!.stateId;
                                var blockName =
                                    value.villageDetails![i]!.blockName;
                                var panchayatName =
                                    value.villageDetails![i]!.panchayatName;
                                var stateidnew =
                                    value.villageDetails![i]!.stateId;
                                var userId = value.villageDetails![i]!.userId;
                                var villageIddetails =
                                    value.villageDetails![i]!.villageId;
                                var villageName =
                                    value.villageDetails![i]!.villageName;
                                var totalNoOfScheme =
                                    value.villageDetails![i]!.totalNoOfScheme;
                                var totalNoOfWaterSource = value
                                    .villageDetails![i]!.totalNoOfWaterSource;
                                var totalWsGeoTagged =
                                    value.villageDetails![i]!.totalWsGeoTagged;
                                var pendingWsTotal =
                                    value.villageDetails![i]!.pendingWsTotal;
                                var balanceWsTotal =
                                    value.villageDetails![i]!.balanceWsTotal;
                                var totalSsGeoTagged =
                                    value.villageDetails![i]!.totalSsGeoTagged;
                                var pendingApprovalSsTotal = value
                                    .villageDetails![i]!.pendingApprovalSsTotal;
                                var totalIbRequiredGeoTagged = value
                                    .villageDetails![i]!.totalIbRequiredGeoTagged;
                                var totalIbGeoTagged =
                                    value.villageDetails![i]!.totalIbGeoTagged;
                                var pendingIbTotal =
                                    value.villageDetails![i]!.pendingIbTotal;
                                var balanceIbTotal =
                                    value.villageDetails![i]!.balanceIbTotal;
                                var totalOaGeoTagged =
                                    value.villageDetails![i]!.totalOaGeoTagged;
                                var balanceOaTotal =
                                    value.villageDetails![i]!.balanceOaTotal;
                                var totalNoOfSchoolScheme = value
                                    .villageDetails![i]!.totalNoOfSchoolScheme;
                                var totalNoOfPwsScheme =
                                    value.villageDetails![i]!.totalNoOfPwsScheme;

                                databaseHelperJalJeevan
                                    ?.insertMastervillagedetails(
                                        Localmasterdatamodal_VillageDetails(
                                  status: "0",
                                  stateName: stateName,
                                  districtName: districtName,
                                  blockName: blockName,
                                  panchayatName: panchayatName,
                                  stateId: stateidnew.toString(),
                                  userId: userId.toString(),
                                  villageId: villageIddetails.toString(),
                                  villageName: villageName,
                                  totalNoOfScheme: totalNoOfScheme.toString(),
                                  totalNoOfWaterSource:
                                      totalNoOfWaterSource.toString(),
                                  totalWsGeoTagged: totalWsGeoTagged.toString(),
                                  pendingWsTotal: pendingWsTotal.toString(),
                                  balanceWsTotal: balanceWsTotal.toString(),
                                  totalSsGeoTagged: totalSsGeoTagged.toString(),
                                  pendingApprovalSsTotal:
                                      pendingApprovalSsTotal.toString(),
                                  totalIbRequiredGeoTagged:
                                      totalIbRequiredGeoTagged.toString(),
                                  totalIbGeoTagged: totalIbGeoTagged.toString(),
                                  pendingIbTotal: pendingIbTotal.toString(),
                                  balanceIbTotal: balanceIbTotal.toString(),
                                  totalOaGeoTagged: totalOaGeoTagged.toString(),
                                  balanceOaTotal: balanceOaTotal.toString(),
                                  totalNoOfSchoolScheme:
                                      totalNoOfSchoolScheme.toString(),
                                  totalNoOfPwsScheme:
                                      totalNoOfPwsScheme.toString(),
                                ));
                              }

                              for (int i = 0; i < value.schmelist!.length; i++) {
                                var source_type = value.schmelist![i]!.source_type;  var schemeidnew = value.schmelist![i]!.schemeid;
                                var villageid = value.schmelist![i]!.villageId;
                                var schemenamenew =
                                    value.schmelist![i]!.schemename;
                                var schemenacategorynew =
                                    value.schmelist![i]!.category;
                                var SourceTypeCategoryId = value.schmelist![i]!.SourceTypeCategoryId;
                                var source_typeCategory = value.schmelist![i]!.source_typeCategory;

                                databaseHelperJalJeevan?.insertMasterSchmelist(
                                    Localmasterdatamoda_Scheme(
                                      source_type: source_type.toString(),  schemeid: schemeidnew.toString(),
                                  villageId: villageid.toString(),
                                  schemename: schemenamenew.toString(),
                                  category: schemenacategorynew.toString(),
                                      SourceTypeCategoryId: SourceTypeCategoryId.toString(),
                                      source_typeCategory: source_typeCategory.toString(),
                                ));
                              }

                              for (int i = 0;
                                  i < value.sourcelist!.length;
                                  i++) {
                                var sourceId = value.sourcelist![i]!.sourceId;
                                var SchemeId = value.sourcelist![i]!.schemeId;
                                var stateid = value.sourcelist![i]!.stateid;
                                var Schemename = value.sourcelist![i]!.schemeName;
                                var villageid = value.sourcelist![i]!.villageId;
                                var sourceTypeId =
                                    value.sourcelist![i]!.sourceTypeId;
                                var statename = value.sourcelist![i]!.stateName;
                                var sourceTypeCategoryId =
                                    value.sourcelist![i]!.sourceTypeCategoryId;
                                var habitationId =
                                    value.sourcelist![i]!.habitationId;
                                var villageName =
                                    value.sourcelist![i]!.villageName;
                                var existTagWaterSourceId =
                                    value.sourcelist![i]!.existTagWaterSourceId;
                                var isApprovedState =
                                    value.sourcelist![i]!.isApprovedState;
                                var landmark = value.sourcelist![i]!.landmark;
                                var latitude = value.sourcelist![i]!.latitude;
                                var longitude = value.sourcelist![i]!.longitude;
                                var habitationName =
                                    value.sourcelist![i]!.habitationName;
                                var location = value.sourcelist![i]!.location;
                                var sourceTypeCategory =
                                    value.sourcelist![i]!.sourceTypeCategory;
                                var sourceType = value.sourcelist![i]!.sourceType;
                                var districtName =
                                    value.sourcelist![i]!.districtName;
                                var districtId = value.sourcelist![i]!.districtId;
                                var panchayatNamenew =
                                    value.sourcelist![i]!.panchayatName;
                                var blocknamenew =
                                    value.sourcelist![i]!.blockName;

                                databaseHelperJalJeevan
                                    ?.insertMasterSourcedetails(
                                        LocalSourcelistdetailsModal(
                                  schemeId: SchemeId.toString(),
                                  sourceId: sourceId.toString(),
                                  villageId: villageid.toString(),
                                  schemeName: Schemename,
                                  sourceTypeId: sourceTypeId.toString(),
                                  sourceTypeCategoryId:
                                      sourceTypeCategoryId.toString(),
                                  habitationId: habitationId.toString(),
                                  existTagWaterSourceId:
                                      existTagWaterSourceId.toString(),
                                  isApprovedState: isApprovedState.toString(),
                                  landmark: landmark,
                                  latitude: latitude.toString(),
                                  longitude: longitude.toString(),
                                  habitationName: habitationName,
                                  location: location,
                                  sourceTypeCategory: sourceTypeCategory,
                                  sourceType: sourceType,
                                  stateName: statename,
                                  districtName: districtName,
                                  blockName: blocknamenew,
                                  panchayatName: panchayatNamenew,
                                  districtId: districtId.toString(),
                                  villageName: villageName,
                                  stateId: stateid.toString(),
                                ));
                              }

                              for (int i = 0;
                                  i < value.habitationlist!.length;
                                  i++) {
                                var villafgeid =
                                    value.habitationlist![i]!.villageId;
                                var habitationId =
                                    value.habitationlist![i]!.habitationId;
                                var habitationName =
                                    value.habitationlist![i]!.habitationName;

                                databaseHelperJalJeevan
                                    ?.insertMasterhabitaionlist(
                                        LocalHabitaionlistModal(
                                            villageId: villafgeid.toString(),
                                            HabitationId:
                                                habitationId.toString(),
                                            HabitationName:
                                                habitationName.toString()));
                              }
                              for (int i = 0;
                                  i < value.informationBoardList!.length;
                                  i++) {
                                databaseHelperJalJeevan?.insertmastersibdetails(LocalmasterInformationBoardItemModal(
                                    userId: value.informationBoardList![i]!.userId
                                        .toString(),
                                    villageId: value.informationBoardList![i]!.villageId
                                        .toString(),
                                    stateId: value.informationBoardList![i]!.stateId
                                        .toString(),
                                    schemeId: value.informationBoardList![i]!.schemeId
                                        .toString(),
                                    districtName: value
                                        .informationBoardList![i]!.districtName,
                                    blockName:
                                        value.informationBoardList![i]!.blockName,
                                    panchayatName: value
                                        .informationBoardList![i]!.panchayatName,
                                    villageName: value
                                        .informationBoardList![i]!.villageName,
                                    habitationName:
                                        value.informationBoardList![i]!.habitationName,
                                    latitude: value.informationBoardList![i]!.latitude.toString(),
                                    longitude: value.informationBoardList![i]!.longitude.toString(),
                                    sourceName: value.informationBoardList![i]!.sourceName,
                                    schemeName: value.informationBoardList![i]!.schemeName,
                                    message: value.informationBoardList![i]!.message,
                                    status: value.informationBoardList![i]!.status.toString()));
                              }

                              showAlertDialog(context);
                            });
                          }
                        } on SocketException catch (_) {
                          setState(() {
                            _isLoading = false;
                          });
                          Stylefile.showmessageforvalidationfalse(context,
                              "Unable to Connect to the Internet. Please check your network settings.");
                        }
                      },
                    ),
                  ),
                ),
              ),
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Appcolor.btncolor),
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
