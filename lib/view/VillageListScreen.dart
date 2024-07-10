import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jaljeevanmissiondynamic/model/MyClass.dart';
import 'package:jaljeevanmissiondynamic/model/Savesourcetypemodal.dart';
import 'package:jaljeevanmissiondynamic/model/Savevillagedetails.dart';
import 'package:jaljeevanmissiondynamic/model/Villagelistforsend.dart';
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
import '../utility/Textfile.dart';
import '../utility/Utilityclass.dart';
import 'LoginScreen.dart';
import 'package:http/http.dart' as http;

class VillageListScreen extends StatefulWidget {
  VillageListScreen({super.key});

  @override
  State<VillageListScreen> createState() => _VillageListScreenState();
}

class _VillageListScreenState extends State<VillageListScreen> {
  GetStorage box = GetStorage();
  TextEditingController searchController = TextEditingController();
  String searchString = "";
  String gettotalvillage = "";
  String OfflineStatus = "";
  String PanchayatName = "";
  String BlockName = "";
  String DistrictName = "";
  var message;
  List<dynamic> Listofsourcetype = [];
  bool isselect = false;
  late Villagelistmodal villagelistmodal;
  int? index;
  late Saveoffinevillagemodal? saveoffinevillagemodal;
  late Villagelistforsend villagelist;
  List<Villagelistforsend> listofvill = [];
  List<MyClass> _selecteCategorys = [];
  List<MyClass> selectedbox = [];
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
  var Nolistpresent;
  var totalsibrecord;
  List<dynamic> ListResponse = [];
  List<Schememodal> schemelist = [];
  late Schememodal schememodal;
  String newschameid = "";
  String newschemename = "";
  String messageofscheme_mvs = "";
  String messageof_existingscheme = "";
  String newCategory = "";

  Future<void> cleartable_localmasterschemelisttable() async {
    await databaseHelperJalJeevan!.cleardb_localmasterschemelist();
    await databaseHelperJalJeevan!.cleartable_villagelist();
    await databaseHelperJalJeevan!.cleardb_sourcetypecategorytable();
    await databaseHelperJalJeevan!.cleardb_sourcassettypetable();
    await databaseHelperJalJeevan!.cleartable_villagedetails();
    await databaseHelperJalJeevan!.cleardb_localhabitaionlisttable();
    await databaseHelperJalJeevan!.cleardb_sourcedetailstable();
    await databaseHelperJalJeevan!.truncatetable_dashboardtable();
    await databaseHelperJalJeevan!.cleardb_sibmasterlist();
  }

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
    Get.back();

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
          listofvill.add(Villagelistforsend(VillageName, VillageId,
              OfflineStatus, PanchayatName, BlockName, DistrictName));

          if (listofvill[i].OfflineStatus == '1') {
            setState(() {
              listofvill[i].isChecked = true;

              _selecteCategorys.add(MyClass(listofvill[i].villageid));

              getschemesource(context, box.read("UserToken"),
                  listofvill[i].villageid.toString());
            });
          } else {
            setState(() {
              listofvill[i].isChecked = false;
            });
          }
        }
      } else if (mResposne["Message"] == "Record not found") {
        Stylefile.showmessageforvalidationfalse(context, mResposne["Message"]);
      } else {
        cleartable_localmasterschemelisttable();
        Get.offAll(LoginScreen());
        box.remove("UserToken");

        Stylefile.showmessageforvalidationfalse(
            context, "Please login your token has been expired!");
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

  @override
  void initState() {
    super.initState();
    myresponse = Myresponse();
    savevillagedetails = Savevillagedetails();
    saveoffinevillagemodal = Saveoffinevillagemodal();
    savesourcetypemodal = Savesourcetypemodal();

    databaseHelperJalJeevan = DatabaseHelperJalJeevan();
    schememodal = Schememodal("-- Select Scheme --", "", "");
    villagelist = Villagelistforsend("", "", "", "", "", "");
    villagelistmodal = Villagelistmodal(
        status: true, message: "success", villagelistDatas: []);

    if (box.read("UserToken").toString() == "null") {
      cleartable_localmasterschemelisttable();
      Get.offAll(LoginScreen());

      Stylefile.showmessageforvalidationfalse(
          context, "Please login your token has been expired!");
    } else {
      setState(() {
        Apicallforvilages();
      });
    }

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

  Apicallforvilages() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        getvillagelist();
        FocusScope.of(context).unfocus();
      }
    } on SocketException catch (_) {
      Utilityclass.showInternetDialog(context);
    }
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
          title: const Text(
            "Assigned Villages ",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
          actions: [],
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
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Row(
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
                                          titlePadding: const EdgeInsets.only(
                                              top: 0, left: 0, right: 00),
                                          buttonPadding:
                                              const EdgeInsets.all(10),
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                            height: 20,
                          ),
                          Container(
                            height: 40,
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            width: double.infinity,
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                color: const Color(0xFF0B2E7C),
                                borderRadius: BorderRadius.circular(8)),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Geo-tag water assets',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
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
                                          const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Text(
                                                  'Select Village',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Appcolor.headingcolor,
                                                      fontSize: 18),
                                                ),
                                              )),
                                          const Divider(
                                            thickness: 1,
                                            height: 10,
                                            color: Appcolor.lightgrey,
                                          ),
                                          message == "Record not found"
                                              ? const SizedBox(
                                                  height: 290,
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
                                                            height: 290,
                                                            child: ListView
                                                                .builder(
                                                                    itemCount:
                                                                        listofvill!
                                                                            .length,
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemBuilder:
                                                                        (context,
                                                                            int index) {
                                                                      return listofvill[index]
                                                                              .villagename
                                                                              .toLowerCase()
                                                                              .toString()
                                                                              .contains(searchString.toLowerCase().toString())
                                                                          ? Container(
                                                                              padding: const EdgeInsets.all(2),
                                                                              child: Material(
                                                                                elevation: 2.0,
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                                child: InkWell(
                                                                                  splashColor: Appcolor.splashcolor,
                                                                                  customBorder: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                  ),
                                                                                  onTap: () {},
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: <Widget>[
                                                                                      Column(
                                                                                        children: [
                                                                                          listofvill[index].OfflineStatus.toString() == "0"
                                                                                              ? Checkbox(
                                                                                                  value: listofvill[index].isChecked,
                                                                                                  onChanged: (selected) {
                                                                                                    setState(() {
                                                                                                      if (selected == true) {
                                                                                                        if (box.read("TotalOfflineVillage").toString() != _selecteCategorys.length.toString()) {
                                                                                                          listofvill[index].isChecked = selected!;
                                                                                                          _selecteCategorys.add(MyClass(listofvill[index].villageid));

                                                                                                          getvillagedetailsApi(context, listofvill[index].villageid, box.read("stateid"), box.read("userid"), box.read("UserToken")).then((value) async {
                                                                                                            await databaseHelperJalJeevan?.insertData_villagedetails_inDB(value.toString());
                                                                                                          });

                                                                                                          getschemesource(context, box.read("UserToken"), listofvill[index].villageid).then((value) {});
                                                                                                        } else {
                                                                                                          listofvill[index].isChecked = false;
                                                                                                        }
                                                                                                      } else {
                                                                                                        listofvill[index].isChecked = false;
                                                                                                        _selecteCategorys.removeAt(index);
                                                                                                        getvillagedetailsApi(context, listofvill[index].villageid, box.read("stateid"), box.read("userid"), box.read("UserToken")).then((value) async {
                                                                                                          await databaseHelperJalJeevan?.insertData_villagedetails_inDB(value.toString());
                                                                                                        });
                                                                                                        getschemesource(context, box.read("UserToken"), listofvill[index].villageid).then((value) {});
                                                                                                      }
                                                                                                    });
                                                                                                  },
                                                                                                )
                                                                                              : Column(
                                                                                                  children: [
                                                                                                    Checkbox(
                                                                                                      value: listofvill[index].isChecked,
                                                                                                      activeColor: Colors.green,
                                                                                                      onChanged: (selected) {
                                                                                                        setState(() {
                                                                                                          if (listofvill[index].isChecked == true) {
                                                                                                            listofvill[index].isChecked = false;

                                                                                                            _selecteCategorys.removeAt(index);

                                                                                                            getvillagedetailsApi(context, listofvill[index].villageid, box.read("stateid"), box.read("userid"), box.read("UserToken")).then((value) async {
                                                                                                              await databaseHelperJalJeevan?.insertData_villagedetails_inDB(value.toString());
                                                                                                            });
                                                                                                            getschemesource(context, box.read("UserToken"), listofvill[index].villageid).then((value) {});
                                                                                                          } else {
                                                                                                            listofvill[index].isChecked = true;
                                                                                                            _selecteCategorys.add(MyClass(listofvill[index].villageid));
                                                                                                            getvillagedetailsApi(context, listofvill[index].villageid, box.read("stateid"), box.read("userid"), box.read("UserToken")).then((value) async {
                                                                                                              await databaseHelperJalJeevan?.insertData_villagedetails_inDB(value.toString());
                                                                                                            });
                                                                                                            getschemesource(context, box.read("UserToken"), listofvill[index].villageid).then((value) {});
                                                                                                          }
                                                                                                        });
                                                                                                      },
                                                                                                    )
                                                                                                  ],
                                                                                                )
                                                                                        ],
                                                                                      ),
                                                                                      Container(
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            SizedBox(
                                                                                              width: 240,
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.all(5.0),
                                                                                                child: Text(
                                                                                                  listofvill![index].villagename.toString(),
                                                                                                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            IconButton(
                                                                                              color: Colors.black,
                                                                                              onPressed: () {},
                                                                                              icon: const Icon(
                                                                                                Icons.double_arrow_outlined,
                                                                                                size: 20,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ))
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
                      Provider.of<InternetConnectionStatus>(context) ==
                              InternetConnectionStatus.disconnected
                          ? const SizedBox()
                          : Center(
                              child: ElevatedButton(
                                child: const Text(
                                  'Select for tagging village',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                                onPressed: () {
                                  if (box.read("UserToken").toString() ==
                                      "null") {
                                    setState(() {
                                      Get.offAll(LoginScreen());
                                    });
                                  } else {
                                    if (_selecteCategorys.isEmpty) {
                                      showAlertDialog(context, gettotalvillage);
                                    } else if (_selecteCategorys.length < 1) {
                                      Stylefile.showmessageforvalidationfalse(
                                          context,
                                          "Select minimum one village");
                                    } else {
                                      SaveOfflinevilaagesApi(
                                              context,
                                              box.read("UserToken"),
                                              box.read("userid"),
                                              _selecteCategorys,
                                              box.read("stateid"))
                                          .then((value) {
                                        if (value["Message"].toString() ==
                                            "Please login your token has been expired!") {
                                          setState(() {
                                            cleartable_localmasterschemelisttable();
                                            Get.offAll(LoginScreen());
                                          });
                                        } else {
                                          databaseHelperJalJeevan!
                                              .insertselecttvillageofflineDB(
                                                  saveoffinevillagemodal!);
                                          databaseHelperJalJeevan!
                                              .truncateTable_offlinevillages();
                                          Get.back();
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
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
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
