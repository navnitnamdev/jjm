import 'dart:io';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaljeevanmissiondynamic/utility/Stylefile.dart';
import 'package:jaljeevanmissiondynamic/view/LoginScreen.dart';
import '../apiservice/Apiservice.dart';
import '../database/DataBaseHelperJalJeevan.dart';
import '../localdatamodel/LocalSIBsavemodal.dart';
import '../localdatamodel/Localmasterdatamodal.dart';
import '../localdatamodel/Localpwssourcemodal.dart';
import '../model/LocalOtherassetsofflinesavemodal.dart';
import '../model/LocalStoragestructureofflinesavemodal.dart';
import '../model/OtherassetsCommonmodal.dart';
import '../model/PWSCommonmodal.dart';
import '../model/SIBCommonmodal.dart';
import '../model/SSCommonmodal.dart';
import '../utility/Appcolor.dart';
import 'Dashboard.dart';

class Commonallofflineentries extends StatefulWidget {
  String clickforallscreen;

  Commonallofflineentries({required this.clickforallscreen, super.key});

  @override
  State<Commonallofflineentries> createState() =>
      _CommonallofflineentriesState();
}

class _CommonallofflineentriesState extends State<Commonallofflineentries>
    with SingleTickerProviderStateMixin {
  DatabaseHelperJalJeevan? databaseHelperJalJeevan;
  int successfulUploadCount = 0;
  GetStorage box = GetStorage();
  var totalpwsdatavillagewise;
  bool _loading = false;
  var villageidname;

  late LocalPWSSavedData localPWSSavedData;
  var villageid;
  List villaheone = [];
  List<PWSCommonmodal> pwssimplelistcommonscreen = [];
  List<SIBCommonmodal> sibsimplelistcommonscreen = [];
  List<OtherassetsCommonmodal> otherassetssimplelistcommonscreen = [];
  List<SSCommonmodal> sssimplelistcommonscreen = [];
  late PWSCommonmodal pwsCommonmodal;
  late SIBCommonmodal sibCommonmodal;
  late OtherassetsCommonmodal otherassetsCommonmodal;
  late SSCommonmodal ssCommonmodal;
  late TabController tabController;

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    databaseHelperJalJeevan = DatabaseHelperJalJeevan();
    pwsCommonmodal = PWSCommonmodal("", "", "", "", "", 0);
    sibCommonmodal = SIBCommonmodal("", "", "", "", "", 0);
    otherassetsCommonmodal = OtherassetsCommonmodal("", "", "", "", "", 0);
    ssCommonmodal = SSCommonmodal("", "", "", "", "", 0);

    setState(() {
      PWScommonfindallrecordsameVillageIds(context);
      SIBcommonfindallrecordsameVillageIds(context);
      OtherassetscommonfindallrecordsameVillageIds(context);
      StoragestructurecommonfindallrecordsameVillageIds(context);
    });

    if (box.read("UserToken").toString() == "null") {
      Get.off(LoginScreen());
      cleartable_localmasterschemelisttable();

      Stylefile.showmessageforvalidationfalse(
          context, "Please login your token has been expired!");
    }

    if (widget.clickforallscreen == "0") {
      tabController = TabController(
        initialIndex: 0,
        length:4,
        vsync: this,
      );
      tabController.addListener(_handleTabIndex);
    } else if (widget.clickforallscreen == "1") {
      tabController = TabController(
        initialIndex: 1,
        length: 4,
        vsync: this,
      );
      tabController.addListener(_handleTabIndex);
    } else if (widget.clickforallscreen == "2") {
      tabController = TabController(
        initialIndex: 2,
        length: 4,
        vsync: this,
      );
      tabController.addListener(_handleTabIndex);
    } else {
      tabController = TabController(
        initialIndex: 3,
        length: 4,
        vsync: this,
      );
      tabController.addListener(_handleTabIndex);
    }
  }

  Future<void> PWScommonfindallrecordsameVillageIds(
      BuildContext context) async {
    setState(() {
      _loading = true;
    });
    final sameVillageIds =
    await databaseHelperJalJeevan!.pwscommonfindallrecordsameVillageIds();
    setState(() {
      _loading = false;
    });
    sameVillageIds.forEach((row) {
      var id = row['id'];
      var vid = row['Villageid'];
      var name = row['villageName'];
      var pan = row['panchayatName'];
      var bloc = row['blockName'];
      var count = row['count'];
      villageidname = row['Villageid'];

      setState(() {
        pwssimplelistcommonscreen
            .add(PWSCommonmodal(id, vid, name, pan, bloc, count));
      });
    });
  }

  Future<void> SIBcommonfindallrecordsameVillageIds(
      BuildContext context) async {
    setState(() {
      _loading = true;
    });
    final sameVillageIds =
    await databaseHelperJalJeevan!.sibcommonfindallrecordsameVillageIds();
    setState(() {
      _loading = false;
    });
    sameVillageIds.forEach((row) {
      var id = row['id'];
      var vid = row['VillageId'];
      var name = row['VillageName'];
      var pan = row['PanchayatName'];
      var bloc = row['BlockName'];
      var count = row['count'];

      villageidname = row['VillageId'];
      sibsimplelistcommonscreen
          .add(SIBCommonmodal(id, vid, name, pan, bloc, count));
    });
  }

  Future<void> SScommonfindallrecordsameVillageIds(BuildContext context) async {
    setState(() {
      _loading = true;
    });
    final sameVillageIds =
    await databaseHelperJalJeevan!.sibcommonfindallrecordsameVillageIds();
    setState(() {
      _loading = false;
    });
    sameVillageIds.forEach((row) {
      var id = row['id'];
      var vid = row['VillageId'];
      var name = row['VillageName'];
      var pan = row['PanchayatName'];
      var bloc = row['BlockName'];
      var count = row['count'];

      villageidname = row['VillageId'];
      sibsimplelistcommonscreen
          .add(SIBCommonmodal(id, vid, name, pan, bloc, count));
    });
  }

  Future<void> OtherassetscommonfindallrecordsameVillageIds(
      BuildContext context) async {
    setState(() {
      _loading = true;
    });
    final sameVillageIds = await databaseHelperJalJeevan!
        .otherassetscommonfindallrecordsameVillageIds();
    setState(() {
      _loading = false;
    });
    sameVillageIds.forEach((row) {
      var id = row['id'];
      var vid = row['VillageId'];
      var name = row['VillageName'];
      var pan = row['PanchayatName'];
      var bloc = row['BlockName'];
      var count = row['count'];

      villageidname = row['VillageId'];
      otherassetssimplelistcommonscreen
          .add(OtherassetsCommonmodal(id, vid, name, pan, bloc, count));
    });
  }

  Future<void> StoragestructurecommonfindallrecordsameVillageIds(
      BuildContext context) async {
    setState(() {
      _loading = true;
    });
    final sameVillageIds = await databaseHelperJalJeevan!
        .structurestructurecommonfindallrecordsameVillageIds();
    setState(() {
      _loading = false;
    });
    sameVillageIds.forEach((row) {
      var id = row['id'];
      var vid = row['VillageId'];
      var name = row['VillageName'];
      var pan = row['PanchayatName'];
      var bloc = row['BlockName'];
      var count = row['count'];

      villageidname = row['VillageId'];
      sssimplelistcommonscreen.add(SSCommonmodal(id, vid, name, pan, bloc, count));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onVisibilityGained: () {},
      child: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Offline entries",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
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
              iconTheme: const IconThemeData(color: Appcolor.white),
              backgroundColor: Appcolor.btncolor,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(25.0),
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                      color: Appcolor.btncolor,
                      border: Border.all(
                        color: Appcolor.grey,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          5.0,
                        ),
                      )),
                  child: TabBar(
                    controller: tabController,
                    indicatorWeight: 0,
                    isScrollable: true,
                    indicatorColor: Appcolor.red,
                    automaticIndicatorColorAdjustment: true,
                    indicator: BoxDecoration(
                      color: Appcolor.blue,
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                      border: Border.all(
                        color: Appcolor.grey,
                        width: 1.0,
                      ),
                    ),
                    labelColor: Appcolor.white,
                    labelStyle: const TextStyle(fontSize: 18),
                    unselectedLabelColor: Appcolor.greysec,
                    unselectedLabelStyle: const TextStyle(fontSize: 14.0),
                    tabs: const [
                      Center(
                        child: Tab(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              "PWS Sources",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Tab(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              "Information Boards",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Tab(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              "Other assets",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Tab(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              "Storage structure",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/header_bg.png'),
                      fit: BoxFit.cover),
                ),
                child: TabBarView(
                  controller: tabController,
                  children: [
                    _loading == true
                        ? const Center(
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator()))
                        : pwssimplelistcommonscreen.length == 0
                        ? const Center(
                      child: Text(
                        "No data found",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    )
                        : ListView.builder(
                        itemCount: pwssimplelistcommonscreen.length,
                        shrinkWrap: true,
                        itemBuilder: (context, int index) {
                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                    top: 5,
                                    bottom: 5),
                                child: Material(
                                  elevation: 5.0,
                                  color: const Color(0xffFFFFFF),
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                  child: InkWell(
                                    onTap: () {},
                                    splashColor: Appcolor.splashcolor,
                                    customBorder:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10.0),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                          top: 5,
                                          bottom: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          const BorderRadius.all(
                                            Radius.circular(
                                              10.0,
                                            ),
                                          ),
                                          border: Border.all(
                                            color:
                                            const Color(0xFF223285),
                                            width: 1,
                                          )),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .only(
                                                      left: 5,
                                                      right: 5,
                                                      bottom: 8,
                                                      top: 8),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                2.0),
                                                            child: Text(
                                                              "Village:",
                                                              style: TextStyle(
                                                                  color: Appcolor
                                                                      .grey,
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                2.0),
                                                            child: Text(
                                                              pwssimplelistcommonscreen[
                                                              index]
                                                                  .villagename
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                  14),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                2.0),
                                                            child: Text(
                                                              "(Block :",
                                                              style: TextStyle(
                                                                  color: Appcolor
                                                                      .grey,
                                                                  fontSize:
                                                                  14),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                2.0),
                                                            child: Text(
                                                              pwssimplelistcommonscreen[
                                                              index]
                                                                  .blockname
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                  14),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                2.0),
                                                            child: Text(
                                                              ", GP :",
                                                              style: TextStyle(
                                                                  color: Appcolor
                                                                      .grey,
                                                                  fontSize:
                                                                  14),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                2.0),
                                                            child: Text(
                                                              "${pwssimplelistcommonscreen[index].villagepanchayat})",
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                  14),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .all(5.0),
                                                  child: Text(
                                                    pwssimplelistcommonscreen[
                                                    index]
                                                        .countofofflinesource
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        color: Appcolor
                                                            .black,
                                                        fontSize: 25),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const Divider(
                                              thickness: 1,
                                              height: 10,
                                              color: Appcolor.lightgrey,
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(
                                                  5.0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center,
                                                  children: [
                                                    SizedBox(
                                                      height: 25,
                                                      child:
                                                      Directionality(
                                                        textDirection:
                                                        TextDirection
                                                            .rtl,
                                                        child:
                                                        ElevatedButton
                                                            .icon(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary:
                                                            Appcolor
                                                                .orange,
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  5.0),
                                                            ),
                                                          ),
                                                          label:
                                                          const Text(
                                                            'Upload to server',
                                                            style: TextStyle(
                                                                fontSize:
                                                                16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Appcolor
                                                                    .white),
                                                          ),
                                                          onPressed:
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
                                                                uploadLocalDataAndClear(context, pwssimplelistcommonscreen[index].villageid.toString());
                                                              }
                                                            } on SocketException catch (_) {
                                                              Stylefile.showmessageforvalidationfalse(
                                                                  context,
                                                                  "Unable to Connect to the Internet. Please check your network settings.");
                                                            }
                                                          },
                                                          icon:
                                                          const Icon(
                                                            Icons
                                                                .upload,
                                                            color: Colors
                                                                .white,
                                                            size: 25.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    SizedBox(
                                                      height: 25,
                                                      child:
                                                      Directionality(
                                                        textDirection:
                                                        TextDirection
                                                            .rtl,
                                                        child:
                                                        ElevatedButton
                                                            .icon(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary:
                                                            Appcolor
                                                                .pink,
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  5.0),
                                                            ),
                                                          ),
                                                          label:
                                                          const Text(
                                                            'Remove',
                                                            style: TextStyle(
                                                                fontSize:
                                                                16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Appcolor
                                                                    .white),
                                                          ),
                                                          onPressed:
                                                              () async {
                                                            _showAlertDialogforuntaggeolocforpws(
                                                                pwssimplelistcommonscreen[index]
                                                                    .id
                                                                    .toString(),
                                                                index);
                                                          },
                                                          icon:
                                                          const Icon(
                                                            Icons
                                                                .delete_outline_outlined,
                                                            color: Colors
                                                                .white,
                                                            size: 25.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                    _loading == true
                        ? const Center(
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator()))
                        : sibsimplelistcommonscreen.length == 0
                        ? const Center(
                      child: Text(
                        "No data found",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    )
                        : ListView.builder(
                        shrinkWrap: true,
                        itemCount: sibsimplelistcommonscreen.length,
                        itemBuilder: (context, int index) {
                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                    top: 5,
                                    bottom: 5),
                                child: Material(
                                  elevation: 5.0,
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                  child: InkWell(
                                    onTap: () {},
                                    splashColor: Appcolor.splashcolor,
                                    customBorder:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10.0),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                          top: 5,
                                          bottom: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          const BorderRadius.all(
                                            Radius.circular(
                                              10.0,
                                            ),
                                          ),
                                          border: Border.all(
                                            color:
                                            const Color(0xFF223285),
                                            width: 1,
                                          )),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .only(
                                                      left: 5,
                                                      right: 5,
                                                      bottom: 8,
                                                      top: 8),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                2.0),
                                                            child: Text(
                                                              "Village:",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .bold,
                                                                  color: Appcolor
                                                                      .grey,
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                2.0),
                                                            child: Text(
                                                              sibsimplelistcommonscreen[
                                                              index]
                                                                  .villagename
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                2.0),
                                                            child: Text(
                                                              "(Block :",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .bold,
                                                                  color: Appcolor
                                                                      .grey,
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                2.0),
                                                            child: Text(
                                                              sibsimplelistcommonscreen[
                                                              index]
                                                                  .blockname
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          const Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                2.0),
                                                            child: Text(
                                                              ", GP :",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .bold,
                                                                  color: Appcolor
                                                                      .grey,
                                                                  fontSize:
                                                                  14),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                2.0),
                                                            child: Text(
                                                              sibsimplelistcommonscreen[index]
                                                                  .villagepanchayat
                                                                  .toString() +
                                                                  ")",
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .all(5.0),
                                                  child: Text(
                                                    sibsimplelistcommonscreen[
                                                    index]
                                                        .countofofflinesource
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        color: Appcolor
                                                            .black,
                                                        fontSize: 25),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const Divider(
                                              thickness: 1,
                                              height: 10,
                                              color: Appcolor.lightgrey,
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(
                                                  5.0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center,
                                                  children: [
                                                    SizedBox(
                                                      height: 25,
                                                      child:
                                                      Directionality(
                                                        textDirection:
                                                        TextDirection
                                                            .rtl,
                                                        child:
                                                        ElevatedButton
                                                            .icon(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary:
                                                            Appcolor
                                                                .orange,
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  5.0),
                                                            ),
                                                          ),
                                                          label:
                                                          const Text(
                                                            'Upload to server',
                                                            style: TextStyle(
                                                                fontSize:
                                                                16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Appcolor
                                                                    .white),
                                                          ),
                                                          onPressed:
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
                                                                sibindexwiseuploadLocalDataAndClear(
                                                                    context,
                                                                    sibsimplelistcommonscreen[index].villageid.toString());
                                                              }
                                                            } on SocketException catch (_) {
                                                              Stylefile.showmessageforvalidationfalse(
                                                                  context,
                                                                  "Unable to connect to the Internet. Please check your network settings.");
                                                            }
                                                          },
                                                          icon:
                                                          const Icon(
                                                            Icons
                                                                .upload,
                                                            color: Colors
                                                                .white,
                                                            size: 25.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    SizedBox(
                                                      height: 25,
                                                      child:
                                                      Directionality(
                                                        textDirection:
                                                        TextDirection
                                                            .rtl,
                                                        child:
                                                        ElevatedButton
                                                            .icon(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary:
                                                            Appcolor
                                                                .pink,
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  5.0),
                                                            ),
                                                          ),
                                                          label:
                                                          const Text(
                                                            'Remove',
                                                            style: TextStyle(
                                                                fontSize:
                                                                16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Appcolor
                                                                    .white),
                                                          ),
                                                          onPressed:
                                                              () async {
                                                            _showAlertDialogforuntaggeoloc(
                                                                sibsimplelistcommonscreen[index]
                                                                    .id
                                                                    .toString(),
                                                                index);
                                                          },
                                                          icon:
                                                          const Icon(
                                                            Icons
                                                                .delete_outline_outlined,
                                                            color: Colors
                                                                .white,
                                                            size: 25.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                    _loading == true
                        ? const Center(
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator()))
                        : otherassetssimplelistcommonscreen.length == 0
                        ? const Center(
                      child: Text(
                        "No data found",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    )
                        : ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                        otherassetssimplelistcommonscreen.length,
                        itemBuilder: (context, int index) {
                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                    top: 5,
                                    bottom: 5),
                                child: Material(
                                  elevation: 5.0,
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                  child: InkWell(
                                    onTap: () {},
                                    splashColor: Appcolor.splashcolor,
                                    customBorder:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10.0),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                          top: 5,
                                          bottom: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          const BorderRadius.all(
                                            Radius.circular(
                                              10.0,
                                            ),
                                          ),
                                          border: Border.all(
                                            color:
                                            const Color(0xFF223285),
                                            width: 1,
                                          )),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .only(
                                                      left: 5,
                                                      right: 5,
                                                      bottom: 8,
                                                      top: 8),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                2.0),
                                                            child: Text(
                                                              "Village:",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .bold,
                                                                  color: Appcolor
                                                                      .grey,
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                2.0),
                                                            child: Text(
                                                              otherassetssimplelistcommonscreen[
                                                              index]
                                                                  .villagename
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                2.0),
                                                            child: Text(
                                                              "(Block :",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .bold,
                                                                  color: Appcolor
                                                                      .grey,
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                2.0),
                                                            child: Text(
                                                              otherassetssimplelistcommonscreen[
                                                              index]
                                                                  .blockname
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          const Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                2.0),
                                                            child: Text(
                                                              ", GP :",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .bold,
                                                                  color: Appcolor
                                                                      .grey,
                                                                  fontSize:
                                                                  14),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                2.0),
                                                            child: Text(
                                                              otherassetssimplelistcommonscreen[index]
                                                                  .villagepanchayat
                                                                  .toString() +
                                                                  ")",
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .all(5.0),
                                                  child: Text(
                                                    otherassetssimplelistcommonscreen[
                                                    index]
                                                        .countofofflinesource
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        color: Appcolor
                                                            .black,
                                                        fontSize: 25),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const Divider(
                                              thickness: 1,
                                              height: 10,
                                              color: Appcolor.lightgrey,
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(
                                                  5.0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center,
                                                  children: [
                                                    SizedBox(
                                                      height: 25,
                                                      child:
                                                      Directionality(
                                                        textDirection:
                                                        TextDirection
                                                            .rtl,
                                                        child:
                                                        ElevatedButton
                                                            .icon(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary:
                                                            Appcolor
                                                                .orange,
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  5.0),
                                                            ),
                                                          ),
                                                          label:
                                                          const Text(
                                                            'Upload to server',
                                                            style: TextStyle(
                                                                fontSize:
                                                                16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Appcolor
                                                                    .white),
                                                          ),
                                                          onPressed:
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
                                                                OTindexwiseuploadLocalDataAndClear(
                                                                    context,
                                                                    otherassetssimplelistcommonscreen[index].villageid.toString());
                                                              }
                                                            } on SocketException catch (_) {
                                                              Stylefile.showmessageforvalidationfalse(
                                                                  context,
                                                                  "Unable to connect to the Internet. Please check your network settings.");
                                                            }
                                                          },
                                                          icon:
                                                          const Icon(
                                                            Icons
                                                                .upload,
                                                            color: Colors
                                                                .white,
                                                            size: 25.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    SizedBox(
                                                      height: 25,
                                                      child:
                                                      Directionality(
                                                        textDirection:
                                                        TextDirection
                                                            .rtl,
                                                        child:
                                                        ElevatedButton
                                                            .icon(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary:
                                                            Appcolor
                                                                .pink,
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  5.0),
                                                            ),
                                                          ),
                                                          label:
                                                          const Text(
                                                            'Remove',
                                                            style: TextStyle(
                                                                fontSize:
                                                                16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Appcolor
                                                                    .white),
                                                          ),
                                                          onPressed:
                                                              () async {
                                                            _showAlertDialogforuntaggeolocforotherasets(
                                                                otherassetssimplelistcommonscreen[index]
                                                                    .id
                                                                    .toString(),
                                                                index);
                                                          },
                                                          icon:
                                                          const Icon(
                                                            Icons
                                                                .delete_outline_outlined,
                                                            color: Colors
                                                                .white,
                                                            size: 25.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                    _loading == true
                        ? const Center(
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator()))
                        : sssimplelistcommonscreen.length == 0
                        ? const Center(
                      child: Text(
                        "No data found",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    )
                        : ListView.builder(
                        shrinkWrap: true,
                        itemCount: sssimplelistcommonscreen.length,
                        itemBuilder: (context, int index) {
                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                    top: 5,
                                    bottom: 5),
                                child: Material(
                                  elevation: 5.0,
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                  child: InkWell(
                                    onTap: () {},
                                    splashColor: Appcolor.splashcolor,
                                    customBorder:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10.0),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                          top: 5,
                                          bottom: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          const BorderRadius.all(
                                            Radius.circular(
                                              10.0,
                                            ),
                                          ),
                                          border: Border.all(
                                            color:
                                            const Color(0xFF223285),
                                            width: 1,
                                          )),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .only(
                                                      left: 5,
                                                      right: 5,
                                                      bottom: 8,
                                                      top: 8),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                2.0),
                                                            child: Text(
                                                              "Village:",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .bold,
                                                                  color: Appcolor
                                                                      .grey,
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                2.0),
                                                            child: Text(
                                                              sssimplelistcommonscreen[
                                                              index]
                                                                  .villagename
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                2.0),
                                                            child: Text(
                                                              "(Block :",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .bold,
                                                                  color: Appcolor
                                                                      .grey,
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                2.0),
                                                            child: Text(
                                                              sssimplelistcommonscreen[
                                                              index]
                                                                  .blockname
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          const Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                2.0),
                                                            child: Text(
                                                              ", GP :",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .bold,
                                                                  color: Appcolor
                                                                      .grey,
                                                                  fontSize:
                                                                  14),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                2.0),
                                                            child: Text(
                                                              sssimplelistcommonscreen[index]
                                                                  .villagepanchayat
                                                                  .toString() +
                                                                  ")",
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                  16),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .all(5.0),
                                                  child: Text(
                                                    sssimplelistcommonscreen[
                                                    index]
                                                        .countofofflinesource
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        color: Appcolor
                                                            .black,
                                                        fontSize: 25),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const Divider(
                                              thickness: 1,
                                              height: 10,
                                              color: Appcolor.lightgrey,
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(
                                                  5.0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center,
                                                  children: [
                                                    SizedBox(
                                                      height: 25,
                                                      child:
                                                      Directionality(
                                                        textDirection:
                                                        TextDirection
                                                            .rtl,
                                                        child:
                                                        ElevatedButton
                                                            .icon(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary:
                                                            Appcolor
                                                                .orange,
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  5.0),
                                                            ),
                                                          ),
                                                          label:
                                                          const Text(
                                                            'Upload to server',
                                                            style: TextStyle(
                                                                fontSize:
                                                                16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Appcolor
                                                                    .white),
                                                          ),
                                                          onPressed:
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
                                                                SSindexwiseuploadLocalDataAndClear(
                                                                    context,
                                                                    sssimplelistcommonscreen[index].villageid.toString());
                                                              }
                                                            } on SocketException catch (_) {
                                                              Stylefile.showmessageforvalidationfalse(
                                                                  context,
                                                                  "Unable to connect to the Internet. Please check your network settings.");
                                                            }
                                                          },
                                                          icon:
                                                          const Icon(
                                                            Icons
                                                                .upload,
                                                            color: Colors
                                                                .white,
                                                            size: 25.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    SizedBox(
                                                      height: 25,
                                                      child:
                                                      Directionality(
                                                        textDirection:
                                                        TextDirection
                                                            .rtl,
                                                        child:
                                                        ElevatedButton
                                                            .icon(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary:
                                                            Appcolor
                                                                .pink,
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  5.0),
                                                            ),
                                                          ),
                                                          label:
                                                          const Text(
                                                            'Remove',
                                                            style: TextStyle(
                                                                fontSize:
                                                                16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Appcolor
                                                                    .white),
                                                          ),
                                                          onPressed:
                                                              () async {
                                                            _showAlertDialogforuntagstoragestructure(
                                                                sssimplelistcommonscreen[index]
                                                                    .id
                                                                    .toString(),
                                                                index);
                                                          },
                                                          icon:
                                                          const Icon(
                                                            Icons
                                                                .delete_outline_outlined,
                                                            color: Colors
                                                                .white,
                                                            size: 25.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ],
                )),
            floatingActionButton: _bottomButtons(),
          )),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    tabController.removeListener(_handleTabIndex);

    super.dispose();
  }

  Future<void> uploadLocalDataAndClear(
      BuildContext context, String villageid) async {
    try {
      final List<LocalPWSSavedData>? localDataList =
      await databaseHelperJalJeevan?.getallpwssave_villagewise(villageid);
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
          localData.sourceTypeCategoryId.toString(),
          localData.landmark,
          localData.latitude,
          localData.longitude,
          localData.accuracy,
          localData.image,
        );

        if (response["Status"].toString() == "true") {
          successfulUploadCount++;
          await databaseHelperJalJeevan
              ?.truncateTableByVillageId_pwssavedonserver(localData.schemeId);
        } else {
          Stylefile.showmessageforvalidationfalse(
              context, "This source is alredy tagged");

          await databaseHelperJalJeevan?.updateStatusInPendingList(
              localData.villageId,
              localData.schemeId,
              'This source is already tagged');
        }
      }

      if (successfulUploadCount > 0) {
        Stylefile.showmessageforvalidationtrue(context,
            "$successfulUploadCount record(s) has been updated successfully.");
      }

      cleartable_localmasterschemelisttable();

      Get.back();
    } catch (e) {}
  }

  Future<void> cleartable_localmasterschemelisttable() async {
    await databaseHelperJalJeevan!.cleardb_localmasterschemelist();
    await databaseHelperJalJeevan!.cleartable_villagelist();
    await databaseHelperJalJeevan!.cleartable_villagedetails();
    await databaseHelperJalJeevan!.cleardb_localhabitaionlisttable();
    await databaseHelperJalJeevan!.cleardb_sourcedetailstable();
    await databaseHelperJalJeevan!.truncatetable_sibmasterdeatils();
    Apiservice.Getmasterapi(context).then((value) {
      for (int i = 0; i < value.villagelist!.length; i++) {
        var userid = value.villagelist![i]!.userId;

        var villageId = value.villagelist![i]!.villageId;
        var stateId = value.villagelist![i]!.stateId;
        var villageName = value.villagelist![i]!.VillageName;

        databaseHelperJalJeevan
            ?.insertMastervillagelistdata(Localmasterdatanodal(
            UserId: userid.toString(),
            villageId: villageId.toString(),
            StateId: stateId.toString(),
            villageName: villageName.toString()))
            .then((value) {});
      }
      databaseHelperJalJeevan!.removeDuplicateEntries();

      for (int i = 0; i < value.villageDetails!.length; i++) {
        var status = "";
        var stateName = "Assam";

        var districtName = value.villageDetails![i]!.districtName;
        var stateid = value.villageDetails![i]!.stateId;
        var blockName = value.villageDetails![i]!.blockName;
        var panchayatName = value.villageDetails![i]!.panchayatName;
        var stateidnew = value.villageDetails![i]!.stateId;
        var userId = value.villageDetails![i]!.userId;
        var villageIddetails = value.villageDetails![i]!.villageId;
        var villageName = value.villageDetails![i]!.villageName;
        var totalNoOfScheme = value.villageDetails![i]!.totalNoOfScheme;
        var totalNoOfWaterSource = value.villageDetails![i]!.totalNoOfWaterSource;
        var totalWsGeoTagged = value.villageDetails![i]!.totalWsGeoTagged;
        var pendingWsTotal = value.villageDetails![i]!.pendingWsTotal;
        var balanceWsTotal = value.villageDetails![i]!.balanceWsTotal;
        var totalSsGeoTagged = value.villageDetails![i]!.totalSsGeoTagged;
        var pendingApprovalSsTotal =
            value.villageDetails![i]!.pendingApprovalSsTotal;
        var totalIbRequiredGeoTagged =
            value.villageDetails![i]!.totalIbRequiredGeoTagged;
        var totalIbGeoTagged = value.villageDetails![i]!.totalIbGeoTagged;
        var pendingIbTotal = value.villageDetails![i]!.pendingIbTotal;
        var balanceIbTotal = value.villageDetails![i]!.balanceIbTotal;
        var totalOaGeoTagged = value.villageDetails![i]!.totalOaGeoTagged;
        var balanceOaTotal = value.villageDetails![i]!.balanceOaTotal;
        var totalNoOfSchoolScheme =
            value.villageDetails![i]!.totalNoOfSchoolScheme;
        var totalNoOfPwsScheme = value.villageDetails![i]!.totalNoOfPwsScheme;

        databaseHelperJalJeevan
            ?.insertMastervillagedetails(Localmasterdatamodal_VillageDetails(
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
          totalNoOfWaterSource: totalNoOfWaterSource.toString(),
          totalWsGeoTagged: totalWsGeoTagged.toString(),
          pendingWsTotal: pendingWsTotal.toString(),
          balanceWsTotal: balanceWsTotal.toString(),
          totalSsGeoTagged: totalSsGeoTagged.toString(),
          pendingApprovalSsTotal: pendingApprovalSsTotal.toString(),
          totalIbRequiredGeoTagged: totalIbRequiredGeoTagged.toString(),
          totalIbGeoTagged: totalIbGeoTagged.toString(),
          pendingIbTotal: pendingIbTotal.toString(),
          balanceIbTotal: balanceIbTotal.toString(),
          totalOaGeoTagged: totalOaGeoTagged.toString(),
          balanceOaTotal: balanceOaTotal.toString(),
          totalNoOfSchoolScheme: totalNoOfSchoolScheme.toString(),
          totalNoOfPwsScheme: totalNoOfPwsScheme.toString(),
        ));
      }

      for (int i = 0; i < value.schmelist!.length; i++) {
        var source_type = value.schmelist![i]!.source_type;
        var schemeidnew = value.schmelist![i]!.schemeid;
        var villageid = value.schmelist![i]!.villageId;
        var schemenamenew = value.schmelist![i]!.schemename;
        var schemenacategorynew = value.schmelist![i]!.category;
        var SourceTypeCategoryId = value.schmelist![i]!.SourceTypeCategoryId;
        var source_typeCategory = value.schmelist![i]!.source_typeCategory;
        databaseHelperJalJeevan
            ?.insertMasterSchmelist(Localmasterdatamoda_Scheme(
          source_type: source_type.toString(),
          schemeid: schemeidnew.toString(),
          villageId: villageid.toString(),
          schemename: schemenamenew.toString(),
          category: schemenacategorynew.toString(),
          SourceTypeCategoryId: SourceTypeCategoryId.toString(),
          source_typeCategory: source_typeCategory.toString(),
        ));
      }

      for (int i = 0; i < value.sourcelist!.length; i++) {
        var sourceId = value.sourcelist![i]!.sourceId;
        var SchemeId = value.sourcelist![i]!.schemeId;
        var stateid = value.sourcelist![i]!.stateid;
        var Schemename = value.sourcelist![i]!.schemeName;
        var villageid = value.sourcelist![i]!.villageId;
        var sourceTypeId = value.sourcelist![i]!.sourceTypeId;
        var statename = value.sourcelist![i]!.stateName;
        var sourceTypeCategoryId = value.sourcelist![i]!.sourceTypeCategoryId;
        var habitationId = value.sourcelist![i]!.habitationId;
        var villageName = value.sourcelist![i]!.villageName;
        var existTagWaterSourceId = value.sourcelist![i]!.existTagWaterSourceId;
        var isApprovedState = value.sourcelist![i]!.isApprovedState;
        var landmark = value.sourcelist![i]!.landmark;
        var latitude = value.sourcelist![i]!.latitude;
        var longitude = value.sourcelist![i]!.longitude;
        var habitationName = value.sourcelist![i]!.habitationName;
        var location = value.sourcelist![i]!.location;
        var sourceTypeCategory = value.sourcelist![i]!.sourceTypeCategory;
        var sourceType = value.sourcelist![i]!.sourceType;
        var districtName = value.sourcelist![i]!.districtName;
        var districtId = value.sourcelist![i]!.districtId;
        var panchayatNamenew = value.sourcelist![i]!.panchayatName;
        var blocknamenew = value.sourcelist![i]!.blockName;

        databaseHelperJalJeevan
            ?.insertMasterSourcedetails(LocalSourcelistdetailsModal(
          schemeId: SchemeId.toString(),
          sourceId: sourceId.toString(),
          villageId: villageid.toString(),
          schemeName: Schemename,
          sourceTypeId: sourceTypeId.toString(),
          sourceTypeCategoryId: sourceTypeCategoryId.toString(),
          habitationId: habitationId.toString(),
          existTagWaterSourceId: existTagWaterSourceId.toString(),
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

      for (int i = 0; i < value.habitationlist!.length; i++) {
        var villafgeid = value.habitationlist![i]!.villageId;
        var habitationId = value.habitationlist![i]!.habitationId;
        var habitationName = value.habitationlist![i]!.habitationName;

        databaseHelperJalJeevan?.insertMasterhabitaionlist(
            LocalHabitaionlistModal(
                villageId: villafgeid.toString(),
                HabitationId: habitationId.toString(),
                HabitationName: habitationName.toString()));
      }
      for (int i = 0; i < value.informationBoardList!.length; i++) {
        databaseHelperJalJeevan?.insertmastersibdetails(
            LocalmasterInformationBoardItemModal(
                userId: value.informationBoardList![i]!.userId.toString(),
                villageId: value.informationBoardList![i]!.villageId.toString(),
                stateId: value.informationBoardList![i]!.stateId.toString(),
                schemeId: value.informationBoardList![i]!.schemeId.toString(),
                districtName: value.informationBoardList![i]!.districtName,
                blockName: value.informationBoardList![i]!.blockName,
                panchayatName: value.informationBoardList![i]!.panchayatName,
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

  Future<void> sibindexwiseuploadLocalDataAndClear(
      BuildContext context, String villageid) async {
    try {
      final List<LocalSIBsavemodal>? localDataList =
      await databaseHelperJalJeevan
          ?.getsibsavedofflineentry_villageidwise(villageid);
      if (localDataList!.isEmpty) {
        return;
      }
      for (final localData in localDataList) {
        final response = await Apiservice.SIBSavetaggingapi(
            context,
            box.read("UserToken").toString(),
            box.read("userid").toString(),
            localData.villageId,
            localData.capturePointTypeId,
            localData.stateId,
            localData.schemeId,
            localData.sourceId,
            box.read("DivisionId").toString(),
            localData.habitationId,
            localData.landmark,
            localData.latitude,
            localData.longitude,
            localData.accuracy,
            localData.photo);

        if (response["Status"].toString() == "true") {
          successfulUploadCount++;
          await databaseHelperJalJeevan
              ?.truncateTableByVillageId_sibsaved(localData.schemeId);
        } else {
          await databaseHelperJalJeevan?.updateStatusInPendingListsib(
              localData.villageId,
              localData.schemeId,
              'This source is already tagged');
        }
      }

      if (successfulUploadCount > 0) {
        Stylefile.showmessageforvalidationtrue(context,
            "$successfulUploadCount record(s) has been updated successfully.");
      }

      sib_cleartable_localmasterschemelisttable();

      Get.back();
    } catch (e) {}
  }

  Future<void> OTindexwiseuploadLocalDataAndClear(
      BuildContext context, String villageid) async {
    try {
      final List<LocalOtherassetsofflinesavemodal>? localDataList =
      await databaseHelperJalJeevan
          ?.getallotherassetssave_villagewise(villageid);
      if (localDataList!.isEmpty) {
        return;
      }
      for (final localData in localDataList) {
        final response = await Apiservice.OtherassetSavetaggingapi(
            context,
            box.read("UserToken").toString(),
            box.read("userid").toString(),
            localData.villageId,
            localData.stateId,
            localData.schemeId,
            localData.sourceId,
            box.read("DivisionId").toString(),
            localData.habitationId,
            localData.landmark,
            localData.latitude,
            localData.longitude,
            localData.accuracy,
            localData.photo,
           // localData.capturePointTypeId
            localData.Selectassetsothercategory

        );


        if (response["Status"].toString() == "true") {
          successfulUploadCount++;
          await databaseHelperJalJeevan
              ?.truncateTableByVillageId_Ot(localData.schemeId);
        } else {
          await databaseHelperJalJeevan?.updateStatusInpendinglistot(
              localData.villageId,
              localData.schemeId,
              'This source is already tagged');
        }
      }

      if (successfulUploadCount > 0) {
        Stylefile.showmessageforvalidationtrue(context,
            "$successfulUploadCount record(s) has been updated successfully.");
      }

      sib_cleartable_localmasterschemelisttable();

      Get.back();
    } catch (e) {}
  }

  Future<void> SSindexwiseuploadLocalDataAndClear(
      BuildContext context, String villageid) async {
    try {
      final List<LocalStoragestructureofflinesavemodal>? localDataList =
      await databaseHelperJalJeevan
          ?.getallstoragestructurestructureofflineentry_villageidwise(
          villageid);
      if (localDataList!.isEmpty) {
        return;
      }
      for (final localData in localDataList) {
        final response = await Apiservice.StoragestructureSavetaggingapi(
          context,
          box.read("UserToken").toString(),
          box.read("userid").toString(),
          localData.villageId,
          localData.stateId,
          localData.schemeId,
          localData.sourceId,
          box.read("DivisionId").toString(),
          localData.habitationId,
          localData.landmark,
          localData.latitude,
          localData.longitude,
          localData.accuracy,
          localData.photo,
          localData.Storagecapacity,
          localData.Selectstoragecategory,
          /*/*localData.Storagecapacity,
          localData.Selectstoragecategory,*/*/
        );

        if (response["Status"].toString() == "true") {
          successfulUploadCount++;
          await databaseHelperJalJeevan
              ?.truncateTableByVillageId_sssaved(localData.schemeId);
        } else {
          await databaseHelperJalJeevan
              ?.updateStatusInPendingListstoragestructure(localData.villageId,
              localData.schemeId, 'This source is already tagged');
        }
      }

      if (successfulUploadCount > 0) {
        Stylefile.showmessageforvalidationtrue(context,
            "$successfulUploadCount record(s) has been updated successfully.");
      }

      sib_cleartable_localmasterschemelisttable();

      Get.back();
    } catch (e) {}
  }

  Future<void> cleartable_villllagedetails() async {
    await databaseHelperJalJeevan!.cleartable_villagedetails();
  }

  Future<void> sib_cleartable_localmasterschemelisttable() async {
    await databaseHelperJalJeevan!.cleardb_localmasterschemelist();
    await databaseHelperJalJeevan!.cleartable_villagelist();
    await databaseHelperJalJeevan!.cleartable_villagedetails();
    await databaseHelperJalJeevan!.cleardb_localhabitaionlisttable();
    await databaseHelperJalJeevan!.cleardb_sourcedetailstable();
    await databaseHelperJalJeevan!.cleardb_offlineviilagetable();
    await databaseHelperJalJeevan!.truncatetable_sibmasterdeatils();

    Apiservice.Getmasterapi(context).then((value) {
      for (int i = 0; i < value.villagelist!.length; i++) {
        var userid = value.villagelist![i]!.userId;

        var villageId = value.villagelist![i]!.villageId;
        var stateId = value.villagelist![i]!.stateId;
        var villageName = value.villagelist![i]!.VillageName;
        databaseHelperJalJeevan
            ?.insertMastervillagelistdata(Localmasterdatanodal(
            UserId: userid.toString(),
            villageId: villageId.toString(),
            StateId: stateId.toString(),
            villageName: villageName.toString()))
            .then((value) {});
      }
      databaseHelperJalJeevan!.removeDuplicateEntries();

      for (int i = 0; i < value.villageDetails!.length; i++) {
        var stateName = "Assam";

        var districtName = value.villageDetails![i]!.districtName;
        var blockName = value.villageDetails![i]!.blockName;
        var panchayatName = value.villageDetails![i]!.panchayatName;
        var stateidnew = value.villageDetails![i]!.stateId;
        var userId = value.villageDetails![i]!.userId;
        var villageIddetails = value.villageDetails![i]!.villageId;
        var villageName = value.villageDetails![i]!.villageName;
        var totalNoOfScheme = value.villageDetails![i]!.totalNoOfScheme;
        var totalNoOfWaterSource = value.villageDetails![i]!.totalNoOfWaterSource;
        var totalWsGeoTagged = value.villageDetails![i]!.totalWsGeoTagged;
        var pendingWsTotal = value.villageDetails![i]!.pendingWsTotal;
        var balanceWsTotal = value.villageDetails![i]!.balanceWsTotal;
        var totalSsGeoTagged = value.villageDetails![i]!.totalSsGeoTagged;
        var pendingApprovalSsTotal =
            value.villageDetails![i]!.pendingApprovalSsTotal;
        var totalIbRequiredGeoTagged =
            value.villageDetails![i]!.totalIbRequiredGeoTagged;
        var totalIbGeoTagged = value.villageDetails![i]!.totalIbGeoTagged;
        var pendingIbTotal = value.villageDetails![i]!.pendingIbTotal;
        var balanceIbTotal = value.villageDetails![i]!.balanceIbTotal;
        var totalOaGeoTagged = value.villageDetails![i]!.totalOaGeoTagged;
        var balanceOaTotal = value.villageDetails![i]!.balanceOaTotal;
        var totalNoOfSchoolScheme =
            value.villageDetails![i]!.totalNoOfSchoolScheme;
        var totalNoOfPwsScheme = value.villageDetails![i]!.totalNoOfPwsScheme;

        databaseHelperJalJeevan
            ?.insertMastervillagedetails(Localmasterdatamodal_VillageDetails(
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
          totalNoOfWaterSource: totalNoOfWaterSource.toString(),
          totalWsGeoTagged: totalWsGeoTagged.toString(),
          pendingWsTotal: pendingWsTotal.toString(),
          balanceWsTotal: balanceWsTotal.toString(),
          totalSsGeoTagged: totalSsGeoTagged.toString(),
          pendingApprovalSsTotal: pendingApprovalSsTotal.toString(),
          totalIbRequiredGeoTagged: totalIbRequiredGeoTagged.toString(),
          totalIbGeoTagged: totalIbGeoTagged.toString(),
          pendingIbTotal: pendingIbTotal.toString(),
          balanceIbTotal: balanceIbTotal.toString(),
          totalOaGeoTagged: totalOaGeoTagged.toString(),
          balanceOaTotal: balanceOaTotal.toString(),
          totalNoOfSchoolScheme: totalNoOfSchoolScheme.toString(),
          totalNoOfPwsScheme: totalNoOfPwsScheme.toString(),
        ));
      }

      for (int i = 0; i < value.schmelist!.length; i++) {
        var source_type = value.schmelist![i]!.source_type;
        var schemeidnew = value.schmelist![i]!.schemeid;
        var villageid = value.schmelist![i]!.villageId;
        var schemenamenew = value.schmelist![i]!.schemename;
        var schemenacategorynew = value.schmelist![i]!.category;
        var SourceTypeCategoryId = value.schmelist![i]!.SourceTypeCategoryId;
        var source_typeCategory = value.schmelist![i]!.source_typeCategory;

        databaseHelperJalJeevan
            ?.insertMasterSchmelist(Localmasterdatamoda_Scheme(
          source_type: source_type.toString(),
          schemeid: schemeidnew.toString(),
          villageId: villageid.toString(),
          schemename: schemenamenew.toString(),
          category: schemenacategorynew.toString(),
          SourceTypeCategoryId: SourceTypeCategoryId.toString(),
          source_typeCategory: source_typeCategory.toString(),
        ));
      }
      for (int i = 0; i < value.sourcelist!.length; i++) {
        var sourceId = value.sourcelist![i]!.sourceId;
        var SchemeId = value.sourcelist![i]!.schemeId;
        var stateid = value.sourcelist![i]!.stateid;
        var Schemename = value.sourcelist![i]!.schemeName;
        var villageid = value.sourcelist![i]!.villageId;
        var sourceTypeId = value.sourcelist![i]!.sourceTypeId;
        var statename = value.sourcelist![i]!.stateName;
        var sourceTypeCategoryId = value.sourcelist![i]!.sourceTypeCategoryId;
        var habitationId = value.sourcelist![i]!.habitationId;
        var villageName = value.sourcelist![i]!.villageName;
        var existTagWaterSourceId = value.sourcelist![i]!.existTagWaterSourceId;
        var isApprovedState = value.sourcelist![i]!.isApprovedState;
        var landmark = value.sourcelist![i]!.landmark;
        var latitude = value.sourcelist![i]!.latitude;
        var longitude = value.sourcelist![i]!.longitude;
        var habitationName = value.sourcelist![i]!.habitationName;
        var location = value.sourcelist![i]!.location;
        var sourceTypeCategory = value.sourcelist![i]!.sourceTypeCategory;
        var sourceType = value.sourcelist![i]!.sourceType;
        var districtName = value.sourcelist![i]!.districtName;
        var districtId = value.sourcelist![i]!.districtId;
        var panchayatNamenew = value.sourcelist![i]!.panchayatName;
        var blocknamenew = value.sourcelist![i]!.blockName;

        databaseHelperJalJeevan
            ?.insertMasterSourcedetails(LocalSourcelistdetailsModal(
          schemeId: SchemeId.toString(),
          sourceId: sourceId.toString(),
          villageId: villageid.toString(),
          schemeName: Schemename,
          sourceTypeId: sourceTypeId.toString(),
          sourceTypeCategoryId: sourceTypeCategoryId.toString(),
          habitationId: habitationId.toString(),
          existTagWaterSourceId: existTagWaterSourceId.toString(),
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
      for (int i = 0; i < value.habitationlist!.length; i++) {
        var villafgeid = value.habitationlist![i]!.villageId;
        var habitationId = value.habitationlist![i]!.habitationId;
        var habitationName = value.habitationlist![i]!.habitationName;

        databaseHelperJalJeevan?.insertMasterhabitaionlist(
            LocalHabitaionlistModal(
                villageId: villafgeid.toString(),
                HabitationId: habitationId.toString(),
                HabitationName: habitationName.toString()));
      }
      for (int i = 0; i < value.informationBoardList!.length; i++) {
        databaseHelperJalJeevan?.insertmastersibdetails(
            LocalmasterInformationBoardItemModal(
                userId: value.informationBoardList![i]!.userId.toString(),
                villageId: value.informationBoardList![i]!.villageId.toString(),
                stateId: value.informationBoardList![i]!.stateId.toString(),
                schemeId: value.informationBoardList![i]!.schemeId.toString(),
                districtName: value.informationBoardList![i]!.districtName,
                blockName: value.informationBoardList![i]!.blockName,
                panchayatName: value.informationBoardList![i]!.panchayatName,
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

  Widget _bottomButtons() {
    return tabController.index == 0 ||
        tabController.index == 1 ||
        tabController.index == 2 || tabController.index == 3
        ? FloatingActionButton(
        shape: const StadiumBorder(),
        onPressed: () {
          tabController.animateTo(1);
        },
        backgroundColor: Appcolor.red,
        child: const Icon(
          Icons.arrow_forward,
          color: Appcolor.white,
          size: 30.0,
        ))
        : FloatingActionButton(
      shape: const StadiumBorder(),
      onPressed: () {
        tabController.animateTo(0);
      },
      backgroundColor: Appcolor.red,
      child: const Icon(
        Icons.arrow_back,
        color: Appcolor.white,
        size: 30.0,
      ),
    );
  }

  Future<void> _showAlertDialogforuntaggeolocforpws(id, int index) async {
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
              padding: EdgeInsets.only(left: 30, top: 5, bottom: 5),
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
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Are you sure you want to remove it?",
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
                border: Border.all(
                  color: Appcolor.red,
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    30.0,
                  ),
                ),
              ),
              child: TextButton(
                child: const Text(
                  'No',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Appcolor.red),
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
                border: Border.all(
                  color: Appcolor.red,
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    30.0,
                  ),
                ),
              ),
              child: TextButton(
                child: const Text(
                  'Yes',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Appcolor.red),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await databaseHelperJalJeevan?.deleteRecordsByVillageIdpws(
                      pwssimplelistcommonscreen[index].villageid.toString());

                  Stylefile.showmessageforvalidationtrue(context, "Removed");
                  setState(() {
                    pwssimplelistcommonscreen.removeAt(index);
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAlertDialogforuntaggeoloc(id, int index) async {
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
              padding: EdgeInsets.only(left: 30, top: 5, bottom: 5),
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
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Are you sure you want to remove it?",
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
                border: Border.all(
                  color: Appcolor.red,
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    30.0,
                  ),
                ),
              ),
              child: TextButton(
                child: const Text(
                  'No',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Appcolor.red),
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
                border: Border.all(
                  color: Appcolor.red,
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    30.0,
                  ),
                ),
              ),
              child: TextButton(
                child: const Text(
                  'Yes',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Appcolor.red),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await databaseHelperJalJeevan?.deleteRecordsByVillageIdsib(
                      sibsimplelistcommonscreen[index].villageid.toString());

                  Stylefile.showmessageforvalidationtrue(context, "Removed");
                  setState(() {
                    sibsimplelistcommonscreen.removeAt(index);
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAlertDialogforuntaggeolocforotherasets(
      id, int index) async {
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
              padding: EdgeInsets.only(left: 30, top: 5, bottom: 5),
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
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Are you sure you want to remove it?",
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
                border: Border.all(
                  color: Appcolor.red,
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    30.0,
                  ),
                ),
              ),
              child: TextButton(
                child: const Text(
                  'No',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Appcolor.red),
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
                border: Border.all(
                  color: Appcolor.red,
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    30.0,
                  ),
                ),
              ),
              child: TextButton(
                child: const Text(
                  'Yes',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Appcolor.red),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await databaseHelperJalJeevan
                      ?.deleteRecordsByVillageIdotherassets(
                      otherassetssimplelistcommonscreen[index]
                          .villageid
                          .toString());

                  Stylefile.showmessageforvalidationtrue(context, "Removed");
                  setState(() {
                    otherassetssimplelistcommonscreen.removeAt(index);
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAlertDialogforuntagstoragestructure(id, int index) async {
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
              padding: EdgeInsets.only(left: 30, top: 5, bottom: 5),
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
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Are you sure you want to remove it?",
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
                border: Border.all(
                  color: Appcolor.red,
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    30.0,
                  ),
                ),
              ),
              child: TextButton(
                child: const Text(
                  'No',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Appcolor.red),
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
                border: Border.all(
                  color: Appcolor.red,
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    30.0,
                  ),
                ),
              ),
              child: TextButton(
                child: const Text(
                  'Yes',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Appcolor.red),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await databaseHelperJalJeevan
                      ?.deleteRecordsByVillageIdstoragestructure(
                      sssimplelistcommonscreen[index].villageid.toString());

                  Stylefile.showmessageforvalidationtrue(context, "Removed");
                  setState(() {
                    sssimplelistcommonscreen.removeAt(index);
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
