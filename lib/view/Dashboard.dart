import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:jaljeevanmissiondynamic/model/GetSourceCategoryModal.dart';
import 'package:jaljeevanmissiondynamic/utility/Stylefile.dart';
import 'package:jaljeevanmissiondynamic/utility/Textfile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaljeevanmissiondynamic/apiservice/Apiservice.dart';
import 'package:jaljeevanmissiondynamic/database/DataBaseHelperJalJeevan.dart';
import 'package:jaljeevanmissiondynamic/localdatamodel/Localmasterdatamodal.dart';
import 'package:jaljeevanmissiondynamic/model/Myresponse.dart';
import 'package:jaljeevanmissiondynamic/model/Schememodal.dart';
import 'package:jaljeevanmissiondynamic/utility/Appcolor.dart';
import 'package:jaljeevanmissiondynamic/utility/SyncronizationData.dart';
import 'package:jaljeevanmissiondynamic/view/LoginScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../Selectedvillagelist.dart';
import '../localdatamodel/LocalSIBsavemodal.dart';
import '../localdatamodel/Localpwssourcemodal.dart';
import '../localdatamodel/Localsaveofflinevillages.dart';
import '../model/LocalOtherassetsofflinesavemodal.dart';
import '../model/LocalStoragestructureofflinesavemodal.dart';
import '../model/MyClass.dart';
import '../model/Saveoffinevillagemodal.dart';
import '../model/Savesourcetypemodal.dart';
import '../model/Savevillagedetails.dart';
import '../model/Villagelistforsend.dart';
import '../model/Villagelistmodal.dart';
import 'Commonallofflineentries.dart';

import 'Villagelistzero.dart';

class Dashboard extends StatefulWidget {
  String stateid;
  String userid;
  String usertoken;

  Dashboard(
      {required this.stateid,
      required this.userid,
      required this.usertoken,
      Key? key})
      : super(key: key);

  @override
  State<Dashboard> createState() =>
      _DashboardState(stateId: stateid, userid: userid, usertoken: usertoken);
}

class _DashboardState extends State<Dashboard> {
  GetStorage box = GetStorage();
  var designation = "";
  dynamic message;
  String? divisionid;
  String? userFirstName;
  String? mobile;
  var stateName = "0";
  String? districtName = "";
  var divisionName = '';
  var stateId = "";
  String? usertoken;
  int? districtId;
  int totalAssignVillage = 0;
  int totalPwsSchemes = 0;
  int? totalHh;
  int? hHsprovided;
  int? hHsProvidedPer;
  int? remainingHh;
  int? fhtcApprovaPending;
  int? totalSchemes;
  int totalSchoolSchemes = 0;
  int noofPwSsources = 0;
  int pwsSourcesGeotagged = 0;
  int remainingPwsSources = 0;
  int? waterSourcetobeGeotag;
  int? noofInformationboardrequired;
  int noofInformationboardGeotagged = 0;
  int remainingInformationboard = 0;
  int geotaggedOtherAssets = 0;
  int geotaggedStorageStructure = 0;
  int totalSchemeswithoutSource = 0;
  int? roleGeoTagStatus;
  int? roleFhtcTagStatus;
  int? noFhtcProvided;
  int? implementationongoing;
  int? fhtcDone;
  int? hgjReported;
  late List<Map<String, dynamic>> mapResponseone = [];
  var subheading = "";
  var listheaderll = "";
  var listheader = "";
  var MenuId = "";
  var pwsheading = "";
  var listheaderone = "";
  var SubHeadingMenuId = "";
  var SubHeadinggeotag = "";
  var SubHeadingotherassets = "";
  var subHeadingParent = "";
  var SubHeadingofdisinfection = "";
  var SubHeading = "";
  var headingdesinfection = "";
  var pwsSubHeading = "";
  var subheadingotherscemeasset = "";
  var schemeinfosubheading = "";
  var menuid;
  var menusec;
  var HGJheading;
  var SubHeadingHGJ = "";
  var LableValue;
  String? username;
  String? geotagingheading;
  String UserDescription = "";
  var subheadingvillage;
  var SubHeadingHGJvillagecertificategrampanc = "";
  var pwsheadingwatersupply;
  var headinghgjdesination;
  var subHeading_desingtion;
  var subHeading_smaplegrampanchatt;
  var subHeading_smaple;
  var subHeadingmenuid;
  var downloadsmapletwo;
  var downloadsampleone;
  var villagenotcertified;
  var subheadinggeotag_schemeinfo;
  var subheadinggeotag_otherassets;
  var subheadinggeotag_pwssource;
  var headinghgjcertificatvillage;
  List<SubResult>? subresultdesinationlist = [];
  List<SubResult>? sublistheadinglistmenu = [];
  List<SubResult>? downloadsamplevillagelist = [];
  List<SubResult>? downloadsamplevillagelisttwo = [];
  List<SubResult>? hgjcertificatelistgrampanachatlist = [];
  List<SubResult>? villagenotcertificiedlist = [];
  List<SubResult>? subResultofhgjdesingation = [];
  List<SubResult>? hgjcertificatelist = [];
  List<SubResult>? subResultofhgj = [];
  List<SubResult>? subResult = [];
  List<SubResult>? subResultofstatusewatersupply = [];
  List<SubResult>? subResulgeotaggingassignvillagelist = [];
  List<SubResult>? subResulgeotaggingassignvillageschemelist = [];
  List<SubResult>? subResult_utherassetslist = [];
  List<SubResult>? villagenotcertifiedlist = [];
  List<SubResult> disinfectionlist = [];
  var mainHeadingmenuwatersuipply = "";
  var mainHeadingmenugeotagging = "";
  var watersupplyheading = "";
  var leftmenuheading = "";
  var leftmenuheadingvalue = "";
  var leftmenuheadingicon = "";
  var schemeinformationtext = "";
  var schemeinformationvalue = "";
  var schemeinformationicon = "";
  var otherassetstext = "";
  var otherassetstextvalue = "";
  var otherassetstexticon = "";
  int totalallrecordoffline = 0;
  bool totalallrecordofflineupload = false;
  var Mobile = "";
  var Designation = "";
  var leftmenuheadingmenuid;
  var userid;
  List _newList = [];
  late Myresponse? myresponse;
  bool uploadserverbtn = false;
  bool Addgeotagbuttonvisible = true;
  bool visibleclose = true;
  bool hasinternetconnection = false;
  DatabaseHelperJalJeevan? databaseHelperJalJeevan;
  var dbleftheadingmenuid;
  var dbleftheadingmain;
  var dbleftsubheadingmenuid;
  var dbleftheadinglablemenuid;
  var dbleftsubheadingmenu;
  var dbleftheadinglable;
  var dbleftheadingvalue;
  String villageid = "";
  bool uploadFunctionCalled = false;
  bool isFABVisible = true;
  Offset fabPosition = const Offset(1, 600);

  void toggleFABVisibility() {
    setState(() {
      isFABVisible = !isFABVisible;
    });
  }

  _DashboardState(
      {required this.stateId, required this.userid, required this.usertoken});

  static CacheManager customCacheManager = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 20,
    ),
  );
  bool _loading = false;

  List<dynamic>? dbmainlist = [];
  List<Schememodal> schemelist = [];
  String schemevalue = '-- Select Scheme --';
  String schemename = "";
  String schemecategory = "";
  String schemeid = "";
  late Schememodal schememodal;
  String? _currentAddress;
  Position? _currentPosition;
  List<dynamic> ListResponse = [];
  String newschameid = "";
  String newschemename = "";
  String messageofscheme_mvs = "";
  String messageof_existingscheme = "";
  String newCategory = "";
  late Future<List<Localmasterdatanodal>> localmasterdatalist;
  late Localmasterdatanodal localmasterdatanodal;
  String gettotalvillage = "";
  String OfflineStatus = "";
  String PanchayatName = "";
  String BlockName = "";
  String DistrictName = "";
  List<dynamic> Listofsourcetype = [];
  bool isselect = false;
  late Villagelistmodal villagelistmodal;
  int? index;
  late Saveoffinevillagemodal? saveoffinevillagemodal;
  var Nolistpresent;
  var totalsibrecord;
  String totalotherassetsofflineentreies = "";
  late Villagelistforsend villagelist;
  List<Villagelistforsend> listofvill = [];
  List<MyClass> _selecteCategorys = [];
  List<MyClass> selectedbox = [];
  List listone = [];
  List<Localsaveofflinevillages> localofflinevillagelist = [];
  late MyClass myClass;
  late Localsaveofflinevillages localsaveofflinevillages;
  String searchString = "";
  String totalpwssource = "";
  String totalpwssource_onupdate = "";
  String totalsibboard = "";
  String totalsibboard_onupdate = "";
  String assignedvillagew = "";
  late Savevillagedetails savevillagedetails;
  late Savesourcetypemodal savesourcetypemodal;
  var totalvillages;
  List<dynamic> saveoffinevillaglist = [];
  String assignedvillage = "";
  String pwstotalscheme = "";
  String awsschoolschemetotal = "";
  var workingvillage = "";
  List offlinevillagelistlist = [];
  String totalstoragestructureofflineentreies = "";
  String totalstoragestructureboard = "";
  var successfulUploadCountOT;
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
  late GetSourceCategoryModal getSourceCategoryModal;
  var distinctlist = [];
  var distinct_categorylist = [];
  List listResult = [];
  bool floatingloader = false;
  var versionapk = 5;

  callfornumber() async {
    if (Nolistpresent == null) {
      Nolistpresent = 0;
    }
    Nolistpresent = await databaseHelperJalJeevan!.countRows();
  }

  Future<bool> requestLocationPermission() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      return false;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    } else {
      return false;
    }
  }

  void checkAndRequestLocationPermission() async {
    bool permissionGranted = await requestLocationPermission();
    if (permissionGranted) {
    } else {}
  }

  @override
  void initState() {
    isInternet();

    checkAndRequestLocationPermission();
    databaseHelperJalJeevan = DatabaseHelperJalJeevan();
    myresponse = Myresponse();
    localmasterdatanodal = Localmasterdatanodal();
    schememodal = Schememodal("-- Select Scheme --", "", "");
    savesourcetypemodal = Savesourcetypemodal();

    print("usertoken" +box.read("UserToken").toString());
    print("stateid" +box.read("stateid").toString());
    print("userid" +box.read("userid").toString());


    setState(() {

      doSomeAsyncStuff();
    });
    loaddata();

    Apicallforvilages();
    getload();
    callfornumber();
    setState(() {
      getallpwssaveoffline();
      getallsibsaveoffline();
      getallotherassetssaveoffline();

      getallstoragestructuresaveoffline();
    });

    setState(() {
      totalvillages = int.parse(box.read("TotalOfflineVillage") ?? '0');
    });
    fetchDateandtimefromtable(box.read("userid").toString());
    super.initState();
  }

  void fetchDateandtimefromtable(String userId) async {
    List<Map<String, dynamic>> data =
        await databaseHelperJalJeevan!.getDatatime(userId);
  }

  Future<void> getallpwssaveoffline() async {
    final List<LocalPWSSavedData>? localDataList =
        await databaseHelperJalJeevan?.getAllLocalPWSSavedData();

    totalpwssource = localDataList!.length.toString();
  }




  Future<void> getallstoragestructuresaveoffline() async {
    final List<LocalStoragestructureofflinesavemodal>? localDataList =
        await databaseHelperJalJeevan
            ?.getallofflineentriesforstoragestructure();
    setState(() {
      totalstoragestructureofflineentreies = localDataList!.length.toString();
    });
  }

  Future<void> getallsibsaveoffline() async {
    final List<LocalSIBsavemodal>? localDataList =
        await databaseHelperJalJeevan?.getallofflineentriessib();
    setState(() {
      totalsibboard = localDataList!.length.toString();
    });
  }

  Future<void> getallotherassetssaveoffline() async {
    final List<LocalOtherassetsofflinesavemodal>? localDataList =
        await databaseHelperJalJeevan?.getallofflineentriesforotherassets();
    setState(() {
      totalotherassetsofflineentreies = localDataList!.length.toString();
    });
  }

  getload() async {
    saveoffinevillaglist =
        await databaseHelperJalJeevan!.fetchData_fromdb_saveofflinevilage();
    setState(() {
      for (int i = 0; i < saveoffinevillaglist.length; i++) {
        offlinevillagelistlist = saveoffinevillaglist![i]!["Villagelist"];
      }
    });
  }

  countdatain_sibtable() async {
    if (totalsibrecord == null) {
      totalsibrecord = 0;
    }

    totalsibrecord = await databaseHelperJalJeevan!.countRows_forsib();
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
  Future<void> cleartable_ofmastersourceandcategory() async {
    await databaseHelperJalJeevan!.cleardb_sourcetypecategorytable();
    await databaseHelperJalJeevan!.cleardb_sourcassettypetable();

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
  Future<void> Totaluploadofflineserver_appupdatecase() async {


    try {
      await uploadLocalDataAndClear_forappupdatecase(context);
      await uploadLocalDataAndClear_forsib_appupdatecase(context);
      await StoragestructureuploadLocalDataAndClear_forappupdatecase(context);
      await OtherassetsuploadLocalDataAndClear_forappupdatecase(context);

      if (uploadFunctionCalled == true) {
        await clearAndFetchMasterData(context);
      }
    } catch (e) {
      debugPrintStack();
    }

  }
  Future<void> uploadLocalDataAndClear_forappupdatecase(BuildContext context) async {
    uploadFunctionCalled = true;
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

        if (response["Status"].toString() == "true") {
          setState(() {
            successfulUploadCount++;
          });

          await databaseHelperJalJeevan
              ?.truncateTableByVillageId_pwssavedonserver(localData.schemeId);
        } /*else {
          Stylefile.showmessageforvalidationfalse(
              context, "This source is alredy tagged.");

          await databaseHelperJalJeevan?.updateStatusInPendingList(
              localData.villageId,
              localData.schemeId,
              'This source is already tagged');
        }*/
      }

      if (successfulUploadCount > 0) {
        Stylefile.showmessageforvalidationtrue(context,
            "$successfulUploadCount records of pws has been uploaded successfully.");
        setState(() {
          totalpwssource =
              (int.parse(totalpwssource) - successfulUploadCount).toString();
        });
      }

    } catch (e) {
      if (e is TimeoutException) {
        Stylefile.showmessageforvalidationfalse(context,
            "Connection timed out. Please check your internet connection.");
      }
    }
  }
  Future<void> uploadLocalDataAndClear_forsib_appupdatecase(BuildContext context) async {
    uploadFunctionCalled = true;
    successfulUploadCountSIB = 0;
    try {
      final List<LocalSIBsavemodal>? localDataList =
      await databaseHelperJalJeevan?.getallofflineentriessib();
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
          localData.photo,
        );

        if (response["Status"].toString() == "true") {
          setState(() {
            successfulUploadCountSIB++;
          });
          await databaseHelperJalJeevan
              ?.truncateTableByVillageId_sibsaved(localData.schemeId);
        }
      }

      if (successfulUploadCountSIB > 0) {
        setState(() {});
        Stylefile.showmessageforvalidationtrue(
          context,
          "$successfulUploadCountSIB records of information board has been uploaded successfully.",
        );

        setState(() {
          totalsibboard =
              (int.parse(totalsibboard) - successfulUploadCountSIB).toString();
        });
      }

    } catch (e) {
      debugPrintStack();
    }
  }
  Future<void> StoragestructureuploadLocalDataAndClear_forappupdatecase(
      BuildContext context) async {
    successfulUploadCountSS = 0;
    uploadFunctionCalled = true;
    try {
      final List<LocalStoragestructureofflinesavemodal>? localDataList =
      await databaseHelperJalJeevan?.getallofflineentriesstoragestructure();
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
          /*  /*localData.Storagecapacity,
          localData.Selectstoragecategory,*/*/
        );

        if (response["Status"].toString() == "true") {
          setState(() {
            successfulUploadCountSS++;
          });
          await databaseHelperJalJeevan
              ?.truncateTableByVillageId_sssaved(localData.schemeId);
        }
      }

      if (successfulUploadCountSS > 0) {
        setState(() {});
        Stylefile.showmessageforvalidationtrue(
          context,
          "$successfulUploadCountSS records of information board has been uploaded successfully.",
        );

        setState(() {
          totalstoragestructureofflineentreies =
              (int.parse(totalstoragestructureofflineentreies) -
                  successfulUploadCountSS)
                  .toString();
        });
      }

    } catch (e) {
      debugPrintStack();
    }
  }

  Future<void> OtherassetsuploadLocalDataAndClear_forappupdatecase(BuildContext context) async {
    uploadFunctionCalled = true;
    successfulUploadCountOT = 0;
    try {
      final List<LocalOtherassetsofflinesavemodal>? localDataList =
      await databaseHelperJalJeevan?.getallofflineentriesotherassets();
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
            //localData.capturePointTypeId
            localData.Selectassetsothercategory

        );

        if (response["Status"].toString() == "true") {
          setState(() {
            successfulUploadCountOT++;
          });

          await databaseHelperJalJeevan
              ?.truncateTableByVillageId_Ot(localData.schemeId);
        }
      }

      if (successfulUploadCountOT > 0) {
        setState(() {});
        Stylefile.showmessageforvalidationtrue(
          context,
          "$successfulUploadCountOT records of other assets has been uploaded successfully.",
        );

        setState(() {
          totalotherassetsofflineentreies =
              (int.parse(totalotherassetsofflineentreies) -
                  successfulUploadCountOT)
                  .toString();
        });
      }

    } catch (e) {
      debugPrintStack();
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

  insertvillagedetails(savevillagedetails) async {
    await databaseHelperJalJeevan
        ?.insertData_villagedetails_inDB(savevillagedetails);
  }

  Future<void> truncateTable_duplicate_entryofdashboarDB() async {
    await databaseHelperJalJeevan!.duplicate_entryofdashboarDB();
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
          var VillageId = data![i]!["VillageId"].toString();
          var VillageName = data![i]!["VillageName"].toString();
          OfflineStatus = data![i]!["OfflineStatus"].toString();
          PanchayatName = data![i]!["PanchayatName"].toString();
          BlockName = data![i]!["BlockName"].toString();
          DistrictName = data![i]!["DistrictName"].toString();
          listofvill.add(Villagelistforsend(VillageName, VillageId,
              OfflineStatus, PanchayatName, BlockName, DistrictName));

          if (listofvill![i]!.OfflineStatus == '1') {
            setState(() {
              listofvill![i]!.isChecked = true;

              _selecteCategorys.add(MyClass(listofvill![i]!.villageid));
              getschemesource(context, box.read("UserToken"),
                  listofvill![i]!.villageid.toString());
            });
          } else {
            setState(() {
              listofvill![i]!.isChecked = false;
            });
          }
        }
      } else if (mResposne["Message"] == "Record not found") {
        cleartable_localmastertables();
        Stylefile.showmessageforvalidationtrue(context, mResposne["Message"]);
      } else {
        Get.offAll(LoginScreen());
        box.remove("UserToken");
      }
      setState(() {});
    }
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
        newschameid = data![i]!["Schemeid"].toString();
        newschemename = data![i]!["Schemename"].toString();
        newCategory = data![i]!["Category"].toString();
        schemelist.add(Schememodal(newschameid, newschemename, newCategory));
      }
      databaseHelperJalJeevan!.insertData_schemelist_inDB(
          Schememodal(newschameid, newschemename, newCategory));
      setState(() {});
    }
    return jsonDecode(response.body);
  }

  loaddata() async {
    List<Localmasterdatanodal> records =
        await databaseHelperJalJeevan!.Fatchdatafrommastertable();

    setState(() {
      localmasterdatalist = databaseHelperJalJeevan!.Fatchdatafrommastertable();
    });
  }

  Future isInternet() async {
    await SyncronizationData.isInternet().then((connection) {
      if (connection) {
      } else {}
    });
  }

  Future<void> truncateTable_duplicate_entryforassetsourcetypeB() async {
    await databaseHelperJalJeevan!.duplicate_entryforassetsourcetypeB();
  }

  Future<void> truncateTable_duplicate_entryforsourcecategory() async {
    await databaseHelperJalJeevan!.duplicate_entryforsourcecategory();
  }

  Future<void> doSomeAsyncStuff() async {
    setState(() {
      _loading = true;
    });
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        getData().then((value) {
          myresponse = value;
          if (box.read("appvaersion") == null) {
            cleartable_localmasterschemelisttable();
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
                var totalNoOfWaterSource =
                    value.villageDetails![i]!.totalNoOfWaterSource;
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
                        villageId:
                            value.informationBoardList![i]!.villageId.toString(),
                        stateId:
                            value.informationBoardList![i]!.stateId.toString(),
                        schemeId:
                            value.informationBoardList![i]!.schemeId.toString(),
                        districtName:
                            value.informationBoardList![i]!.districtName,
                        blockName: value.informationBoardList![i]!.blockName,
                        panchayatName:
                            value.informationBoardList![i]!.panchayatName,
                        villageName: value.informationBoardList![i]!.villageName,
                        habitationName:
                            value.informationBoardList![i]!.habitationName,
                        latitude:
                            value.informationBoardList![i]!.latitude.toString(),
                        longitude:
                            value.informationBoardList![i]!.longitude.toString(),
                        sourceName: value.informationBoardList![i]!.sourceName,
                        schemeName: value.informationBoardList![i]!.schemeName,
                        message: value.informationBoardList![i]!.message,
                        status:
                            value.informationBoardList![i]!.status.toString()));
              }
            });
          }
          else if (box.read("appvaersion") != versionapk) {
        /*    SchedulerBinding.instance!.addPostFrameCallback((_) {
              showAlertDialogforupdateapp(context);
              return;
            });*/
            showAlertDialogforupdateapp(context);
          }
        });
        setState(() {
          hasinternetconnection = true;

        });

setState(()  {
  cleartable_ofmastersourceandcategory();
  getcategoryApi(context, box.read("UserToken"));
  getsourcetyprASSETApi(context, box.read("UserToken"));
  print("nimacho");

});
      }

    /*  Stylefile.showmessageforvalidationtrue(
          context,
          "Master data downloaded successfully.");*/
    } on SocketException catch (_) {
      List<Myresponse> dataList =
          await databaseHelperJalJeevan!.fetchData_fromdb_ofdashboard();
      setState(() {
        hasinternetconnection = false;
      });

      setState(() {
        for (Myresponse myresponse in dataList) {
          username = myresponse!.userName.toString();
          UserDescription = myresponse.userDescription.toString();
          listResult = myresponse!.result!;

          truncateTable_duplicate_entryofdashboarDB();
          truncateTable_duplicate_entryforassetsourcetypeB();
          truncateTable_duplicate_entryforsourcecategory();

          try {
            for (var listResultmainmenu in listResult!) {
              for (int i = 0; i < listResult!.length; i++) {
                if (listResultmainmenu.menuId == "20") {
                  List<SubHeadingmenulist>? subheadingmenulist =
                      listResultmainmenu.subHeadingmenulist;

                  for (var subheadingofmainmenulist in subheadingmenulist!) {
                    subResult = subheadingofmainmenulist.result;
                    subHeadingmenuid =
                        subheadingofmainmenulist.subHeadingMenuId.toString();
                    dbleftsubheadingmenu =
                        subheadingofmainmenulist.subHeading.toString();
                    for (var lables in subResult!) {
                      leftmenuheadingmenuid = lables.lableMenuId.toString();
                      leftmenuheading = lables.lableText.toString();
                      leftmenuheadingvalue = lables.lableValue.toString();
                    }
                    dbleftheadingmenuid = listResultmainmenu.menuId;
                    dbleftheadingmain = listResultmainmenu.heading;
                    dbleftsubheadingmenuid = subHeadingmenuid;
                    dbleftheadinglablemenuid = leftmenuheadingmenuid;
                    dbleftheadinglable = leftmenuheading;
                    dbleftheadingvalue = leftmenuheadingvalue;
                  }
                  for (var subheadingofmainmenulist in subheadingmenulist!) {
                    subResult = subheadingofmainmenulist.result;
                    subHeadingmenuid =
                        subheadingofmainmenulist.subHeadingMenuId.toString();
                    dbleftsubheadingmenu =
                        subheadingofmainmenulist.subHeading.toString();

                    for (var lables in subResult!) {
                      leftmenuheadingmenuid = lables.lableMenuId.toString();
                      leftmenuheading = lables.lableText.toString();
                      leftmenuheadingvalue = lables.lableValue.toString();

                      var tv = "click here";
                      assignedvillage = lables.lableValue.toString();

                      if (lables.lableMenuId.toString() == "22") {
                        pwstotalscheme = lables.lableValue.toString();
                      }
                      if (lables.lableMenuId.toString() == "23") {
                        awsschoolschemetotal = lables.lableValue.toString();
                      }
                      totalSchemes = int.parse(pwstotalscheme) +
                          int.parse(awsschoolschemetotal);
                    }
                  }
                } else if (listResultmainmenu.menuId == "1") {
                  List<SubHeadingmenulist>? subheadingmenulist =
                      listResultmainmenu.subHeadingmenulist;
                  mainHeadingmenuwatersuipply =
                      listResultmainmenu.heading.toString();
                  for (var subheadingofmainmenulist in subheadingmenulist!) {
                    subResultofstatusewatersupply =
                        subheadingofmainmenulist.result;
                    watersupplyheading =
                        subheadingofmainmenulist.subHeading.toString();

                    if (subHeadingmenuid == "24") {
                      for (var lables in subResultofstatusewatersupply!) {
                        leftmenuheading = lables.lableText.toString();
                        leftmenuheadingvalue = lables.lableValue.toString();
                        leftmenuheadingicon = lables.icon.toString();
                      }
                    }
                  }
                } else if (listResultmainmenu.menuId == "2") {
                  List<SubHeadingmenulist>? subheadingmenulist =
                      listResultmainmenu.subHeadingmenulist;
                  mainHeadingmenugeotagging =
                      listResultmainmenu.heading.toString();

                  for (var subheadingofmainmenulist in subheadingmenulist!) {
                    subheadinggeotag_pwssource =
                        subheadingofmainmenulist.subHeading.toString();
                    subHeadingmenuid =
                        subheadingofmainmenulist.subHeadingMenuId.toString();

                    if (subHeadingmenuid.toString() == "8") {
                      pwsSubHeading =
                          subheadingofmainmenulist.subHeading.toString();
                      subResulgeotaggingassignvillagelist =
                          subheadingofmainmenulist.result;
                      for (var lables in subResulgeotaggingassignvillagelist!) {
                        leftmenuheading = lables.lableText.toString();
                        leftmenuheadingvalue = lables.lableValue.toString();
                        leftmenuheadingicon = lables.icon.toString();
                      }
                    } else if (subHeadingmenuid == "9") {
                      schemeinfosubheading =
                          subheadingofmainmenulist.subHeading.toString();
                      subResulgeotaggingassignvillageschemelist =
                          subheadingofmainmenulist.result;
                      for (var lables
                          in subResulgeotaggingassignvillageschemelist!) {
                        schemeinformationtext = lables.lableText.toString();
                        schemeinformationvalue = lables.lableValue.toString();
                        schemeinformationicon = lables.icon.toString();
                      }
                    } else if (subHeadingmenuid == "10") {
                      subheadingotherscemeasset =
                          subheadingofmainmenulist.subHeading.toString();
                      subResult_utherassetslist =
                          subheadingofmainmenulist.result;
                      for (var lables in subResult_utherassetslist!) {
                        otherassetstext = lables.lableText.toString();
                        otherassetstextvalue = lables.lableValue.toString();
                        otherassetstexticon = lables.icon.toString();
                      }
                    }
                  }
                } else if (listResultmainmenu.menuId == "3") {
                  List<SubHeadingmenulist>? subheadingmenulist =
                      listResultmainmenu.subHeadingmenulist;
                  villagenotcertified = listResultmainmenu.heading.toString();

                  for (var subheadingofmainmenulist in subheadingmenulist!) {
                    subHeadingmenuid =
                        subheadingofmainmenulist.subHeadingMenuId.toString();

                    if (subHeadingmenuid == "32") {
                      downloadsampleone =
                          subheadingofmainmenulist.subHeading.toString();
                      downloadsamplevillagelist =
                          subheadingofmainmenulist.result;
                      for (var lables in downloadsamplevillagelist!) {}
                    } else if (subHeadingmenuid == "33") {
                      downloadsmapletwo =
                          subheadingofmainmenulist.subHeading.toString();
                      downloadsamplevillagelisttwo =
                          subheadingofmainmenulist.result;
                    } else if (subHeadingmenuid.toString() == "26") {
                      subheadingvillage =
                          subheadingofmainmenulist.subHeading.toString();
                      villagenotcertifiedlist = subheadingofmainmenulist.result;
                      for (var lables in villagenotcertifiedlist!) {
                        leftmenuheading = lables.lableText.toString();
                        leftmenuheadingvalue = lables.lableValue.toString();
                        leftmenuheadingicon = lables.icon.toString();
                      }
                    }
                  }
                } else if (listResultmainmenu.menuId.toString() == "4") {
                  List<SubHeadingmenulist>? subheadingmenulist =
                      listResultmainmenu.subHeadingmenulist;
                  headinghgjdesination = listResultmainmenu.heading.toString();

                  for (var subheadingofmainmenulist in subheadingmenulist!) {
                    subHeadingmenuid =
                        subheadingofmainmenulist.subHeadingMenuId.toString();
                    subHeading_desingtion =
                        subheadingofmainmenulist.subHeading.toString();
                    subresultdesinationlist = subheadingofmainmenulist.result;

                    if (subHeadingmenuid.toString() == "29") {
                      for (var lables in subresultdesinationlist!) {
                        leftmenuheading = lables.lableText.toString();
                        leftmenuheadingvalue = lables.lableValue.toString();
                        leftmenuheadingicon = lables.icon.toString();
                      }
                    }
                  }
                }
              }
            }
          } catch (e) {}
        }
      });

      setState(() {
        _loading = false;
      });
    }
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
      await databaseHelperJalJeevan!.cleardb_sourcetypecategorytable();
      await databaseHelperJalJeevan?.insertData_mastersource_categorytype_inDB(getSourceCategoryModal!)
          .then((value) {});
      for (int i = 0; i < mainListsourcecategory.length; i++) {
        SourceTypeCategoryIdget =
            mainListsourcecategory![i]!["SourceTypeCategoryId"].toString();
        SourceTypeCategoryList_id.add(SourceTypeCategoryIdget);

        final SourceTypeCategory =
            mainListsourcecategory![i]!["SourceTypeCategory"];
        SourceTypeCategoryList.add(SourceTypeCategory);

        final sourcetypeid = mainListsourcecategory![i]!["SourceTypeId"];
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
            minisource.add(mainListsourcecategory![i]!["SourceType"].toString());
            sourcetypeidlistone
                .add(mainListsourcecategory![i]!["SourceTypeId"].toString());
          }
        } else if (SourceTypeCategory == "Surface Water") {
          if (SourceTypeCategoryIdget.toString() == "2") {
            minisource2.add(mainListsourcecategory![i]!["SourceType"].toString());
            sourcetypeidlist
                .add(mainListsourcecategory![i]!["SourceTypeId"].toString());
          }
        }
      }
    }
    return jsonDecode(response.body);
  }

  Future getData() async {
    var url = '${Apiservice.baseurl}'
            "JJM_Mobile/GetUsermenu?UserId=" +
        widget.userid.toString() +
        "&StateId=" +
        widget.stateid;
    final response =
        await http.post(Uri.parse(url), headers: {"APIKey": widget.usertoken});

    myresponse = Myresponse.fromJson(jsonDecode(response.body));


    if (myresponse!.status.toString() == "false") {
      setState(() {
        Get.off(LoginScreen());
        box.remove("UserToken").toString();

        cleartable_localmastertables();
        Stylefile.showmessageforvalidationfalse(
            context, "Please login, your token has been expired!");
      });
    } else {
      try {
        listResult = myresponse!.result!;

        await databaseHelperJalJeevan!.insertData_dashboard_inDB(myresponse!);

        truncateTable_duplicate_entryofdashboarDB();
        truncateTable_duplicate_entryforassetsourcetypeB();
        truncateTable_duplicate_entryforassetsourcetypeB();

        setState(() {
          if (myresponse!.result == null || myresponse!.status == "false") {
            Get.offAll(LoginScreen());
            box.remove("UserToken").toString();
          } else {
            dbmainlist = myresponse!.result!;
            username = myresponse!.userName.toString();
            UserDescription = myresponse!.userDescription.toString();
            box.write("username", myresponse!.userName.toString());
            Mobile = myresponse!.Mobile.toString();
            Designation = myresponse!.Designation.toString();

            try {
              for (var listResultmainmenu in listResult!) {
                for (int i = 0; i < listResult!.length; i++) {
                  if (listResultmainmenu.menuId == "20") {
                    List<SubHeadingmenulist>? subheadingmenulist =
                        listResultmainmenu.subHeadingmenulist;

                    for (var subheadingofmainmenulist in subheadingmenulist!) {
                      subResult = subheadingofmainmenulist.result;
                      subHeadingmenuid =
                          subheadingofmainmenulist.subHeadingMenuId.toString();
                      dbleftsubheadingmenu =
                          subheadingofmainmenulist.subHeading.toString();

                      for (var lables in subResult!) {
                        leftmenuheadingmenuid = lables.lableMenuId.toString();
                        leftmenuheading = lables.lableText.toString();
                        leftmenuheadingvalue = lables.lableValue.toString();

                        if (lables.lableMenuId.toString() == "21") {
                          assignedvillage = lables.lableValue.toString();
                        }

                        if (lables.lableMenuId.toString() == "35") {
                          var tv = "click here";

                          workingvillage = lables.lableValue.toString();
                          if (lables.lableValue == "0") {}
                          if (lables.lableMenuId.toString() == "22") {
                            pwstotalscheme = lables.lableValue.toString();
                          }
                          if (lables.lableMenuId.toString() == "23") {
                            awsschoolschemetotal = lables.lableValue.toString();
                          }
                          totalSchemes = int.parse(pwstotalscheme) +
                              int.parse(awsschoolschemetotal);
                        }
                      }
                    }
                  } else if (listResultmainmenu.menuId == "1") {
                    List<SubHeadingmenulist>? subheadingmenulist =
                        listResultmainmenu.subHeadingmenulist;
                    mainHeadingmenuwatersuipply =
                        listResultmainmenu.heading.toString();
                    for (var subheadingofmainmenulist in subheadingmenulist!) {
                      subResultofstatusewatersupply =
                          subheadingofmainmenulist.result;
                      watersupplyheading =
                          subheadingofmainmenulist.subHeading.toString();

                      if (subHeadingmenuid == "24") {
                        for (var lables in subResultofstatusewatersupply!) {
                          leftmenuheading = lables.lableText.toString();
                          leftmenuheadingvalue = lables.lableValue.toString();
                          leftmenuheadingicon = lables.icon.toString();
                        }
                      }
                    }
                  } else if (listResultmainmenu.menuId == "2") {
                    List<SubHeadingmenulist>? subheadingmenulist =
                        listResultmainmenu.subHeadingmenulist;
                    mainHeadingmenugeotagging =
                        listResultmainmenu.heading.toString();

                    for (var subheadingofmainmenulist in subheadingmenulist!) {
                      subheadinggeotag_pwssource =
                          subheadingofmainmenulist.subHeading.toString();
                      subHeadingmenuid =
                          subheadingofmainmenulist.subHeadingMenuId.toString();

                      if (subHeadingmenuid.toString() == "8") {
                        pwsSubHeading =
                            subheadingofmainmenulist.subHeading.toString();
                        subResulgeotaggingassignvillagelist =
                            subheadingofmainmenulist.result;
                        for (var lables
                            in subResulgeotaggingassignvillagelist!) {
                          leftmenuheading = lables.lableText.toString();
                          leftmenuheadingvalue = lables.lableValue.toString();
                          leftmenuheadingicon = lables.icon.toString();
                        }
                      } else if (subHeadingmenuid == "9") {
                        schemeinfosubheading =
                            subheadingofmainmenulist.subHeading.toString();
                        subResulgeotaggingassignvillageschemelist =
                            subheadingofmainmenulist.result;
                        for (var lables
                            in subResulgeotaggingassignvillageschemelist!) {
                          schemeinformationtext = lables.lableText.toString();
                          schemeinformationvalue = lables.lableValue.toString();
                          schemeinformationicon = lables.icon.toString();
                        }
                      } else if (subHeadingmenuid == "10") {
                        subheadingotherscemeasset =
                            subheadingofmainmenulist.subHeading.toString();
                        subResult_utherassetslist =
                            subheadingofmainmenulist.result;
                        for (var lables in subResult_utherassetslist!) {
                          otherassetstext = lables.lableText.toString();
                          otherassetstextvalue = lables.lableValue.toString();
                          otherassetstexticon = lables.icon.toString();
                        }
                      }
                    }
                  } else if (listResultmainmenu.menuId == "3") {
                    List<SubHeadingmenulist>? subheadingmenulist =
                        listResultmainmenu.subHeadingmenulist;
                    villagenotcertified = listResultmainmenu.heading.toString();

                    for (var subheadingofmainmenulist in subheadingmenulist!) {
                      subHeadingmenuid =
                          subheadingofmainmenulist.subHeadingMenuId.toString();

                      if (subHeadingmenuid == "32") {
                        downloadsampleone =
                            subheadingofmainmenulist.subHeading.toString();
                        downloadsamplevillagelist =
                            subheadingofmainmenulist.result;
                        for (var lables in downloadsamplevillagelist!) {}
                      } else if (subHeadingmenuid == "33") {
                        downloadsmapletwo =
                            subheadingofmainmenulist.subHeading.toString();
                        downloadsamplevillagelisttwo =
                            subheadingofmainmenulist.result;
                      } else if (subHeadingmenuid.toString() == "26") {
                        subheadingvillage =
                            subheadingofmainmenulist.subHeading.toString();
                        villagenotcertifiedlist =
                            subheadingofmainmenulist.result;
                        for (var lables in villagenotcertifiedlist!) {
                          leftmenuheading = lables.lableText.toString();
                          leftmenuheadingvalue = lables.lableValue.toString();
                          leftmenuheadingicon = lables.icon.toString();
                        }
                      }
                    }
                  } else if (listResultmainmenu.menuId.toString() == "4") {
                    List<SubHeadingmenulist>? subheadingmenulist =
                        listResultmainmenu.subHeadingmenulist;
                    headinghgjdesination =
                        listResultmainmenu.heading.toString();

                    for (var subheadingofmainmenulist in subheadingmenulist!) {
                      subHeadingmenuid =
                          subheadingofmainmenulist.subHeadingMenuId.toString();
                      subHeading_desingtion =
                          subheadingofmainmenulist.subHeading.toString();
                      subresultdesinationlist = subheadingofmainmenulist.result;

                      if (subHeadingmenuid.toString() == "29") {
                        for (var lables in subresultdesinationlist!) {
                          leftmenuheading = lables.lableText.toString();
                          leftmenuheadingvalue = lables.lableValue.toString();
                          leftmenuheadingicon = lables.icon.toString();
                        }
                      }
                    }
                  }
                }
              }

              setState(() {
               // getsourcetyprASSETApi(context, box.read("UserToken").toString());
              });
            } catch (e) {
            } finally {
              setState(() {
                _loading = false;
              });
            }
          }
        });
      } catch (e) {}
    }
  }

  Future getsourcetyprASSETApi(
    BuildContext context,
    String token,
  ) async {
    setState(() {
      _loading = true;
    });
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
      if (mResposne["Status"].toString() == "false") {
        setState(() {
          Get.offAll(LoginScreen());
          box.remove("UserToken").toString();
        });
      } else {
        Listofsourcetype = mResposne["Result"];
        savesourcetypemodal =
            Savesourcetypemodal.fromJson(jsonDecode(response.body));
        await databaseHelperJalJeevan!.cleardb_sourcassettypetable();
        await databaseHelperJalJeevan
            ?.insertData_mastersourcetype_inDB(savesourcetypemodal!);
        return jsonDecode(response.body);
      }
    }
    setState(() {
      _loading = false;
    });
  }

  void showAlertDialogforupdateapp(BuildContext context) async {
    List<String> messageParts =
    box.read("appAPKVersionMessage").toString().split("\\n");

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Appcolor.white,
            titlePadding: const EdgeInsets.only(top: 0, left: 0, right: 00),
            insetPadding: const EdgeInsets.symmetric(horizontal: 5),
            buttonPadding: const EdgeInsets.all(00),
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
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 5),
                child: Text(
                  'Note :',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Appcolor.white),
                ),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: messageParts.map((part) {
                      return Text(
                        part,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              /*Center(
                child: Container(
                  height: 40,
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
                      try {
                        launch(box.read("appAPKURL"));
                      } on PlatformException catch (e) {
                        launch(box.read("appAPKURL"));
                      } finally {
                        launch(box.read("appAPKURL"));
                      }
                      box.remove("UserToken");
                      box.remove('loginBool');
                      cleartable_localmasterschemelisttable();
                      Get.offAll(LoginScreen());
                    },
                    child: const Text(
                      'Download & update',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Appcolor.black,
                      ),
                    ),
                  ),
                ),
              ),*/
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Appcolor.red,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:

                      TextButton(
                        onPressed: () {
                          try {
                            launch(box.read("appAPKURL"));
                          } on PlatformException catch (e) {
                            launch(box.read("appAPKURL"));
                          } finally {
                            launch(box.read("appAPKURL"));
                          }
                          box.remove("UserToken");
                          box.remove('loginBool');
                          cleartable_localmasterschemelisttable();
                          Get.offAll(LoginScreen());
                        },
                        child: const Text(
                          'Download & update',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Appcolor.black,
                          ),
                        ),
                      ),
                    ) ,

                    SizedBox(height: 15,),
                    totalpwssource=="0" && totalstoragestructureofflineentreies=="0" && totalsibboard=="0" &&  totalotherassetsofflineentreies=="0" ?   SizedBox() :  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment:
                          Alignment.centerLeft,
                          child: Text(
                            "Offline data saved, will be erased if not synced using the below option.",
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(height: 15,),
                        SizedBox(
                          height: 40,
                          child: Directionality(
                            textDirection:
                            TextDirection.rtl,
                            child: ElevatedButton.icon(
                              style:
                              ElevatedButton.styleFrom(
                                elevation: 6,
                                primary: Appcolor.orange,
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      10.0),
                                ),
                              ),
                              onPressed: ()  async{
                                try {
                                  final result = await InternetAddress.lookup('example.com');
                                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

                                    Totaluploadofflineserver_appupdatecase().then((value) {
                                      try {
                                        launch(box.read("appAPKURL"));
                                      } on PlatformException catch (e) {
                                        launch(box.read("appAPKURL"));
                                      } finally {
                                        launch(box.read("appAPKURL"));
                                      }
                                      box.remove("UserToken");
                                      box.remove('loginBool');
                                      cleartable_localmasterschemelisttable();
                                      Get.offAll(LoginScreen());
                                    });

                                    // Navigator.of(context).pop();

                                  }
                                } on SocketException catch (_) {
                                  Stylefile
                                      .showmessageforvalidationfalse(
                                      context,
                                      "Unable to Connect to the Internet. Please check your network settings.");

                                }


                                //Get.offAll(LoginScreen());
                                // cleartable_localmasterschemelisttable();
                              },
                              label: const Text(
                                  'Sync offline data & download app',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight.bold,
                                      color: Appcolor.white)),
                              icon: const Icon(
                                Icons.upload,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup,
      child: FocusDetector(
        onFocusGained: () {
          setState(() {
            getData();
            getallpwssaveoffline();
            getallsibsaveoffline();
            getallotherassetssaveoffline();
            getallstoragestructuresaveoffline();
          });
        },
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(40.0),
              child: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                iconTheme: const IconThemeData(
                  color: Appcolor.white,
                ),
                title: const Text(
                  'Home',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                ),
                backgroundColor: Appcolor.bgcolor,
                elevation: 5,
              ),
            ),
            body: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/header_bg.png'),
                        fit: BoxFit.cover),
                  ),
                  child: _loading == true
                      ? const Center(
                          child: SizedBox(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(
                                  color: Appcolor.btncolor)),
                        )
                      : SingleChildScrollView(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              child: Image.asset(
                                                'images/bharat.png',
                                                width: 60,
                                                height: 60,
                                              ),
                                            ),
                                            Container(
                                              child: const Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      Textfile.headingjaljeevan,
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: Stylefile
                                                          .mainheadingstyle),
                                                  SizedBox(
                                                    child: Text(
                                                        Textfile
                                                            .subheadingjaljeevan,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: Stylefile
                                                            .submainheadingstyle),
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
                                                  backgroundColor:
                                                      Appcolor.white,
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
                                                                  FontWeight
                                                                      .bold,
                                                              color: Appcolor
                                                                  .white),
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
                                                              EdgeInsets.all(
                                                                  8.0),
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
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: TextButton(
                                                        child: const Text(
                                                          'No',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Appcolor
                                                                  .black),
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
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: TextButton(
                                                        child: const Text(
                                                          'Yes',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Appcolor
                                                                  .black),
                                                        ),
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();

                                                          box.remove(
                                                              "UserToken");
                                                          box.remove(
                                                              'loginBool');
                                                          cleartable_localmasterschemelisttable();

                                                          Get.offAll(
                                                              LoginScreen());

                                                          Stylefile
                                                              .showmessageforvalidationtrue(
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
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFC2C2C2)
                                          .withOpacity(0.3),
                                      border: Border.all(
                                        color: const Color(0xFFC2C2C2)
                                            .withOpacity(0.3),
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                          10.0,
                                        ),
                                      ),
                                    ),
                                    margin: const EdgeInsets.all(10),
                                    child: SizedBox(
                                        width: double.infinity,
                                        child: Container(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    "images/profile.png",
                                                    width: 60,
                                                    height: 60,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        username.toString(),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Container(
                                                        width: 250,
                                                        child: Text(
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          UserDescription
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 16,
                                                              color: Appcolor
                                                                  .dark),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              subResult!.length == 0
                                                  ? const SizedBox()
                                                  : Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            child:
                                                                ScrollConfiguration(
                                                              behavior: const ScrollBehavior()
                                                                  .copyWith(
                                                                      overscroll:
                                                                          false),
                                                              child: ListView
                                                                  .builder(
                                                                      itemCount:
                                                                          subResult!
                                                                              .length,
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                      const NeverScrollableScrollPhysics(),
                                                                      itemBuilder:
                                                                          (context,
                                                                              int index) {
                                                                        if (subResult![index].lableMenuId.toString() ==
                                                                            "21") {
                                                                          assignedvillage = subResult![index]
                                                                              .lableValue
                                                                              .toString();
                                                                        }

                                                                        if (subResult![index].lableMenuId.toString() ==
                                                                            "22") {
                                                                          pwstotalscheme = subResult![index]
                                                                              .lableValue
                                                                              .toString();
                                                                        }
                                                                        if (subResult![index].lableMenuId.toString() ==
                                                                            "23") {
                                                                          awsschoolschemetotal = subResult![index]
                                                                              .lableValue
                                                                              .toString();
                                                                        }
                                                                        try {
                                                                          totalSchemes =
                                                                              int.parse(pwstotalscheme) + int.parse(awsschoolschemetotal);
                                                                        } catch (e) {
                                                                          debugPrintStack();
                                                                        }
                                                                        return Container(
                                                                          margin: const EdgeInsets
                                                                              .all(
                                                                              2),
                                                                          child:
                                                                              Material(
                                                                            elevation:
                                                                                2.0,
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                            child:
                                                                                InkWell(
                                                                              splashColor: Appcolor.splashcolor,
                                                                              customBorder: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                              ),
                                                                              onTap: () {},
                                                                              child: Container(
                                                                                margin: const EdgeInsets.all(5),
                                                                                child: Row(children: [
                                                                                  subResult![index].lableMenuId == "21"
                                                                                      ? const SizedBox()
                                                                                      : const Icon(
                                                                                          Icons.radio_button_checked,
                                                                                          size: 20,
                                                                                          color: Colors.orange,
                                                                                        ),
                                                                                  const SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(2.0),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        subResult![index].lableMenuId.toString() == "35"
                                                                                            ? Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                children: [
                                                                                                  Text("${subResult![index].lableText}  : ${subResult![index].lableValue} ", style: const TextStyle(color: Appcolor.black, fontSize: 17, fontWeight: FontWeight.w500)),
                                                                                                  const SizedBox(
                                                                                                    width: 10,
                                                                                                  ),
                                                                                                  GestureDetector(
                                                                                                    onTap: () {
                                                                                                      if (assignedvillage == "0") {
                                                                                                        Stylefile.showmessageapierrors(context, "There is no assigned villages to you please contact to division officer.");
                                                                                                      } else {
                                                                                                        Get.to(Villagelistzero(assignedvillage: assignedvillage));
                                                                                                      }
                                                                                                    },
                                                                                                    child: const Padding(
                                                                                                      padding: EdgeInsets.all(0.0),
                                                                                                      child: Icon(
                                                                                                        Icons.edit_note_outlined,
                                                                                                        color: Appcolor.btncolor,
                                                                                                        size: 30,
                                                                                                      ),
                                                                                                    ),
                                                                                                  )
                                                                                                ],
                                                                                              )
                                                                                            : Text(
                                                                                                "${subResult![index].lableText} : ${subResult![index].lableValue} ",
                                                                                                style: const TextStyle(color: Appcolor.black, fontSize: 17, fontWeight: FontWeight.w500),
                                                                                              )
                                                                                      ],
                                                                                    ),
                                                                                  )
                                                                                ]),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }),
                                                            )),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                      ],
                                                    )
                                            ],
                                          ),
                                        )),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 1,
                                        bottom: 10),
                                    child: Material(
                                      elevation: 6.0,
                                      color: const Color(0xFF0D3A98),
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: InkWell(
                                        splashColor: Appcolor.splashcolor,
                                        customBorder: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        onTap: () {
                                          if (assignedvillage == "0") {
                                            Stylefile.showmessageapierrors(
                                                context,
                                                "There is no village assigned to you. Please contact to division officer.");
                                          } else if (workingvillage == "0") {
                                            if (workingvillage == "0") {
                                              Stylefile
                                                  .showmessageforvalidationtrue(
                                                      context,
                                                      "There is no villages assigned to you. Please select villages first.");
                                              Get.to(Villagelistzero(
                                                  assignedvillage:
                                                      assignedvillage));
                                            }
                                          } else {
                                            Get.to(Selectedvillaglist(
                                              stateId: stateId,
                                              userId: userid,
                                              usertoken: usertoken!,
                                            ));
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'Add/Geo-tag PWS assets ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.all(5),
                                                child: CircleAvatar(
                                                  minRadius: 20,
                                                  maxRadius: 20,
                                                  backgroundColor:
                                                      const Color(0xffffffff),
                                                  child: IconButton(
                                                    color:
                                                        const Color(0xFF0D3A98),
                                                    onPressed: () {
                                                      if (assignedvillage ==
                                                          "0") {
                                                        Stylefile
                                                            .showmessageapierrors(
                                                                context,
                                                                "There is no assigned villages to you please contact to division officer.");
                                                      } else if (workingvillage ==
                                                          "0") {
                                                        Stylefile
                                                            .showmessageapierrors(
                                                                context,
                                                                "There is no village assigned to you for geotagging assets. Please select villages first.");
                                                      } else {
                                                        Get.to(
                                                            Selectedvillaglist(
                                                          stateId: stateId,
                                                          userId: userid,
                                                          usertoken: usertoken!,
                                                        ));
                                                      }
                                                    },
                                                    icon: const Icon(
                                                      Icons.add,
                                                      weight: 100,
                                                      size: 25,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  totalpwssource == "0"
                                      ? const SizedBox()
                                      : Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Appcolor.btncolor,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          height: 50,
                                          child: Material(
                                            elevation: 6.0,
                                            color: Appcolor.white,
                                            borderRadius: BorderRadius.circular(
                                              10.0,
                                            ),
                                            child: InkWell(
                                              customBorder:
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0)),
                                              onTap: () async {
                                                await Get.to(
                                                    Commonallofflineentries(
                                                        clickforallscreen:
                                                            "0"));
                                                setState(() {});
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      'Tagged PWS Sources (Offline)',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Text(
                                                        totalpwssource,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          fontSize: 20.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  totalsibboard == "0"
                                      ? const SizedBox()
                                      : Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Appcolor.btncolor,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          height: 50,
                                          child: Material(
                                            elevation: 6.0,
                                            color: Appcolor.white,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: InkWell(
                                              splashColor: Appcolor.splashcolor,
                                              customBorder:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              onTap: () async {
                                                await Get.to(
                                                    Commonallofflineentries(
                                                        clickforallscreen:
                                                            "1"));
                                                setState(() {});
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      'Information boards (Offline)',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Text(
                                                        totalsibboard,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          fontSize: 20.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  totalotherassetsofflineentreies == "0"
                                      ? const SizedBox()
                                      : Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Appcolor.btncolor,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          height: 50,
                                          child: Material(
                                            elevation: 6.0,
                                            color: Appcolor.white,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: InkWell(
                                              splashColor: Appcolor.splashcolor,
                                              customBorder:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              onTap: () async {
                                                await Get.to(
                                                    Commonallofflineentries(
                                                        clickforallscreen:
                                                            "2"));
                                                setState(() {});
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      'Other assets (Offline)',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Text(
                                                        totalotherassetsofflineentreies,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          fontSize: 20.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  totalstoragestructureofflineentreies == "0"
                                      ? const SizedBox()
                                      : Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, top: 10, right: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Appcolor.btncolor,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          height: 50,
                                          child: Material(
                                            elevation: 6.0,
                                            color: Appcolor.white,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: InkWell(
                                              splashColor: Appcolor.splashcolor,
                                              customBorder:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              onTap: () async {
                                                await Get.to(
                                                    Commonallofflineentries(
                                                        clickforallscreen:
                                                            "3"));
                                                setState(() {});
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      'Storage structure (Offline)',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Text(
                                                        totalstoragestructureofflineentreies,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          fontSize: 20.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ), totalpwssource=="0" && totalstoragestructureofflineentreies=="0" && totalsibboard=="0" &&  totalotherassetsofflineentreies=="0" ?
                                       const SizedBox()
                                      : Center(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            margin: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                bottom: 10),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFFFFF)
                                                  .withOpacity(0.3),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                            child: SizedBox(
                                              height: 40,
                                              child: Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 6,
                                                    primary: Appcolor.orange,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                  ),
                                                  label: const Text(
                                                    'Upload to server',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                        if (box
                                                                .read(
                                                                    "UserToken")
                                                                .toString() ==
                                                            "null") {
                                                          box.remove(
                                                              "UserToken");
                                                          box.remove(
                                                              'loginBool');
                                                          cleartable_localmasterschemelisttable();
                                                          Get.off(
                                                              LoginScreen());
                                                          Stylefile
                                                              .showmessageforvalidationfalse(context, "Please login your token has been expired!");
                                                        } else {
                                                          setState(() {
                                                            Totaluploadofflineserver();
                                                          });
                                                        }
                                                      }
                                                    } on SocketException catch (_) {
                                                      Stylefile
                                                          .showmessageforvalidationfalse(
                                                              context,
                                                              "Unable to Connect to the Internet. Please check your network settings.");
                                                    }
                                                    setState(() {
                                                      getallpwssaveoffline();
                                                      getallsibsaveoffline();
                                                      getallotherassetssaveoffline();
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.upload,
                                                    color: Colors.white,
                                                    size: 30.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
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
                                          "Note : All the geo tagging entries are to be synced once the internet is available.",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: Container(
                                      child: Column(children: [
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        mainHeadingmenugeotagging == ""
                                            ? const SizedBox()
                                            : Container(
                                                margin: const EdgeInsets.all(5),
                                                height: 45,
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFF0B2E7C),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        mainHeadingmenugeotagging
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 18,
                                                            color:
                                                                Colors.white),
                                                      )),
                                                ),
                                              ),
                                        pwsSubHeading == null
                                            ? const SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 10),
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      pwsSubHeading,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.blue,
                                                          fontSize: 18),
                                                    )),
                                              ),
                                        subResulgeotaggingassignvillagelist!
                                                    .length ==
                                                0
                                            ? const SizedBox()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: GridView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    mainAxisSpacing: 4.0,
                                                    crossAxisSpacing: 4.0,
                                                    childAspectRatio:
                                                        (370.0 / 260.0),
                                                  ),
                                                  itemCount:
                                                      subResulgeotaggingassignvillagelist!
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              0),
                                                      decoration: BoxDecoration(
                                                        color: Appcolor.white,
                                                        border: Border.all(
                                                          color: Appcolor.white,
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
                                                      child: Material(
                                                        elevation: 2.0,
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
                                                          onTap: () {},
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child: Text(
                                                                      subResulgeotaggingassignvillagelist![
                                                                              index]
                                                                          .lableValue
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 125,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          5.0),
                                                                      child:
                                                                          Text(
                                                                        maxLines:
                                                                            4,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        softWrap:
                                                                            true,
                                                                        subResulgeotaggingassignvillagelist![index]
                                                                            .lableText
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: 35,
                                                                height: 80,
                                                                child: Center(
                                                                  child: CachedNetworkImage(
                                                                      cacheManager:
                                                                          customCacheManager,
                                                                      key:
                                                                          UniqueKey(),
                                                                      imageUrl: subResulgeotaggingassignvillagelist![
                                                                              index]
                                                                          .icon
                                                                          .toString(),
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      progressIndicatorBuilder: (context, url, downloadProgress) => Transform.scale(
                                                                          scale:
                                                                              .4,
                                                                          child: CircularProgressIndicator(
                                                                              value: downloadProgress
                                                                                  .progress)),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          const Icon(
                                                                              Icons.image)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        schemeinfosubheading == null
                                            ? const SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    schemeinfosubheading,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.blue,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                        subResulgeotaggingassignvillageschemelist!
                                                    .length ==
                                                0
                                            ? const SizedBox()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: GridView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    childAspectRatio:
                                                        (340.0 / 230.0),
                                                    mainAxisSpacing: 4.0,
                                                    crossAxisSpacing: 4.0,
                                                  ),
                                                  itemCount:
                                                      subResulgeotaggingassignvillageschemelist!
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              0),
                                                      decoration: BoxDecoration(
                                                        color: Appcolor.white,
                                                        border: Border.all(
                                                          color: Appcolor.white,
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
                                                      child: Material(
                                                        elevation: 2.0,
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
                                                          onTap: () {},
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            4.0),
                                                                    child: Text(
                                                                      subResulgeotaggingassignvillageschemelist![
                                                                              index]
                                                                          .lableValue
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            5.0),
                                                                    child:
                                                                        SizedBox(
                                                                      width: 90,
                                                                      child:
                                                                          Text(
                                                                        maxLines:
                                                                            3,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        softWrap:
                                                                            true,
                                                                        subResulgeotaggingassignvillageschemelist![index]
                                                                            .lableText
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 80,
                                                                width: 40,
                                                                child: Center(
                                                                  child: CachedNetworkImage(
                                                                      cacheManager:
                                                                          customCacheManager,
                                                                      key:
                                                                          UniqueKey(),
                                                                      imageUrl: subResulgeotaggingassignvillageschemelist![
                                                                              index]
                                                                          .icon
                                                                          .toString(),
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      progressIndicatorBuilder: (context, url, downloadProgress) => Transform.scale(
                                                                          scale:
                                                                              .4,
                                                                          child: CircularProgressIndicator(
                                                                              value: downloadProgress
                                                                                  .progress)),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          const Icon(
                                                                              Icons.image)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        subheadingotherscemeasset == null
                                            ? const SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    subheadingotherscemeasset,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.blue,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                        subResult_utherassetslist!.length ==
                                                null
                                            ? const SizedBox()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: GridView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    childAspectRatio:
                                                        (320.0 / 220.0),
                                                    mainAxisSpacing: 3.0,
                                                    crossAxisSpacing: 3.0,
                                                  ),
                                                  itemCount:
                                                      subResult_utherassetslist!
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              0),
                                                      decoration: BoxDecoration(
                                                        color: Appcolor.white,
                                                        border: Border.all(
                                                          color: Appcolor.white,
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
                                                      child: Material(
                                                        elevation: 2.0,
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
                                                          onTap: () {},
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child: Text(
                                                                      subResult_utherassetslist![
                                                                              index]
                                                                          .lableValue
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            2.0),
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          110,
                                                                      child:
                                                                          Text(
                                                                        maxLines:
                                                                            3,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        softWrap:
                                                                            true,
                                                                        subResult_utherassetslist![index]
                                                                            .lableText
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: 45,
                                                                height: 80,
                                                                child: Center(
                                                                  child: CachedNetworkImage(
                                                                      cacheManager:
                                                                          customCacheManager,
                                                                      key:
                                                                          UniqueKey(),
                                                                      imageUrl: subResult_utherassetslist![
                                                                              index]
                                                                          .icon
                                                                          .toString(),
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      progressIndicatorBuilder: (context, url, downloadProgress) => Transform.scale(
                                                                          scale:
                                                                              .4,
                                                                          child: CircularProgressIndicator(
                                                                              value: downloadProgress
                                                                                  .progress)),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          const Icon(
                                                                              Icons.image)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        villagenotcertified == null
                                            ? const SizedBox()
                                            : Container(
                                                margin: const EdgeInsets.all(5),
                                                height: 45,
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFF0B2E7C),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        villagenotcertified,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white),
                                                      )),
                                                ),
                                              ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        downloadsampleone == null
                                            ? const SizedBox()
                                            : Container(
                                                margin: const EdgeInsets.all(5),
                                                height: 55,
                                                width: double.infinity,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: TextButton(
                                                  onPressed: () {},
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 20,
                                                        child: IconButton(
                                                          color: Colors.orange,
                                                          onPressed: () {},
                                                          icon: const Icon(
                                                            Icons
                                                                .download_rounded,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      downloadsampleone == null
                                                          ? const SizedBox()
                                                          : SizedBox(
                                                              width: 200,
                                                              child: Text(
                                                                downloadsampleone
                                                                    .toString(),
                                                                maxLines: 3,
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      14.0,
                                                                ),
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        downloadsmapletwo == null
                                            ? const SizedBox()
                                            : GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 5,
                                                      top: 5,
                                                      bottom: 5,
                                                      right: 5),
                                                  height: 55,
                                                  width: double.infinity,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: TextButton(
                                                    onPressed: () {},
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 20,
                                                          child: IconButton(
                                                            color:
                                                                Colors.orange,
                                                            onPressed: () {},
                                                            icon: const Icon(
                                                              Icons
                                                                  .download_rounded,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        SizedBox(
                                                          width: 200,
                                                          child: Text(
                                                            downloadsmapletwo
                                                                .toString(),
                                                            maxLines: 3,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14.0,
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
                                        subheadingvillage == null
                                            ? const SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    subheadingvillage
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.blue,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                        villagenotcertifiedlist!.length == 0
                                            ? const SizedBox()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: GridView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    mainAxisSpacing: 5.0,
                                                    crossAxisSpacing: 5.0,
                                                    childAspectRatio:
                                                        (340.0 / 220.0),
                                                  ),
                                                  itemCount:
                                                      villagenotcertifiedlist!
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              0),
                                                      decoration: BoxDecoration(
                                                        color: Appcolor.white,
                                                        border: Border.all(
                                                          color: Appcolor.white,
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
                                                      child: Material(
                                                        elevation: 2.0,
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
                                                          onTap: () {},
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child: Text(
                                                                      villagenotcertifiedlist![
                                                                              index]
                                                                          .lableValue
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 92,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          Text(
                                                                        villagenotcertifiedlist![index]
                                                                            .lableText
                                                                            .toString(),
                                                                        maxLines:
                                                                            4,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        softWrap:
                                                                            true,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: 50,
                                                                height: 90,
                                                                child: Center(
                                                                  child: villagenotcertifiedlist![index]
                                                                              .icon
                                                                              .toString() ==
                                                                          null
                                                                      ? const SizedBox()
                                                                      : CachedNetworkImage(
                                                                          cacheManager:
                                                                              customCacheManager,
                                                                          key:
                                                                              UniqueKey(),
                                                                          imageUrl: villagenotcertifiedlist![index]
                                                                              .icon
                                                                              .toString(),
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          progressIndicatorBuilder: (context, url, downloadProgress) => Transform.scale(
                                                                              scale: .4,
                                                                              child: CircularProgressIndicator(value: downloadProgress.progress)),
                                                                          errorWidget: (context, url, error) => const Icon(Icons.image)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        subHeading_desingtion == null
                                            ? const SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    subHeading_desingtion
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.blue,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ListView.builder(
                                            itemCount:
                                                subresultdesinationlist!.length,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, int index) {
                                              return GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10,
                                                      left: 5,
                                                      right: 5),
                                                  height: 55,
                                                  width: double.infinity,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: TextButton(
                                                    onPressed: () {},
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFF0D3A98),
                                                          minRadius: 20,
                                                          maxRadius: 20,
                                                          child: IconButton(
                                                            color: Colors.white,
                                                            onPressed: () {},
                                                            icon: const Icon(
                                                              Icons.add,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          subresultdesinationlist![
                                                                  index]
                                                              .lableText
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.black,
                                                            fontSize: 15.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            })
                                      ]),
                                    ),
                                  ),
                                ]),
                          ],
                        )),
                ),
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
                          fabPosition.dx.clamp(
                              0.0, MediaQuery.of(context).size.width - 56),
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
                            if (!_isButtonDisabled) {
                              setState(() {
                                _isButtonDisabled = true;
                                _hasButtonBeenClicked = true;
                              });
                              Timer(const Duration(seconds: 3), () {
                                setState(() {
                                  floatingloader = false;
                                  _isButtonDisabled = false;
                                });
                              });
                              try {
                                final result =
                                    await InternetAddress.lookup('example.com');
                                if (result.isNotEmpty &&
                                    result[0].rawAddress.isNotEmpty) {
                                  cleartable_localmastertables();
                                  doSomeAsyncStuff().then((value) {
                                    floatingloader = true;
                                  });

                                  Apiservice.Getmasterapi(context)
                                      .then((value) {
                                    databaseHelperJalJeevan!
                                        .insertMasterapidatetime(
                                            Localmasterdatetime(
                                                UserId: box
                                                    .read("userid")
                                                    .toString(),
                                                API_DateTime: value.API_DateTime
                                                    .toString()));

                                    for (int i = 0;
                                        i < value.villagelist!.length;
                                        i++) {
                                      var userid = value.villagelist![i]!.userId;

                                      var villageId =
                                          value.villagelist![i]!.villageId;
                                      var stateId =
                                          value.villagelist![i]!.stateId;
                                      var villageName =
                                          value.villagelist![i]!.VillageName;

                                      databaseHelperJalJeevan
                                          ?.insertMastervillagelistdata(
                                              Localmasterdatanodal(
                                                  UserId: userid.toString(),
                                                  villageId:
                                                      villageId.toString(),
                                                  StateId: stateId.toString(),
                                                  villageName:
                                                      villageName.toString()))
                                          .then((value) {});
                                    }
                                    databaseHelperJalJeevan!
                                        .removeDuplicateEntries();

                                    for (int i = 0;
                                        i < value.villageDetails!.length;
                                        i++) {
                                      var stateName = "Assam";

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
                                      var totalNoOfScheme = value
                                          .villageDetails![i]!.totalNoOfScheme;
                                      var totalNoOfWaterSource = value
                                          .villageDetails![i]!
                                          .totalNoOfWaterSource;
                                      var totalWsGeoTagged = value
                                          .villageDetails![i]!.totalWsGeoTagged;
                                      var pendingWsTotal = value
                                          .villageDetails![i]!.pendingWsTotal;
                                      var balanceWsTotal = value
                                          .villageDetails![i]!.balanceWsTotal;
                                      var totalSsGeoTagged = value
                                          .villageDetails![i]!.totalSsGeoTagged;
                                      var pendingApprovalSsTotal = value
                                          .villageDetails![i]!
                                          .pendingApprovalSsTotal;
                                      var totalIbRequiredGeoTagged = value
                                          .villageDetails![i]!
                                          .totalIbRequiredGeoTagged;
                                      var totalIbGeoTagged = value
                                          .villageDetails![i]!.totalIbGeoTagged;
                                      var pendingIbTotal = value
                                          .villageDetails![i]!.pendingIbTotal;
                                      var balanceIbTotal = value
                                          .villageDetails![i]!.balanceIbTotal;
                                      var totalOaGeoTagged = value
                                          .villageDetails![i]!.totalOaGeoTagged;
                                      var balanceOaTotal = value
                                          .villageDetails![i]!.balanceOaTotal;
                                      var totalNoOfSchoolScheme = value
                                          .villageDetails![i]!
                                          .totalNoOfSchoolScheme;
                                      var totalNoOfPwsScheme = value
                                          .villageDetails![i]!.totalNoOfPwsScheme;

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
                                        totalNoOfScheme:
                                            totalNoOfScheme.toString(),
                                        totalNoOfWaterSource:
                                            totalNoOfWaterSource.toString(),
                                        totalWsGeoTagged:
                                            totalWsGeoTagged.toString(),
                                        pendingWsTotal:
                                            pendingWsTotal.toString(),
                                        balanceWsTotal:
                                            balanceWsTotal.toString(),
                                        totalSsGeoTagged:
                                            totalSsGeoTagged.toString(),
                                        pendingApprovalSsTotal:
                                            pendingApprovalSsTotal.toString(),
                                        totalIbRequiredGeoTagged:
                                            totalIbRequiredGeoTagged.toString(),
                                        totalIbGeoTagged:
                                            totalIbGeoTagged.toString(),
                                        pendingIbTotal:
                                            pendingIbTotal.toString(),
                                        balanceIbTotal:
                                            balanceIbTotal.toString(),
                                        totalOaGeoTagged:
                                            totalOaGeoTagged.toString(),
                                        balanceOaTotal:
                                            balanceOaTotal.toString(),
                                        totalNoOfSchoolScheme:
                                            totalNoOfSchoolScheme.toString(),
                                        totalNoOfPwsScheme:
                                            totalNoOfPwsScheme.toString(),
                                      ));
                                    }

                                    for (int i = 0;
                                        i < value.schmelist!.length;
                                        i++) {
                                      var source_type =
                                          value.schmelist![i]!.source_type;
                                    var schemeidnew =
                                          value.schmelist![i]!.schemeid;
                                      var villageid =
                                          value.schmelist![i]!.villageId;
                                      var schemenamenew =
                                          value.schmelist![i]!.schemename;
                                      var schemenacategorynew =
                                          value.schmelist![i]!.category;
                                      var SourceTypeCategoryId = value.schmelist![i]!.SourceTypeCategoryId;
                                      var source_typeCategory = value.schmelist![i]!.source_typeCategory;
                                      databaseHelperJalJeevan
                                          ?.insertMasterSchmelist(
                                              Localmasterdatamoda_Scheme(
                                                source_type: source_type.toString(),
                                        schemeid: schemeidnew.toString(),
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
                                      var stateid = value.sourcelist![i]!.stateid;
                                      var Schemename =
                                          value.sourcelist![i]!.schemeName;
                                      var villageid =
                                          value.sourcelist![i]!.villageId;
                                      var sourceTypeId =
                                          value.sourcelist![i]!.sourceTypeId;
                                      var statename =
                                          value.sourcelist![i]!.stateName;
                                      var sourceTypeCategoryId = value
                                          .sourcelist![i]!.sourceTypeCategoryId;
                                      var habitationId =
                                          value.sourcelist![i]!.habitationId;
                                      var villageName =
                                          value.sourcelist![i]!.villageName;
                                      var existTagWaterSourceId = value
                                          .sourcelist![i]!.existTagWaterSourceId;
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
                                      var sourceTypeCategory = value
                                          .sourcelist![i]!.sourceTypeCategory;
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
                                        isApprovedState:
                                            isApprovedState.toString(),
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
                                      var habitationName = value
                                          .habitationlist![i]!.habitationName;

                                      databaseHelperJalJeevan
                                          ?.insertMasterhabitaionlist(
                                              LocalHabitaionlistModal(
                                                  villageId:
                                                      villafgeid.toString(),
                                                  HabitationId:
                                                      habitationId.toString(),
                                                  HabitationName: habitationName
                                                      .toString()));
                                    }
                                    for (int i = 0;
                                        i < value.informationBoardList!.length;
                                        i++) {
                                      databaseHelperJalJeevan?.insertmastersibdetails(LocalmasterInformationBoardItemModal(
                                          userId: value.informationBoardList![i]!.userId
                                              .toString(),
                                          villageId: value
                                              .informationBoardList![i]!.villageId
                                              .toString(),
                                          stateId: value.informationBoardList![i]!.stateId
                                              .toString(),
                                          schemeId: value
                                              .informationBoardList![i]!.schemeId
                                              .toString(),
                                          districtName: value
                                              .informationBoardList![i]!
                                              .districtName,
                                          blockName: value
                                              .informationBoardList![i]!
                                              .blockName,
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
                                  setState(() {
                                    floatingloader = false;
                                  });
                                  Stylefile.showmessageforvalidationtrue(
                                      context,
                                      "Master data downloaded successfully.");
                                  DateTime currentTime = DateTime.now();
                                }
                              }
                              on SocketException catch (_) {
                                Stylefile.showmessageforvalidationfalse(context,
                                    "Unable to Connect to the Internet. Please check your network settings.");
                              }
                            }
                          }),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => Container(
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
                      "Are you sure want to exit from this application ?",
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
                    SystemNavigator.pop();
                  },
                ),
              ),
            ],
          )),
        ) ??
        false;
  }

  var totalofflineupload;
  int successfulUploadCount = 0;
  int successfulUploadCountSIB = 0;
  int successfulUploadCountSS = 0;

  Future<void> Totaluploadofflineserver() async {
    try {
      await uploadLocalDataAndClear(context);
      await uploadLocalDataAndClear_forsib(context);
      await StoragestructureuploadLocalDataAndClear(context);
      await OtherassetsuploadLocalDataAndClear(context);

      if (uploadFunctionCalled == true) {
        await clearAndFetchMasterData(context);
      }
    } catch (e) {
      debugPrintStack();
    }
  }
  Future<void> clearAndFetchMasterData(BuildContext context) async {
    cleartable_localmasterschemelisttable();
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
        var stateid = value.villageDetails![i]!.stateId;
        var blockName = value.villageDetails![i]!.blockName;
        var panchayatName = value.villageDetails![i]!.panchayatName;
        var stateidnew = value.villageDetails![i]!.stateId;
        var userId = value.villageDetails![i]!.userId;
        var villageIddetails = value.villageDetails![i]!.villageId;
        var villageName = value.villageDetails![i]!.villageName;
        var totalNoOfScheme = value.villageDetails![i]!.totalNoOfScheme;
        var totalNoOfWaterSource =
            value.villageDetails![i]!.totalNoOfWaterSource;
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

  Future<void> uploadLocalDataAndClear_forsib(BuildContext context) async {
    uploadFunctionCalled = true;
    successfulUploadCountSIB = 0;
    try {
      final List<LocalSIBsavemodal>? localDataList =
          await databaseHelperJalJeevan?.getallofflineentriessib();
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
          localData.photo,
        );

        if (response["Status"].toString() == "true") {
          setState(() {
            successfulUploadCountSIB++;
          });
          await databaseHelperJalJeevan
              ?.truncateTableByVillageId_sibsaved(localData.schemeId);
        } else {
          await databaseHelperJalJeevan?.updateStatusInPendingListsib(
            localData.villageId,
            localData.schemeId,
            'This source is already tagged',
          );
          Stylefile.showmessageforvalidationfalse(
            context,
            "This source is already tagged",
          );
        }
      }

      if (successfulUploadCountSIB > 0) {
        setState(() {});
        Stylefile.showmessageforvalidationtrue(
          context,
          "$successfulUploadCountSIB records of information board has been uploaded successfully.",
        );

        setState(() {
          totalsibboard =
              (int.parse(totalsibboard) - successfulUploadCountSIB).toString();
        });
      }

    } catch (e) {
      debugPrintStack();
    }
  }

  Future<void> StoragestructureuploadLocalDataAndClear(
      BuildContext context) async {
    successfulUploadCountSS = 0;
    uploadFunctionCalled = true;
    try {
      final List<LocalStoragestructureofflinesavemodal>? localDataList =
          await databaseHelperJalJeevan?.getallofflineentriesstoragestructure();
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
          /*localData.Storagecapacity,
          localData.Selectstoragecategory,*/
        );

        if (response["Status"].toString() == "true") {
          setState(() {
            successfulUploadCountSS++;
          });
          await databaseHelperJalJeevan
              ?.truncateTableByVillageId_sssaved(localData.schemeId);
        } else {
          await databaseHelperJalJeevan
              ?.updateStatusInPendingListstoragestructure(
            localData.villageId,
            localData.schemeId,
            'This source is already tagged',
          );
          Stylefile.showmessageforvalidationfalse(
            context,
            "This source is already tagged",
          );
        }
      }

      if (successfulUploadCountSS > 0) {
        setState(() {});
        Stylefile.showmessageforvalidationtrue(
          context,
          "$successfulUploadCountSS records of information board has been uploaded successfully.",
        );

        setState(() {
          totalstoragestructureofflineentreies =
              (int.parse(totalstoragestructureofflineentreies) -
                      successfulUploadCountSS)
                  .toString();
        });
      }

    } catch (e) {
      debugPrintStack();
    }
  }

  Future<void> OtherassetsuploadLocalDataAndClear(BuildContext context) async {
    uploadFunctionCalled = true;
    successfulUploadCountOT = 0;
    try {
      final List<LocalOtherassetsofflinesavemodal>? localDataList =
          await databaseHelperJalJeevan?.getallofflineentriesotherassets();
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
            localData.Selectassetsothercategory);
            //localData.capturePointTypeId);

        if (response["Status"].toString() == "true") {
          setState(() {
            successfulUploadCountOT++;
          });

          await databaseHelperJalJeevan
              ?.truncateTableByVillageId_Ot(localData.schemeId);
        } else {
          await databaseHelperJalJeevan?.updateStatusInpendinglistot(
            localData.villageId,
            localData.schemeId,
            'This source is already tagged',
          );
          Stylefile.showmessageforvalidationfalse(
            context,
            "This source is already tagged",
          );
        }
      }

      if (successfulUploadCountOT > 0) {
        setState(() {});
        Stylefile.showmessageforvalidationtrue(
          context,
          "$successfulUploadCountOT records of other assets has been uploaded successfully.",
        );

        setState(() {
          totalotherassetsofflineentreies =
              (int.parse(totalotherassetsofflineentreies) -
                      successfulUploadCountOT)
                  .toString();
        });
      }

    } catch (e) {
      debugPrintStack();
    }
  }

  Future<void> uploadLocalDataAndClear(BuildContext context) async {
    uploadFunctionCalled = true;
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

        if (response["Status"].toString() == "true") {
          setState(() {
            successfulUploadCount++;
          });

          await databaseHelperJalJeevan
              ?.truncateTableByVillageId_pwssavedonserver(localData.schemeId);
        } else {
          Stylefile.showmessageforvalidationfalse(
              context, "This source is alredy tagged.");

          await databaseHelperJalJeevan?.updateStatusInPendingList(
              localData.villageId,
              localData.schemeId,
              'This source is already tagged');
        }
      }

      if (successfulUploadCount > 0) {
        Stylefile.showmessageforvalidationtrue(context,
            "$successfulUploadCount records of pws has been uploaded successfully.");
        setState(() {
          totalpwssource =
              (int.parse(totalpwssource) - successfulUploadCount).toString();
        });
      }

    } catch (e) {
      if (e is TimeoutException) {
        Stylefile.showmessageforvalidationfalse(context,
            "Connection timed out. Please check your internet connection.");
      }
    }
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
                    Get.to(Dashboard(
                        stateid: box.read("stateid"),
                        userid: box.read("userid"),
                        usertoken: box.read("UserToken")));
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

  bool _isButtonDisabled = false;
  bool _hasButtonBeenClicked = false;
}
