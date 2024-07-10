import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jaljeevanmissiondynamic/localdatamodel/Localmasterdatamodal.dart';
import 'package:jaljeevanmissiondynamic/model/MyClass.dart';
import 'package:jaljeevanmissiondynamic/model/Savesourcetypemodal.dart';
import 'package:jaljeevanmissiondynamic/model/Savevillagedetails.dart';
import 'package:jaljeevanmissiondynamic/model/Villagelistforsend.dart';
import 'package:jaljeevanmissiondynamic/view/Dashboard.dart';
import 'package:provider/provider.dart';
import '../apiservice/Apiservice.dart';
import '../database/DataBaseHelperJalJeevan.dart';
import '../localdatamodel/Localsaveofflinevillages.dart';
import '../model/Myresponse.dart';
import '../model/Saveoffinevillagemodal.dart';
import '../model/Schememodal.dart';
import '../model/Villagelistmodal.dart';
import '../utility/Appcolor.dart';
import '../utility/InternetAllow.dart';
import '../utility/Stylefile.dart';

import 'package:http/http.dart' as http;

import 'LoginScreen.dart';

class Villagelistzero extends StatefulWidget {
  final assignedvillage;

  Villagelistzero({required this.assignedvillage});

  @override
  State<Villagelistzero> createState() => _VillageListScreenState();
}

class _VillageListScreenState extends State<Villagelistzero> {
  GetStorage box = GetStorage();
  TextEditingController searchController = TextEditingController();
  String searchString = "";
  String gettotalvillage = "";
  String PanchayatName = "";
  String OfflineStatus = "";
  String BlockName = "";
  String DistrictName = "";
  bool _loading = false;
  var message;
  List<dynamic> Listofsourcetype = [];
  bool isselect = false;
  late Villagelistmodal villagelistmodal;
  int? index;
  late Saveoffinevillagemodal? saveoffinevillagemodal;
  late Villagelistforsend villagelist;
  List<Villagelistforsend> listofvill = [];
  List<MyClass> _selecteCategorys = [];
  List listone = [];
  List<Localsaveofflinevillages> localofflinevillagelist = [];
  late MyClass myClass;
  late Localsaveofflinevillages localsaveofflinevillages;
  DatabaseHelperJalJeevan? databaseHelperJalJeevan;
  late Myresponse? myresponse;
  List<dynamic>? dbmainlist = [];
  var villagenotcertified;
  var subheadinggeotag_schemeinfo;
  var subheadinggeotag_otherassets;
  var subheadinggeotag_pwssource;
  var headinghgjcertificatvillage;
  late Savevillagedetails savevillagedetails;
  late Savesourcetypemodal savesourcetypemodal;
  List<dynamic> ListResponse = [];
  List<Schememodal> schemelist = [];
  late Schememodal schememodal;
  String newschameid = "";
  String newschemename = "";
  String messageofscheme_mvs = "";
  String messageof_existingscheme = "";
  String newCategory = "";
  List<dynamic> saveoffinevillaglist = [];
  String assignedvillage = "";
  List offlinevillagelistlist = [];

  Future SaveOfflinevilaagesApi(
    BuildContext context,
    String token,
    String UserId,
    List Villagelist,
    String StateId,
  ) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: 40,
                  width: 40,
                  child: Image.asset("images/loading.gif")),
            ],
          );
        });

    final response = await http.post(
      Uri.parse('${Apiservice.baseurl}' + "JJM_Mobile/SaveOfflineVillage"),
      headers: {
        'Content-Type': 'application/json',
        'APIKey': token ?? 'DEFAULT_API_KEY'
      },
      body: jsonEncode({
        "UserId": UserId,
        "VillageList": Villagelist,
        "StateId": StateId,
      }),
    );

    if (response.statusCode == 200) {
      saveoffinevillagemodal =
          Saveoffinevillagemodal.fromJson(jsonDecode(response.body));

      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future getvillagelist() async {
    var url = '${Apiservice.baseurl}'
            "JJM_Mobile/GetAssignedVillages?StateId=" +
        box.read("stateid") +
        "&UserId=" +
        box.read("userid");
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'APIKey': box.read("UserToken")
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> mResposne = jsonDecode(response.body);
      message = mResposne["Message"];

      if (mResposne["Message"] == "Village list") {
        List<dynamic> data = mResposne["Villagelist_Datas"];
        listofvill.clear();
        for (int i = 0; i < data.length; i++) {
          var VillageId = data[i]["VillageId"].toString();
          var VillageName = data[i]["VillageName"].toString();
          OfflineStatus = data[i]["OfflineStatus"].toString();
          PanchayatName = data[i]["PanchayatName"].toString();
          BlockName = data[i]["BlockName"].toString();
          DistrictName = data[i]["DistrictName"].toString();

          listofvill.add(Villagelistforsend(VillageName, VillageId, OfflineStatus, PanchayatName, BlockName, DistrictName));

          if (listofvill[i].OfflineStatus == '1') {
            listofvill[i].isChecked = true;

            _selecteCategorys.add(MyClass(listofvill[i].villageid));
            getschemesource(context, box.read("UserToken"),
                listofvill[i].villageid.toString());
          } else {
            listofvill[i].isChecked = false;
          }
        }
      } else if (mResposne["Message"] == "Record not found") {
        Stylefile.showmessageforvalidationfalse(context, mResposne["Message"]);
      } else {
        Get.offAll(LoginScreen());
        box.remove("UserToken");

        Stylefile.showmessageforvalidationfalse(
            context, "Please login, your token has been expired!");
      }
      setState(() {});
    }
  }

  insertvillagedetails(savevillagedetails) async {
    await databaseHelperJalJeevan
        ?.insertData_villagedetails_inDB(savevillagedetails);
  }

  Future getschemesource(
    BuildContext context,
    String token,
    String villageid,
  ) async {
    final queryParameters = {
      'UserId': box.read("userid").toString(),
      'StateId': box.read("stateid"),
      'villageid': villageid,
    };

    var uri = Uri.parse('${Apiservice.baseurl}JJM_Mobile/GetSourceScheme');
    final newUri = uri.replace(queryParameters: queryParameters);
    var response = await http.get(
      newUri,
      headers: {
        'Content-Type': 'application/json',
        'APIKey': token ?? 'DEFAULT_API_KEY'
      },
    );

    if (response.statusCode == 200) {
      ListResponse.add("--Select scheme --");
      Map<String, dynamic> mResposne = jsonDecode(response.body);

      List data = mResposne['schmelist'];

      schemelist.clear();
      schemelist.add(schememodal);
      for (int i = 0; i < data.length; i++) {
        newschameid = data[i]["Schemeid"].toString();
        newschemename = data[i]["Schemename"].toString();
        newCategory = data[i]["Category"].toString();
        schemelist.add(Schememodal(newschameid, newschemename, newCategory));
      }
      databaseHelperJalJeevan!.insertData_schemelist_inDB(
          Schememodal(newschameid, newschemename, newCategory));
      setState(() {});
    }
    return jsonDecode(response.body);
  }

  Future getvillagedetailsApi(BuildContext context, String villageid,
      String stateid, String userid, String token) async {
    try {
      var response = await http.get(
        Uri.parse('${Apiservice.baseurl}' +
            "JJM_Mobile/GetVillageGeoTaggingDetails?VillageId=" +
            villageid +
            "&StateId=" +
            stateid +
            "&UserId=" +
            userid),
        headers: {
          'Content-Type': 'application/json',
          'APIKey': token ?? 'DEFAULT_API_KEY'
        },
      );
      if (response.statusCode == 200) {
        var mapResponse = jsonDecode(response.body);
        return mapResponse;
      } else {
        var mapResponse = jsonDecode(response.body);
        var status = mapResponse["Status"];

        if (status == "false") {
          Get.offAll(LoginScreen());
          box.remove("UserToken");
          return jsonDecode(response.body);
        }

        setState(() {
          insertvillagedetails(mapResponse.toString());
        });

        return mapResponse;
      }
    } catch (e) {}
  }

  var totalvillages;

  @override
  void initState() {
    super.initState();

    setState(() {
      totalvillages = int.parse(box.read("TotalOfflineVillage") ?? '0');
    });
    myresponse = Myresponse();
    savevillagedetails = Savevillagedetails();
    saveoffinevillagemodal = Saveoffinevillagemodal();
    savesourcetypemodal = Savesourcetypemodal();

    databaseHelperJalJeevan = DatabaseHelperJalJeevan();
    schememodal = Schememodal("-- Select Scheme --", "", "");
    villagelist = Villagelistforsend("", "", "", "", "", "");
    villagelistmodal = Villagelistmodal(status: true, message: "success", villagelistDatas: []);

    if (box.read("UserToken").toString() == "null") {
      Get.offAll(LoginScreen());
      cleartable_localmasterschemelisttable();
      Stylefile.showmessageforvalidationfalse(
          context, "Please login, your token has been expired!");
    } else {
      setState(() {
        Apicallforvilages();
      });
    }
  }

  Apicallforvilages() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        getvillagelist();
        FocusScope.of(context).unfocus();
      }
    } on SocketException catch (_) {}
  }

  Future<void> cleartable_localmasterschemelisttable() async {
    await databaseHelperJalJeevan!.cleardb_localmasterschemelist();
    await databaseHelperJalJeevan!.cleartable_villagelist();
    await databaseHelperJalJeevan!.cleartable_villagedetails();
    await databaseHelperJalJeevan!.cleardb_localhabitaionlisttable();
    await databaseHelperJalJeevan!.cleardb_sourcedetailstable();
    await databaseHelperJalJeevan!.truncatetable_dashboardtable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Appcolor.white,
          ),
          title: const Text(
            'Select working village',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
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
          backgroundColor: Appcolor.bgcolor,
          elevation: 5,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/header_bg.png'), fit: BoxFit.cover),
            ),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible:
                            Provider.of<InternetConnectionStatus>(context) ==
                                InternetConnectionStatus.disconnected,
                        child: InternetAllow(),
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                textAlign: TextAlign.justify,
                                "Please select maximum ${totalvillages} villages at a time where to geotagging of assets.",
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Appcolor.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: TextField(
                              autofocus: false,
                              controller: searchController,
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Appcolor.black,
                                  fontWeight: FontWeight.bold),
                              onChanged: (value) {
                                setState(() {
                                  searchString = value;
                                });
                              },
                              decoration: InputDecoration(
                                suffixIcon: const Icon(
                                  Icons.search,
                                  color: Appcolor.bgcolor,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Search Villages...',
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 8.0, top: 8.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Appcolor.btncolor, width: 3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Provider.of<InternetConnectionStatus>(context) ==
                                  InternetConnectionStatus.disconnected
                              ? InternetAllowwithimage()
                              : Container(
                                  margin: const EdgeInsets.all(10),
                                  child: Material(
                                    child: InkWell(
                                      onTap: () {},
                                      child: Column(
                                        children: [
                                          message == "Record not found"
                                              ? const SizedBox(
                                                  child: Center(
                                                      child: Text(
                                                  "Record not found",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )))
                                              : Column(
                                                  children: [
                                                    listofvill.length == 0
                                                        ? const CircularProgressIndicator()
                                                        : Container(
                                                            child: Container(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height /
                                                                    1.8,
                                                                child: ListView
                                                                    .builder(
                                                                  itemCount:
                                                                      listofvill
                                                                          .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          int index) {
                                                                    return listofvill[index]
                                                                            .villagename
                                                                            .toString()
                                                                            .toUpperCase()
                                                                            .toLowerCase()
                                                                            .contains(searchString.toLowerCase().toString())
                                                                        ? Container(
                                                                            padding:
                                                                                const EdgeInsets.all(5),
                                                                            child:
                                                                                Material(
                                                                              elevation: 2.0,
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                              child: InkWell(
                                                                                splashColor: Appcolor.splashcolor,
                                                                                customBorder: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                                ),
                                                                                onTap: () {},
                                                                                child: SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: <Widget>[
                                                                                      Column(
                                                                                        children: [
                                                                                          Checkbox(
                                                                                            value: listofvill[index].isChecked,
                                                                                            onChanged: (selected) {
                                                                                              setState(() {
                                                                                                if (selected!) {
                                                                                                  if (_selecteCategorys.length < totalvillages) {
                                                                                                    setState(() {
                                                                                                      listofvill[index].isChecked = true;
                                                                                                      _selecteCategorys.add(MyClass(listofvill[index].villageid));
                                                                                                    });
                                                                                                  } else {
                                                                                                    Stylefile.showmessageforvalidationfalse(context, "You can select only ${totalvillages} villages");
                                                                                                  }
                                                                                                } else {
                                                                                                  setState(() {
                                                                                                    listofvill[index].isChecked = false;
                                                                                                    _selecteCategorys.removeWhere((element) => element.VillageId == listofvill[index].villageid);
                                                                                                  });
                                                                                                }
                                                                                              });
                                                                                            },
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                      Container(
                                                                                        child: Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                const Padding(
                                                                                                  padding: EdgeInsets.all(2.0),
                                                                                                  child: Text(
                                                                                                    "Village:",
                                                                                                    style: TextStyle(fontWeight: FontWeight.w500, color: Appcolor.grey, fontSize: 14),
                                                                                                  ),
                                                                                                ),
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.all(2.0),
                                                                                                  child: Text(
                                                                                                    listofvill![index].villagename.toString(),
                                                                                                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                const Padding(
                                                                                                  padding: EdgeInsets.all(2.0),
                                                                                                  child: Text(
                                                                                                    "(Block :",
                                                                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Appcolor.grey, fontSize: 14),
                                                                                                  ),
                                                                                                ),
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.all(2.0),
                                                                                                  child: Text(
                                                                                                    listofvill![index].BlockName.toString(),
                                                                                                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                                                                                  ),
                                                                                                ),
                                                                                                const SizedBox(
                                                                                                  width: 10,
                                                                                                ),
                                                                                                const Padding(
                                                                                                  padding: EdgeInsets.all(2.0),
                                                                                                  child: Text(
                                                                                                    ", GP :",
                                                                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Appcolor.grey, fontSize: 14),
                                                                                                  ),
                                                                                                ),
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.all(2.0),
                                                                                                  child: Text(
                                                                                                    listofvill![index].PanchayatName.toString() + ")",
                                                                                                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : const SizedBox();
                                                                  },
                                                                )),
                                                          )
                                                  ],
                                                )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          Provider.of<InternetConnectionStatus>(context) ==
                                  InternetConnectionStatus.disconnected
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    Center(
                                      child: ElevatedButton(
                                        child: const Text(
                                          'Submit',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                        onPressed: () {
                                          if (box
                                                  .read("UserToken")
                                                  .toString() ==
                                              "null") {
                                            setState(() {
                                              cleartable_localmasterschemelisttable();
                                              Get.offAll(LoginScreen());
                                            });
                                          } else {
                                            if (_selecteCategorys.isEmpty) {
                                              Stylefile
                                                  .showmessageforvalidationfalse(
                                                      context,
                                                      "You have to select atleast 1 village");
                                            } else {
                                              SaveOfflinevilaagesApi(
                                                      context,
                                                      box.read("UserToken"),
                                                      box.read("userid"),
                                                      _selecteCategorys,
                                                      box.read("stateid"))
                                                  .then((value) {
                                                if (value["Message"]
                                                        .toString() ==
                                                    "Token is wrong or expire") {
                                                  setState(() {
                                                    cleartable_localmasterschemelisttable();
                                                    Get.offAll(LoginScreen());
                                                  });
                                                } else {
                                                  showDialog<void>(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        backgroundColor:
                                                            Appcolor.white,
                                                        titlePadding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 0,
                                                                left: 0,
                                                                right: 00),
                                                        buttonPadding:
                                                            const EdgeInsets
                                                                .all(10),
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
                                                            MainAxisAlignment
                                                                .center,
                                                        content:
                                                            SingleChildScrollView(
                                                          child: ListBody(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 0,
                                                                        top: 0,
                                                                        bottom:
                                                                            0),
                                                                child: Text(
                                                                  "You have chosen ${_selecteCategorys.length} villages to geotag assets.\nThe master data for these villages has been successfully downloaded.",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          16,
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
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              border:
                                                                  Border.all(
                                                                color: Appcolor
                                                                    .red,
                                                                width: 1,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: TextButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    try {
                                                                      cleartable_localmastertables();
                                                                      Apiservice.Getmasterapi(
                                                                              context)
                                                                          .then(
                                                                              (value) {
                                                                        if (value !=
                                                                            null) {
                                                                          databaseHelperJalJeevan!.insertMasterapidatetime(Localmasterdatetime(
                                                                              UserId: box.read("userid").toString(),
                                                                              API_DateTime: value.API_DateTime.toString()));

                                                                          for (int i = 0;
                                                                              i < value.villagelist!.length;
                                                                              i++) {
                                                                            var userid =
                                                                                value.villagelist![i]!.userId;

                                                                            var villageId =
                                                                                value.villagelist![i]!.villageId;
                                                                            var stateId =
                                                                                value.villagelist![i]!.stateId;
                                                                            var villageName =
                                                                                value.villagelist![i]!.VillageName;

                                                                            databaseHelperJalJeevan?.insertMastervillagelistdata(Localmasterdatanodal(UserId: userid.toString(), villageId: villageId.toString(), StateId: stateId.toString(), villageName: villageName.toString())).then((value) {});
                                                                          }
                                                                          databaseHelperJalJeevan!
                                                                              .removeDuplicateEntries();

                                                                          for (int i = 0;
                                                                              i < value.villageDetails!.length;
                                                                              i++) {
                                                                            var stateName =
                                                                                "";

                                                                            var districtName =
                                                                                value.villageDetails![i]!.districtName;
                                                                            var stateid =
                                                                                value.villageDetails![i]!.stateId;
                                                                            var blockName =
                                                                                value.villageDetails![i]!.blockName;
                                                                            var panchayatName =
                                                                                value.villageDetails![i]!.panchayatName;
                                                                            var stateidnew =
                                                                                value.villageDetails![i]!.stateId;
                                                                            var userId =
                                                                                value.villageDetails![i]!.userId;
                                                                            var villageIddetails =
                                                                                value.villageDetails![i]!.villageId;
                                                                            var villageName =
                                                                                value.villageDetails![i]!.villageName;
                                                                            var totalNoOfScheme =
                                                                                value.villageDetails![i]!.totalNoOfScheme;
                                                                            var totalNoOfWaterSource =
                                                                                value.villageDetails![i]!.totalNoOfWaterSource;
                                                                            var totalWsGeoTagged =
                                                                                value.villageDetails![i]!.totalWsGeoTagged;
                                                                            var pendingWsTotal =
                                                                                value.villageDetails![i]!.pendingWsTotal;
                                                                            var balanceWsTotal =
                                                                                value.villageDetails![i]!.balanceWsTotal;
                                                                            var totalSsGeoTagged =
                                                                                value.villageDetails![i]!.totalSsGeoTagged;
                                                                            var pendingApprovalSsTotal =
                                                                                value.villageDetails![i]!.pendingApprovalSsTotal;
                                                                            var totalIbRequiredGeoTagged =
                                                                                value.villageDetails![i]!.totalIbRequiredGeoTagged;
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
                                                                            var totalNoOfSchoolScheme =
                                                                                value.villageDetails![i]!.totalNoOfSchoolScheme;
                                                                            var totalNoOfPwsScheme =
                                                                                value.villageDetails![i]!.totalNoOfPwsScheme;

                                                                            databaseHelperJalJeevan?.insertMastervillagedetails(Localmasterdatamodal_VillageDetails(
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

                                                                          for (int i = 0;
                                                                              i < value.schmelist!.length;
                                                                              i++) {
                                                                            var source_type =
                                                                                value.schmelist![i]!.source_type;   var schemeidnew =
                                                                                value.schmelist![i]!.schemeid;
                                                                            var villageid =
                                                                                value.schmelist![i]!.villageId;
                                                                            var schemenamenew =
                                                                                value.schmelist![i]!.schemename;
                                                                            var schemenacategorynew =
                                                                                value.schmelist![i]!.category;
                                                                            var SourceTypeCategoryId = value.schmelist![i]!.SourceTypeCategoryId;
                                                                            var source_typeCategory = value.schmelist![i]!.source_typeCategory;

                                                                            databaseHelperJalJeevan?.insertMasterSchmelist(Localmasterdatamoda_Scheme(
                                                                              source_type: source_type.toString(),             schemeid: schemeidnew.toString(),
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
                                                                            var sourceId =
                                                                                value.sourcelist![i]!.sourceId;
                                                                            var SchemeId =
                                                                                value.sourcelist![i]!.schemeId;
                                                                            var stateid =
                                                                                value.sourcelist![i]!.stateid;
                                                                            var Schemename =
                                                                                value.sourcelist![i]!.schemeName;
                                                                            var villageid =
                                                                                value.sourcelist![i]!.villageId;
                                                                            var sourceTypeId =
                                                                                value.sourcelist![i]!.sourceTypeId;
                                                                            var statename =
                                                                                value.sourcelist![i]!.stateName;
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
                                                                            var landmark =
                                                                                value.sourcelist![i]!.landmark;
                                                                            var latitude =
                                                                                value.sourcelist![i]!.latitude;
                                                                            var longitude =
                                                                                value.sourcelist![i]!.longitude;
                                                                            var habitationName =
                                                                                value.sourcelist![i]!.habitationName;
                                                                            var location =
                                                                                value.sourcelist![i]!.location;
                                                                            var sourceTypeCategory =
                                                                                value.sourcelist![i]!.sourceTypeCategory;
                                                                            var sourceType =
                                                                                value.sourcelist![i]!.sourceType;
                                                                            var districtName =
                                                                                value.sourcelist![i]!.districtName;
                                                                            var districtId =
                                                                                value.sourcelist![i]!.districtId;
                                                                            var panchayatNamenew =
                                                                                value.sourcelist![i]!.panchayatName;
                                                                            var blocknamenew =
                                                                                value.sourcelist![i]!.blockName;

                                                                            databaseHelperJalJeevan?.insertMasterSourcedetails(LocalSourcelistdetailsModal(
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

                                                                          for (int i = 0;
                                                                              i < value.habitationlist!.length;
                                                                              i++) {
                                                                            var villafgeid =
                                                                                value.habitationlist![i]!.villageId;
                                                                            var habitationId =
                                                                                value.habitationlist![i]!.habitationId;
                                                                            var habitationName =
                                                                                value.habitationlist![i]!.habitationName;

                                                                            databaseHelperJalJeevan?.insertMasterhabitaionlist(LocalHabitaionlistModal(
                                                                                villageId: villafgeid.toString(),
                                                                                HabitationId: habitationId.toString(),
                                                                                HabitationName: habitationName.toString()));
                                                                          }
                                                                          for (int i = 0;
                                                                              i < value.informationBoardList!.length;
                                                                              i++) {
                                                                            databaseHelperJalJeevan?.insertmastersibdetails(LocalmasterInformationBoardItemModal(
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
                                                                        } else {
                                                                          Stylefile.showmessageforvalidationfalse(
                                                                              context,
                                                                              "Master data is not downloaded successfully.");
                                                                        }
                                                                      });
                                                                    } catch (e) {
                                                                      Stylefile
                                                                          .showmessageforvalidationfalse(
                                                                        context,
                                                                        "An unexpected error occurred. Please try again later.",
                                                                      );
                                                                    }
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                  Get.offAll(Dashboard(
                                                                      stateid: box
                                                                          .read(
                                                                              "stateid"),
                                                                      userid: box
                                                                          .read(
                                                                              "userid"),
                                                                      usertoken:
                                                                          box.read(
                                                                              "UserToken")));
                                                                },
                                                                child: const Text(
                                                                    'OK',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Appcolor
                                                                            .black))),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              });
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Appcolor.btncolor,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 5),
                                            textStyle: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Appcolor.white)),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 5,
                                            bottom: 8),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Appcolor.grey,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: const Text(
                                            textAlign: TextAlign.left,
                                            "Note :If the desired village is not appearing then it may not have been allotted to you. Please contact the divisional MIS officer.",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.red),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )),
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

  void showAlertDialog(BuildContext context, String villageassing) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text("You have assinged villages : " + villageassing),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
