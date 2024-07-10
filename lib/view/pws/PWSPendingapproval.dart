import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jaljeevanmissiondynamic/apiservice/Apiservice.dart';
import 'package:jaljeevanmissiondynamic/localdatamodel/Localpwspendinglistmodal.dart';
import 'package:jaljeevanmissiondynamic/model/PWSPendingapprovalmodal.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../database/DataBaseHelperJalJeevan.dart';
import '../../localdatamodel/Localmasterdatamodal.dart';
import '../../localdatamodel/Localpwssourcemodal.dart';
import '../../utility/Appcolor.dart';
import '../../utility/Stylefile.dart';
import '../Dashboard.dart';
import '../LoginScreen.dart';
import '../SS/ZoomImage.dart';

class PWSPendingapproval extends StatefulWidget {
  String send_district;
  String send_block = "";
  String send_panchayat = "";
  String villageid = "";
  String villagename = "";
  String stateid = "";
  String token = "";
  String statusapproved = "";

  PWSPendingapproval(
      {required this.send_district,
      required this.send_block,
      required this.send_panchayat,
      required this.villageid,
      required this.villagename,
      required this.stateid,
      required this.token,
      required this.statusapproved,
      super.key});

  @override
  State<PWSPendingapproval> createState() => _PWSPendingapprovalState();
}

class _PWSPendingapprovalState extends State<PWSPendingapproval> {
  DatabaseHelperJalJeevan? databaseHelperJalJeevan;
  GetStorage box = GetStorage();
  var statusforapproveornot;
  var statusforapproveornot_message;
  var village;
  var message;

  var statusformodal;
  var Headingmessage;
  var Panchayat;
  var Block;
  var district;
  var getvillageid;
  var getstateid;
  var gettoken;
  var getstatusapproved;
  var villagename;
  bool _loading = false;
  bool offflinevisibility = false;
  bool onlinevisibility = true;
  List<LocalPWSSavedData> localpwspendingDataList = [];

  late PwsPendingapprovalmodal pwsPendingapprovalmodal;
  List<Result> pwspendinglistresult = [];
  var one = "";
  late Localpwspendinglistmodal localpwspendinglistmodal;

  @override
  void initState() {
    villagename = widget.villagename;
    getvillageid = widget.villageid;
    getstateid = widget.stateid;
    gettoken = widget.token;
    getstatusapproved = widget.statusapproved;

    pwsPendingapprovalmodal = PwsPendingapprovalmodal(
        status: true,
        message: "ff",
        district: "",
        block: "",
        panchayat: "",
        headingMessage: "",
        result: []);

    databaseHelperJalJeevan = DatabaseHelperJalJeevan();
    PWSPendingapprovalAPI(getvillageid, getstateid, box.read("userid"),
            getstatusapproved, gettoken)
        .then((value) {
      setState(() {});
    });

    setState(() {
      getallpendingpwsrecordfromdb(context);
    });

    super.initState();
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

  Future PWSPendingapprovalAPI(String villageid, String stateid, String userid,
      String status, String token) async {
    setState(() {
      _loading = true;
    });
    var response = await http.get(
      Uri.parse(
          "${Apiservice.baseurl}JJM_Mobile/GetGeotaggedWaterSource?VillageId=" +
              villageid +
              "&StateId=" +
              stateid +
              "&UserId=" +
              userid +
              "&Status=" +
              status),
      headers: {'Content-Type': 'application/json', 'APIKey': token},
    );
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> mResposne = jsonDecode(response.body);
        message = mResposne["Message"];

        if (message == "Token is wrong or expire") {
          setState(() {
            Get.off(LoginScreen());
            box.remove("UserToken").toString();
            cleartable_localmastertables();
          });
          Stylefile.showmessageforvalidationfalse(
              context, "Please login, your token has been expired!");
        } else {
          setState(() {
            district = mResposne["District"];
            Block = mResposne["Block"];
            Panchayat = mResposne["Panchayat"];
            pwspendinglistresult = (mResposne["Result"] as List<dynamic>)
                .map((item) => Result.fromJson(item))
                .toList();
          });
        }
      }
    } catch (e) {
      e.printError();
    } finally {
      _loading = false;
    }
  }

  Future<void> cleartable_villllagedetails() async {
    await databaseHelperJalJeevan!.cleartable_villagedetails();
  }

  Future RemovegeotaggedPWSAPI(String villageid, String stateid, String userid,
      String token, String taggedid, int index) async {
    var response = await http.get(
      Uri.parse(
          "${Apiservice.baseurl}JJM_Mobile/RemoveGeoTaggedWaterSource?VillageId=$villageid&StateId=$stateid&UserId=$userid&TaggedId=$taggedid"),
      headers: {'Content-Type': 'application/json', 'APIKey': token},
    );
    try {
      if (response.statusCode == 200) {
        var responseof = jsonDecode(response.body);
        var message = responseof["Message"].toString();
        var Status = responseof["Status"].toString();
        if (Status == "true") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(message.toString()),
            backgroundColor: Appcolor.greenmessagecolor,
          ));
        }
      }
    } catch (e) {
      e.printError();
    }
  }

  Future<void> getallpendingpwsrecordfromdb(BuildContext context) async {
    await databaseHelperJalJeevan?.getAllLocalPWSSavedData().then((value) {
      localpwspendingDataList = value.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onVisibilityGained: () {
        setState(() {});
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(40.0),
              child: AppBar(
                titleSpacing: 0,
                backgroundColor: const Color(0xFF0D3A98),
                iconTheme: const IconThemeData(
                  color: Appcolor.white,
                ),
                title: getstatusapproved == "1"
                    ? const Text("Geo-tagged PWS ( Approved )",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold))
                    : const Text("Geo-tagged PWS ( Pending )",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
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
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/header_bg.png'),
                          fit: BoxFit.cover),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SingleChildScrollView(
                              child:
                                  Provider.of<InternetConnectionStatus>(
                                              context) ==
                                          InternetConnectionStatus.disconnected
                                      ? const SizedBox(
                                          child: Center(
                                            child: Text(
                                              "Unable to Connect to the Internet. Please check your network settings.",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      : _loading == true
                                          ? const Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator()),
                                              ),
                                            )
                                          : pwspendinglistresult.length == 0
                                              ? Center(
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    child: const Center(
                                                        child: Text(
                                                      "No data found",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Appcolor.black),
                                                    )),
                                                  ),
                                                )
                                              : Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      top: 10,
                                                      bottom: 10),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              'Village : ${widget.villagename}',
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 16,
                                                                  color: Appcolor
                                                                      .headingcolor),
                                                            )),
                                                      ),
                                                      const Divider(
                                                        thickness: 1,
                                                        height: 10,
                                                        color:
                                                            Appcolor.lightgrey,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    bottom: 5),
                                                            child: SizedBox(
                                                                child: Text(
                                                              "District:",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Appcolor
                                                                      .black),
                                                            )),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10,
                                                                    bottom: 5),
                                                            child: SizedBox(
                                                                child: Text(
                                                              widget
                                                                  .send_district,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Appcolor
                                                                      .black,
                                                                  fontSize: 16),
                                                            )),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    bottom: 5),
                                                            child: SizedBox(
                                                                child: Text(
                                                              "Block:",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Appcolor
                                                                      .black),
                                                            )),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10,
                                                                    bottom: 5),
                                                            child: SizedBox(
                                                                child: Text(
                                                              widget.send_block
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Appcolor
                                                                      .black,
                                                                  fontSize: 16),
                                                            )),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    bottom: 5),
                                                            child: SizedBox(
                                                                child: Text(
                                                              "Panchayat:",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Appcolor
                                                                      .black),
                                                            )),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10,
                                                                    bottom: 5),
                                                            child: SizedBox(
                                                                child: Text(
                                                              widget
                                                                  .send_panchayat
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Appcolor
                                                                      .black,
                                                                  fontSize: 16),
                                                            )),
                                                          )
                                                        ],
                                                      ),
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color(
                                                                    0xFFFFFFFF)
                                                                .withOpacity(
                                                                    0.3),
                                                            border: Border.all(
                                                              color:
                                                                  Colors.green,
                                                              width: 1,
                                                            ),
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                10.0,
                                                              ),
                                                            ),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              pwspendinglistresult
                                                                          .length ==
                                                                      0
                                                                  ? const Center(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.all(10.0),
                                                                        child:
                                                                            Text(
                                                                          "No data found",
                                                                          style:
                                                                              TextStyle(color: Appcolor.black),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  :
                                                              ListView
                                                                      .builder(
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemCount: pwspendinglistresult
                                                                              .length,
                                                                          physics:
                                                                              const NeverScrollableScrollPhysics(),
                                                                          itemBuilder:
                                                                              (context, int index) {
                                                                            villagename =
                                                                                pwspendinglistresult[index].villageName.toString();
                                                                            statusforapproveornot =
                                                                                pwspendinglistresult[index].status.toString();
                                                                            statusforapproveornot_message =
                                                                                pwspendinglistresult[index].message.toString();
                                                                            int counter =
                                                                                index + 1;
                                                                            return Container(
                                                                                margin: const EdgeInsets.all(5),
                                                                                width: double.infinity,
                                                                                alignment: Alignment.center,
                                                                                decoration: BoxDecoration(color: Colors.white, border: Border.all(width: 1, color: Appcolor.greenmessagecolor), borderRadius: BorderRadius.circular(10)),
                                                                                padding: const EdgeInsets.all(5),
                                                                                child: Material(
                                                                                  elevation: 0,
                                                                                  child: InkWell(
                                                                                    splashColor: Appcolor.lightyello,
                                                                                    onTap: () {},
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(5.0),
                                                                                          child: Align(
                                                                                              alignment: Alignment.centerLeft,
                                                                                              child: Text(
                                                                                                "" + counter.toString() + ".",
                                                                                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                                                              )),
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            const Padding(
                                                                                              padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                              child: SizedBox(
                                                                                                  child: Text(
                                                                                                "Scheme:",
                                                                                                style: TextStyle(fontWeight: FontWeight.bold, color: Appcolor.black, fontSize: 16),
                                                                                              )),
                                                                                            ),
                                                                                            Flexible(

                                                                                                child: Padding(
                                                                                                  padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                                  child: Text(
                                                                                                    maxLines: 2,
                                                                                                    pwspendinglistresult[index].schemeName.toString(),
                                                                                                    style: const TextStyle(fontWeight: FontWeight.w400, color: Appcolor.black, fontSize: 16),
                                                                                                  ),
                                                                                                ))
                                                                                          ],
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            const Padding(
                                                                                              padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                              child: SizedBox(
                                                                                                  width: 100,
                                                                                                  child: Text(
                                                                                                    "Habitation :",
                                                                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Appcolor.black, fontSize: 16),
                                                                                                  )),
                                                                                            ),
                                                                                            Flexible(
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                                child: Text(
                                                                                                  pwspendinglistresult[index].habitationName.toString(),
                                                                                                  style: const TextStyle(fontWeight: FontWeight.w400, color: Appcolor.black, fontSize: 16),
                                                                                                ),
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            const Padding(
                                                                                              padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                              child: SizedBox(
                                                                                                  child: Text(
                                                                                                "Location :",
                                                                                                style: TextStyle(fontWeight: FontWeight.bold, color: Appcolor.black, fontSize: 16),
                                                                                              )),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                              child: SizedBox(
                                                                                                  width: 180,
                                                                                                  child: Text(
                                                                                                    maxLines: 10,
                                                                                                    pwspendinglistresult[index].sourceName.toString(),
                                                                                                    style: const TextStyle(fontWeight: FontWeight.w400, color: Appcolor.black, fontSize: 16),
                                                                                                  )),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            const Padding(
                                                                                              padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                              child: SizedBox(
                                                                                                  child: Text(
                                                                                                maxLines: 2,
                                                                                                "Source Category :",
                                                                                                style: TextStyle(fontWeight: FontWeight.bold, color: Appcolor.black, fontSize: 16),
                                                                                              )),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                              child: SizedBox(
                                                                                                  child: Text(
                                                                                                maxLines: 10,
                                                                                                textAlign: TextAlign.justify,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                pwspendinglistresult[index].sourceCatogery.toString().toString(),
                                                                                                style: const TextStyle(
                                                                                                  fontWeight: FontWeight.w400,
                                                                                                  color: Appcolor.black,
                                                                                                  fontSize: 16,
                                                                                                ),
                                                                                              )),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            const Padding(
                                                                                              padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                              child: SizedBox(
                                                                                                  child: Text(
                                                                                                maxLines: 2,
                                                                                                "Source Type :",
                                                                                                style: TextStyle(
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  color: Appcolor.black,
                                                                                                  fontSize: 16,
                                                                                                ),
                                                                                              )),
                                                                                            ),
                                                                                            Flexible(
                                                                                                child: Padding(
                                                                                                  padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                                  child: Text(
                                                                                                       maxLines: 10,
                                                                                                       textAlign: TextAlign.justify,
                                                                                                       overflow: TextOverflow.ellipsis,
                                                                                                       pwspendinglistresult[index].sourcetype.toString().toString(),
                                                                                                       style: const TextStyle(fontWeight: FontWeight.w400, color: Appcolor.black, fontSize: 16),
                                                                                                     ),
                                                                                                ))
                                                                                          ],
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            const Padding(
                                                                                              padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                              child: SizedBox(
                                                                                                  child: Text(
                                                                                                "Latitude :",
                                                                                                style: TextStyle(fontWeight: FontWeight.bold, color: Appcolor.black, fontSize: 16),
                                                                                              )),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                              child: SizedBox(
                                                                                                  width: 180,
                                                                                                  child: Text(
                                                                                                    maxLines: 10,
                                                                                                    textAlign: TextAlign.justify,
                                                                                                    overflow: TextOverflow.ellipsis,
                                                                                                    pwspendinglistresult[index].latitude.toString().toString(),
                                                                                                    style: const TextStyle(fontWeight: FontWeight.w400, color: Appcolor.black, fontSize: 16),
                                                                                                  )),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            const Padding(
                                                                                              padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                              child: SizedBox(
                                                                                                  child: Text(
                                                                                                "Longitude :",
                                                                                                style: TextStyle(fontWeight: FontWeight.bold, color: Appcolor.black, fontSize: 16),
                                                                                              )),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                              child: SizedBox(
                                                                                                  width: 180,
                                                                                                  child: Text(
                                                                                                    textAlign: TextAlign.justify,
                                                                                                    maxLines: 5,
                                                                                                    overflow: TextOverflow.ellipsis,
                                                                                                    pwspendinglistresult[index].longitude.toString().toString(),
                                                                                                    style: const TextStyle(fontWeight: FontWeight.w400, color: Appcolor.black, fontSize: 16),
                                                                                                  )),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            const Padding(
                                                                                              padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                              child: SizedBox(
                                                                                                  child: Text(
                                                                                                "Status :",
                                                                                                style: TextStyle(fontWeight: FontWeight.bold, color: Appcolor.black, fontSize: 16),
                                                                                              )),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                              child: SizedBox(
                                                                                                  child: Text(
                                                                                                textAlign: TextAlign.justify,
                                                                                                maxLines: 5,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                pwspendinglistresult[index].message.toString().toString(),
                                                                                                style: const TextStyle(fontWeight: FontWeight.w400, color: Appcolor.red, fontSize: 16),
                                                                                              )),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                        const Divider(
                                                                                          thickness: 1,
                                                                                          height: 10,
                                                                                          color: Appcolor.lightgrey,
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.end, children: [
                                                                                            SizedBox(
                                                                                              height: 25,
                                                                                              child: ElevatedButton.icon(
                                                                                                style: ElevatedButton.styleFrom(
                                                                                                  primary: Appcolor.lightgrey,
                                                                                                  shape: RoundedRectangleBorder(
                                                                                                    borderRadius: BorderRadius.circular(5.0),
                                                                                                  ),
                                                                                                ),
                                                                                                onPressed: () {

                                                                                                  Get.to(ZoomImage(
                                                                                                    imgurl: pwspendinglistresult[index].imageUrl.toString(),
                                                                                                    lat: pwspendinglistresult[index].latitude.toString(),
                                                                                                    long: pwspendinglistresult[index].longitude.toString(),
                                                                                                  ));
                                                                                                },
                                                                                                icon: const Icon(
                                                                                                  Icons.remove_red_eye_outlined,
                                                                                                  size: 18,
                                                                                                  color: Appcolor.white,
                                                                                                ),
                                                                                                label: const Text(
                                                                                                  "View",
                                                                                                  style: TextStyle(color: Appcolor.white, fontSize: 12, fontWeight: FontWeight.w400),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            const SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            getstatusapproved == "1"
                                                                                                ? const SizedBox()
                                                                                                : SizedBox(
                                                                                                    height: 25,
                                                                                                    child: ElevatedButton.icon(
                                                                                                      style: ElevatedButton.styleFrom(
                                                                                                        primary: Appcolor.pink,
                                                                                                        shape: RoundedRectangleBorder(
                                                                                                          borderRadius: BorderRadius.circular(5.0),
                                                                                                        ),
                                                                                                      ),
                                                                                                      onPressed: () {
                                                                                                        showuntagedalertbox(pwspendinglistresult[index].villageId.toString(), pwspendinglistresult[index].stateId.toString(), box.read("userid").toString(), gettoken, pwspendinglistresult[index].taggedId.toString(), index).then((value) {
                                                                                                          setState(() {});
                                                                                                        });
                                                                                                      },
                                                                                                      icon: const Icon(
                                                                                                        size: 18.0,
                                                                                                        Icons.delete_outline_outlined,
                                                                                                        color: Appcolor.white,
                                                                                                      ),
                                                                                                      label: const Text(
                                                                                                        "Remove",
                                                                                                        style: TextStyle(color: Appcolor.white, fontSize: 12, fontWeight: FontWeight.w400),
                                                                                                      ),
                                                                                                    ),
                                                                                                  )
                                                                                          ]),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ));
                                                                          }),
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                )),
                          Visibility(
                            visible: offflinevisibility,
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF).withOpacity(0.3),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(
                                    10.0,
                                  ),
                                ),
                              ),
                              child: localpwspendingDataList.length == 0
                                  ? const SizedBox(
                                      child: Text("No data found"),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 30,
                                          child: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                primary: Appcolor.orange,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                              ),
                                              label: const Text(
                                                'Upload to server',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Appcolor.white),
                                              ),
                                              onPressed: () async {
                                                try {
                                                  final result =
                                                      await InternetAddress
                                                          .lookup(
                                                              'example.com');
                                                  if (result.isNotEmpty &&
                                                      result[0]
                                                          .rawAddress
                                                          .isNotEmpty) {
                                                    uploadLocalDataAndClear(
                                                        context);
                                                  }
                                                } on SocketException catch (_) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Unable to Connect to the Internet. Please check your network settings.")));
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
                                        const Divider(
                                          thickness: 1,
                                          height: 10,
                                          color: Appcolor.lightgrey,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Village : ${widget.villagename}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color:
                                                        Appcolor.headingcolor),
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, bottom: 5),
                                              child: SizedBox(
                                                  child: Text(
                                                "District :",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Appcolor.black),
                                              )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, bottom: 5),
                                              child: SizedBox(
                                                  child: Text(
                                                district.toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Appcolor.black),
                                              )),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, bottom: 5),
                                              child: SizedBox(
                                                  child: Text(
                                                "Block :",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Appcolor.black),
                                              )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, bottom: 5),
                                              child: SizedBox(
                                                  child: Text(
                                                Block.toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Appcolor.black),
                                              )),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, bottom: 5),
                                              child: SizedBox(
                                                  child: Text(
                                                "Panchayat :",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Appcolor.black),
                                              )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, bottom: 5),
                                              child: SizedBox(
                                                  child: Text(
                                                Panchayat.toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Appcolor.black),
                                              )),
                                            )
                                          ],
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFFFFF)
                                                .withOpacity(0.3),
                                            border: Border.all(
                                              color: Colors.green,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(
                                                10.0,
                                              ),
                                            ),
                                          ),
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: localpwspendingDataList
                                                  .length,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (context, int index) {
                                                return Container(
                                                    margin:
                                                        const EdgeInsets.all(5),
                                                    width: double.infinity,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Material(
                                                      child: InkWell(
                                                        splashColor:
                                                            Appcolor.lightyello,
                                                        onTap: () {},
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                  child: SizedBox(
                                                                      width: 140,
                                                                      child: Text(
                                                                        "Scheme Name : ",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Appcolor.black),
                                                                      )),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                  child: SizedBox(
                                                                      width: 120,
                                                                      child: Text(
                                                                        maxLines:
                                                                            2,
                                                                        localpwspendingDataList[index]
                                                                            .schemename
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Appcolor.black),
                                                                      )),
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                  child: SizedBox(
                                                                      width: 140,
                                                                      child: Text(
                                                                        "Habitation Name : ",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Appcolor.black),
                                                                      )),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                  child:
                                                                      SizedBox(
                                                                          child:
                                                                              Text(
                                                                    localpwspendingDataList![
                                                                            index]
                                                                        .habitationName
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Appcolor
                                                                            .black),
                                                                  )),
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                  child: SizedBox(
                                                                      width: 140,
                                                                      child: Text(
                                                                        "Location/landmark : ",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Appcolor.black),
                                                                      )),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                  child:
                                                                      SizedBox(
                                                                          child:
                                                                              Text(
                                                                    maxLines:
                                                                        10,
                                                                    localpwspendingDataList![
                                                                            index]
                                                                        .landmark
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Appcolor
                                                                            .black),
                                                                  )),
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                  child: SizedBox(
                                                                      width: 140,
                                                                      child: Text(
                                                                        "Source Category : ",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Appcolor.black),
                                                                      )),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                  child:
                                                                      SizedBox(
                                                                          child:
                                                                              Text(
                                                                    maxLines:
                                                                        10,
                                                                    localpwspendingDataList![
                                                                            index]
                                                                        .sourceName
                                                                        .toString()
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Appcolor
                                                                            .black),
                                                                  )),
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                  child: SizedBox(
                                                                      width: 140,
                                                                      child: Text(
                                                                        "Source Type : ",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Appcolor.black),
                                                                      )),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                  child:
                                                                      SizedBox(
                                                                          child:
                                                                              Text(
                                                                    maxLines:
                                                                        10,
                                                                    localpwspendingDataList![
                                                                            index]
                                                                        .sourceType
                                                                        .toString()
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Appcolor
                                                                            .black),
                                                                  )),
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                  child:
                                                                      SizedBox(
                                                                          child:
                                                                              Text(
                                                                    "Latitude : ",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Appcolor
                                                                            .black),
                                                                  )),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                  child:
                                                                      SizedBox(
                                                                          child:
                                                                              Text(
                                                                    maxLines:
                                                                        10,
                                                                    localpwspendingDataList![
                                                                            index]
                                                                        .latitude
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Appcolor
                                                                            .black),
                                                                  )),
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                  child:
                                                                      SizedBox(
                                                                          child:
                                                                              Text(
                                                                    "Longitude : ",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Appcolor
                                                                            .black),
                                                                  )),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                  child:
                                                                      SizedBox(
                                                                          child:
                                                                              Text(
                                                                    maxLines:
                                                                        10,
                                                                    localpwspendingDataList![
                                                                            index]
                                                                        .longitude
                                                                        .toString()
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Appcolor
                                                                            .black),
                                                                  )),
                                                                )
                                                              ],
                                                            ),
                                                            const Row(
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                  child:
                                                                      SizedBox(
                                                                          child:
                                                                              Text(
                                                                    "Status : ",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Appcolor
                                                                            .black),
                                                                  )),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                  child: SizedBox(
                                                                      width: 130,
                                                                      child: Text(
                                                                        maxLines:
                                                                            10,
                                                                        "sss",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Appcolor.red),
                                                                      )),
                                                                )
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            const Divider(
                                                              thickness: 1,
                                                              height: 10,
                                                              color: Appcolor
                                                                  .lightgrey,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          25,
                                                                      child: ElevatedButton
                                                                          .icon(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          primary:
                                                                              Appcolor.lightgrey,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                          ),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Get.to(
                                                                              ZoomImage(
                                                                            imgurl:
                                                                                localpwspendingDataList![index].image,
                                                                            lat:
                                                                                localpwspendingDataList[index].latitude,
                                                                            long:
                                                                                localpwspendingDataList[index].longitude,
                                                                          ));
                                                                        },
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .remove_red_eye_outlined,
                                                                          size:
                                                                              18,
                                                                          color:
                                                                              Appcolor.white,
                                                                        ),
                                                                        label:
                                                                            const Text(
                                                                          "View",
                                                                          style: TextStyle(
                                                                              color: Appcolor.white,
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          25,
                                                                      child: ElevatedButton
                                                                          .icon(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          primary:
                                                                              Appcolor.pink,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                          ),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          showuntagedalertbox(localpwspendingDataList![index].villageId.toString(), pwspendinglistresult[index].stateId.toString(), box.read("userid").toString(), gettoken, pwspendinglistresult[index].taggedId.toString(), index)
                                                                              .then((value) {
                                                                            setState(() {});
                                                                          });
                                                                        },
                                                                        icon:
                                                                            const Icon(
                                                                          size:
                                                                              18.0,
                                                                          Icons
                                                                              .delete_outline_outlined,
                                                                          color:
                                                                              Appcolor.white,
                                                                        ),
                                                                        label:
                                                                            const Text(
                                                                          "Remove",
                                                                          style: TextStyle(
                                                                              color: Appcolor.white,
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ]),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ));
                                              }),
                                        ),
                                      ],
                                    ),
                            ),
                          )
                        ],
                      ),
                    )),
              ],
            )),
      ),
    );
  }

  Future<bool> showuntagedalertbox(String villageid, String stateid,
      String userid, String token, String taggedid, int index) async {
    return await showDialog(
          context: context,
          builder: (context) => Container(
            margin: const EdgeInsets.all(10),
            child: AlertDialog(
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
                    padding: EdgeInsets.only(left: 25, top: 5, bottom: 5),
                    child: Text(
                      'Alert!',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Appcolor.white),
                    )),
              ),
              content: const Padding(
                padding: EdgeInsets.only(left: 5, right: 10),
                child: Text(
                  'Are you sure you want to remove it ?',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Appcolor.black),
                ),
              ),
              actions: [
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                side: BorderSide(color: Appcolor.red)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'No',
                            style: TextStyle(
                                color: Appcolor.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Appcolor.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  side: BorderSide(color: Appcolor.red))),
                          onPressed: () {
                            RemovegeotaggedPWSAPI(villageid, stateid, userid, token, taggedid, index).then((value) {
                              pwspendinglistresult.removeAt(index);
                              Navigator.of(context).pop(false);
                              cleartable_localmasterschemelisttable();

                            });
                          },
                          child: const Text(
                            'Yes',
                            style: TextStyle(
                                color: Appcolor.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ) ??
        false;
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
            localData.sourceTypeCategoryId.toString(),
            localData.landmark,
            localData.latitude,
            localData.longitude,
            localData.accuracy,
            localData.image);

        await databaseHelperJalJeevan?.truncatetable_pwssourcesaveddata();
        await databaseHelperJalJeevan?.truncatetable_pwspendinglist();
        if (response["Status"].toString() == "false") {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response.toString())));
          cleartable_localmasterschemelisttable();
        } else if (response["Status"].toString() == true) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response["msg"].toString())));
        }
      }
    } catch (e) {
      debugPrintStack();
    }
  }

  Future<void> cleartable_localmasterschemelisttable() async {
    await databaseHelperJalJeevan!.cleardb_localmasterschemelist();
    await databaseHelperJalJeevan!.cleartable_villagelist();
    await databaseHelperJalJeevan!.cleartable_villagedetails();
    await databaseHelperJalJeevan!.cleardb_localhabitaionlisttable();
    await databaseHelperJalJeevan!.cleardb_sourcedetailstable();
    await databaseHelperJalJeevan!.truncatetable_dashboardtable();
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
        var stateName = "";

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
}
