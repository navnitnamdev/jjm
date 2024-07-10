import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaljeevanmissiondynamic/apiservice/Apiservice.dart';
import 'package:jaljeevanmissiondynamic/utility/Stylefile.dart';
import 'package:vibration/vibration.dart';
import '../database/DataBaseHelperJalJeevan.dart';
import '../localdatamodel/Localmasterdatamodal.dart';
import '../model/GetSourceCategoryModal.dart';
import '../model/Savesourcetypemodal.dart';
import '../model/Savevillagedetails.dart';
import '../utility/Appcolor.dart';
import '../view/Dashboard.dart';
import '../view/LoginScreen.dart';
import '../view/Villagelistzero.dart';

class Logincontroller extends GetxController {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController entercaptcha = TextEditingController();
  GetStorage box = GetStorage();
  DatabaseHelperJalJeevan? databaseHelperJalJeevan;

  List<dynamic> mainListsourcecategory = [];
  List<dynamic> sourcetypeidlistone = [];
  List<dynamic> sourcetypeidlist = [];
  List<dynamic> SourceTypeCategoryList = [];
  List<dynamic> SourceTypeCategoryList_id = [];
  List<dynamic> sourcetypelistone_id = [];
  List<dynamic> minisource2 = [];
  List<dynamic> minisource = [];
  String SourceTypeCategoryIdget = "";
  String sourcetypeid = "";
  String fileNameofimg = "";
  String sourcetype = "";
  String sourceTypeCategoryId = "";
  var distinctlist = [];
  var distinct_categorylist = [];
  List<dynamic> Listofsourcetype = [];
  var userid;
  var totalvillages;
  String assignedvillage = "";
  bool hasinternetconnection = false;
  late Savevillagedetails savevillagedetails;
  late Savesourcetypemodal savesourcetypemodal;
  List<dynamic>? dbmainlist = [];
  String schemevalue = '-- Select Scheme --';
  bool _loading = false;
  late List<Map<String, dynamic>> mapResponseone = [];

  var _timer;
  bool uploadserverbtn = false;
  bool Addgeotagbuttonvisible = true;

  late GetSourceCategoryModal getSourceCategoryModal;

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
    await databaseHelperJalJeevan!.truncatetable_sibmasterdeatils();
  }

  Future<void> truncateTable_localmasterdatatable() async {
    await databaseHelperJalJeevan!.truncateTable_localmasterdatatable();
  }

  Future<void> truncatetable_villagedetails() async {
    await databaseHelperJalJeevan!.truncateTable_villagedetails();
  }

  Future<void> truncateTable_localmastersourcedetails() async {
    await databaseHelperJalJeevan!.truncateTable_localmastersourcedetails();
  }

  Future<void> truncateTable_localmasterhabitaionlist() async {
    await databaseHelperJalJeevan!.truncateTable_localmasterhabitaionlist();
  }

  void LoginApi(
      BuildContext context, String hashpassword, String RandomNumbersalt) {
    Apiservice.Loginapi(context, emailcontroller.text.trim().toString(),
            hashpassword, RandomNumbersalt)
        .then((value)
    {
      if (value["Status"].toString() == "true") {
        cleartable_localmasterschemelisttable();
        box.write("Status", value["Status"].toString());
        box.write("UserToken", value["Token"].toString());
        box.write("userid", value["Userid"].toString());
        box.write("stateid", value["StateId"].toString());
        box.write("DivisionId", value["DivisionId"].toString());
        box.write("TotalOfflineVillage", value["TotalOfflineVillage"].toString());
        box.write('loginBool', true);
        {



          showDialog(
            context: context,
            builder: (BuildContext builderContext) {
              _timer = Timer(const Duration(seconds: 3), () {
                databaseHelperJalJeevan = DatabaseHelperJalJeevan();
                databaseHelperJalJeevan?.Tableschemelistsourcetype();
                databaseHelperJalJeevan?.TableschemelistSourceTypeCategoryId();
                databaseHelperJalJeevan?.TableschemelistsourcetypeCategory();
                Apiservice.Getmasterapi(context).then((value) {
                  databaseHelperJalJeevan!.insertMasterapidatetime(
                      Localmasterdatetime(
                          UserId: box.read("userid").toString(),
                          API_DateTime: value.API_DateTime.toString()));
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
                    var stateName = "";
                    var districtName = value.villageDetails![i]!.districtName;
                    var stateid = value.villageDetails![i]!.stateId;
                    var blockName = value.villageDetails![i]!.blockName;
                    var panchayatName = value.villageDetails![i]!.panchayatName;
                    var stateidnew = value.villageDetails![i]!.stateId;
                    var userId = value.villageDetails![i]!.userId;
                    var villageIddetails = value.villageDetails![i]!.villageId;
                    var villageName = value.villageDetails![i]!.villageName;
                    var totalNoOfScheme =
                        value.villageDetails![i]!.totalNoOfScheme;
                    var totalNoOfWaterSource =
                        value.villageDetails![i]!.totalNoOfWaterSource;
                    var totalWsGeoTagged =
                        value.villageDetails![i]!.totalWsGeoTagged;
                    var pendingWsTotal = value.villageDetails![i]!.pendingWsTotal;
                    var balanceWsTotal = value.villageDetails![i]!.balanceWsTotal;
                    var totalSsGeoTagged =
                        value.villageDetails![i]!.totalSsGeoTagged;
                    var pendingApprovalSsTotal =
                        value.villageDetails![i]!.pendingApprovalSsTotal;
                    var totalIbRequiredGeoTagged =
                        value.villageDetails![i]!.totalIbRequiredGeoTagged;
                    var totalIbGeoTagged =
                        value.villageDetails![i]!.totalIbGeoTagged;
                    var pendingIbTotal = value.villageDetails![i]!.pendingIbTotal;
                    var balanceIbTotal = value.villageDetails![i]!.balanceIbTotal;
                    var totalOaGeoTagged =
                        value.villageDetails![i]!.totalOaGeoTagged;
                    var balanceOaTotal = value.villageDetails![i]!.balanceOaTotal;
                    var totalNoOfSchoolScheme =
                        value.villageDetails![i]!.totalNoOfSchoolScheme;
                    var totalNoOfPwsScheme =
                        value.villageDetails![i]!.totalNoOfPwsScheme;

                    databaseHelperJalJeevan?.insertMastervillagedetails(
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
                      totalNoOfWaterSource: totalNoOfWaterSource.toString(),
                      totalWsGeoTagged: totalWsGeoTagged.toString(),
                      pendingWsTotal: pendingWsTotal.toString(),
                      balanceWsTotal: balanceWsTotal.toString(),
                      totalSsGeoTagged: totalSsGeoTagged.toString(),
                      pendingApprovalSsTotal: pendingApprovalSsTotal.toString(),
                      totalIbRequiredGeoTagged:
                          totalIbRequiredGeoTagged.toString(),
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
                    var sourceTypeCategoryId =
                        value.sourcelist![i]!.sourceTypeCategoryId;
                    var habitationId = value.sourcelist![i]!.habitationId;
                    var villageName = value.sourcelist![i]!.villageName;
                    var existTagWaterSourceId =
                        value.sourcelist![i]!.existTagWaterSourceId;
                    var isApprovedState = value.sourcelist![i]!.isApprovedState;
                    var landmark = value.sourcelist![i]!.landmark;
                    var latitude = value.sourcelist![i]!.latitude;
                    var longitude = value.sourcelist![i]!.longitude;
                    var habitationName = value.sourcelist![i]!.habitationName;
                    var location = value.sourcelist![i]!.location;
                    var sourceTypeCategory =
                        value.sourcelist![i]!.sourceTypeCategory;
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
                            userId: value.informationBoardList![i]!.userId
                                .toString(),
                            villageId: value.informationBoardList![i]!.villageId
                                .toString(),
                            stateId: value.informationBoardList![i]!.stateId
                                .toString(),
                            schemeId: value.informationBoardList![i]!.schemeId
                                .toString(),
                            districtName:
                                value.informationBoardList![i]!.districtName,
                            blockName: value.informationBoardList![i]!.blockName,
                            panchayatName:
                                value.informationBoardList![i]!.panchayatName,
                            villageName:
                                value.informationBoardList![i]!.villageName,
                            habitationName:
                                value.informationBoardList![i]!.habitationName,
                            latitude: value.informationBoardList![i]!.latitude
                                .toString(),
                            longitude: value.informationBoardList![i]!.longitude
                                .toString(),
                            sourceName:
                                value.informationBoardList![i]!.sourceName,
                            schemeName:
                                value.informationBoardList![i]!.schemeName,
                            message: value.informationBoardList![i]!.message,
                            status: value.informationBoardList![i]!.status
                                .toString()));
                  }
                });
                getcategoryApi(context, box.read("UserToken"));
                getsourcetyprASSETApi(context, box.read("UserToken"));
                Stylefile.showmessageforvalidationtrue(
                    context, "Master data downloaded successfully.");
                Get.offAll(Dashboard(
                    stateid: value["StateId"].toString(),
                    userid: value["Userid"].toString(),
                    usertoken: value["Token"].toString()));
              });
              return Center(
                  child: SizedBox(
                      height: 40,
                      width: 40,
                      child: Image.asset("images/loading.gif")));
            },
          ).then((val) {
            if (_timer.isActive) {
              _timer.cancel();
            }
          }).then((value) {});
        }
      } else {
        Stylefile.showmessageapierrors(context, value["Message"].toString());
        Vibration.vibrate(duration: 1000);
        emailcontroller.clear();
        passwordcontroller.clear();
        entercaptcha.clear();
      }
    });
  }

  Future getcategoryApi(
    BuildContext context,
    String token,
  ) async {
    var uri = Uri.parse(
        '${Apiservice.baseurl}Master/GetSourceCategorylist?UserId=' +
            box.read("userid"));
    var response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'APIKey': token ?? 'DEFAULT_API_KEY'
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> mResposne = jsonDecode(response.body);

      mainListsourcecategory = mResposne["Result"];

      getSourceCategoryModal = GetSourceCategoryModal.fromJson(jsonDecode(response.body));

      await databaseHelperJalJeevan?.insertData_mastersource_categorytype_inDB(getSourceCategoryModal!)
          .then((value) {});

      for (int i = 0; i < mainListsourcecategory.length; i++) {
        SourceTypeCategoryIdget =
            mainListsourcecategory[i]["SourceTypeCategoryId"].toString();
        SourceTypeCategoryList_id.add(SourceTypeCategoryIdget);

        final SourceTypeCategory =
            mainListsourcecategory[i]["SourceTypeCategory"];
        SourceTypeCategoryList.add(SourceTypeCategory);

        final sourcetypeid = mainListsourcecategory[i]["SourceTypeId"];
        sourcetypelistone_id.add(sourcetypeid);

        final jsonList =
            SourceTypeCategoryList.map((item) => jsonEncode(item)).toList();
        final uniqueJsonList = jsonList.toSet().toList();
        distinctlist = uniqueJsonList.map((item) => jsonDecode(item)).toList();

        final categoryid =
            SourceTypeCategoryList_id.map((item) => jsonEncode(item)).toList();
        final categorylist = categoryid.toSet().toList();
        distinct_categorylist =
            categorylist.map((item) => jsonDecode(item)).toList();

        if (SourceTypeCategory == "Ground Water") {
          if (SourceTypeCategoryIdget.toString() == "1") {
            minisource.add(mainListsourcecategory[i]["SourceType"].toString());
            sourcetypeidlistone
                .add(mainListsourcecategory[i]["SourceTypeId"].toString());
          }
        } else if (SourceTypeCategory == "Surface Water") {
          if (SourceTypeCategoryIdget.toString() == "2") {
            minisource2.add(mainListsourcecategory[i]["SourceType"].toString());
            sourcetypeidlist
                .add(mainListsourcecategory[i]["SourceTypeId"].toString());
          }
        }
      }
    }
    return jsonDecode(response.body);
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

  Future<void> truncateTable_duplicate_entryofdashboarDB() async {
    await databaseHelperJalJeevan!.duplicate_entryofdashboarDB();
  }



  Future<void> showalertdialog_workingvillzero(BuildContext context) async {
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
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      textAlign: TextAlign.justify,
                      " Please select maximum ${totalvillages} villages at a time where to geotagging of assets.",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Appcolor.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
              child: Center(
                child: TextButton(
                  child: const Text(
                    'Ok',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Appcolor.black),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Get.to(Villagelistzero(assignedvillage: assignedvillage));
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future getsourcetyprASSETApi(
      BuildContext context,
      String token,
      ) async {

    var uri = Uri.parse(
        '${Apiservice.baseurl}Master/Get_AssetTaggingType?UserId=' +
            box.read("userid"));
    var response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'APIKey': token ?? 'DEFAULT_API_KEY'
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> mResposne = jsonDecode(response.body);
    /*  if (mResposne["Status"].toString() == "false") {
        setState(() {
          Get.offAll(LoginScreen());
          box.remove("UserToken").toString();
        });
      } else {*/
        Listofsourcetype = mResposne["Result"];
        savesourcetypemodal =
            Savesourcetypemodal.fromJson(jsonDecode(response.body));
        await databaseHelperJalJeevan
            ?.insertData_mastersourcetype_inDB(savesourcetypemodal!);
        return jsonDecode(response.body);
      //}
    }

  }
}
