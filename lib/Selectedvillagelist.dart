import 'dart:async';

import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaljeevanmissiondynamic/localdatamodel/Localmasterdatamodal.dart';
import 'package:jaljeevanmissiondynamic/utility/Appcolor.dart';
import 'package:jaljeevanmissiondynamic/utility/Stylefile.dart';
import 'package:jaljeevanmissiondynamic/utility/Textfile.dart';
import 'package:jaljeevanmissiondynamic/view/Dashboard.dart';
import 'package:jaljeevanmissiondynamic/view/VillageDetails.dart';

import 'CommanScreen.dart';
import 'DisinfectionTagwater.dart';
import 'database/DataBaseHelperJalJeevan.dart';
import 'localdatamodel/Villagelistdatalocaldata.dart';
import 'view/LoginScreen.dart';

class Selectedvillaglist extends StatefulWidget {
  String stateId;
  String userId;
  String usertoken;

  Selectedvillaglist(
      {super.key,
      required this.stateId,
      required this.userId,
      required this.usertoken});

  @override
  State<Selectedvillaglist> createState() => _SelectedvillaglistState(
      stateId: stateId, userId: userId, usertoken: usertoken);
}

class _SelectedvillaglistState extends State<Selectedvillaglist> {
  GetStorage box = GetStorage();
  TextEditingController searchController = TextEditingController();
  String searchString = "";
  String gettotalvillage = "";
  String OfflineStatus = "";
  bool _loading = false;
  String stateId;
  String userId;
  String usertoken;

  _SelectedvillaglistState(
      {required this.stateId, required this.userId, required this.usertoken});

  DatabaseHelperJalJeevan? databaseHelperJalJeevan;
  bool isselect = true;
  List<dynamic> saveoffinevillaglist = [];
  int? index;
  var Nolistpresent;
  var totalsibrecord;
  List listone = [];
  var selectvillagelist;
  List<Localmasterdatanodal> offlinevillagelistlist = [];
  late Localmasterdatanodal localmasterdatanodal;
  bool _isLoading = false;
  late Future<List<Villagelistlocaldata>> villagelistlocal;
  List _newList = [];
  List list = [];
  List<Localmasterdatanodal> localpwspendingDataList = [];

  countdatain_sibtable() async {
    if (totalsibrecord == null) {
      totalsibrecord = 0;
    }

    totalsibrecord = await databaseHelperJalJeevan!.countRows_forsib();
  }

  callfornumber() async {
    if (Nolistpresent == null) {
      Nolistpresent = 0;
    }

    Nolistpresent = await databaseHelperJalJeevan!.countRows();
  }

  @override
  void initState() {
    super.initState();
    box.read("refreshtimerapi").toString();
    databaseHelperJalJeevan = DatabaseHelperJalJeevan();

    localmasterdatanodal = Localmasterdatanodal();

    if (box.read("UserToken").toString() == "null") {
      Get.offAll(LoginScreen());
      box.remove("UserToken").toString();
      Stylefile.showmessageforvalidationfalse(
          context, "Please login, your token has been expired!");
    }

    databaseHelperJalJeevan = DatabaseHelperJalJeevan();

    getAllofflinevillagelistfromdb(context);
    callfornumber();
  }

  Future<void> cleartable_localmasterschemelisttable() async {
    await databaseHelperJalJeevan!.truncateTable_localmasterschemelist();
    await databaseHelperJalJeevan!.cleardb_localmasterschemelist();
    await databaseHelperJalJeevan!.cleardb_sourcetypecategorytable();
    await databaseHelperJalJeevan!.cleardb_sourcassettypetable();
    await databaseHelperJalJeevan!.cleartable_villagelist();
    await databaseHelperJalJeevan!.cleartable_villagedetails();
    await databaseHelperJalJeevan!.cleardb_localhabitaionlisttable();
    await databaseHelperJalJeevan!.cleardb_sourcedetailstable();
    await databaseHelperJalJeevan!.truncatetable_dashboardtable();
    await databaseHelperJalJeevan!.truncatetable_sibmasterdeatils();
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

  Future<void> getAllofflinevillagelistfromdb(BuildContext context) async {
    setState(() {
      _loading = true;
    });
    await databaseHelperJalJeevan
        ?.getAllofflinevillagelistfromdb()
        .then((value) {
      setState(() {
        _loading = false;
      });

      offlinevillagelistlist = value.toList();
    });
  }

  List<dynamic> ListResponse = [];
  bool isFABVisible = true;
  Offset fabPosition = const Offset(1, 600);
  var VillageId;
  var VillageName;
  bool checkedValue = false;
  String checkedboxvalueselet = "";
  List<bool> isCheckedList = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Dashboard(
                  stateid: stateId, userid: userId, usertoken: usertoken)));

          return true;
        },
        child: FocusDetector(
          onVisibilityGained: () {},
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(40.0),
              child: AppBar(
                backgroundColor: const Color(0xFF0D3A98),
                iconTheme: const IconThemeData(
                  color: Appcolor.white,
                ),
                title: const Text("Village list",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
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
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Stack(
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
                            Column(
                              children: [
                                const SizedBox(
                                  height: 11,
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'images/bharat.png',
                                            width: 60,
                                            height: 60,
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
                                                    Text(
                                                        Textfile
                                                            .headingjaljeevan,
                                                        textAlign:
                                                            TextAlign.justify,
                                                        style: Stylefile
                                                            .mainheadingstyle),
                                                    SizedBox(
                                                      child: Text(
                                                          Textfile
                                                              .subheadingjaljeevan,
                                                          textAlign:
                                                              TextAlign.justify,
                                                          style: Stylefile
                                                              .submainheadingstyle),
                                                    ),
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
                                                titlePadding:
                                                    const EdgeInsets.only(
                                                        top: 0,
                                                        left: 0,
                                                        right: 00),
                                                buttonPadding:
                                                    const EdgeInsets.all(10),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
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
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "Jal jeevan mission",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Appcolor.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                content:
                                                    const SingleChildScrollView(
                                                  child: ListBody(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(
                                                          "Are you sure want to sign out from this application ?",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Appcolor
                                                                  .black),
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
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: TextButton(
                                                      child: const Text(
                                                        'No',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Appcolor.black),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
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
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: TextButton(
                                                      child: const Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Appcolor.black),
                                                      ),
                                                      onPressed: () async {
                                                        box.remove("UserToken");
                                                        box.remove('loginBool');
                                                        cleartable_localmasterschemelisttable();
                                                        Get.offAll(
                                                            LoginScreen());
                                                        Stylefile
                                                            .showmessageapisuccess(
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
                                          borderRadius:
                                              BorderRadius.circular(20.0),
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
                                    villageId: '0', villageName: "", no: 2),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: Material(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {});
                                      },
                                      child: Column(
                                        children: [
                                          const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Text(
                                                  'Select villages for geotagging assets',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Appcolor.headingcolor,
                                                      fontSize: 16),
                                                ),
                                              )),
                                          const Divider(
                                            thickness: 1,
                                            height: 10,
                                            color: Appcolor.lightgrey,
                                          ),
                                          _loading == true
                                              ? const CircularProgressIndicator()
                                              : Column(
                                                  children: [
                                                    offlinevillagelistlist
                                                                .length ==
                                                            0
                                                        ? const Center(
                                                            child: SizedBox(
                                                              height: 100,
                                                              child: Center(
                                                                  child: Text(
                                                                "No data found",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                ),
                                                              )),
                                                            ),
                                                          )
                                                        : Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            child: ListView
                                                                .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        const NeverScrollableScrollPhysics(),
                                                                    itemCount:
                                                                        offlinevillagelistlist
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            int index) {
                                                                      int counter =
                                                                          index +
                                                                              1;
                                                                      return offlinevillagelistlist[index]
                                                                              .villageName
                                                                              .toString()
                                                                              .toUpperCase()
                                                                              .toLowerCase()
                                                                              .contains(searchString.toLowerCase().toString())
                                                                          ? Container(
                                                                              margin: const EdgeInsets.all(5),
                                                                              child: Material(
                                                                                elevation: 2.0,
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                                child: InkWell(
                                                                                  splashColor: Appcolor.splashcolor,
                                                                                  customBorder: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                  ),
                                                                                  onTap: () {
                                                                                    var villageid = offlinevillagelistlist[index].villageId.toString();
                                                                                    var villagename = offlinevillagelistlist[index].villageName.toString();
                                                                                    print("villageid >"+offlinevillagelistlist[index].villageId.toString());

                                                                                    Get.to(VillageDetails(
                                                                                      villageid: offlinevillagelistlist[index].villageId.toString(),
                                                                                      villagename: villagename,
                                                                                      stateid: box.read("stateid"),
                                                                                      userID: userId,
                                                                                      token: usertoken,
                                                                                    ));

                                                                                /*    Get.to(DisinfectionTagwater(villageid: offlinevillagelistlist[index].villageId.toString(),
                                                                                      villagename: villagename,
                                                                                      stateid: box.read("stateid"),
                                                                                      userID: userId,
                                                                                      token: usertoken,));*/
                                                                                  },
                                                                                  child: Container(
                                                                                    margin: const EdgeInsets.all(10),
                                                                                    child: Container(
                                                                                        margin: const EdgeInsets.all(0),
                                                                                        height: 40,
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            SizedBox(
                                                                                              height: 40,
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.all(5.0),
                                                                                                    child: Text(
                                                                                                      counter.toString() + ".",
                                                                                                      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                                                                                                    ),
                                                                                                  ),
                                                                                                  const SizedBox(
                                                                                                    width: 10,
                                                                                                  ),
                                                                                                  Text(
                                                                                                    offlinevillagelistlist[index].villageName.toString(),
                                                                                                    style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            IconButton(
                                                                                              color: Colors.black,
                                                                                              onPressed: () {
                                                                                                var villageid = offlinevillagelistlist[index].villageId.toString();
                                                                                                var villagename = offlinevillagelistlist[index].villageName.toString();

                                                                                                Get.to(VillageDetails(
                                                                                                  villageid: offlinevillagelistlist[index].villageId.toString(),
                                                                                                  villagename: villagename,
                                                                                                  stateid: box.read("stateid"),
                                                                                                  userID: userId,
                                                                                                  token: usertoken,
                                                                                                ));
                                                                                              },
                                                                                              icon: const Icon(
                                                                                                Icons.double_arrow,
                                                                                                size: 20,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        )),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : const SizedBox();
                                                                    }),
                                                          )
                                                  ],
                                                )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
