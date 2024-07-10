import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jaljeevanmissiondynamic/localdatamodel/LocalSIBsavemodal.dart';
import 'package:jaljeevanmissiondynamic/model/Savesourcetypemodal.dart';
import 'package:jaljeevanmissiondynamic/model/Schememodal.dart';
import 'package:jaljeevanmissiondynamic/utility/Appcolor.dart';
import 'package:jaljeevanmissiondynamic/view/NewTagScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../CommanScreen.dart';
import '../Selectedvillagelist.dart';
import '../apiservice/Apiservice.dart';
import '../database/DataBaseHelperJalJeevan.dart';
import '../localdatamodel/Localmasterdatamodal.dart';
import '../localdatamodel/Localpwssourcemodal.dart';
import '../model/Habitationlistmodal.dart';
import '../model/LocalOtherassetsofflinesavemodal.dart';
import '../model/LocalStoragestructureofflinesavemodal.dart';
import '../utility/Drawlatlong.dart';
import '../utility/Stylefile.dart';
import '../utility/Textfile.dart';
import 'AddNewSourceScreen.dart';
import 'Dashboard.dart';
import 'LoginScreen.dart';
import 'SS/ZoomImage.dart';
import 'VillageDetails.dart';
import 'firstnumerical.dart';

class ScreenPoints extends StatelessWidget {
  String no;

  ScreenPoints({required this.no});

  final int numberOfPoints = 2;

  @override
  Widget build(BuildContext context) {
    return Text(
      buildText(),
      style: const TextStyle(color: Colors.black, fontSize: 20),
    );
  }

  String buildText() {
    String screen = "Screen : ";
    return screen;
  }
}

class PointsAndLines extends StatelessWidget {
  final int numberOfPoints = 4;
  GetStorage box = GetStorage();
  var str = ['1', '2', '3', '4'];

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
      widgets.add(_buildPoint(str![i]!));
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

class NewTagWater extends StatefulWidget {
  String clcikedstatus;
  String stateid;
  String villageid;
  String villagename;
  String districtname;
  String blockname;
  String panchayatname;

  NewTagWater(
      {required this.clcikedstatus,
      required this.stateid,
      required this.villageid,
      required this.villagename,
      required this.districtname,
      required this.blockname,
      required this.panchayatname,
      Key? key})
      : super(key: key);

  @override
  State<NewTagWater> createState() => _NewTagWaterState();
}

class _NewTagWaterState extends State<NewTagWater> {
  bool messagedisplaypendingsource = false;
  bool messagenowatersourcecontactofc = false;
  bool viewVisible = false;
  bool selectschemesib = false;
  bool Habitaionsamesourcetext = false;
  bool ERVisible = false;
  bool Watersource = false;
  bool Schemeinformationboard = false;
  bool isGetGeoLocatonlatlong = false;
  bool Storagestructuretype = false;
  bool Selectalreadytaggedsource = false;
  bool SelectalreadytaggedsourceSIB = false;
  bool ESR_Selectalreadytaggedsource = false;
  bool capturepointlocation = false;
  bool cameradisplaygeotag = false;
  bool Elevated_Storage_Reservoir = false;
  bool Selecttaggedsource_camera = false;
  bool Selectstoragetype_ESR = false;
  bool Selectstoragetype_GSR = false;
  bool Getgeolocation_SIB = false;
  bool Takephotoforotherassets = false;

  bool othercategory = false;
  bool ESR_capacity = false;

  bool SelectalreadytaggedsourceESR = false;
  bool isMBRVisible = false;
  bool Clorinatorcategory = false;
  bool PumphouseOthercategory = false;
  bool PumphouseOthercategorywatertreatment = false;
  bool Othercategorymbr = false;
  bool Othercategorygrooundrechargewater = false;
  bool Takephotovisibility = false;
  bool isSameasSource = false;
  String base64Image = "";
  bool messagevisibility = false;
  bool geotaggedonlydropdown = false;
  bool selectschemesource = false;
  bool selectschemesourcemessage_mvc = false;
  bool offlinesiblistvosibleornot = false;
  bool selectschemenosource_svc = false;

  String? Selectassettaggingmain;
  String? ESRstoragestructuretype;

  var Othersmain;
  String? Capturepointotherscategory;
  String? Capturepointotherscategorypumphouse;
  String? Capturepointotherscategorywatertreatment;
  String? Selectassetcategory;
  String? Capturepointotherscategorymbr;
  String? Capturepointotherscategorygroundrecharge;
  String lat = '0';
  String long = '0';
  String? samesource;
  String? samesourcesib = "";
  String? geoloca;
  var assettaggingtype;
  String getvillagename = "";
  var getclickedstatus;
  var assettaggingid_fornewsource;
  String AssetTaggingType = "";
  String approvedState = "";
  String newschameid = "";
  String newschemename = "";
  String messageofscheme_mvs = "";
  String messageof_existingscheme = "";
  String newCategory = "";

  File? _image;

  List<dynamic> ListResponse = [];
  List<dynamic> Listofsourcetype = [];

  GetStorage box = GetStorage();

  void showWidget() {
    setState(() {
      viewVisible = true;
    });
  }

  void hideWidget() {
    setState(() {
      viewVisible = false;
    });
  }


  String dropdownvalue3 = 'Item 1';
  var schemename;

  var schemenameafterselect;

  var location;

  var SchemeId;

  var Latitude;

  var Longitude;

  var HabitationName;
  var SourceType;

  var SourceTypeCategory;
  var StateName;

  var BlockName;

  File? imgFile;
  final imgPicker = ImagePicker();

  List<dynamic> Listdetaillistofscheme = [];
  List<dynamic> Listdetaillistofscheme_mvs = [];
  List<dynamic> ListExistingsource = [];
  List<dynamic> ListExistingsource_location = [];
  String Existingsource_location = "";
  var Existingsource_habitaionid;

  var Existingsource_HabitationName;

  var Existingsource_SchemeId;

  String selectschamename = "";
  String selectcategoryname = "";
  String _mySchemeid = "-- Select Scheme --";
  String fileNameofimg = "";
  String imagepath = "";

  String schemeid = "";
  String schemecategory = "";

  List<Schememodal> schemelist = [];
  late Schememodal schememodal;
  Schememodal? initialSchememodal;
  String selectscheme_addnewsourcebtn = "";

  String selecthabitation_addnewsourcebtn = "";

  String selectlocationlanmark_addnewsourcebtn = "";

  String villageid_addnewsourcebtn = "";

  String assettaggingid_addnewsourcebtn = "";

  String StateId_addnewsourcebtn = "";

  String schemeid_addnewsourcebtn = "";

  String SourceId_addnewsourcebtn = "";

  String HabitationId_addnewsourcebtn = "";

  String SourceTypeId_addnewsourcebtn = "";

  String SourceTypeCategoryId_addnewsourcebtn = "";

  String villagename_addnewsourcebtn = "";
  var accuracyofgetlocation;
  var latitute_addnewsourcebtn;
  var Sourceid_new = "";
  var Sourceid_type = "";
  var SourceTypeCategoryId = "";
  var source_typeCategory = "";
  var longitute_addnewsourcebtn;
  DatabaseHelperJalJeevan? databaseHelperJalJeevan;
  late Savesourcetypemodal savesourcetypemodal;
  List<dynamic> saveassettypelist = [];
  String districtname = "";
  String blockname = "";
  String sourcetype = "";
  String panchayatname = "";
  var Nolistpresent;
  var totalsibrecord;
  bool btnstateicon = true;
  List<LocalSIBsavemodal> localsibpendinglist = [];
  List list = [];
  List<LocalPWSSavedData> localpwspendingDataList = [];
  Offset fabPosition = const Offset(1, 600);
  bool assetvisibility = false;
  var totalamout;
  var items2 = [
    'Item 6',
    'Item 7',
    'Item 8',
    'Item 9',
  ];
  String dropdownvalue = 'Item 1';
  String? selectlocation = 'Selectlocation';

  bool sibonlinemastermodallistvisible = false;

  var sourceTypeCategoryid = "";
  var sourcetypeidfroproced = "";
  var sourcetypelocal = "";

  List<String> _schemeDropdownItems = [];
  List<String> _habitaiondropdownitem = [];
  String _selectedscheme = '--Select Scheme--';
  String _selectedhabitaion = '--Select Habitaion--';
  List<LocalmasterInformationBoardItemModal> sibmasterdeail_list = [];

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

  Future<void> cleartable_villllagedetails() async {
    await databaseHelperJalJeevan!.cleartable_villagedetails();
  }

  Future<void> updateDetails() async {
    Map<String, dynamic> updatedDetails = {
      'villageId': widget.villageid,
    };

    int? rowsUpdated =
        await databaseHelperJalJeevan?.updateVillageDetails(updatedDetails);
  }

  void resetDropdownState() {
    setState(() {
      schemelist.clear();
      schememodal = schemelist.isNotEmpty
          ? schemelist[0]
          : Schememodal("-- Select id  --", "-- Select Scheme --", "");
      Listdetaillistofscheme.clear();
      Listdetaillistofscheme_mvs.clear();

      selectschemesource = false;
      selectschemesourcemessage_mvc = false;
      messagevisibility = false;
      selectschemenosource_svc = false;
      messagenowatersourcecontactofc = false;
    });
  }

  String? _dupselectedSchemeId = "";

  void onSchemeIdSelected(String schemeId) {
    _dupselectedSchemeId = schemeId;
    databaseHelperJalJeevan!
        .clearDuplicateEntriesForSchemeId(schemeId, widget.villageid);
  }

  callfornumber() async {
    if (Nolistpresent == null) {
      Nolistpresent = 0;
    }
    Nolistpresent = await databaseHelperJalJeevan!.countRows();
  }

  Future<void> _fetchSchemeDropdownItems(String villageId) async {
    List<Map<String, dynamic>>? distinctSchemes = await databaseHelperJalJeevan!
        .getAllRecordsForschemelist(villageId.toString());

    distinctSchemes!.map((map) => map['Schemename'].toString());

    schemelist.clear();
    schemelist.add(schememodal);
    for (int i = 0; i < distinctSchemes.length; i++) {
      newschameid = distinctSchemes![i]!["SchemeId"].toString();
      newschemename = distinctSchemes![i]!["Schemename"].toString();
      newCategory = distinctSchemes![i]!["Category"].toString();

      schemelist.add(Schememodal(newschameid, newschemename, newCategory));
    }

    setState(() {
      _schemeDropdownItems = [
        '-- Select Scheme --',
        ...distinctSchemes!.map((map) => map['Schemename'].toString())
      ];
    });
  }

  Future<void> _fetchhabitaiondropdownDropdownItems(villageId) async {
    List<Map<String, dynamic>>? distinctSchemes =
        await databaseHelperJalJeevan!.getDistinctHabitaion(villageId);
    habitationlist.clear();
    habitationlist.add(habitaionlistmodal);
    for (int i = 0; i < distinctSchemes!.length; i++) {
      var habitaionname = distinctSchemes![i]!["HabitationName"].toString();
      var habitaionid = distinctSchemes![i]!["HabitationId"].toString();
      habitationlist.add(Habitaionlistmodal(habitaionname, habitaionid));
    }

    setState(() {
      _habitaiondropdownitem = [
        '-- Select Habitation --',
        ...distinctSchemes!.map((map) => map['HabitationName'].toString())
      ];
      _selectedhabitaion = _habitaiondropdownitem.first;
    });
  }

  List<int> imageBytes = [];
  TextEditingController locationlandmarkcontroller = TextEditingController();
  TextEditingController capacitycontroller = TextEditingController();

  String selecthabitaionname = "-- Select Habitation --";
  var selecthabitaionid;
  List<Habitaionlistmodal> habitationlist = [];
  late Habitaionlistmodal habitaionlistmodal;

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

  String? _currentAddress;
  Position? _currentPosition;
  final PermissionWithService _permission = Permission.locationWhenInUse;

  bool locationprogress = false;

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

  var assettypeindexvalue;
  bool _loading = false;
  bool _loading_siblist = false;
  bool _loading_getloc = false;

  Future getexistingsourceApi(
    BuildContext context,
    String token,
    String schemeid,
  ) async {
    var uri = Uri.parse(
        '${Apiservice.baseurl}JJM_Mobile/GetExistSource?VillageId=' +
            widget.villageid +
            "&StateId=" +
            widget.stateid +
            "&UserId=" +
            box.read("userid").toString() +
            "&SchemeId=" +
            schemeid.toString());
    var response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'APIKey': token ?? 'DEFAULT_API_KEY'
      },
    );
    if (response.statusCode == 200) {
      setState(() {});
    }
    return jsonDecode(response.body);
  }

  Future getsourceschemedetails(
    BuildContext context,
    String token,
    String schemeid,
  ) async {
    var uri = Uri.parse(
        '${Apiservice.baseurl}JJM_Mobile/GetSourceSchemeDetails?VillageId=' +
            widget.villageid +
            "&StateId=" +
            widget.stateid +
            "&UserId=" +
            box.read("userid").toString() +
            "&SchemeId=" +
            schemeid.toString());
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
        Stylefile.showmessageforvalidationfalse(
            context, mResposne["Message"].toString());
      } else {
        Map<String, dynamic> mResposne = jsonDecode(response.body);
      }

      setState(() {});
    }
    return jsonDecode(response.body);
  }

  Future getsourceschemedetails_mvs(
    BuildContext context,
    String token,
    String schemeid,
  ) async {
    var uri = Uri.parse(
        '${Apiservice.baseurl}JJM_Mobile/GetSourceScheme_OtherVillage?VillageId=' +
            widget.villageid +
            "&StateId=" +
            widget.stateid +
            "&UserId=" +
            box.read("userid").toString() +
            "&SchemeId=" +
            schemeid.toString());
    var response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'APIKey': token ?? 'DEFAULT_API_KEY'
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> mResposne = jsonDecode(response.body);

      setState(() {});
    }
    return jsonDecode(response.body);
  }

  bool _isLoading = false;

  loadalldetails(String villageid) async {
    await databaseHelperJalJeevan!.getAllRecords().then((value) {
      List list = value;
    });

    await databaseHelperJalJeevan!
        .getallrecordsourcedetails(widget.villageid.toString())
        .then((value) {});
  }

  Future<void> fetchsourceid(String schemeid) async {
    Map<String, String?>? sourceDetails =
        await databaseHelperJalJeevan?.findSourceDetailsBySchemeId(schemeid);
    if (sourceDetails!.isNotEmpty) {
      setState(() {
        Sourceid_new = sourceDetails['SourceId'] ?? '';
      
        sourceTypeCategoryid = sourceDetails['sourceTypeCategoryId'].toString();
        sourcetypeidfroproced = sourceDetails['SourceTypeId'].toString();
        sourcetypelocal = sourceDetails['sourceType'].toString();
      });
    } else {
      Sourceid_new = '';
    }
  }

  Future<void> fetchsourceid_schemetable(String schemeid) async {
    Map<String, String?>? sourceDetails =
    await databaseHelperJalJeevan?.findSourcettypeBySchemeId(schemeid);
    if (sourceDetails!.isNotEmpty) {
      setState(() {
        Sourceid_type = sourceDetails['source_type'] ?? '';
        print("Sourceid_type$Sourceid_type");
      
      });
    } else {
      Sourceid_new = '';
    }
  }
  Future<void> fetchSourceTypeCategoryId_schemetable(String schemeid) async {
    Map<String, String?>? sourceDetails =
    await databaseHelperJalJeevan?.findSourcettype_categoryidBySchemeId(schemeid);
    if (sourceDetails!.isNotEmpty) {
      setState(() {
        SourceTypeCategoryId = sourceDetails['SourceTypeCategoryId'] ?? '';
        print("SourceTypeCategoryId_type:-$SourceTypeCategoryId");

      });
    } else {

      SourceTypeCategoryId = '';
    }
  }
  Future<void> fetchSourceTypeCategory_schemetable(String schemeid) async {
    Map<String, String?>? sourceDetails =
    await databaseHelperJalJeevan?.findSourcettype_categoryBySchemeId(schemeid);
    if (sourceDetails!.isNotEmpty) {
      setState(() {
        source_typeCategory = sourceDetails['source_typeCategory'] ?? '';
        print("source_typeCategory:-$source_typeCategory");

      });
    } else {
      source_typeCategory = '';
    }
  }
  
  void fetchRecordsByVillageId(schemeid) async {
    await databaseHelperJalJeevan!
        .getalllistfrompwssaveaccordingtoschemeid(schemeid, widget.villageid)
        .then((value) {
      localpwspendingDataList = value;
    });
  }

  void SIBfetchRecordsByVillageId(schemeid) async {
    await databaseHelperJalJeevan!
        .getalllistfromSIBsaveaccordingtoschemeid(schemeid, widget.villageid)
        .then((value) {
      localsibpendinglist = value;
    });
  }

  void countsib() async {
    if (totalsibrecord == null) {
      totalsibrecord = 0;
    }

    totalsibrecord = await databaseHelperJalJeevan?.countRows_forsib();
  }

  void fetchRecordsByschemeid(schemeid) async {
    setState(() {});
    await databaseHelperJalJeevan!.getallrecordsib_masterdata(schemeid, widget.villageid).then((value) {
      if (value.isNotEmpty) {
        setState(() {
          sibmasterdeail_list = value;
          for (int i = 0; i < sibmasterdeail_list.length; i++) {}
        });
      } else {
        Sourceid_new = "0";
        setState(() {
          sibmasterdeail_list.clear();
        });
      }
    });
  }

  @override
  void initState() {
    if (getclickedstatus == "1" ||
        getclickedstatus == "2" ||
        getclickedstatus == "4") {
      setState(() {
        selectschamename = schemelist[0].toString();
      });
    }

    countsib();

    initialSchememodal = schemelist.isNotEmpty ? schemelist[0] : null;
    databaseHelperJalJeevan = DatabaseHelperJalJeevan();
    resetDropdownState();
    _fetchhabitaiondropdownDropdownItems(widget.villageid);
    _fetchSchemeDropdownItems(widget.villageid);
    loadalldetails(widget.villageid);

    panchayatname = widget.panchayatname;
    blockname = widget.blockname;
    districtname = widget.districtname;

    setState(() {});

    if (box.read("UserToken").toString() == "null") {
      Get.off(LoginScreen());
      cleartable_localmasterschemelisttable();

      Stylefile.showmessageforvalidationfalse(
          context, "Please login your token has been expired!");
    }

    getclickedstatus = widget.clcikedstatus;

    getvillagename = widget.villagename;

    setState(() {
      if (getclickedstatus == "1") {
        assettypeindexvalue = getclickedstatus;
        viewVisible = true;
      } else if (getclickedstatus == "2") {
        setState(() {
          assettypeindexvalue = getclickedstatus;
          Storagestructuretype = false;
          Schemeinformationboard = true;
          viewVisible = true;
        });
      } else if (getclickedstatus == "3") {
        assettypeindexvalue = getclickedstatus;

        Schemeinformationboard = false;
        viewVisible = true;
        othercategory = false;
        Storagestructuretype = false;
      } else if (getclickedstatus == "4") {
        assettypeindexvalue = getclickedstatus;
        viewVisible = true;
        Storagestructuretype = false;
        Schemeinformationboard = false;
      }
    });

    habitaionlistmodal = Habitaionlistmodal(
        "-- Select Habitation --", "-- Select Habitation --");

    savesourcetypemodal = Savesourcetypemodal();
    setState(() {
      assettypesource();
    });
    callfornumber();

    _getCurrentPosition(context);

    super.initState();
  }

  assettypesource() async {
    saveassettypelist =
        await databaseHelperJalJeevan!.fetchData_fromdb_sourceassettype();
    setState(() {
      Listofsourcetype = saveassettypelist[0]["Resultone"];
      Listofsourcetype[0]["AssetTaggingType"].toString();
      Listofsourcetype[1]["AssetTaggingType"].toString();
      for (int i = 0; i < Listofsourcetype.length - 2; i++) {}
    });
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
            title: const Text("Asset details",
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
        body: FocusDetector(
          onFocusGained: () {
            setState(() {
            });
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/header_bg.png'), fit: BoxFit.cover),
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(Textfile.headingjaljeevan,
                                                textAlign: TextAlign.justify,
                                                style:
                                                    Stylefile.mainheadingstyle),
                                            SizedBox(
                                              child: Text(
                                                  Textfile.subheadingjaljeevan,
                                                  textAlign: TextAlign.justify,
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
                                                              FontWeight.bold,
                                                          color:
                                                              Appcolor.black),
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
                                visible: assetvisibility,
                                child:
                                Container(
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                "Select Asset",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const Divider(
                                              height: 10,
                                              color: Appcolor.lightgrey,
                                              thickness: 1,
                                            ),
                                            _loading == true
                                                ? Center(
                                                    child: SizedBox(
                                                        height: 40,
                                                        width: 40,
                                                        child: Image.asset(
                                                            "images/loading.gif")),
                                                  )
                                                :
                                            ListView.builder(
                                                    itemCount:
                                                        Listofsourcetype.length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (context, int index) {
                                                      return Container(
                                                        margin: const EdgeInsets
                                                            .all(3),
                                                        child: Material(
                                                          elevation: 2,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: InkWell(
                                                            splashColor: Appcolor
                                                                .splashcolor,
                                                            onTap: () {},
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          0),
                                                                  child:
                                                                      RadioListTile(
                                                                    activeColor:
                                                                        Appcolor
                                                                            .btncolor,
                                                                    enableFeedback:
                                                                        true,
                                                                    contentPadding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            0),
                                                                    visualDensity: const VisualDensity(
                                                                        horizontal:
                                                                            VisualDensity
                                                                                .minimumDensity,
                                                                        vertical:
                                                                            VisualDensity.minimumDensity),
                                                                    title: Container(
                                                                        child: Text(
                                                                            Listofsourcetype[index]["AssetTaggingType"].toString())),
                                                                    value: Listofsourcetype[index]
                                                                            [
                                                                            "Id"]
                                                                        .toString(),
                                                                    groupValue:
                                                                        getclickedstatus,
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        getclickedstatus = value;

                                                                        assettaggingid_fornewsource =
                                                                            getclickedstatus;

                                                                        if (getclickedstatus.toString() ==
                                                                            "1") {
                                                                          setState(
                                                                              () {
                                                                            schememodal = (schemelist.isNotEmpty
                                                                                ? schemelist[0]
                                                                                : null)!;

                                                                            sibonlinemastermodallistvisible =
                                                                                false;
                                                                            messagedisplaypendingsource =
                                                                                false;
                                                                            viewVisible =
                                                                                true;

                                                                            ERVisible =
                                                                                false;
                                                                            Watersource =
                                                                                false;
                                                                            Storagestructuretype =
                                                                                false;
                                                                            Schemeinformationboard =
                                                                                false;
                                                                            capturepointlocation =
                                                                                false;
                                                                            Selectalreadytaggedsource =
                                                                                false;
                                                                            messagevisibility =
                                                                                false;
                                                                            Elevated_Storage_Reservoir =
                                                                                false;
                                                                            Selecttaggedsource_camera =
                                                                                false;
                                                                            SelectalreadytaggedsourceSIB =
                                                                                false;
                                                                            Selectstoragetype_ESR =
                                                                                false;
                                                                            Selectstoragetype_GSR =
                                                                                false;
                                                                            Getgeolocation_SIB =
                                                                                false;
                                                                            othercategory =
                                                                                false;
                                                                            isGetGeoLocatonlatlong =
                                                                                false;

                                                                            ESR_capacity =
                                                                                false;
                                                                            Othercategorymbr =
                                                                                false;
                                                                            PumphouseOthercategorywatertreatment =
                                                                                false;
                                                                            PumphouseOthercategory =
                                                                                false;
                                                                            Clorinatorcategory =
                                                                                false;
                                                                            Othercategorymbr =
                                                                                false;
                                                                            Othercategorygrooundrechargewater =
                                                                                false;
                                                                            ESR_Selectalreadytaggedsource =
                                                                                false;

                                                                            selectschemesource =
                                                                                false;

                                                                            geotaggedonlydropdown =
                                                                                false;

                                                                            Takephotovisibility =
                                                                                false;
                                                                            offlinesiblistvosibleornot =
                                                                                false;
                                                                          });
                                                                        } else if (getclickedstatus.toString() ==
                                                                            "2") {
                                                                          setState(
                                                                              () {
                                                                            schememodal = (schemelist.isNotEmpty
                                                                                ? schemelist[0]
                                                                                : null)!;

                                                                            sibonlinemastermodallistvisible =
                                                                                false;
                                                                            offlinesiblistvosibleornot =
                                                                                true;
                                                                            messagedisplaypendingsource =
                                                                                false;
                                                                            viewVisible =
                                                                                true;
                                                                            ERVisible =
                                                                                false;
                                                                            Watersource =
                                                                                false;

                                                                            Storagestructuretype =
                                                                                false;
                                                                            Selectalreadytaggedsource =
                                                                                false;
                                                                            capturepointlocation =
                                                                                false;
                                                                            Elevated_Storage_Reservoir =
                                                                                false;
                                                                            Selecttaggedsource_camera =
                                                                                false;
                                                                            SelectalreadytaggedsourceSIB =
                                                                                false;
                                                                            Selectstoragetype_ESR =
                                                                                false;
                                                                            Selectstoragetype_GSR =
                                                                                false;
                                                                            Getgeolocation_SIB =
                                                                                false;
                                                                            othercategory =
                                                                                false;
                                                                            isGetGeoLocatonlatlong =
                                                                                false;
                                                                            ESR_capacity =
                                                                                false;
                                                                            Othercategorymbr =
                                                                                false;
                                                                            PumphouseOthercategorywatertreatment =
                                                                                false;
                                                                            PumphouseOthercategory =
                                                                                false;
                                                                            Clorinatorcategory =
                                                                                false;
                                                                            Othercategorymbr =
                                                                                false;
                                                                            Othercategorygrooundrechargewater =
                                                                                false;
                                                                            ESR_Selectalreadytaggedsource =
                                                                                false;
                                                                            selectschemesource =
                                                                                false;
                                                                            selectschemesourcemessage_mvc =
                                                                                false;
                                                                            Takephotovisibility =
                                                                                false;
                                                                            messagevisibility =
                                                                                false;
                                                                            offlinesiblistvosibleornot =
                                                                                false;

                                                                            Takephotoforotherassets =
                                                                                false;
                                                                            offlinesiblistvosibleornot =
                                                                                false;
                                                                          });
                                                                        } else if (getclickedstatus.toString() ==
                                                                            "3") {
                                                                          setState(
                                                                              () {
                                                                            schememodal = (schemelist.isNotEmpty
                                                                                ? schemelist[0]
                                                                                : null)!;

                                                                            sibonlinemastermodallistvisible =
                                                                                false;
                                                                            offlinesiblistvosibleornot =
                                                                                true;
                                                                            messagedisplaypendingsource =
                                                                                false;
                                                                            viewVisible =
                                                                                true;
                                                                            ERVisible =
                                                                                false;
                                                                            Watersource =
                                                                                false;

                                                                            Selectalreadytaggedsource =
                                                                                false;
                                                                            capturepointlocation =
                                                                                false;
                                                                            Elevated_Storage_Reservoir =
                                                                                false;
                                                                            Selecttaggedsource_camera =
                                                                                false;
                                                                            SelectalreadytaggedsourceSIB =
                                                                                false;
                                                                            Selectstoragetype_ESR =
                                                                                false;
                                                                            Selectstoragetype_GSR =
                                                                                false;
                                                                            Getgeolocation_SIB =
                                                                                false;
                                                                            othercategory =
                                                                                false;
                                                                            isGetGeoLocatonlatlong =
                                                                                false;
                                                                            ESR_capacity =
                                                                                false;
                                                                            Othercategorymbr =
                                                                                false;
                                                                            PumphouseOthercategorywatertreatment =
                                                                                false;
                                                                            PumphouseOthercategory =
                                                                                false;
                                                                            Clorinatorcategory =
                                                                                false;
                                                                            Othercategorymbr =
                                                                                false;
                                                                            Othercategorygrooundrechargewater =
                                                                                false;
                                                                            ESR_Selectalreadytaggedsource =
                                                                                false;
                                                                            selectschemesource =
                                                                                false;
                                                                            selectschemesourcemessage_mvc =
                                                                                false;
                                                                            Takephotovisibility =
                                                                                false;
                                                                            messagevisibility =
                                                                                false;
                                                                            offlinesiblistvosibleornot =
                                                                                false;

                                                                            Takephotoforotherassets =
                                                                                false;
                                                                            offlinesiblistvosibleornot =
                                                                                false;
                                                                            Storagestructuretype =
                                                                                true;
                                                                          });
                                                                        } else if (getclickedstatus.toString() ==
                                                                            "4") {
                                                                          setState(
                                                                              () {
                                                                            schememodal = (schemelist.isNotEmpty
                                                                                ? schemelist[0]
                                                                                : null)!;

                                                                            othercategory =
                                                                                true;
                                                                            Schemeinformationboard =
                                                                                false;
                                                                            sibonlinemastermodallistvisible =
                                                                                false;
                                                                          });
                                                                        }
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Visibility(
                                visible: viewVisible,
                                child: Container(
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
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Material(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: InkWell(
                                                splashColor:
                                                    Appcolor.splashcolor,
                                                onTap: () {},
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.all(10.0),
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Select Scheme",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
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
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.2,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 10.0,
                                                              right: 10,
                                                              left: 10),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5.0,
                                                              right: 5.0),
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          border: Border.all(
                                                              color: Appcolor
                                                                  .lightgrey,
                                                              width: .5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6)),
                                                      child: DropdownButton<
                                                              Schememodal>(
                                                          itemHeight: 100,
                                                          alignment:
                                                              Alignment.center,
                                                          elevation: 10,
                                                          dropdownColor:
                                                              Appcolor.white,
                                                          underline:
                                                              const SizedBox(),
                                                          isExpanded: true,
                                                          hint: const Text(
                                                            "-- Select Scheme --",
                                                          ),
                                                          value: schememodal,
                                                          items: schemelist.map(
                                                              (concernnames) {
                                                            return DropdownMenuItem<
                                                                Schememodal>(
                                                              value:
                                                                  concernnames,
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                decoration: const BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color:
                                                                                Colors.grey,
                                                                            width: 1))),
                                                                child: Text(
                                                                  concernnames
                                                                      .Schemename,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 3,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Appcolor
                                                                          .black),
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged:
                                                              (Schememodal?
                                                                  newValue) {
                                                            setState(() {
                                                              imgFile = null;
                                                              habitaionlistmodal =
                                                                  habitationlist
                                                                      .first;
                                                              locationlandmarkcontroller
                                                                  .text = '';

                                                              if (newValue
                                                                      ?.Schemename ==
                                                                  "-- Select Scheme --") {
                                                                setState(() {
                                                                  sibonlinemastermodallistvisible =
                                                                      false;
                                                                  messagenowatersourcecontactofc =
                                                                      false;
                                                                  Schemeinformationboard =
                                                                      false;
                                                                  selectschemesourcemessage_mvc =
                                                                      false;
                                                                  offlinesiblistvosibleornot =
                                                                      false;
                                                                  othercategory =
                                                                      false;

                                                                  Clorinatorcategory =
                                                                      false;
                                                                  PumphouseOthercategory =
                                                                      false;
                                                                  PumphouseOthercategorywatertreatment =
                                                                      false;
                                                                  Othercategorymbr =
                                                                      false;
                                                                  Othercategorygrooundrechargewater =
                                                                      false;
                                                                  geotaggedonlydropdown =
                                                                      false;

                                                                  Storagestructuretype =
                                                                      false;
                                                                  ESR_capacity =
                                                                      false;

                                                                  ESRstoragestructuretype =
                                                                      "";
                                                                });
                                                              }
                                                              if (getclickedstatus == "1" ||
                                                                  getclickedstatus ==
                                                                      "2" ||
                                                                  getclickedstatus ==
                                                                      "3" ||
                                                                  getclickedstatus ==
                                                                      "4") {
                                                                schememodal = newValue ?? schememodal;

                                                                ESRstoragestructuretype =
                                                                    "";
                                                              }

                                                              schememodal = newValue!;
                                                              _mySchemeid = newValue.Schemeid
                                                                  .toString();
                                                              selectschamename = newValue.Schemename;
                                                              selectcategoryname = newValue.Category.toString();

                                                              setState(() {
                                                                fetchRecordsByVillageId(
                                                                    _mySchemeid
                                                                        .toString());

                                                                SIBfetchRecordsByVillageId(
                                                                    _mySchemeid
                                                                        .toString());
                                                              });

                                                              if (newValue
                                                                      .Schemename ==
                                                                  "-- Select Scheme --") {
                                                                setState(() {
                                                                  Getgeolocation_SIB = false;
                                                                  isGetGeoLocatonlatlong = false;
                                                                  SelectalreadytaggedsourceSIB = false;
                                                                  Takephotoforotherassets = false;
                                                                });
                                                              } else {
                                                                fetchsourceid(_mySchemeid);
                                                                fetchsourceid_schemetable(_mySchemeid);
                                                                fetchSourceTypeCategoryId_schemetable(_mySchemeid);
                                                                fetchSourceTypeCategory_schemetable(_mySchemeid);
                                                                onSchemeIdSelected(_mySchemeid);
                                                                setState(() {fetchRecordsByVillageId(_mySchemeid.toString());
                                                                });

                                                                if (getclickedstatus == "1") {
                                                                  if (selectcategoryname == "svs") {
                                                                    databaseHelperJalJeevan!.getallrecordsourcedetails_byschemeid(_mySchemeid.toString(),
                                                                            selectcategoryname.toString(),
                                                                            widget.villageid).then(
                                                                            (value) {
                                                                      if (value
                                                                          .isNotEmpty) {
                                                                        setState(
                                                                            () {
                                                                          Listdetaillistofscheme =
                                                                              value.toList();
                                                                          sibonlinemastermodallistvisible =
                                                                              false;

                                                                          messagenowatersourcecontactofc =
                                                                              false;
                                                                          selectschemesourcemessage_mvc =
                                                                              true;

                                                                          Schemeinformationboard =
                                                                              false;
                                                                          messagevisibility =
                                                                              false;
                                                                        });
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          Sourceid_new = "0";
                                                                          Listdetaillistofscheme
                                                                              .clear();
                                                                          sibonlinemastermodallistvisible =
                                                                              false;
                                                                          selectschemenosource_svc =
                                                                              true;
                                                                          messagenowatersourcecontactofc =
                                                                              false;

                                                                          selectschemesourcemessage_mvc =
                                                                              true;
                                                                          messagevisibility =
                                                                              false;
                                                                        });
                                                                      }
                                                                    });
                                                                  } else {
                                                                    Listdetaillistofscheme
                                                                        .clear();
                                                                    messagenowatersourcecontactofc =
                                                                        false;
                                                                    databaseHelperJalJeevan!
                                                                        .getallrecordsourcedetails_byschemeid(
                                                                            _mySchemeid
                                                                                .toString(),
                                                                            selectcategoryname
                                                                                .toString(),
                                                                            widget
                                                                                .villageid)
                                                                        .then(
                                                                            (value) {
                                                                      if (value
                                                                          .isNotEmpty) {
                                                                        setState(
                                                                            () {
                                                                          Listdetaillistofscheme
                                                                              .clear();
                                                                          selectschemesourcemessage_mvc =
                                                                              true;
                                                                          Listdetaillistofscheme_mvs =
                                                                              value.toList();
                                                                          messagenowatersourcecontactofc =
                                                                              false;
                                                                          messagevisibility =
                                                                              true;
                                                                        });
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          sibonlinemastermodallistvisible =
                                                                              false;
                                                                          selectschemesourcemessage_mvc =
                                                                              false;
                                                                          selectschemenosource_svc =
                                                                              true;
                                                                          Listdetaillistofscheme
                                                                              .clear();
                                                                          messagenowatersourcecontactofc =
                                                                              true;
                                                                        });
                                                                      }
                                                                    });
                                                                  }
                                                                }
                                                                else if (getclickedstatus ==
                                                                    "2") {
                                                                  setState(() {
                                                                    sibonlinemastermodallistvisible =
                                                                        true;
                                                                    Schemeinformationboard =
                                                                        true;

                                                                    selectschemesource =
                                                                        false;
                                                                    selectschemesourcemessage_mvc =
                                                                        false;
                                                                    offlinesiblistvosibleornot =
                                                                        true;
                                                                    isGetGeoLocatonlatlong =
                                                                        false;
                                                                    SelectalreadytaggedsourceSIB =
                                                                        false;
                                                                    Getgeolocation_SIB =
                                                                        false;
                                                                  });
                                                                  fetchRecordsByschemeid(
                                                                      _mySchemeid
                                                                          .toString());
                                                                }
                                                                else if (getclickedstatus ==
                                                                    "3") {
                                                                  setState(() {
                                                                    Getgeolocation_SIB =
                                                                        true;
                                                                    Storagestructuretype =
                                                                        true;

                                                                    ESR_capacity =
                                                                        true;
                                                                    isGetGeoLocatonlatlong =
                                                                        true;
                                                                    Takephotoforotherassets =
                                                                        true;
                                                                  });
                                                                }
                                                                else if (getclickedstatus ==
                                                                    "4") {
                                                                  setState(() {
                                                                    othercategory =
                                                                        true;
                                                                    Schemeinformationboard =
                                                                        false;
                                                                    sibonlinemastermodallistvisible =
                                                                        false;
                                                                    Getgeolocation_SIB =
                                                                        true;
                                                                    Takephotoforotherassets =
                                                                        true;

                                                                    Othersmain =
                                                                        "";
                                                                    isGetGeoLocatonlatlong =
                                                                        true;
                                                                  });
                                                                }
                                                              }
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
                                visible: sibonlinemastermodallistvisible,
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
                                    child: sibmasterdeail_list.length == "0"
                                        ? const Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text("No data found"),
                                            ),
                                          )
                                        : _loading_siblist == true
                                            ? const Center(
                                                child: SizedBox(
                                                    height: 15,
                                                    width: 15,
                                                    child:
                                                        CircularProgressIndicator()))
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: sibmasterdeail_list
                                                                .length ==
                                                            0
                                                        ? const SizedBox()
                                                        : const Text(
                                                            "Geotagged information board : ",
                                                            style: TextStyle(
                                                                color: Appcolor
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18),
                                                          ),
                                                  ),
                                                  ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          sibmasterdeail_list
                                                              .length,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (context, int index) {
                                                        int counter = index + 1;
                                                        return Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            width:
                                                                double.infinity,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Appcolor
                                                                          .lightgrey,
                                                                      width: 1,
                                                                    ),
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            child: Material(
                                                              elevation: 0,
                                                              child: InkWell(
                                                                splashColor:
                                                                    Appcolor
                                                                        .lightyello,
                                                                onTap: () {},
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          5.0),
                                                                      child: Align(
                                                                          alignment: Alignment.centerLeft,
                                                                          child: Text(
                                                                            "" +
                                                                                counter.toString() +
                                                                                ".",
                                                                            style:
                                                                                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                                          )),
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const Padding(
                                                                          padding: EdgeInsets.only(
                                                                              left: 10,
                                                                              bottom: 5,
                                                                              top: 5),
                                                                          child: SizedBox(
                                                                              child: Text(
                                                                            "Habitation :",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Appcolor.black,
                                                                                fontSize: 16),
                                                                          )),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 10,
                                                                              bottom: 5,
                                                                              top: 5),
                                                                          child: SizedBox(
                                                                              child: Text(
                                                                            textAlign:
                                                                                TextAlign.justify,
                                                                            maxLines:
                                                                                5,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            sibmasterdeail_list![index].habitationName.toString(),
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 16,
                                                                                color: Appcolor.black),
                                                                          )),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const Padding(
                                                                          padding: EdgeInsets.only(
                                                                              left: 10,
                                                                              bottom: 5,
                                                                              top: 5),
                                                                          child: SizedBox(
                                                                              child: Text(
                                                                            "Location :",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 16,
                                                                                color: Appcolor.black),
                                                                          )),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 10,
                                                                              bottom: 5,
                                                                              top: 5),
                                                                          child: SizedBox(
                                                                              child: Text(
                                                                            textAlign:
                                                                                TextAlign.justify,
                                                                            maxLines:
                                                                                5,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            sibmasterdeail_list[index].sourceName.toString().toString(),
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 16,
                                                                                color: Appcolor.black),
                                                                          )),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const Padding(
                                                                          padding: EdgeInsets.only(
                                                                              left: 10,
                                                                              bottom: 5,
                                                                              top: 5),
                                                                          child: SizedBox(
                                                                              child: Text(
                                                                            "Latitude : ",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 16,
                                                                                color: Appcolor.black),
                                                                          )),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 10,
                                                                              bottom: 5,
                                                                              top: 5),
                                                                          child: SizedBox(
                                                                              child: Text(
                                                                            textAlign:
                                                                                TextAlign.justify,
                                                                            maxLines:
                                                                                5,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            sibmasterdeail_list![index].latitude.toString(),
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.w400, color: Appcolor.black),
                                                                          )),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const Padding(
                                                                          padding: EdgeInsets.only(
                                                                              left: 10,
                                                                              bottom: 5,
                                                                              top: 5),
                                                                          child: SizedBox(
                                                                              child: Text(
                                                                            "Longitude : ",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 16,
                                                                                color: Appcolor.black),
                                                                          )),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 10,
                                                                              bottom: 5,
                                                                              top: 5),
                                                                          child: SizedBox(
                                                                              child: Text(
                                                                            textAlign:
                                                                                TextAlign.justify,
                                                                            maxLines:
                                                                                5,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            sibmasterdeail_list[index].longitude.toString(),
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.w400, color: Appcolor.black),
                                                                          )),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    sibmasterdeail_list[index].message.toString() ==
                                                                            ""
                                                                        ? const SizedBox()
                                                                        : Row(
                                                                            children: [
                                                                              const Padding(
                                                                                padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                child: SizedBox(
                                                                                    child: Text(
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  "Message : ",
                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Appcolor.black),
                                                                                )),
                                                                              ),
                                                                              Flexible(
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                  child: SizedBox(
                                                                                      child: Text(
                                                                                    textAlign: TextAlign.justify,
                                                                                    maxLines: 5,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    sibmasterdeail_list[index].message.toString(),
                                                                                    style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Appcolor.red),
                                                                                  )),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ));
                                                      }),
                                                  Visibility(
                                                    visible:
                                                        Schemeinformationboard,
                                                    child: Material(
                                                      elevation: 5,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: InkWell(
                                                        splashColor:
                                                            Appcolor.lightyello,
                                                        onTap: () {},
                                                        child: Container(
                                                          height: 45,
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Appcolor
                                                                .btncolor,
                                                            border: Border.all(
                                                              color: Appcolor
                                                                  .btncolor,
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
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                child: SizedBox(
                                                                  height: 30,
                                                                  child: btnstateicon ==
                                                                          true
                                                                      ? GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            if (sibmasterdeail_list.length !=
                                                                                0) {
                                                                              _showalertboxforaddinformationboards();
                                                                            } else {
                                                                              _mySchemeid.toString() == "-- Select id  --"
                                                                                  ? Fluttertoast.showToast(msg: "Please select scheme", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0)
                                                                                  : setState(() {
                                                                                      btnstateicon = false;
                                                                                      samesourcesib = "2";

                                                                                      isGetGeoLocatonlatlong = true;
                                                                                      Takephotovisibility = false;
                                                                                      ESR_Selectalreadytaggedsource = false;
                                                                                      selectschemesource = false;
                                                                                      selectschemesourcemessage_mvc = false;
                                                                                      SelectalreadytaggedsourceSIB = true;
                                                                                      messagevisibility = false;
                                                                                      geotaggedonlydropdown = false;
                                                                                      Getgeolocation_SIB = true;
                                                                                      viewVisible = true;
                                                                                      offlinesiblistvosibleornot = true;
                                                                                    });
                                                                            }
                                                                          },
                                                                          child:
                                                                              const Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Align(
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Text(
                                                                                  'Add information board',
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.white,
                                                                                    fontSize: 18.0,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: 15),
                                                                              Icon(
                                                                                Icons.add_circle_outline,
                                                                                color: Appcolor.white,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      : GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              btnstateicon = true;

                                                                              Getgeolocation_SIB = false;
                                                                              isGetGeoLocatonlatlong = false;
                                                                              SelectalreadytaggedsourceSIB = false;
                                                                            });
                                                                          },
                                                                          child: const Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Align(
                                                                                  alignment: Alignment.centerLeft,
                                                                                  child: Text(
                                                                                    'Add information board',
                                                                                    style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.white,
                                                                                      fontSize: 18.0,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: 15),
                                                                                Icon(
                                                                                  Icons.remove_circle_outline,
                                                                                  color: Appcolor.white,
                                                                                )
                                                                              ])),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                              ),
                              Visibility(
                                visible: capturepointlocation,
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
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          "Capture Point Location(Information board_) * ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const Divider(
                                        height: 10,
                                        color: Colors.grey,
                                        thickness: 1,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5.0)),
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RadioListTile(
                                              visualDensity:
                                                  const VisualDensity(
                                                      horizontal: VisualDensity
                                                          .minimumDensity,
                                                      vertical: VisualDensity
                                                          .minimumDensity),
                                              contentPadding: EdgeInsets.zero,
                                              title:
                                                  const Text("Same as source"),
                                              value: "Sameassource_one",
                                              groupValue: samesource,
                                              onChanged: (value) {
                                                setState(() {
                                                  samesource = value.toString();
                                                  Selecttaggedsource_camera =
                                                      true;
                                                  ESR_Selectalreadytaggedsource =
                                                      true;
                                                  selectschemesource = false;
                                                  selectschemesourcemessage_mvc =
                                                      false;
                                                  Takephotovisibility = true;
                                                  SelectalreadytaggedsourceSIB =
                                                      false;
                                                  messagevisibility = false;
                                                  selectschemesib = false;
                                                  viewVisible = false;
                                                  offlinesiblistvosibleornot =
                                                      false;
                                                });
                                              },
                                            ),
                                            RadioListTile(
                                              visualDensity:
                                                  const VisualDensity(
                                                      horizontal: VisualDensity
                                                          .minimumDensity,
                                                      vertical: VisualDensity
                                                          .minimumDensity),
                                              contentPadding: EdgeInsets.zero,
                                              title: const Text(
                                                  "Get geo location"),
                                              value: "GeoLocation",
                                              groupValue: samesource,
                                              onChanged: (value) {
                                                setState(() {
                                                  samesource = value.toString();
                                                  Selecttaggedsource_camera =
                                                      false;
                                                  SelectalreadytaggedsourceSIB =
                                                      false;
                                                  ESR_Selectalreadytaggedsource =
                                                      false;
                                                  messagevisibility = false;
                                                  selectschemesourcemessage_mvc =
                                                      false;
                                                  selectschemesource = false;
                                                  geotaggedonlydropdown = false;
                                                  selectschemesib = false;
                                                  viewVisible = false;
                                                  offlinesiblistvosibleornot =
                                                      false;
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: messagedisplaypendingsource,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 5, top: 5, right: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            'Alert: Source tagging is pending for this scheme. Kindly tag the source',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Divider(
                                          height: 10,
                                          color: Appcolor.lightgrey,
                                          thickness: 1,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              getclickedstatus = "1";
                                              messagedisplaypendingsource =
                                                  false;
                                              Schemeinformationboard = false;

                                              viewVisible = true;
                                              selectschemesource = true;
                                              offlinesiblistvosibleornot =
                                                  false;

                                              if (selectcategoryname
                                                      .toString() ==
                                                  "svs") {
                                                selectschemesource = true;
                                                selectschemesourcemessage_mvc =
                                                    true;
                                                messagevisibility = false;

                                                getsourceschemedetails(
                                                        context,
                                                        box
                                                            .read("UserToken")
                                                            .toString(),
                                                        _mySchemeid.toString())
                                                    .then((value) {
                                                  setState(() {
                                                    if (value) {
                                                      Listdetaillistofscheme =
                                                          value.toList();
                                                    } else {
                                                      Listdetaillistofscheme
                                                          .clear();
                                                      selectschemesourcemessage_mvc =
                                                          true;
                                                    }
                                                  });
                                                });

                                                samesourcesib = "";
                                              } else {
                                                selectschemesourcemessage_mvc =
                                                    true;
                                                selectschemesource = false;
                                                messagevisibility = false;

                                                getsourceschemedetails_mvs(
                                                        context,
                                                        box
                                                            .read("UserToken")
                                                            .toString(),
                                                        _mySchemeid.toString())
                                                    .then((value) {
                                                  setState(() {
                                                    if (value["Status"]
                                                            .toString() ==
                                                        "true") {
                                                      setState(() {
                                                        Listdetaillistofscheme_mvs =
                                                            value["Result"];
                                                        messageofscheme_mvs =
                                                            value["Message"]
                                                                .toString();

                                                        messagevisibility =
                                                            true;
                                                      });
                                                    } else {
                                                      Listdetaillistofscheme_mvs
                                                          .clear();
                                                      selectschemesourcemessage_mvc =
                                                          true;
                                                    }
                                                    samesourcesib = "";
                                                  });
                                                });
                                              }
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Appcolor.greenmessagecolor,
                                              border: Border.all(
                                                color:
                                                    Appcolor.greenmessagecolor,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(
                                                  10.0,
                                                ),
                                              ),
                                            ),
                                            child: const SizedBox(
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text(
                                                  'Go to source',
                                                  style: TextStyle(
                                                      color: Appcolor.white,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                              const SizedBox(
                                height: 5,
                              ),
                              Visibility(
                                visible: othercategory,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text(
                                              'Select Asset Other Category',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Appcolor.lightgrey),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                RadioListTile(
                                                  visualDensity:
                                                      const VisualDensity(
                                                          horizontal:
                                                              VisualDensity
                                                                  .minimumDensity,
                                                          vertical: VisualDensity
                                                              .minimumDensity),
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  title:
                                                      const Text("Chlorinator"),
                                                  value: "1",
                                                  groupValue: Othersmain,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      Othersmain =
                                                          value.toString();

                                                      Clorinatorcategory = true;
                                                      PumphouseOthercategory =
                                                          false;
                                                      PumphouseOthercategorywatertreatment =
                                                          false;
                                                      Othercategorymbr = false;
                                                      Othercategorygrooundrechargewater =
                                                          false;
                                                      messagevisibility = false;
                                                      ESR_Selectalreadytaggedsource =
                                                          false;
                                                      SelectalreadytaggedsourceSIB =
                                                          false;

                                                      selectschemesource =
                                                          false;
                                                      selectschemesourcemessage_mvc =
                                                          false;
                                                      offlinesiblistvosibleornot =
                                                          false;

                                                      Clorinatorcategory = true;
                                                      PumphouseOthercategory =
                                                          false;
                                                      Othercategorymbr = false;
                                                      PumphouseOthercategorywatertreatment =
                                                          false;
                                                      Takephotoforotherassets =
                                                          true;

                                                      isGetGeoLocatonlatlong =
                                                          true;
                                                      Getgeolocation_SIB = true;
                                                    });
                                                  },
                                                ),
                                                RadioListTile(
                                                  visualDensity:
                                                      const VisualDensity(
                                                          horizontal:
                                                              VisualDensity
                                                                  .minimumDensity,
                                                          vertical: VisualDensity
                                                              .minimumDensity),
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  title:
                                                      const Text("Pump House"),
                                                  value: "2",
                                                  groupValue: Othersmain,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      Othersmain = value.toString();

                                                      PumphouseOthercategory =
                                                          true;

                                                      Clorinatorcategory =
                                                          false;
                                                      PumphouseOthercategorywatertreatment =
                                                          false;

                                                      Othercategorygrooundrechargewater =
                                                          false;
                                                      ESR_Selectalreadytaggedsource =
                                                          false;
                                                      isSameasSource = false;

                                                      Othercategorygrooundrechargewater =
                                                          false;
                                                      selectschemesource =
                                                          false;
                                                      selectschemesourcemessage_mvc =
                                                          false;
                                                      selectschemesib = false;
                                                      offlinesiblistvosibleornot =
                                                          false;
                                                      viewVisible = true;

                                                      Clorinatorcategory =
                                                          false;
                                                      PumphouseOthercategory =
                                                          true;
                                                      PumphouseOthercategorywatertreatment =
                                                          false;
                                                      Othercategorymbr = false;
                                                      Othercategorygrooundrechargewater =
                                                          false;
                                                      Takephotoforotherassets =
                                                          true;

                                                      Getgeolocation_SIB = true;

                                                      isGetGeoLocatonlatlong =
                                                          true;
                                                    });
                                                  },
                                                ),
                                                RadioListTile(
                                                  visualDensity:
                                                      const VisualDensity(
                                                          horizontal:
                                                              VisualDensity
                                                                  .minimumDensity,
                                                          vertical: VisualDensity
                                                              .minimumDensity),
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  title: const Text(
                                                      "Water Treatment Plant (WTP)"),
                                                  value: "3",
                                                  groupValue: Othersmain,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      Othersmain =
                                                          value.toString();

                                                      PumphouseOthercategory =
                                                          false;
                                                      Clorinatorcategory =
                                                          false;

                                                      ESR_Selectalreadytaggedsource =
                                                          false;

                                                      messagevisibility = false;
                                                      selectschemesource =
                                                          false;
                                                      selectschemesourcemessage_mvc =
                                                          false;
                                                      selectschemesib = false;
                                                      viewVisible = true;
                                                      offlinesiblistvosibleornot =
                                                          false;

                                                      Clorinatorcategory =
                                                          false;
                                                      PumphouseOthercategory =
                                                          false;
                                                      PumphouseOthercategorywatertreatment =
                                                          true;
                                                      Othercategorymbr = false;
                                                      Othercategorygrooundrechargewater =
                                                          false;

                                                      isGetGeoLocatonlatlong =
                                                          true;
                                                      Getgeolocation_SIB = true;
                                                      Takephotoforotherassets =
                                                          true;
                                                    });
                                                  },
                                                ),
                                                RadioListTile(
                                                  visualDensity:
                                                      const VisualDensity(
                                                          horizontal:
                                                              VisualDensity
                                                                  .minimumDensity,
                                                          vertical: VisualDensity
                                                              .minimumDensity),
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  title: const Text(
                                                      "Mass Balancing Reservior (MBR)"),
                                                  value: "4",
                                                  groupValue: Othersmain,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      Othersmain =
                                                          value.toString();

                                                      PumphouseOthercategory =
                                                          false;
                                                      Clorinatorcategory =
                                                          false;

                                                      ESR_Selectalreadytaggedsource =
                                                          false;

                                                      selectschemesource =
                                                          false;
                                                      messagevisibility = false;
                                                      selectschemesourcemessage_mvc =
                                                          false;
                                                      selectschemesib = false;
                                                      viewVisible = true;
                                                      offlinesiblistvosibleornot =
                                                          false;

                                                      Clorinatorcategory =
                                                          false;
                                                      PumphouseOthercategory =
                                                          false;
                                                      PumphouseOthercategorywatertreatment =
                                                          false;
                                                      Othercategorymbr = true;
                                                      Othercategorygrooundrechargewater =
                                                          false;

                                                      isGetGeoLocatonlatlong =
                                                          true;
                                                      Getgeolocation_SIB = true;
                                                      Takephotoforotherassets =
                                                          true;
                                                    });
                                                  },
                                                ),
                                                RadioListTile(
                                                  visualDensity:
                                                      const VisualDensity(
                                                          horizontal:
                                                              VisualDensity
                                                                  .minimumDensity,
                                                          vertical: VisualDensity
                                                              .minimumDensity),
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  title: const Text(
                                                      "Ground Water Recharge Structure"),
                                                  value: "5",
                                                  groupValue: Othersmain,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      Othersmain =
                                                          value.toString();

                                                      PumphouseOthercategory =
                                                          false;
                                                      Clorinatorcategory =
                                                          false;

                                                      ESR_Selectalreadytaggedsource =
                                                          false;

                                                      selectschemesource =
                                                          false;
                                                      messagevisibility = false;
                                                      selectschemesourcemessage_mvc =
                                                          false;
                                                      selectschemesib = false;
                                                      viewVisible = true;
                                                      offlinesiblistvosibleornot =
                                                          false;

                                                      Clorinatorcategory =
                                                          false;
                                                      PumphouseOthercategory =
                                                          false;
                                                      PumphouseOthercategorywatertreatment =
                                                          false;
                                                      Othercategorymbr = false;
                                                      Othercategorygrooundrechargewater =
                                                          true;

                                                      isGetGeoLocatonlatlong =
                                                          true;
                                                      Getgeolocation_SIB = true;
                                                      Takephotoforotherassets =
                                                          true;
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
                                visible: Storagestructuretype,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text(
                                              'Select storage structure type',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Appcolor.lightgrey),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                RadioListTile(
                                                  visualDensity:
                                                      const VisualDensity(
                                                          horizontal:
                                                              VisualDensity
                                                                  .minimumDensity,
                                                          vertical: VisualDensity
                                                              .minimumDensity),
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  title: const Text(
                                                      "Elevated Storage Reservior (ESR)"),
                                                  value: "1",
                                                  groupValue:
                                                      ESRstoragestructuretype,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      ESRstoragestructuretype =
                                                          value.toString();
                                                      Selectstoragetype_ESR =
                                                          true;
                                                      Selectstoragetype_GSR =
                                                          false;
                                                      messagevisibility = false;
                                                      ESR_Selectalreadytaggedsource =
                                                          false;
                                                      selectschemesource =
                                                          false;
                                                      selectschemesourcemessage_mvc =
                                                          false;
                                                      selectschemesib = false;
                                                      viewVisible = true;
                                                      offlinesiblistvosibleornot =
                                                          false;
                                                    });
                                                  },
                                                ),
                                                RadioListTile(
                                                  visualDensity:
                                                      const VisualDensity(
                                                          horizontal:
                                                              VisualDensity
                                                                  .minimumDensity,
                                                          vertical: VisualDensity
                                                              .minimumDensity),
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  title: const Text(
                                                      "Ground Storage Reservoir (GSR)"),
                                                  value: "2",
                                                  groupValue:
                                                      ESRstoragestructuretype,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      ESRstoragestructuretype =
                                                          value.toString();
                                                      Selectstoragetype_ESR =
                                                          false;
                                                      Selectstoragetype_GSR =
                                                          true;

                                                      ESR_Selectalreadytaggedsource =
                                                          false;
                                                      messagevisibility = false;
                                                      selectschemesource =
                                                          false;
                                                      selectschemesourcemessage_mvc =
                                                          false;
                                                      selectschemesib = false;
                                                      viewVisible = true;
                                                      offlinesiblistvosibleornot =
                                                          false;
                                                    });
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Visibility(
                                visible: Getgeolocation_SIB,
                                child: Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '  Habitation',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            height: 55,
                                            margin: const EdgeInsets.only(
                                                bottom: 5.0, right: 5, left: 5),
                                            width: double.infinity,
                                            padding: const EdgeInsets.only(
                                                left: 5.0, right: 5.0),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                    color: Appcolor.lightgrey,
                                                    width: .5),
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            child: DropdownButton<
                                                    Habitaionlistmodal>(
                                                itemHeight: 60,
                                                elevation: 10,
                                                dropdownColor: Appcolor.light,
                                                underline: const SizedBox(),
                                                isExpanded: true,
                                                hint: const Text(
                                                  "-- Select Habitation --",
                                                ),
                                                value: habitaionlistmodal,
                                                items: habitationlist
                                                    .map((habitations) {
                                                  return DropdownMenuItem<
                                                      Habitaionlistmodal>(
                                                    value: habitations,
                                                    child: Text(
                                                      habitations
                                                          .HabitationName,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 4,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              Appcolor.black),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (Habitaionlistmodal?
                                                    newValue) {
                                                  setState(() {
                                                    habitaionlistmodal =
                                                        newValue!;
                                                    selecthabitaionid =
                                                        habitaionlistmodal!
                                                            .HabitationId;
                                                    selecthabitaionname =
                                                        habitaionlistmodal
                                                            .HabitationName;
                                                  });
                                                }),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10,
                                                            bottom: 10,
                                                            top: 5),
                                                    child: getclickedstatus ==
                                                            "3"
                                                        ? const Text(
                                                            "Storage structure location",
                                                            maxLines: 4,
                                                            style: TextStyle(
                                                                color: Appcolor
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16),
                                                          )
                                                        : const Text(
                                                            "Asset location/landmark",
                                                            maxLines: 4,
                                                            style: TextStyle(
                                                                color: Appcolor
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16),
                                                          ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 5,
                                                      bottom: 10,
                                                      right: 5),
                                                  width: double.infinity,
                                                  height: 45,
                                                  child: TextFormField(
                                                    inputFormatters: <TextInputFormatter>[
                                                      FirstNonNumericalFormatter(),
                                                    ],
                                                    controller:
                                                        locationlandmarkcontroller,
                                                    decoration: InputDecoration(
                                                      fillColor:
                                                          Colors.grey.shade100,
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      hintText:
                                                          "Enter location/landmark",
                                                      hintStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Appcolor.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    ),
                                                    keyboardType: TextInputType
                                                        .visiblePassword,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: ESR_capacity,
                                child: Container(
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
                                  padding: const EdgeInsets.all(7.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Capacity (In Liter)',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              SizedBox(
                                                height: 45,
                                                child: TextFormField(
                                                  keyboardType:
                                                      const TextInputType
                                                          .numberWithOptions(
                                                          decimal: true),
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  controller:
                                                      capacitycontroller,
                                                  decoration: InputDecoration(
                                                    border:
                                                        new OutlineInputBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(
                                                        10.0,
                                                      ),
                                                      borderSide:
                                                          new BorderSide(
                                                              color: Appcolor
                                                                  .lightgrey),
                                                    ),
                                                    hintText:
                                                        "Enter Capacity (in Liter)",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isGetGeoLocatonlatlong,
                                child: Container(
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
                                  padding: const EdgeInsets.all(7.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Geo location details',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Divider(
                                        height: 10,
                                        color: Appcolor.lightgrey,
                                        thickness: 1,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        children: [
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Latitude',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _getCurrentPosition(context);
                                            },
                                            child: Container(
                                              height: 40,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                                color: const Color(0xffbFFFDE5),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(
                                                    5.0,
                                                  ),
                                                ),
                                              ),
                                              padding: const EdgeInsets.all(10),
                                              child: locationprogress == true
                                                  ? const Center(
                                                      child: SizedBox(
                                                          height: 15,
                                                          width: 15,
                                                          child:
                                                              CircularProgressIndicator(
                                                            strokeWidth: 1,
                                                            strokeAlign: BorderSide
                                                                .strokeAlignCenter,
                                                          )),
                                                    )
                                                  : Text(
                                                      ' ${_currentPosition?.latitude ?? ""}',
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Longitude',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _getCurrentPosition(context);
                                            },
                                            child: Container(
                                              height: 40,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(
                                                    5.0,
                                                  ),
                                                ),
                                                border: Border.all(
                                                    color: Colors.black),
                                                color: const Color(0xffbfffde5),
                                              ),
                                              padding: const EdgeInsets.all(10),
                                              child: locationprogress == true
                                                  ? const Center(
                                                      child: SizedBox(
                                                          height: 15,
                                                          width: 15,
                                                          child:
                                                              CircularProgressIndicator(
                                                            strokeWidth: 1,
                                                          )),
                                                    )
                                                  : Text(
                                                      ' ${_currentPosition?.longitude ?? ""}',
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: Takephotoforotherassets,
                                child: Column(
                                  children: [
                                    Center(
                                      child: Container(
                                        margin: const EdgeInsets.all(5),
                                        height: 320,
                                        width: 400,
                                        padding: const EdgeInsets.only(top: 15),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Column(
                                          children: [
                                            imgFile == null
                                                ? Center(
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              width: 2,
                                                              color: Appcolor
                                                                  .COLOR_PRIMARY),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3),
                                                        margin: const EdgeInsets
                                                            .only(
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
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                            width: 2,
                                                            color: Appcolor
                                                                .COLOR_PRIMARY),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              top: 10),
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
                                              height: 35,
                                            ),
                                            Center(
                                              child: Container(
                                                height: 40,
                                                width: 200,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFF0D3A98),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: TextButton(
                                                  onPressed: () {
                                                    if (_currentPosition ==
                                                        null) {
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
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    getclickedstatus == "4"
                                        ? Center(
                                            child: Container(
                                              height: 40,
                                              width: 200,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF0D3A98),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: TextButton(
                                                onPressed: () async {
                                                  if (Othersmain == "") {
                                                    Stylefile
                                                        .showmessageforvalidationfalse(
                                                            context,
                                                            "Please select category");
                                                  } else if (selecthabitaionname ==
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
                                                  } else {
                                                    bool isRecordPresent =
                                                        await databaseHelperJalJeevan!
                                                            .isRecordExists_indbforotsave(
                                                                _mySchemeid,
                                                                selecthabitaionid
                                                                    .toString(),
                                                                _currentPosition!
                                                                    .latitude
                                                                    .toString(),
                                                                _currentPosition!
                                                                    .longitude
                                                                    .toString(),
                                                                Othersmain);

                                                    if (isRecordPresent) {
                                                      Stylefile
                                                          .showmessageforvalidationfalse(
                                                              context,
                                                              "The record has been already saved successfully.");
                                                    } else {
                                                      databaseHelperJalJeevan!.insertotherassetsofflinesaveindb(LocalOtherassetsofflinesavemodal(
                                                          userId: box
                                                              .read("userid")
                                                              .toString(),
                                                          villageId:
                                                              widget.villageid,
                                                          capturePointTypeId:
                                                              "4",
                                                          stateId: box
                                                              .read("stateid"),
                                                          schemeId: _mySchemeid,
                                                          SchemeName: selectschamename,
                                                          sourceId: "0",
                                                          sourcename: sourcetypelocal
                                                              .toString(),
                                                          SourceTypeId:
                                                              getclickedstatus
                                                                  .toString(),
                                                          divisionId: box.read(
                                                              "DivisionId"),
                                                          habitationId:
                                                              selecthabitaionid,
                                                          HabitationName:
                                                              selecthabitaionname,
                                                          landmark:
                                                              locationlandmarkcontroller
                                                                  .text
                                                                  .toString(),
                                                          latitude:
                                                              _currentPosition!
                                                                  .latitude
                                                                  .toString(),
                                                          longitude:
                                                              _currentPosition!
                                                                  .longitude
                                                                  .toString(),
                                                          accuracy:
                                                              accuracyofgetlocation
                                                                  .toString(),
                                                          photo: base64Image,
                                                          VillageName: getvillagename,
                                                          DistrictName: districtname,
                                                          BlockName: blockname,
                                                          PanchayatName: panchayatname,
                                                          Status: "Pending",
                                                          Selectassetsothercategory: Othersmain.toString(),
                                                          Capturepointlocationot: ""));

                                                      showAlertDialog(context);
                                                    }
                                                  }
                                                },
                                                child: const Text(
                                                  'Save',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Center(
                                            child: Container(
                                              height: 40,
                                              width: 200,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF0D3A98),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: TextButton(
                                                onPressed: () async {
                                                  if (ESRstoragestructuretype ==
                                                      "") {
                                                    Stylefile
                                                        .showmessageforvalidationfalse(
                                                            context,
                                                            "Please select storage structure type");
                                                  } else if (selecthabitaionname ==
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
                                                  } else if (capacitycontroller
                                                      .text
                                                      .trim()
                                                      .toString()
                                                      .isEmpty) {
                                                    Stylefile
                                                        .showmessageforvalidationfalse(
                                                            context,
                                                            "Please enter capacity in liters");
                                                  } else if (imgFile == null) {
                                                    Stylefile
                                                        .showmessageforvalidationfalse(
                                                            context,
                                                            "Please select image");
                                                  } else {
                                                    bool isRecordPresent =
                                                        await databaseHelperJalJeevan!
                                                            .isRecordExists_indbforsssave(
                                                                _mySchemeid,
                                                                selecthabitaionid
                                                                    .toString(),
                                                                _currentPosition!
                                                                    .latitude
                                                                    .toString(),
                                                                _currentPosition!
                                                                    .longitude
                                                                    .toString(),
                                                                ESRstoragestructuretype
                                                                    .toString());

                                                    if (isRecordPresent) {
                                                      Stylefile
                                                          .showmessageforvalidationfalse(
                                                              context,
                                                              "The record has been already saved successfully.");
                                                    } else {
                                                      databaseHelperJalJeevan!.insertstoragestructureofflinesaveindb(LocalStoragestructureofflinesavemodal(
                                                          userId: box
                                                              .read("userid")
                                                              .toString(),
                                                          villageId:
                                                              widget.villageid,
                                                          stateId: box
                                                              .read("stateid"),
                                                          schemeId: _mySchemeid,
                                                          SchemeName:
                                                              selectschamename,
                                                          sourceId: "0",
                                                          sourcename: sourcetypelocal
                                                              .toString(),
                                                          SourceTypeId:
                                                              getclickedstatus
                                                                  .toString(),
                                                          divisionId: box.read(
                                                              "DivisionId"),
                                                          habitationId:
                                                              selecthabitaionid,
                                                          HabitationName:
                                                              selecthabitaionname,
                                                          landmark:
                                                              locationlandmarkcontroller
                                                                  .text
                                                                  .toString(),
                                                          latitude:
                                                              _currentPosition!
                                                                  .latitude
                                                                  .toString(),
                                                          longitude:
                                                              _currentPosition!
                                                                  .longitude
                                                                  .toString(),
                                                          accuracy:
                                                              accuracyofgetlocation
                                                                  .toString(),
                                                          photo: base64Image,
                                                          VillageName: getvillagename,
                                                          DistrictName: districtname,
                                                          BlockName: blockname,
                                                          PanchayatName: panchayatname,
                                                          Status: "Pending",
                                                          Selectstoragecategory: ESRstoragestructuretype.toString(),
                                                          Storagecapacity: capacitycontroller.text.toString()));

                                                      showAlertDialog(context);
                                                    }
                                                  }
                                                },
                                                child: const Text(
                                                  'Save',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                    const SizedBox(height: 20),
                                    getclickedstatus == "4"
                                        ? Center(
                                            child: SizedBox(
                                                height: 40,
                                                width: 200,
                                                child: Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: ElevatedButton.icon(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary:
                                                              Appcolor.orange,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                        ),
                                                        label: const Text(
                                                          'Save & sync',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Appcolor
                                                                  .white),
                                                        ),
                                                        icon: const Icon(
                                                          Icons.upload,
                                                          color: Colors.white,
                                                          size: 30.0,
                                                        ),
                                                        onPressed: () async {
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
                                                              if (getclickedstatus
                                                                      .toString() ==
                                                                  "") {
                                                                Stylefile
                                                                    .showmessageforvalidationfalse(
                                                                        context,
                                                                        "Please select  source");
                                                              } else if (_mySchemeid
                                                                      .toString() ==
                                                                  "-- Select id  --") {
                                                                Stylefile
                                                                    .showmessageforvalidationfalse(
                                                                        context,
                                                                        "Please select scheme");
                                                              } else if (Othersmain ==
                                                                  "") {
                                                                Stylefile
                                                                    .showmessageforvalidationfalse(
                                                                        context,
                                                                        "Please select category");
                                                              } else if (selecthabitaionname ==
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
                                                              } else if (imgFile ==
                                                                  null) {
                                                                Stylefile
                                                                    .showmessageforvalidationfalse(
                                                                        context,
                                                                        "Please select image");
                                                              } else {
                                                                Apiservice.OtherassetSavetaggingapi(
                                                                        context,
                                                                        box
                                                                            .read(
                                                                                "UserToken")
                                                                            .toString(),
                                                                        box
                                                                            .read(
                                                                                "userid")
                                                                            .toString(),
                                                                        widget
                                                                            .villageid,
                                                                        box.read(
                                                                            "stateid"),
                                                                        _mySchemeid,
                                                                        "4",
                                                                        box
                                                                            .read(
                                                                                "DivisionId")
                                                                            .toString(),
                                                                        selecthabitaionid,
                                                                        locationlandmarkcontroller
                                                                            .text
                                                                            .toString(),
                                                                        _currentPosition!
                                                                            .latitude
                                                                            .toString(),
                                                                        _currentPosition!
                                                                            .longitude
                                                                            .toString(),
                                                                        accuracyofgetlocation
                                                                            .toString(),
                                                                        base64Image
                                                                            .toString(),
                                                                        Othersmain)
                                                                    .then(
                                                                        (value) {
                                                                  Get.back();
                                                                  if (value["Status"]
                                                                          .toString() ==
                                                                      "false") {
                                                                    Stylefile.showmessageforvalidationfalse(
                                                                        context,
                                                                        value["msg"]
                                                                            .toString());

                                                                    if (value["msg"]
                                                                            .toString() ==
                                                                        "Token is wrong or expire") {
                                                                      setState(
                                                                          () {
                                                                        Get.off(
                                                                            LoginScreen());
                                                                        box
                                                                            .remove("UserToken")
                                                                            .toString();
                                                                        cleartable_localmastertables();
                                                                      });
                                                                    }
                                                                  } else if (value[
                                                                              "Status"]
                                                                          .toString() ==
                                                                      "true") {
                                                                    Stylefile.showmessageforvalidationtrue(
                                                                        context,
                                                                        value["msg"]
                                                                            .toString());

                                                                    cleartable_localmastertables();
                                                                    Apiservice.Getmasterapi(
                                                                            context)
                                                                        .then(
                                                                            (value) {
                                                                      for (int i =
                                                                              0;
                                                                          i < value.villagelist!.length;
                                                                          i++) {
                                                                        var userid = value
                                                                            .villagelist![i]!
                                                                            .userId;

                                                                        var villageId = value
                                                                            .villagelist![i]!
                                                                            .villageId;
                                                                        var stateId = value
                                                                            .villagelist![i]!
                                                                            .stateId;
                                                                        var villageName = value
                                                                            .villagelist![i]!
                                                                            .VillageName;

                                                                        databaseHelperJalJeevan
                                                                            ?.insertMastervillagelistdata(Localmasterdatanodal(
                                                                                UserId: userid.toString(),
                                                                                villageId: villageId.toString(),
                                                                                StateId: stateId.toString(),
                                                                                villageName: villageName.toString()))
                                                                            .then((value) {});
                                                                      }
                                                                      databaseHelperJalJeevan!
                                                                          .removeDuplicateEntries();

                                                                      for (int i =
                                                                              0;
                                                                          i < value.villageDetails!.length;
                                                                          i++) {
                                                                        var stateName =
                                                                            "Assam";

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
                                                                        var totalNoOfWaterSource = value
                                                                            .villageDetails![i]!
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
                                                                        var pendingApprovalSsTotal = value
                                                                            .villageDetails![i]!
                                                                            .pendingApprovalSsTotal;
                                                                        var totalIbRequiredGeoTagged = value
                                                                            .villageDetails![i]!
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
                                                                        var totalNoOfSchoolScheme = value
                                                                            .villageDetails![i]!
                                                                            .totalNoOfSchoolScheme;
                                                                        var totalNoOfPwsScheme = value
                                                                            .villageDetails![i]!
                                                                            .totalNoOfPwsScheme;

                                                                        databaseHelperJalJeevan
                                                                            ?.insertMastervillagedetails(Localmasterdatamodal_VillageDetails(
                                                                          status:
                                                                              "0",
                                                                          stateName:
                                                                              stateName,
                                                                          districtName:
                                                                              districtName,
                                                                          blockName:
                                                                              blockName,
                                                                          panchayatName:
                                                                              panchayatName,
                                                                          stateId:
                                                                              stateidnew.toString(),
                                                                          userId:
                                                                              userId.toString(),
                                                                          villageId:
                                                                              villageIddetails.toString(),
                                                                          villageName:
                                                                              villageName,
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

                                                                      for (int i =
                                                                              0;
                                                                          i < value.schmelist!.length;
                                                                          i++) {
                                                                        var schemeidnew = value
                                                                            .schmelist![i]!
                                                                            .schemeid;
                                                                        var villageid = value
                                                                            .schmelist![i]!
                                                                            .villageId;
                                                                        var schemenamenew = value
                                                                            .schmelist![i]!
                                                                            .schemename;
                                                                        var schemenacategorynew = value
                                                                            .schmelist![i]!
                                                                            .category;
                                                                        var SourceTypeCategoryId = value.schmelist![i]!.SourceTypeCategoryId;
                                                                        var source_typeCategory = value.schmelist![i]!.source_typeCategory;

                                                                        databaseHelperJalJeevan
                                                                            ?.insertMasterSchmelist(Localmasterdatamoda_Scheme(
                                                                          source_type: Sourceid_type.toString(),
                                                                          schemeid: schemeidnew.toString(),
                                                                          villageId:
                                                                              villageid.toString(),
                                                                          schemename:
                                                                              schemenamenew.toString(),
                                                                          category: schemenacategorynew.toString(),
                                                                          SourceTypeCategoryId: SourceTypeCategoryId.toString(),
                                                                          source_typeCategory: source_typeCategory.toString(),
                                                                        ));
                                                                      }

                                                                      for (int i =
                                                                              0;
                                                                          i < value.sourcelist!.length;
                                                                          i++) {
                                                                        var sourceId = value
                                                                            .sourcelist![i]!
                                                                            .sourceId;
                                                                        var SchemeId = value
                                                                            .sourcelist![i]!
                                                                            .schemeId;
                                                                        var stateid = value
                                                                            .sourcelist![i]!
                                                                            .stateid;
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
                                                                        var sourceTypeCategoryId = value
                                                                            .sourcelist![i]!
                                                                            .sourceTypeCategoryId;
                                                                        var habitationId = value
                                                                            .sourcelist![i]!
                                                                            .habitationId;
                                                                        var villageName = value
                                                                            .sourcelist![i]!
                                                                            .villageName;
                                                                        var existTagWaterSourceId = value
                                                                            .sourcelist![i]!
                                                                            .existTagWaterSourceId;
                                                                        var isApprovedState = value
                                                                            .sourcelist![i]!
                                                                            .isApprovedState;
                                                                        var landmark = value
                                                                            .sourcelist![i]!
                                                                            .landmark;
                                                                        var latitude = value
                                                                            .sourcelist![i]!
                                                                            .latitude;
                                                                        var longitude = value
                                                                            .sourcelist![i]!
                                                                            .longitude;
                                                                        var habitationName = value
                                                                            .sourcelist![i]!
                                                                            .habitationName;
                                                                        var location = value
                                                                            .sourcelist![i]!
                                                                            .location;
                                                                        var sourceTypeCategory = value
                                                                            .sourcelist![i]!
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
                                                                            ?.insertMasterSourcedetails(LocalSourcelistdetailsModal(
                                                                          schemeId:
                                                                              SchemeId.toString(),
                                                                          sourceId:
                                                                              sourceId.toString(),
                                                                          villageId:
                                                                              villageid.toString(),
                                                                          schemeName:
                                                                              Schemename,
                                                                          sourceTypeId:
                                                                              sourceTypeId.toString(),
                                                                          sourceTypeCategoryId:
                                                                              sourceTypeCategoryId.toString(),
                                                                          habitationId:
                                                                              habitationId.toString(),
                                                                          existTagWaterSourceId:
                                                                              existTagWaterSourceId.toString(),
                                                                          isApprovedState:
                                                                              isApprovedState.toString(),
                                                                          landmark:
                                                                              landmark,
                                                                          latitude:
                                                                              latitude.toString(),
                                                                          longitude:
                                                                              longitude.toString(),
                                                                          habitationName:
                                                                              habitationName,
                                                                          location:
                                                                              location,
                                                                          sourceTypeCategory:
                                                                              sourceTypeCategory,
                                                                          sourceType:
                                                                              sourceType,
                                                                          stateName:
                                                                              statename,
                                                                          districtName:
                                                                              districtName,
                                                                          blockName:
                                                                              blocknamenew,
                                                                          panchayatName:
                                                                              panchayatNamenew,
                                                                          districtId:
                                                                              districtId.toString(),
                                                                          villageName:
                                                                              villageName,
                                                                          stateId:
                                                                              stateid.toString(),
                                                                        ));
                                                                      }

                                                                      for (int i =
                                                                              0;
                                                                          i < value.habitationlist!.length;
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

                                                                        databaseHelperJalJeevan?.insertMasterhabitaionlist(LocalHabitaionlistModal(
                                                                            villageId:
                                                                                villafgeid.toString(),
                                                                            HabitationId: habitationId.toString(),
                                                                            HabitationName: habitationName.toString()));
                                                                      }
                                                                      for (int i =
                                                                              0;
                                                                          i < value.informationBoardList!.length;
                                                                          i++) {
                                                                        databaseHelperJalJeevan?.insertmastersibdetails(LocalmasterInformationBoardItemModal(
                                                                            userId:
                                                                                value.informationBoardList![i]!.userId.toString(),
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
                                                                });
                                                              }
                                                            }
                                                          } on SocketException catch (_) {
                                                            Stylefile
                                                                .showmessageforvalidationfalse(
                                                                    context,
                                                                    "Unable to Connect to the Internet. Please check your network settings.");
                                                          }
                                                        }))))
                                        : Center(
                                            child: SizedBox(
                                                height: 40,
                                                width: 200,
                                                child: Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: ElevatedButton.icon(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary:
                                                              Appcolor.orange,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                        ),
                                                        label: const Text(
                                                          'Save & sync',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Appcolor
                                                                  .white),
                                                        ),
                                                        icon: const Icon(
                                                          Icons.upload,
                                                          color: Colors.white,
                                                          size: 30.0,
                                                        ),
                                                        onPressed: () async {
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
                                                              if (getclickedstatus
                                                                      .toString() ==
                                                                  "") {
                                                                Stylefile
                                                                    .showmessageforvalidationfalse(
                                                                        context,
                                                                        "Please select  source");
                                                              } else if (_mySchemeid
                                                                      .toString() ==
                                                                  "-- Select id  --") {
                                                                Stylefile
                                                                    .showmessageforvalidationfalse(
                                                                        context,
                                                                        "Please select scheme");
                                                              }

                                                              if (ESRstoragestructuretype ==
                                                                  "") {
                                                                Stylefile
                                                                    .showmessageforvalidationfalse(
                                                                        context,
                                                                        "Please select storage structure type");
                                                              } else if (selecthabitaionname ==
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
                                                              } else if (imgFile ==
                                                                  null) {
                                                                Stylefile
                                                                    .showmessageforvalidationfalse(
                                                                        context,
                                                                        "Please select image");
                                                              } else {
                                                                Apiservice.StoragestructureSavetaggingapi(
                                                                        context,
                                                                        box
                                                                            .read(
                                                                                "UserToken")
                                                                            .toString(),
                                                                        box
                                                                            .read(
                                                                                "userid")
                                                                            .toString(),
                                                                        widget
                                                                            .villageid,
                                                                        box.read(
                                                                            "stateid"),
                                                                        _mySchemeid,
                                                                        "3",
                                                                        box
                                                                            .read(
                                                                                "DivisionId")
                                                                            .toString(),
                                                                        selecthabitaionid,
                                                                        locationlandmarkcontroller
                                                                            .text
                                                                            .toString(),
                                                                        _currentPosition!
                                                                            .latitude
                                                                            .toString(),
                                                                        _currentPosition!
                                                                            .longitude
                                                                            .toString(),
                                                                        accuracyofgetlocation
                                                                            .toString(),
                                                                        base64Image
                                                                            .toString(),
                                                                        /* capacitycontroller.text.toString(),
                                                                         ESRstoragestructuretype.toString()*/
                                                                        capacitycontroller
                                                                            .text
                                                                            .toString(),
                                                                        ESRstoragestructuretype
                                                                            .toString())
                                                                    .then(
                                                                        (value) {
                                                                  Get.back();
                                                                  if (value["Status"]
                                                                          .toString() ==
                                                                      "false") {
                                                                    Stylefile.showmessageforvalidationfalse(
                                                                        context,
                                                                        value["msg"]
                                                                            .toString());

                                                                    if (value["msg"]
                                                                            .toString() ==
                                                                        "Token is wrong or expire") {
                                                                      setState(
                                                                          () {
                                                                        Get.off(
                                                                            LoginScreen());
                                                                        box
                                                                            .remove("UserToken")
                                                                            .toString();
                                                                        cleartable_localmastertables();
                                                                      });
                                                                    }
                                                                  } else if (value[
                                                                              "Status"]
                                                                          .toString() ==
                                                                      "true") {
                                                                    Stylefile.showmessageforvalidationtrue(
                                                                        context,
                                                                        value["msg"]
                                                                            .toString());

                                                                    cleartable_localmastertables();
                                                                    Apiservice.Getmasterapi(
                                                                            context)
                                                                        .then(
                                                                            (value) {
                                                                      for (int i =
                                                                              0;
                                                                          i < value.villagelist!.length;
                                                                          i++) {
                                                                        var userid = value
                                                                            .villagelist![i]!
                                                                            .userId;

                                                                        var villageId = value
                                                                            .villagelist![i]!
                                                                            .villageId;
                                                                        var stateId = value
                                                                            .villagelist![i]!
                                                                            .stateId;
                                                                        var villageName = value
                                                                            .villagelist![i]!
                                                                            .VillageName;

                                                                        databaseHelperJalJeevan
                                                                            ?.insertMastervillagelistdata(Localmasterdatanodal(
                                                                                UserId: userid.toString(),
                                                                                villageId: villageId.toString(),
                                                                                StateId: stateId.toString(),
                                                                                villageName: villageName.toString()))
                                                                            .then((value) {});
                                                                      }
                                                                      databaseHelperJalJeevan!
                                                                          .removeDuplicateEntries();

                                                                      for (int i =
                                                                              0;
                                                                          i < value.villageDetails!.length;
                                                                          i++) {
                                                                        var stateName =
                                                                            "";

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
                                                                        var totalNoOfWaterSource = value
                                                                            .villageDetails![i]!
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
                                                                        var pendingApprovalSsTotal = value
                                                                            .villageDetails![i]!
                                                                            .pendingApprovalSsTotal;
                                                                        var totalIbRequiredGeoTagged = value
                                                                            .villageDetails![i]!
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
                                                                        var totalNoOfSchoolScheme = value
                                                                            .villageDetails![i]!
                                                                            .totalNoOfSchoolScheme;
                                                                        var totalNoOfPwsScheme = value
                                                                            .villageDetails![i]!
                                                                            .totalNoOfPwsScheme;

                                                                        databaseHelperJalJeevan
                                                                            ?.insertMastervillagedetails(Localmasterdatamodal_VillageDetails(
                                                                          status:
                                                                              "0",
                                                                          stateName:
                                                                              stateName,
                                                                          districtName:
                                                                              districtName,
                                                                          blockName:
                                                                              blockName,
                                                                          panchayatName:
                                                                              panchayatName,
                                                                          stateId:
                                                                              stateidnew.toString(),
                                                                          userId:
                                                                              userId.toString(),
                                                                          villageId:
                                                                              villageIddetails.toString(),
                                                                          villageName:
                                                                              villageName,
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

                                                                      for (int i =
                                                                              0;
                                                                          i < value.schmelist!.length;
                                                                          i++) {
                                                                        var schemeidnew = value
                                                                            .schmelist![i]!
                                                                            .schemeid;
                                                                        var villageid = value
                                                                            .schmelist![i]!
                                                                            .villageId;
                                                                        var schemenamenew = value
                                                                            .schmelist![i]!
                                                                            .schemename;
                                                                        var schemenacategorynew = value
                                                                            .schmelist![i]!
                                                                            .category;
                                                                        var SourceTypeCategoryId = value.schmelist![i]!.SourceTypeCategoryId;
                                                                        var source_typeCategory = value.schmelist![i]!.source_typeCategory;


                                                                        databaseHelperJalJeevan
                                                                            ?.insertMasterSchmelist(Localmasterdatamoda_Scheme(
                                                                          source_type: Sourceid_type.toString(),
                                                                          schemeid: schemeidnew.toString(),
                                                                          villageId:
                                                                              villageid.toString(),
                                                                          schemename:
                                                                              schemenamenew.toString(),
                                                                          category: schemenacategorynew.toString(),
                                                                          SourceTypeCategoryId: SourceTypeCategoryId.toString(),
                                                                          source_typeCategory: source_typeCategory.toString(),
                                                                        ));
                                                                      }

                                                                      for (int i =
                                                                              0;
                                                                          i < value.sourcelist!.length;
                                                                          i++) {
                                                                        var sourceId = value
                                                                            .sourcelist![i]!
                                                                            .sourceId;
                                                                        var SchemeId = value
                                                                            .sourcelist![i]!
                                                                            .schemeId;
                                                                        var stateid = value
                                                                            .sourcelist![i]!
                                                                            .stateid;
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
                                                                        var sourceTypeCategoryId = value
                                                                            .sourcelist![i]!
                                                                            .sourceTypeCategoryId;
                                                                        var habitationId = value
                                                                            .sourcelist![i]!
                                                                            .habitationId;
                                                                        var villageName = value
                                                                            .sourcelist![i]!
                                                                            .villageName;
                                                                        var existTagWaterSourceId = value
                                                                            .sourcelist![i]!
                                                                            .existTagWaterSourceId;
                                                                        var isApprovedState = value
                                                                            .sourcelist![i]!
                                                                            .isApprovedState;
                                                                        var landmark = value
                                                                            .sourcelist![i]!
                                                                            .landmark;
                                                                        var latitude = value
                                                                            .sourcelist![i]!
                                                                            .latitude;
                                                                        var longitude = value
                                                                            .sourcelist![i]!
                                                                            .longitude;
                                                                        var habitationName = value
                                                                            .sourcelist![i]!
                                                                            .habitationName;
                                                                        var location = value
                                                                            .sourcelist![i]!
                                                                            .location;
                                                                        var sourceTypeCategory = value
                                                                            .sourcelist![i]!
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
                                                                            ?.insertMasterSourcedetails(LocalSourcelistdetailsModal(
                                                                          schemeId:
                                                                              SchemeId.toString(),
                                                                          sourceId:
                                                                              sourceId.toString(),
                                                                          villageId:
                                                                              villageid.toString(),
                                                                          schemeName:
                                                                              Schemename,
                                                                          sourceTypeId:
                                                                              sourceTypeId.toString(),
                                                                          sourceTypeCategoryId:
                                                                              sourceTypeCategoryId.toString(),
                                                                          habitationId:
                                                                              habitationId.toString(),
                                                                          existTagWaterSourceId:
                                                                              existTagWaterSourceId.toString(),
                                                                          isApprovedState:
                                                                              isApprovedState.toString(),
                                                                          landmark:
                                                                              landmark,
                                                                          latitude:
                                                                              latitude.toString(),
                                                                          longitude:
                                                                              longitude.toString(),
                                                                          habitationName:
                                                                              habitationName,
                                                                          location:
                                                                              location,
                                                                          sourceTypeCategory:
                                                                              sourceTypeCategory,
                                                                          sourceType:
                                                                              sourceType,
                                                                          stateName:
                                                                              statename,
                                                                          districtName:
                                                                              districtName,
                                                                          blockName:
                                                                              blocknamenew,
                                                                          panchayatName:
                                                                              panchayatNamenew,
                                                                          districtId:
                                                                              districtId.toString(),
                                                                          villageName:
                                                                              villageName,
                                                                          stateId:
                                                                              stateid.toString(),
                                                                        ));
                                                                      }

                                                                      for (int i =
                                                                              0;
                                                                          i < value.habitationlist!.length;
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

                                                                        databaseHelperJalJeevan?.insertMasterhabitaionlist(LocalHabitaionlistModal(
                                                                            villageId:
                                                                                villafgeid.toString(),
                                                                            HabitationId: habitationId.toString(),
                                                                            HabitationName: habitationName.toString()));
                                                                      }
                                                                      for (int i =
                                                                              0;
                                                                          i < value.informationBoardList!.length;
                                                                          i++) {
                                                                        databaseHelperJalJeevan?.insertmastersibdetails(LocalmasterInformationBoardItemModal(
                                                                            userId:
                                                                                value.informationBoardList![i]!.userId.toString(),
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
                                                                });
                                                              }
                                                            }
                                                          } on SocketException catch (_) {
                                                            Stylefile
                                                                .showmessageforvalidationfalse(
                                                                    context,
                                                                    "Unable to Connect to the Internet. Please check your network settings.");
                                                          }
                                                        })))),
                                    const SizedBox(height: 20)
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: geotaggedonlydropdown,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 8, top: 5, right: 8, bottom: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 10,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                        5.0,
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Select already tagged Source',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Divider(
                                          height: 10,
                                          color: Appcolor.lightgrey,
                                          thickness: 1,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(8.0),
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: DropdownButton(
                                            isExpanded: true,
                                            value: selectlocation.toString(),
                                            isDense: true,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                            dropdownColor: Colors.white,
                                            underline: const SizedBox(),
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),
                                            items:
                                                ListExistingsource_location.map(
                                                    (dynamic? items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            onChanged: (dynamic? newValue) {
                                              setState(() {
                                                selectlocation =
                                                    newValue!.toString();

                                                selectschemesib = false;
                                                viewVisible = false;
                                                selectschemesource = false;
                                                selectschemesourcemessage_mvc =
                                                    false;

                                                Habitaionsamesourcetext = true;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                  visible: Habitaionsamesourcetext,
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 8,
                                            top: 5,
                                            right: 8,
                                            bottom: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 10,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                              5.0,
                                            ),
                                          ),
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Habitaion',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Divider(
                                                height: 10,
                                                color: Appcolor.lightgrey,
                                                thickness: 1,
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(8.0),
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10.0),
                                                child: Container(
                                                  height: 40,
                                                  width: 250,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    color: const Color(
                                                        0xffbFFFDE5),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Text(
                                                    Existingsource_HabitationName
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 8,
                                            top: 5,
                                            right: 8,
                                            bottom: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 10,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                              5.0,
                                            ),
                                          ),
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Scheme',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Divider(
                                                height: 10,
                                                color: Appcolor.lightgrey,
                                                thickness: 1,
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(8.0),
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10.0),
                                                child: Container(
                                                  height: 40,
                                                  width: 250,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    color: const Color(
                                                        0xffbFFFDE5),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Text(
                                                    selectschamename.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
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
                                        padding: const EdgeInsets.all(7.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Geotagged of Information Board ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: double.infinity,
                                              margin: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Appcolor.white,
                                                border: Border.all(
                                                  color: Appcolor.lightgrey,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(
                                                    10.0,
                                                  ),
                                                ),
                                              ),
                                              padding: const EdgeInsets.only(
                                                  top: 15, left: 15, right: 15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  const Text(
                                                    'Latitude',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {},
                                                    child: Container(
                                                      height: 40,
                                                      width: 250,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
                                                        color: const Color(
                                                            0xffbFFFDE5),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: locationprogress ==
                                                              true
                                                          ? const SizedBox(
                                                              height: 20,
                                                              width: 20,
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            )
                                                          : Text(
                                                              ' ${_currentPosition?.latitude ?? ""}',
                                                              style: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  const Text(
                                                    'Longitude',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {},
                                                    child: Container(
                                                      height: 40,
                                                      width: 250,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
                                                        color: const Color(
                                                            0xffbfffde5),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: locationprogress ==
                                                              true
                                                          ? const SizedBox(
                                                              width: 20,
                                                              height: 20,
                                                              child:
                                                                  CircularProgressIndicator())
                                                          : Text(
                                                              ' ${_currentPosition?.longitude ?? ""}',
                                                              style: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                              Visibility(
                                visible: SelectalreadytaggedsourceSIB,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Center(
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
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(
                                                10.0,
                                              ),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              imgFile == null
                                                  ? Center(
                                                      child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                                width: 2,
                                                                color: Appcolor
                                                                    .COLOR_PRIMARY),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3),
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 0,
                                                                  top: 10),
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
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              width: 2,
                                                              color: Appcolor
                                                                  .COLOR_PRIMARY),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3),
                                                        margin: const EdgeInsets
                                                            .only(
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
                                                      color: const Color(
                                                          0xFF0D3A98),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      if (_currentPosition ==
                                                          null) {
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
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 20),
                                            height: 40,
                                            width: 200,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: const Color(0xFF0D3A98),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: TextButton(
                                              onPressed: () async {
                                                if (samesourcesib == "1") {
                                                  if (getclickedstatus
                                                          .toString() ==
                                                      "") {
                                                    Stylefile
                                                        .showmessageforvalidationfalse(
                                                            context,
                                                            "Please select  source");
                                                  } else if (imgFile == null) {
                                                    Stylefile
                                                        .showmessageforvalidationfalse(
                                                            context,
                                                            "Please select  image");
                                                  } else {
                                                    Apiservice.SIBSavetaggingapi(
                                                            context,
                                                            box
                                                                .read(
                                                                    "UserToken")
                                                                .toString(),
                                                            box
                                                                .read("userid")
                                                                .toString(),
                                                            widget.villageid,
                                                            samesourcesib
                                                                .toString(),
                                                            box.read("stateid"),
                                                            Existingsource_SchemeId,
                                                            getclickedstatus,
                                                            box
                                                                .read(
                                                                    "DivisionId")
                                                                .toString(),
                                                            Existingsource_habitaionid
                                                                .toString(),
                                                            locationlandmarkcontroller
                                                                .text
                                                                .toString(),
                                                            _currentPosition!
                                                                .latitude
                                                                .toString(),
                                                            _currentPosition!
                                                                .longitude
                                                                .toString(),
                                                            "0",
                                                            base64Image)
                                                        .then((value) {
                                                      Get.back();
                                                      if (value["Status"]
                                                              .toString() ==
                                                          "false") {
                                                        Stylefile
                                                            .showmessageforvalidationfalse(
                                                                context,
                                                                value["msg"]
                                                                    .toString());

                                                        if (value["msg"]
                                                                .toString() ==
                                                            "Token is wrong or expire") {
                                                          setState(() {
                                                            Get.off(
                                                                LoginScreen());
                                                            box
                                                                .remove(
                                                                    "UserToken")
                                                                .toString();
                                                            cleartable_localmastertables();
                                                          });
                                                        }
                                                      } else if (value["Status"]
                                                              .toString() ==
                                                          "true") {
                                                        Stylefile
                                                            .showmessageforvalidationfalse(
                                                                context,
                                                                value["msg"]
                                                                    .toString());
                                                        cleartable_localmastertables();
                                                        Apiservice.Getmasterapi(
                                                                context)
                                                            .then((value) {
                                                          for (int i = 0;
                                                              i <
                                                                  value
                                                                      .villagelist!
                                                                      .length;
                                                              i++) {
                                                            var userid = value
                                                                .villagelist![i]!
                                                                .userId;

                                                            var villageId = value
                                                                .villagelist![i]!
                                                                .villageId;
                                                            var stateId = value
                                                                .villagelist![i]!
                                                                .stateId;
                                                            var villageName =
                                                                value
                                                                    .villagelist![
                                                                    i]!
                                                                    .VillageName;

                                                            databaseHelperJalJeevan
                                                                ?.insertMastervillagelistdata(Localmasterdatanodal(
                                                                    UserId: userid
                                                                        .toString(),
                                                                    villageId:
                                                                        villageId
                                                                            .toString(),
                                                                    StateId: stateId
                                                                        .toString(),
                                                                    villageName:
                                                                        villageName
                                                                            .toString()))
                                                                .then(
                                                                    (value) {});
                                                          }
                                                          databaseHelperJalJeevan!
                                                              .removeDuplicateEntries();

                                                          for (int i = 0;
                                                              i <
                                                                  value
                                                                      .villageDetails!
                                                                      .length;
                                                              i++) {
                                                            var stateName =
                                                                "Assam";

                                                            var districtName = value
                                                                .villageDetails![
                                                                    i]!
                                                                .districtName;
                                                            var stateid = value
                                                                .villageDetails![
                                                                    i]!
                                                                .stateId;
                                                            var blockName = value
                                                                .villageDetails![
                                                                    i]!
                                                                .blockName;
                                                            var panchayatName = value
                                                                .villageDetails![
                                                                    i]!
                                                                .panchayatName;
                                                            var stateidnew = value
                                                                .villageDetails![
                                                                    i]!
                                                                .stateId;
                                                            var userId = value
                                                                .villageDetails![
                                                                    i]!
                                                                .userId;
                                                            var villageIddetails =
                                                                value
                                                                    .villageDetails![
                                                                    i]!
                                                                    .villageId;
                                                            var villageName = value
                                                                .villageDetails![
                                                                    i]!
                                                                .villageName;
                                                            var totalNoOfScheme = value
                                                                .villageDetails![
                                                                    i]!
                                                                .totalNoOfScheme;
                                                            var totalNoOfWaterSource = value
                                                                .villageDetails![
                                                                    i]!
                                                                .totalNoOfWaterSource;
                                                            var totalWsGeoTagged = value
                                                                .villageDetails![
                                                                    i]!
                                                                .totalWsGeoTagged;
                                                            var pendingWsTotal = value
                                                                .villageDetails![
                                                                    i]!
                                                                .pendingWsTotal;
                                                            var balanceWsTotal = value
                                                                .villageDetails![
                                                                    i]!
                                                                .balanceWsTotal;
                                                            var totalSsGeoTagged = value
                                                                .villageDetails![
                                                                    i]!
                                                                .totalSsGeoTagged;
                                                            var pendingApprovalSsTotal = value
                                                                .villageDetails![
                                                                    i]!
                                                                .pendingApprovalSsTotal;
                                                            var totalIbRequiredGeoTagged = value
                                                                .villageDetails![
                                                                    i]!
                                                                .totalIbRequiredGeoTagged;
                                                            var totalIbGeoTagged = value
                                                                .villageDetails![
                                                                    i]!
                                                                .totalIbGeoTagged;
                                                            var pendingIbTotal = value
                                                                .villageDetails![
                                                                    i]!
                                                                .pendingIbTotal;
                                                            var balanceIbTotal = value
                                                                .villageDetails![
                                                                    i]!
                                                                .balanceIbTotal;
                                                            var totalOaGeoTagged = value
                                                                .villageDetails![
                                                                    i]!
                                                                .totalOaGeoTagged;
                                                            var balanceOaTotal = value
                                                                .villageDetails![
                                                                    i]!
                                                                .balanceOaTotal;
                                                            var totalNoOfSchoolScheme = value
                                                                .villageDetails![
                                                                    i]!
                                                                .totalNoOfSchoolScheme;
                                                            var totalNoOfPwsScheme = value
                                                                .villageDetails![
                                                                    i]!
                                                                .totalNoOfPwsScheme;

                                                            databaseHelperJalJeevan
                                                                ?.insertMastervillagedetails(
                                                                    Localmasterdatamodal_VillageDetails(
                                                              status: "0",
                                                              stateName:
                                                                  stateName,
                                                              districtName:
                                                                  districtName,
                                                              blockName:
                                                                  blockName,
                                                              panchayatName:
                                                                  panchayatName,
                                                              stateId: stateidnew
                                                                  .toString(),
                                                              userId: userId
                                                                  .toString(),
                                                              villageId:
                                                                  villageIddetails
                                                                      .toString(),
                                                              villageName:
                                                                  villageName,
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
                                                                      .schmelist!
                                                                      .length;
                                                              i++) {
                                                            var schemeidnew =
                                                                value
                                                                    .schmelist![
                                                                    i]!
                                                                    .schemeid;
                                                            var villageid =
                                                                value
                                                                    .schmelist![
                                                                    i]!
                                                                    .villageId;
                                                            var schemenamenew =
                                                                value
                                                                    .schmelist![
                                                                    i]!
                                                                    .schemename;
                                                            var schemenacategorynew =
                                                                value
                                                                    .schmelist![
                                                                    i]!
                                                                    .category;
                                                            var SourceTypeCategoryId = value.schmelist![i]!.SourceTypeCategoryId;
                                                            var source_typeCategory = value.schmelist![i]!.source_typeCategory;

                                                            databaseHelperJalJeevan
                                                                ?.insertMasterSchmelist(
                                                                    Localmasterdatamoda_Scheme(
                                                              source_type: Sourceid_type.toString(),          schemeid: schemeidnew.toString(),
                                                              villageId: villageid
                                                                  .toString(),
                                                              schemename:
                                                                  schemenamenew
                                                                      .toString(),
                                                              category: schemenacategorynew
                                                                      .toString(),
                                                                      SourceTypeCategoryId: SourceTypeCategoryId.toString(),
                                                                      source_typeCategory: source_typeCategory.toString(),
                                                            ));
                                                          }

                                                          for (int i = 0;
                                                              i <
                                                                  value
                                                                      .sourcelist!
                                                                      .length;
                                                              i++) {
                                                            var sourceId = value
                                                                .sourcelist![i]!
                                                                .sourceId;
                                                            var SchemeId = value
                                                                .sourcelist![i]!
                                                                .schemeId;
                                                            var stateid = value
                                                                .sourcelist![i]!
                                                                .stateid;
                                                            var Schemename =
                                                                value
                                                                    .sourcelist![i]!.schemeName;
                                                            var villageid =
                                                                value
                                                                    .sourcelist![
                                                                    i]!
                                                                    .villageId;
                                                            var sourceTypeId =
                                                                value
                                                                    .sourcelist![
                                                                    i]!
                                                                    .sourceTypeId;
                                                            var statename =
                                                                value
                                                                    .sourcelist![
                                                                    i]!
                                                                    .stateName;
                                                            var sourceTypeCategoryId =
                                                                value
                                                                    .sourcelist![
                                                                    i]!
                                                                    .sourceTypeCategoryId;
                                                            var habitationId =
                                                                value
                                                                    .sourcelist![
                                                                    i]!
                                                                    .habitationId;
                                                            var villageName =
                                                                value
                                                                    .sourcelist![
                                                                    i]!
                                                                    .villageName;
                                                            var existTagWaterSourceId =
                                                                value
                                                                    .sourcelist![
                                                                    i]!
                                                                    .existTagWaterSourceId;
                                                            var isApprovedState =
                                                                value
                                                                    .sourcelist![
                                                                    i]!
                                                                    .isApprovedState;
                                                            var landmark = value
                                                                .sourcelist![i]!
                                                                .landmark;
                                                            var latitude = value
                                                                .sourcelist![i]!
                                                                .latitude;
                                                            var longitude =
                                                                value
                                                                    .sourcelist![
                                                                    i]!
                                                                    .longitude;
                                                            var habitationName =
                                                                value
                                                                    .sourcelist![
                                                                    i]!
                                                                    .habitationName;
                                                            var location = value
                                                                .sourcelist![i]!
                                                                .location;
                                                            var sourceTypeCategory =
                                                                value
                                                                    .sourcelist![
                                                                    i]!
                                                                    .sourceTypeCategory;
                                                            var sourceType =
                                                                value
                                                                    .sourcelist![
                                                                    i]!
                                                                    .sourceType;
                                                            var districtName =
                                                                value
                                                                    .sourcelist![
                                                                    i]!
                                                                    .districtName;
                                                            var districtId =
                                                                value
                                                                    .sourcelist![
                                                                    i]!
                                                                    .districtId;
                                                            var panchayatNamenew =
                                                                value
                                                                    .sourcelist![
                                                                    i]!
                                                                    .panchayatName;
                                                            var blocknamenew =
                                                                value
                                                                    .sourcelist![
                                                                    i]!
                                                                    .blockName;

                                                            databaseHelperJalJeevan
                                                                ?.insertMasterSourcedetails(
                                                                    LocalSourcelistdetailsModal(
                                                              schemeId: SchemeId
                                                                  .toString(),
                                                              sourceId: sourceId
                                                                  .toString(),
                                                              villageId: villageid
                                                                  .toString(),
                                                              schemeName:
                                                                  Schemename,
                                                              sourceTypeId:
                                                                  sourceTypeId
                                                                      .toString(),
                                                              sourceTypeCategoryId:
                                                                  sourceTypeCategoryId
                                                                      .toString(),
                                                              habitationId:
                                                                  habitationId
                                                                      .toString(),
                                                              existTagWaterSourceId:
                                                                  existTagWaterSourceId
                                                                      .toString(),
                                                              isApprovedState:
                                                                  isApprovedState
                                                                      .toString(),
                                                              landmark:
                                                                  landmark,
                                                              latitude: latitude
                                                                  .toString(),
                                                              longitude: longitude
                                                                  .toString(),
                                                              habitationName:
                                                                  habitationName,
                                                              location:
                                                                  location,
                                                              sourceTypeCategory:
                                                                  sourceTypeCategory,
                                                              sourceType:
                                                                  sourceType,
                                                              stateName:
                                                                  statename,
                                                              districtName:
                                                                  districtName,
                                                              blockName:
                                                                  blocknamenew,
                                                              panchayatName:
                                                                  panchayatNamenew,
                                                              districtId:
                                                                  districtId
                                                                      .toString(),
                                                              villageName:
                                                                  villageName,
                                                              stateId: stateid
                                                                  .toString(),
                                                            ));
                                                          }

                                                          for (int i = 0;
                                                              i <
                                                                  value
                                                                      .habitationlist!
                                                                      .length;
                                                              i++) {
                                                            var villafgeid = value
                                                                .habitationlist![
                                                                    i]!
                                                                .villageId;
                                                            var habitationId = value
                                                                .habitationlist![
                                                                    i]!
                                                                .habitationId;
                                                            var habitationName = value
                                                                .habitationlist![
                                                                    i]!
                                                                .habitationName;

                                                            databaseHelperJalJeevan?.insertMasterhabitaionlist(LocalHabitaionlistModal(
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
                                                                villageId: value.informationBoardList![i]!.villageId
                                                                    .toString(),
                                                                stateId: value
                                                                    .informationBoardList![
                                                                    i]!
                                                                    .stateId
                                                                    .toString(),
                                                                schemeId: value
                                                                    .informationBoardList![
                                                                    i]!
                                                                    .schemeId
                                                                    .toString(),
                                                                districtName: value
                                                                    .informationBoardList![
                                                                    i]!
                                                                    .districtName,
                                                                blockName: value
                                                                    .informationBoardList![i]!
                                                                    .blockName,
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
                                                    });
                                                  }
                                                } else {
                                                  if (getclickedstatus
                                                          .toString() ==
                                                      "") {
                                                    Stylefile
                                                        .showmessageforvalidationfalse(
                                                            context,
                                                            "Please select  source");
                                                  } else if (_mySchemeid
                                                          .toString() ==
                                                      "-- Select id  --") {
                                                    Stylefile
                                                        .showmessageforvalidationfalse(
                                                            context,
                                                            "Please select scheme");
                                                  } else if (selecthabitaionname ==
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
                                                  } else {
                                                    bool isRecordPresent =
                                                        await databaseHelperJalJeevan!
                                                            .isRecordExists_insibsave(
                                                                _mySchemeid,
                                                                selecthabitaionid
                                                                    .toString(),
                                                                locationlandmarkcontroller
                                                                    .text
                                                                    .toString());
                                                    if (isRecordPresent) {
                                                      Stylefile
                                                          .showmessageforvalidationfalse(
                                                              context,
                                                              "The record has been saved successfully.");
                                                    } else {
                                                      box
                                                          .read("userid")
                                                          .toString();

                                                      widget.villageid;

                                                      box.read("stateid");
                                                      _mySchemeid;
                                                      getclickedstatus;
                                                      "0";
                                                      box
                                                          .read("DivisionId")
                                                          .toString();
                                                      selecthabitaionid
                                                          .toString();
                                                      locationlandmarkcontroller
                                                          .text
                                                          .toString();

                                                      _currentPosition!.latitude
                                                          .toString();
                                                      _currentPosition!
                                                          .longitude
                                                          .toString();
                                                      "0";
                                                      base64Image;

                                                      databaseHelperJalJeevan!
                                                          .insertsibsaveindb(
                                                              LocalSIBsavemodal(
                                                        userId: box
                                                            .read("userid")
                                                            .toString(),
                                                        villageId:
                                                            widget.villageid,
                                                        capturePointTypeId: "2",
                                                        stateId:
                                                            box.read("stateid"),
                                                        schemeId: _mySchemeid,
                                                        SchemeName:
                                                            selectschamename,
                                                        sourceId: "0",
                                                        sourcename:
                                                            sourcetypelocal
                                                                .toString(),
                                                        SourceTypeId:
                                                            getclickedstatus
                                                                .toString(),
                                                        divisionId: box
                                                            .read("DivisionId"),
                                                        habitationId:
                                                            selecthabitaionid,
                                                        HabitationName:
                                                            selecthabitaionname,
                                                        landmark:
                                                            locationlandmarkcontroller
                                                                .text
                                                                .toString(),
                                                        latitude:
                                                            _currentPosition!
                                                                .latitude
                                                                .toString(),
                                                        longitude:
                                                            _currentPosition!
                                                                .longitude
                                                                .toString(),
                                                        accuracy:
                                                            accuracyofgetlocation
                                                                .toString(),
                                                        photo: base64Image,
                                                        VillageName:
                                                            getvillagename,
                                                        DistrictName:
                                                            districtname,
                                                        BlockName: blockname,
                                                        PanchayatName:
                                                            panchayatname,
                                                        Status: "Pending",
                                                      ))
                                                          .then((value) {
                                                        countsib();

                                                        showAlertDialog(
                                                            context);
                                                      });
                                                    }
                                                  }
                                                }
                                              },
                                              child: const Text(
                                                'Save',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                            child: SizedBox(
                                                height: 40,
                                                width: 200,
                                                child: Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: ElevatedButton.icon(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary:
                                                              Appcolor.orange,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                        ),
                                                        label: const Text(
                                                          'Save & sync',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Appcolor
                                                                  .white),
                                                        ),
                                                        icon: const Icon(
                                                          Icons.upload,
                                                          color: Colors.white,
                                                          size: 30.0,
                                                        ),
                                                        onPressed: () async {
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
                                                              if (getclickedstatus
                                                                      .toString() ==
                                                                  "") {
                                                                Stylefile
                                                                    .showmessageforvalidationfalse(
                                                                        context,
                                                                        "Please select  source");
                                                              } else if (_mySchemeid
                                                                      .toString() ==
                                                                  "-- Select id  --") {
                                                                Stylefile
                                                                    .showmessageforvalidationfalse(
                                                                        context,
                                                                        "Please select scheme");
                                                              } else if (selecthabitaionname ==
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
                                                              } else if (imgFile ==
                                                                  null) {
                                                                Stylefile
                                                                    .showmessageforvalidationfalse(
                                                                        context,
                                                                        "Please select image");
                                                              } else {
                                                                Apiservice.SIBSavetaggingapi(
                                                                        context,
                                                                        box
                                                                            .read(
                                                                                "UserToken")
                                                                            .toString(),
                                                                        box
                                                                            .read(
                                                                                "userid")
                                                                            .toString(),
                                                                        widget
                                                                            .villageid,
                                                                        "2",
                                                                        box.read(
                                                                            "stateid"),
                                                                        _mySchemeid,
                                                                        getclickedstatus,
                                                                        box
                                                                            .read(
                                                                                "DivisionId")
                                                                            .toString(),
                                                                        selecthabitaionid,
                                                                        locationlandmarkcontroller
                                                                            .text
                                                                            .toString(),
                                                                        _currentPosition!
                                                                            .latitude
                                                                            .toString(),
                                                                        _currentPosition!
                                                                            .longitude
                                                                            .toString(),
                                                                        accuracyofgetlocation
                                                                            .toString(),
                                                                        base64Image)
                                                                    .then(
                                                                        (value) {
                                                                  Get.back();
                                                                  if (value["Status"]
                                                                          .toString() ==
                                                                      "false") {
                                                                    Stylefile.showmessageforvalidationfalse(
                                                                        context,
                                                                        value["msg"]
                                                                            .toString());

                                                                    if (value["msg"]
                                                                            .toString() ==
                                                                        "Token is wrong or expire") {
                                                                      setState(
                                                                          () {
                                                                        Get.off(
                                                                            LoginScreen());
                                                                        box
                                                                            .remove("UserToken")
                                                                            .toString();
                                                                        cleartable_localmastertables();
                                                                      });
                                                                    }
                                                                  } else if (value[
                                                                              "Status"]
                                                                          .toString() ==
                                                                      "true") {
                                                                    Stylefile.showmessageforvalidationtrue(
                                                                        context,
                                                                        value["msg"]
                                                                            .toString());

                                                                    cleartable_localmastertables();
                                                                    Apiservice.Getmasterapi(
                                                                            context)
                                                                        .then(
                                                                            (value) {
                                                                      for (int i =
                                                                              0;
                                                                          i < value.villagelist!.length;
                                                                          i++) {
                                                                        var userid = value
                                                                            .villagelist![i]!
                                                                            .userId;

                                                                        var villageId = value
                                                                            .villagelist![i]!
                                                                            .villageId;
                                                                        var stateId = value
                                                                            .villagelist![i]!
                                                                            .stateId;
                                                                        var villageName = value
                                                                            .villagelist![i]!
                                                                            .VillageName;

                                                                        databaseHelperJalJeevan
                                                                            ?.insertMastervillagelistdata(Localmasterdatanodal(
                                                                                UserId: userid.toString(),
                                                                                villageId: villageId.toString(),
                                                                                StateId: stateId.toString(),
                                                                                villageName: villageName.toString()))
                                                                            .then((value) {});
                                                                      }
                                                                      databaseHelperJalJeevan!
                                                                          .removeDuplicateEntries();

                                                                      for (int i =
                                                                              0;
                                                                          i < value.villageDetails!.length;
                                                                          i++) {
                                                                        var status =
                                                                            "";
                                                                        var stateName =
                                                                            "Assam";

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
                                                                        var totalNoOfWaterSource = value
                                                                            .villageDetails![i]!
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
                                                                        var pendingApprovalSsTotal = value
                                                                            .villageDetails![i]!
                                                                            .pendingApprovalSsTotal;
                                                                        var totalIbRequiredGeoTagged = value
                                                                            .villageDetails![i]!
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
                                                                        var totalNoOfSchoolScheme = value
                                                                            .villageDetails![i]!
                                                                            .totalNoOfSchoolScheme;
                                                                        var totalNoOfPwsScheme = value
                                                                            .villageDetails![i]!
                                                                            .totalNoOfPwsScheme;

                                                                        databaseHelperJalJeevan
                                                                            ?.insertMastervillagedetails(Localmasterdatamodal_VillageDetails(
                                                                          status:
                                                                              "0",
                                                                          stateName:
                                                                              stateName,
                                                                          districtName:
                                                                              districtName,
                                                                          blockName:
                                                                              blockName,
                                                                          panchayatName:
                                                                              panchayatName,
                                                                          stateId:
                                                                              stateidnew.toString(),
                                                                          userId:
                                                                              userId.toString(),
                                                                          villageId:
                                                                              villageIddetails.toString(),
                                                                          villageName:
                                                                              villageName,
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

                                                                      for (int i =
                                                                              0;
                                                                          i < value.schmelist!.length;
                                                                          i++) {
                                                                        var schemeidnew = value
                                                                            .schmelist![i]!
                                                                            .schemeid;
                                                                        var villageid = value
                                                                            .schmelist![i]!
                                                                            .villageId;
                                                                        var schemenamenew = value
                                                                            .schmelist![i]!
                                                                            .schemename;
                                                                        var schemenacategorynew = value
                                                                            .schmelist![i]!
                                                                            .category;
                                                                        var SourceTypeCategoryId = value.schmelist![i]!.SourceTypeCategoryId;
                                                                        var source_typeCategory = value.schmelist![i]!.source_typeCategory;

                                                                        databaseHelperJalJeevan
                                                                            ?.insertMasterSchmelist(Localmasterdatamoda_Scheme(
                                                                          source_type: Sourceid_type.toString(),  schemeid: schemeidnew.toString(),
                                                                          villageId:
                                                                              villageid.toString(),
                                                                          schemename:
                                                                              schemenamenew.toString(),
                                                                          category: schemenacategorynew.toString(),
                                                                          SourceTypeCategoryId: SourceTypeCategoryId.toString(),
                                                                          source_typeCategory: source_typeCategory.toString(),
                                                                        ));
                                                                      }

                                                                      for (int i =
                                                                              0;
                                                                          i < value.sourcelist!.length;
                                                                          i++) {
                                                                        var sourceId = value
                                                                            .sourcelist![i]!
                                                                            .sourceId;
                                                                        var SchemeId = value
                                                                            .sourcelist![i]!
                                                                            .schemeId;
                                                                        var stateid = value
                                                                            .sourcelist![i]!
                                                                            .stateid;
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
                                                                        var sourceTypeCategoryId = value
                                                                            .sourcelist![i]!
                                                                            .sourceTypeCategoryId;
                                                                        var habitationId = value
                                                                            .sourcelist![i]!
                                                                            .habitationId;
                                                                        var villageName = value
                                                                            .sourcelist![i]!
                                                                            .villageName;
                                                                        var existTagWaterSourceId = value
                                                                            .sourcelist![i]!
                                                                            .existTagWaterSourceId;
                                                                        var isApprovedState = value
                                                                            .sourcelist![i]!
                                                                            .isApprovedState;
                                                                        var landmark = value
                                                                            .sourcelist![i]!
                                                                            .landmark;
                                                                        var latitude = value
                                                                            .sourcelist![i]!
                                                                            .latitude;
                                                                        var longitude = value
                                                                            .sourcelist![i]!
                                                                            .longitude;
                                                                        var habitationName = value
                                                                            .sourcelist![i]!
                                                                            .habitationName;
                                                                        var location = value
                                                                            .sourcelist![i]!
                                                                            .location;
                                                                        var sourceTypeCategory = value
                                                                            .sourcelist![i]!
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
                                                                            ?.insertMasterSourcedetails(LocalSourcelistdetailsModal(
                                                                          schemeId:
                                                                              SchemeId.toString(),
                                                                          sourceId:
                                                                              sourceId.toString(),
                                                                          villageId:
                                                                              villageid.toString(),
                                                                          schemeName:
                                                                              Schemename,
                                                                          sourceTypeId:
                                                                              sourceTypeId.toString(),
                                                                          sourceTypeCategoryId:
                                                                              sourceTypeCategoryId.toString(),
                                                                          habitationId:
                                                                              habitationId.toString(),
                                                                          existTagWaterSourceId:
                                                                              existTagWaterSourceId.toString(),
                                                                          isApprovedState:
                                                                              isApprovedState.toString(),
                                                                          landmark:
                                                                              landmark,
                                                                          latitude:
                                                                              latitude.toString(),
                                                                          longitude:
                                                                              longitude.toString(),
                                                                          habitationName:
                                                                              habitationName,
                                                                          location:
                                                                              location,
                                                                          sourceTypeCategory:
                                                                              sourceTypeCategory,
                                                                          sourceType:
                                                                              sourceType,
                                                                          stateName:
                                                                              statename,
                                                                          districtName:
                                                                              districtName,
                                                                          blockName:
                                                                              blocknamenew,
                                                                          panchayatName:
                                                                              panchayatNamenew,
                                                                          districtId:
                                                                              districtId.toString(),
                                                                          villageName:
                                                                              villageName,
                                                                          stateId:
                                                                              stateid.toString(),
                                                                        ));
                                                                      }

                                                                      for (int i =
                                                                              0;
                                                                          i < value.habitationlist!.length;
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

                                                                        databaseHelperJalJeevan?.insertMasterhabitaionlist(LocalHabitaionlistModal(
                                                                            villageId:
                                                                                villafgeid.toString(),
                                                                            HabitationId: habitationId.toString(),
                                                                            HabitationName: habitationName.toString()));
                                                                      }
                                                                      for (int i =
                                                                              0;
                                                                          i < value.informationBoardList!.length;
                                                                          i++) {
                                                                        databaseHelperJalJeevan?.insertmastersibdetails(LocalmasterInformationBoardItemModal(
                                                                            userId:
                                                                                value.informationBoardList![i]!.userId.toString(),
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
                                                                });
                                                              }
                                                            }
                                                          } on SocketException catch (_) {
                                                            Stylefile
                                                                .showmessageforvalidationfalse(
                                                                    context,
                                                                    "Unable to Connect to the Internet. Please check your network settings.");
                                                          }
                                                        })))),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isSameasSource,
                                child: Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Select already tagged Source',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Container(
                                          height: 200,
                                          width: 400,
                                          padding:
                                              const EdgeInsets.only(top: 15),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Column(
                                            children: [
                                              _image != null
                                                  ? Image.file(
                                                      _image!,
                                                      width: 500,
                                                      height: 117,
                                                    )
                                                  : InkWell(
                                                      onTap: () {},
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        child: Image.asset(
                                                            'images/camera.png',
                                                            width: 100.0,
                                                            height: 100.0),
                                                      ),
                                                    ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Center(
                                                child: Container(
                                                  height: 40,
                                                  width: 200,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFF0D3A98),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      if (_currentPosition ==
                                                          null) {
                                                        Stylefile
                                                            .showmessageforvalidationfalse(
                                                                context,
                                                                "Please enter latitude longitude ");
                                                      } else {
                                                        openCamera();
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Take Photo this is for same source',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                              Get.back();
                                              Stylefile.showmessageforvalidationtrue(
                                                      context, "Saved Successfully");},
                                            child: const Text(
                                              'Save',
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
                              Visibility(
                                  visible: selectschemesourcemessage_mvc,
                                  child: Container(
                                    margin: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Appcolor.white,
                                      border: Border.all(
                                        color: Appcolor.lightgrey,
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0,),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Listdetaillistofscheme.length == 0
                                              ? const SizedBox()
                                              : Container(
                                                  child: const Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(5.0),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "List of PWS sources",
                                                            style: TextStyle(
                                                                color: Appcolor
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                      ),
                                                      Divider(
                                                        height: 10,
                                                        color: Colors.grey,
                                                        thickness: 1,
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          Column(
                                            children: [
                                              ListView.builder(
                                                  itemCount:
                                                      Listdetaillistofscheme
                                                          .length,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    districtname =
                                                        Listdetaillistofscheme[
                                                                    index]
                                                                ["DistrictName"]
                                                            .toString();
                                                    blockname =
                                                        Listdetaillistofscheme[
                                                                    index]
                                                                ["BlockName"]
                                                            .toString();
                                                    sourcetype =
                                                        Listdetaillistofscheme[
                                                                    index]
                                                                ["SourceType"]
                                                            .toString();
                                                    panchayatname =
                                                        Listdetaillistofscheme[
                                                                    index][
                                                                "PanchayatName"]
                                                            .toString();
                                                    var exstingsourceid =
                                                        Listdetaillistofscheme[
                                                                    index][
                                                                "existTagWaterSourceId"]
                                                            .toString();

                                                    selectscheme_addnewsourcebtn =
                                                        Listdetaillistofscheme[
                                                                    index]
                                                                ["SchemeName"]
                                                            .toString();
                                                    selecthabitation_addnewsourcebtn =
                                                        Listdetaillistofscheme[
                                                                    index][
                                                                "HabitationName"]
                                                            .toString();
                                                    selectlocationlanmark_addnewsourcebtn =
                                                        Listdetaillistofscheme[
                                                                    index]
                                                                ["location"]
                                                            .toString();
                                                    villageid_addnewsourcebtn =
                                                        widget.villageid
                                                            .toString();

                                                    assettaggingid_addnewsourcebtn =
                                                        assettaggingid_fornewsource
                                                            .toString();

                                                    StateId_addnewsourcebtn =
                                                        box
                                                            .read("stateid")
                                                            .toString();
                                                    schemeid_addnewsourcebtn =
                                                        _mySchemeid;
                                                    SourceId_addnewsourcebtn =
                                                        Listdetaillistofscheme[
                                                                    index]
                                                                ["SourceId"]
                                                            .toString();
                                                    HabitationId_addnewsourcebtn =
                                                        Listdetaillistofscheme[
                                                                    index]
                                                                ["Habitationid"]
                                                            .toString();
                                                    SourceTypeId_addnewsourcebtn =
                                                        Listdetaillistofscheme[
                                                                    index]
                                                                ["SourceTypeId"]
                                                            .toString();
                                                    SourceTypeCategoryId_addnewsourcebtn =
                                                        Listdetaillistofscheme[
                                                                    index][
                                                                "sourceTypeCategoryId"]
                                                            .toString();
                                                    villagename_addnewsourcebtn =
                                                        getvillagename;
                                                    latitute_addnewsourcebtn =
                                                        _currentPosition
                                                            ?.latitude;
                                                    longitute_addnewsourcebtn =
                                                        _currentPosition
                                                            ?.longitude;

                                                    int counter = index + 1;
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 5,
                                                                  top: 5),
                                                          child: Column(
                                                            children: [
                                                              Material(
                                                                elevation: 4,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                child: InkWell(
                                                                  splashColor:
                                                                      Appcolor
                                                                          .splashcolor,
                                                                  onTap: () {},
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            borderRadius:
                                                                                const BorderRadius.all(Radius.circular(5.0)),
                                                                            border: Border.all(
                                                                              color: Appcolor.lightgrey,
                                                                            )),
                                                                    child:
                                                                        Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      margin: const EdgeInsets
                                                                          .all(
                                                                          10),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                "" + counter.toString() + ".",
                                                                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Listdetaillistofscheme[index]["isApprovedState"].toString() == "0"
                                                                                  ? const SizedBox()
                                                                                  : const Align(
                                                                                      alignment: Alignment.centerRight,
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.all(1.0),
                                                                                        child: Text(
                                                                                          "Verified by State",
                                                                                          style: TextStyle(color: Appcolor.greenmessagecolor, fontSize: 16, fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              const Padding(
                                                                                padding: EdgeInsets.all(5.0),
                                                                                child: SizedBox(
                                                                                  child: Text(
                                                                                    "Location :",
                                                                                    maxLines: 10,
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(5.0),
                                                                                  child: Text(
                                                                                    Listdetaillistofscheme[index]["location"].toString(),
                                                                                    maxLines: 5,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              const SizedBox(
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.all(5.0),
                                                                                  child: Text(
                                                                                    textAlign: TextAlign.justify,
                                                                                    maxLines: 5,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    "Source Category :",
                                                                                    style: TextStyle(color: Appcolor.black, fontWeight: FontWeight.bold, fontSize: 16),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(5.0),
                                                                                child: Text(
                                                                                  textAlign: TextAlign.justify,
                                                                                  maxLines: 5,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  Listdetaillistofscheme[index]["sourceTypeCategory"].toString(),
                                                                                  style: const TextStyle(color: Appcolor.black, fontWeight: FontWeight.w400, fontSize: 16),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              const SizedBox(
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.all(5.0),
                                                                                  child: Text(
                                                                                    textAlign: TextAlign.justify,
                                                                                    maxLines: 5,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    "Source Type :",
                                                                                    style: TextStyle(color: Appcolor.black, fontWeight: FontWeight.bold, fontSize: 16),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Flexible(
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(5.0),
                                                                                  child: Text(
                                                                                    textAlign: TextAlign.justify,
                                                                                    maxLines: 5,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    Listdetaillistofscheme[index]["sourceType"].toString(),
                                                                                    style: const TextStyle(color: Appcolor.black, fontWeight: FontWeight.w400, fontSize: 16),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Listdetaillistofscheme[index]["latitude"] == "0" || Listdetaillistofscheme[index]["longitude"] == "0"
                                                                              ? const SizedBox()
                                                                              : Row(
                                                                                  children: [
                                                                                    const SizedBox(
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.all(5.0),
                                                                                        child: Text(
                                                                                          "Habitation :",
                                                                                          style: TextStyle(color: Appcolor.black, fontWeight: FontWeight.bold, fontSize: 16),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Flexible(
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(5.0),
                                                                                        child: Text(
                                                                                          maxLines: 5,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          Listdetaillistofscheme[index]["habitationName"].toString(),
                                                                                          style: const TextStyle(color: Appcolor.black, fontWeight: FontWeight.w400, fontSize: 16),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                          Listdetaillistofscheme[index]["latitude"] == "0" || Listdetaillistofscheme[index]["longitude"] == "0"
                                                                              ? const SizedBox()
                                                                              : const Text(""),
                                                                          Listdetaillistofscheme[index]["isApprovedState"].toString() == "0" && Listdetaillistofscheme[index]["existTagWaterSourceId"].toString() != "0"
                                                                              ? Row(
                                                                                  children: [
                                                                                    const SizedBox(
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.all(5.0),
                                                                                        child: Text(
                                                                                          textAlign: TextAlign.justify,
                                                                                          maxLines: 5,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          "Latitude :",
                                                                                          style: TextStyle(color: Appcolor.black, fontWeight: FontWeight.bold, fontSize: 16),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(5.0),
                                                                                      child: Text(
                                                                                        textAlign: TextAlign.justify,
                                                                                        maxLines: 5,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        Listdetaillistofscheme[index]["latitude"].toString(),
                                                                                        style: const TextStyle(color: Appcolor.black, fontWeight: FontWeight.w400, fontSize: 16),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              : const SizedBox(),
                                                                          Listdetaillistofscheme[index]["isApprovedState"].toString() == "0" && Listdetaillistofscheme[index]["existTagWaterSourceId"].toString() != "0"
                                                                              ? Row(
                                                                                  children: [
                                                                                    const SizedBox(
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.all(5.0),
                                                                                        child: Text(
                                                                                          "Longitude :",
                                                                                          style: TextStyle(color: Appcolor.black, fontWeight: FontWeight.bold, fontSize: 16),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(5.0),
                                                                                      child: Text(
                                                                                        textAlign: TextAlign.justify,
                                                                                        maxLines: 5,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        Listdetaillistofscheme[index]["longitude"].toString(),
                                                                                        style: const TextStyle(color: Appcolor.black, fontWeight: FontWeight.w400, fontSize: 16),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              : const SizedBox(),
                                                                          Listdetaillistofscheme[index]["Message"] == "" || Listdetaillistofscheme[index]["Message"] == null
                                                                              ? const SizedBox()
                                                                              : Row(
                                                                                  children: [
                                                                                    const SizedBox(
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.all(5.0),
                                                                                        child: Text(
                                                                                          "Status :",
                                                                                          style: TextStyle(color: Appcolor.black, fontWeight: FontWeight.bold, fontSize: 16),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(5.0),
                                                                                      child: Text(
                                                                                        textAlign: TextAlign.justify,
                                                                                        maxLines: 5,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        Listdetaillistofscheme[index]["Message"].toString(),
                                                                                        style: const TextStyle(color: Appcolor.red, fontWeight: FontWeight.w400, fontSize: 16),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                          const Divider(
                                                                            height:
                                                                                10,
                                                                            color:
                                                                                Appcolor.lightgrey,
                                                                            thickness:
                                                                                1,
                                                                          ),
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.centerRight,
                                                                            child: Listdetaillistofscheme[index]["existTagWaterSourceId"].toString() == "0" && Listdetaillistofscheme[index]["isApprovedState"].toString() == "0"
                                                                                ? ElevatedButton(
                                                                                    style: ButtonStyle(
                                                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                        RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(10.0),
                                                                                          side: const BorderSide(color: Appcolor.btncolor),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    onPressed: () async {
                                                                                      bool isRecordPresent = await databaseHelperJalJeevan!.isRecordExistsProceedtotag(_mySchemeid, Listdetaillistofscheme[index]["habitationId"].toString(), Listdetaillistofscheme[index]["location"]);
                                                                                      if (isRecordPresent) {
                                                                                        Stylefile.showmessageforvalidationfalse(context, "A record already tagged offline.");
                                                                                      } else {
                                                                                        Get.to(NewTagScreen(
                                                                                          selectscheme: Listdetaillistofscheme[index]["Schemename"],
                                                                                          selecthabitation: Listdetaillistofscheme[index]["habitationName"],
                                                                                          selecthabitationid: Listdetaillistofscheme[index]["habitationId"],
                                                                                          selectlocationlanmark: Listdetaillistofscheme[index]["location"],
                                                                                          villageid: widget.villageid,
                                                                                          assettaggingid: getclickedstatus,
                                                                                          StateId: box.read("stateid").toString(),
                                                                                          schemeid: _mySchemeid,
                                                                                          SourceId: Listdetaillistofscheme[index]["SourceId"],
                                                                                          sourcetypelocal: sourcetypelocal,
                                                                                          HabitationId: Listdetaillistofscheme[index]["habitationId"].toString(),
                                                                                          SourceTypeId: sourcetypeidfroproced,
                                                                                          SourceTypeCategoryId: sourceTypeCategoryid,
                                                                                          villagename: widget.villagename,
                                                                                          districtname: Listdetaillistofscheme[index]["DistrictName"].toString(),
                                                                                          blockname: Listdetaillistofscheme[index]["BlockName"].toString(),
                                                                                          sourcetype: Listdetaillistofscheme[index]["SourceType"].toString(),
                                                                                          panchayatname: Listdetaillistofscheme[index]["PanchayatName"].toString(),
                                                                                        ));
                                                                                      }
                                                                                    },
                                                                                    child: const Text(
                                                                                      "Proceed & tag",
                                                                                      style: TextStyle(color: Appcolor.btncolor, fontSize: 14, fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  )
                                                                                : const SizedBox(),
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
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                              selectcategoryname == "svs"
                                                  ? Container(
                                                      height: 45,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Appcolor
                                                                    .btncolor,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            if ( Listdetaillistofscheme
                                                                    .length
                                                                    .toString() !=
                                                                "0") {
                                                              _showalertboxforaddnewsource(
                                                                  Listdetaillistofscheme
                                                                      .length
                                                                      .toString());
                                                            } else {
                                                              Get.to(AddNewSourceScreen(
                                                                  Sourceid_typesend :  Sourceid_type,
                                                                  source_typeCategorysend:      source_typeCategory,

                                                                  SourceTypeCategoryIdsend:SourceTypeCategoryId,

                                                                  selectscheme: selectschamename,
                                                                  selecthabitation:
                                                                      selecthabitation_addnewsourcebtn,
                                                                  selectlocationlanmark:
                                                                      selectlocationlanmark_addnewsourcebtn,
                                                                  villageid: widget
                                                                      .villageid,
                                                                  assettaggingid:
                                                                      getclickedstatus
                                                                          .toString(),
                                                                  StateId:
                                                                      StateId_addnewsourcebtn,
                                                                  schemeid:
                                                                      _mySchemeid,
                                                                  SourceId: "0",
                                                                  HabitationId:
                                                                      HabitationId_addnewsourcebtn,
                                                                  SourceTypeId:
                                                                      SourceTypeId_addnewsourcebtn,
                                                                  SourceTypeCategoryId:
                                                                      SourceTypeCategoryId_addnewsourcebtn,
                                                                  villagename:
                                                                      getvillagename,
                                                                  latitute:
                                                                      latitute_addnewsourcebtn,
                                                                  longitute:
                                                                      longitute_addnewsourcebtn,
                                                                  districtname:
                                                                      districtname,
                                                                  blockname:
                                                                      blockname,
                                                                  sourcetype:
                                                                      sourcetype,
                                                                  panchayatname: panchayatname));
                                                            }
                                                          },
                                                          child: const Text(
                                                            "Add New Source & Geo-tag",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18.0,
                                                            ),
                                                          )),
                                                    )
                                                  : const SizedBox(),
                                              SizedBox(height: 5,),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                margin: const EdgeInsets.all(0),
                                                decoration: BoxDecoration(
                                                  color: const Color(0x89BBBBBB)
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                ),
                                                child:
                                                    localpwspendingDataList
                                                                .length ==
                                                            0
                                                        ? const Center(
                                                            child: SizedBox())
                                                        : SingleChildScrollView(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const SizedBox(
                                                                    height: 20),
                                                                Center(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            5.0),
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          40,
                                                                      child:
                                                                          Directionality(
                                                                        textDirection:
                                                                            TextDirection.rtl,
                                                                        child: ElevatedButton

                                                                            .icon(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            primary:
                                                                                Appcolor.lightgrey,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(20.0),
                                                                            ),
                                                                          ),
                                                                          label:
                                                                              const Padding(
                                                                            padding:
                                                                                EdgeInsets.all(10.0),
                                                                            child:
                                                                                Text(
                                                                              'Tagged water sources ',
                                                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Appcolor.white),
                                                                            ),
                                                                          ),
                                                                          onPressed:
                                                                              () async {},
                                                                          icon:
                                                                              const Icon(
                                                                            Icons.offline_share,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                20.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 10),
                                                                const Divider(
                                                                  thickness: 1,
                                                                  height: 10,
                                                                  color: Appcolor
                                                                      .lightgrey,
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: const Color(
                                                                            0xFFFFFFFF)
                                                                        .withOpacity(
                                                                            0.3),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .green,
                                                                      width: 1,
                                                                    ),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                      Radius
                                                                          .circular(
                                                                        10.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  child: ListView
                                                                      .builder(
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemCount: localpwspendingDataList
                                                                              .length,
                                                                          physics:
                                                                              const NeverScrollableScrollPhysics(),
                                                                          itemBuilder:
                                                                              (context, int index) {
                                                                            int counter =
                                                                                index + 1;
                                                                            return Container(
                                                                              margin: const EdgeInsets.all(5),
                                                                              width: double.infinity,
                                                                              alignment: Alignment.center,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                              ),
                                                                              padding: const EdgeInsets.all(5),
                                                                              child: Material(
                                                                                child: InkWell(
                                                                                  splashColor: Appcolor.lightyello,
                                                                                  onTap: () {},
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                                                                            child: Text(
                                                                                              "Habitation :",
                                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Appcolor.black),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                              child: Text(
                                                                                                localpwspendingDataList![index].habitationName.toString(),
                                                                                                textAlign: TextAlign.justify,
                                                                                                style: const TextStyle(fontWeight: FontWeight.w400, color: Appcolor.black, fontSize: 16),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          const Padding(
                                                                                            padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                            child: Text(
                                                                                              "Location :",
                                                                                              style: TextStyle(fontWeight: FontWeight.bold, color: Appcolor.black, fontSize: 16),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                              child: Text(
                                                                                                localpwspendingDataList![index].landmark.toString(),
                                                                                                textAlign: TextAlign.justify,
                                                                                                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Appcolor.black),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          const Padding(
                                                                                            padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                            child: Text(
                                                                                              "Source Category :",
                                                                                              textAlign: TextAlign.justify,
                                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Appcolor.black),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                              child: Text(
                                                                                                localpwspendingDataList![index].sourceName.toString().toString(),
                                                                                                textAlign: TextAlign.justify,
                                                                                                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Appcolor.black),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          const Padding(
                                                                                            padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                            child: Text(
                                                                                              "Source Type:",
                                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Appcolor.black),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                              child: Text(
                                                                                                localpwspendingDataList![index].sourceType.toString().toString(),
                                                                                                textAlign: TextAlign.justify,
                                                                                                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Appcolor.black),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          const Padding(
                                                                                            padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                            child: Text(
                                                                                              "Latitude : ",
                                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Appcolor.black),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                              child: Text(
                                                                                                localpwspendingDataList![index].latitude.toString(),
                                                                                                textAlign: TextAlign.justify,
                                                                                                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Appcolor.black),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          const Padding(
                                                                                            padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                            child: Text(
                                                                                              "Longitude :",
                                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Appcolor.black),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                              child: Text(
                                                                                                localpwspendingDataList![index].longitude.toString().toString(),
                                                                                                textAlign: TextAlign.justify,
                                                                                                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Appcolor.black),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          const Padding(
                                                                                            padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                            child: SizedBox(
                                                                                                child: Text(
                                                                                              "Status : ",
                                                                                              style: TextStyle(fontWeight: FontWeight.bold, color: Appcolor.black),
                                                                                            )),
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
                                                                                            child: SizedBox(
                                                                                                width: 130,
                                                                                                child: Text(
                                                                                                  maxLines: 10,
                                                                                                  localpwspendingDataList![index].Status.toString(),
                                                                                                  style: const TextStyle(fontWeight: FontWeight.w400, color: Appcolor.red),
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
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                                          children: [
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
                                                                                                  Get.to(ZoomImage(imgurl: localpwspendingDataList![index].image, lat: localpwspendingDataList[index].latitude, long: localpwspendingDataList[index].longitude));
                                                                                                },
                                                                                                icon: const Icon(
                                                                                                  Icons.remove_red_eye_outlined,
                                                                                                  size: 18,
                                                                                                  color: Appcolor.white,
                                                                                                ),
                                                                                                label: const Text(
                                                                                                  "View",
                                                                                                  style: TextStyle(color: Appcolor.white, fontSize: 12, fontWeight: FontWeight.bold),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            const SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 25,
                                                                                              child: ElevatedButton.icon(
                                                                                                style: ElevatedButton.styleFrom(
                                                                                                  primary: Appcolor.pink,
                                                                                                  shape: RoundedRectangleBorder(
                                                                                                    borderRadius: BorderRadius.circular(5.0),
                                                                                                  ),
                                                                                                ),
                                                                                                onPressed: () async {
                                                                                                  _showAlertDialogforuntaggeoloc(localpwspendingDataList[index].id.toString(), index);
                                                                                                },
                                                                                                icon: const Icon(
                                                                                                  size: 18.0,
                                                                                                  Icons.delete_outline_outlined,
                                                                                                  color: Appcolor.white,
                                                                                                ),
                                                                                                label: const Text(
                                                                                                  "Remove",
                                                                                                  style: TextStyle(color: Appcolor.white, fontSize: 12, fontWeight: FontWeight.bold),
                                                                                                ),
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                              ),
                                            ],
                                          ),
                                          selectcategoryname.toString() == "mvs"
                                              ? GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      messagevisibility = true;
                                                      Listdetaillistofscheme
                                                          .clear();
                                                    });
                                                  },
                                                  child: const Center(
                                                      child: SizedBox()),
                                                )
                                              : const SizedBox(),
                                          const SizedBox(
                                            height: 0,
                                          ),
                                          Visibility(
                                              visible: messagevisibility,
                                              child: Container(
                                                child: Column(
                                                  children: [
                                                    Listdetaillistofscheme_mvs
                                                                .length ==
                                                            0
                                                        ? const SizedBox()
                                                        : Container(
                                                            child: const Column(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5.0),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      "List of PWS sources",
                                                                      style: TextStyle(
                                                                          color: Appcolor
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Divider(
                                                                  height: 10,
                                                                  color: Colors
                                                                      .grey,
                                                                  thickness: 1,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                    Container(
                                                      child: ListView.builder(
                                                          itemCount:
                                                              Listdetaillistofscheme_mvs
                                                                  .length,
                                                          shrinkWrap: true,
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            int counter =
                                                                index + 1;
                                                            return Column(
                                                              children: [
                                                                Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              2,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              10),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Appcolor
                                                                        .white,
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Appcolor
                                                                          .lightgrey,
                                                                      width: .5,
                                                                    ),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                      Radius
                                                                          .circular(
                                                                        10.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      Material(
                                                                        elevation:
                                                                            4,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              Appcolor.splashcolor,
                                                                          onTap:
                                                                              () {},
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
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
                                                                            child:
                                                                                Container(
                                                                              margin: const EdgeInsets.only(top: 5, right: 5, left: 5),
                                                                              child: Column(
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(5.0),
                                                                                        child: Text(
                                                                                          "" + counter.toString() + ".",
                                                                                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                      ),
                                                                                      Listdetaillistofscheme_mvs[index]["isApprovedState"].toString() == "0"
                                                                                          ? const SizedBox()
                                                                                          : const Align(
                                                                                              alignment: Alignment.centerRight,
                                                                                              child: Padding(
                                                                                                padding: EdgeInsets.all(1.0),
                                                                                                child: Text(
                                                                                                  "Verified by State",
                                                                                                  style: TextStyle(color: Appcolor.greenmessagecolor, fontSize: 16, fontWeight: FontWeight.bold),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                      const SizedBox(
                                                                                        width: 10,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      const Padding(
                                                                                        padding: EdgeInsets.all(5.0),
                                                                                        child: SizedBox(
                                                                                          child: Text(
                                                                                            "Location :",
                                                                                            maxLines: 10,
                                                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(5.0),
                                                                                          child: Text(
                                                                                            Listdetaillistofscheme_mvs[index]["location"].toString(),
                                                                                            maxLines: 5,
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      const SizedBox(
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.all(5.0),
                                                                                          child: Text(
                                                                                            textAlign: TextAlign.justify,
                                                                                            maxLines: 5,
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            "Source Category :",
                                                                                            style: TextStyle(color: Appcolor.black, fontWeight: FontWeight.bold, fontSize: 16),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(5.0),
                                                                                        child: Text(
                                                                                          textAlign: TextAlign.justify,
                                                                                          maxLines: 5,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          Listdetaillistofscheme_mvs[index]["sourceTypeCategory"].toString(),
                                                                                          style: const TextStyle(color: Appcolor.black, fontWeight: FontWeight.w400, fontSize: 16),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      const SizedBox(
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.all(5.0),
                                                                                          child: Text(
                                                                                            textAlign: TextAlign.justify,
                                                                                            maxLines: 5,
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            "Source Type :",
                                                                                            style: TextStyle(color: Appcolor.black, fontWeight: FontWeight.bold, fontSize: 16),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(5.0),
                                                                                        child: Text(
                                                                                          textAlign: TextAlign.justify,
                                                                                          maxLines: 5,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          Listdetaillistofscheme_mvs[index]["sourceType"].toString(),
                                                                                          style: const TextStyle(color: Appcolor.black, fontWeight: FontWeight.w400, fontSize: 16),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Listdetaillistofscheme_mvs[index]["latitude"] == "0" || Listdetaillistofscheme_mvs[index]["longitude"] == "0"
                                                                                      ? const SizedBox()
                                                                                      : Row(
                                                                                          children: [
                                                                                            const SizedBox(
                                                                                              child: Padding(
                                                                                                padding: EdgeInsets.all(5.0),
                                                                                                child: Text(
                                                                                                  "Habitation :",
                                                                                                  style: TextStyle(color: Appcolor.black, fontWeight: FontWeight.bold, fontSize: 16),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.all(5.0),
                                                                                              child: Text(
                                                                                                textAlign: TextAlign.justify,
                                                                                                maxLines: 5,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                Listdetaillistofscheme_mvs[index]["habitationName"].toString(),
                                                                                                style: const TextStyle(color: Appcolor.black, fontWeight: FontWeight.w400, fontSize: 16),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                  Listdetaillistofscheme_mvs[index]["latitude"] == "0" || Listdetaillistofscheme_mvs[index]["longitude"] == "0" ? const SizedBox() : const Text(""),
                                                                                  Listdetaillistofscheme_mvs[index]["isApprovedState"].toString() == "0" && Listdetaillistofscheme_mvs[index]["existTagWaterSourceId"].toString() != "0"
                                                                                      ? Row(
                                                                                          children: [
                                                                                            const SizedBox(
                                                                                              child: Padding(
                                                                                                padding: EdgeInsets.all(5.0),
                                                                                                child: Text(
                                                                                                  textAlign: TextAlign.justify,
                                                                                                  maxLines: 5,
                                                                                                  overflow: TextOverflow.ellipsis,
                                                                                                  "Latitude :",
                                                                                                  style: TextStyle(color: Appcolor.black, fontWeight: FontWeight.bold, fontSize: 16),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.all(5.0),
                                                                                              child: Text(
                                                                                                textAlign: TextAlign.justify,
                                                                                                maxLines: 5,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                Listdetaillistofscheme_mvs[index]["latitude"].toString(),
                                                                                                style: const TextStyle(color: Appcolor.black, fontWeight: FontWeight.w400, fontSize: 16),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        )
                                                                                      : const SizedBox(),
                                                                                  Listdetaillistofscheme_mvs[index]["isApprovedState"].toString() == "0" && Listdetaillistofscheme_mvs[index]["existTagWaterSourceId"].toString() != "0"
                                                                                      ? Row(
                                                                                          children: [
                                                                                            const SizedBox(
                                                                                              child: Padding(
                                                                                                padding: EdgeInsets.all(5.0),
                                                                                                child: Text(
                                                                                                  "Longitude :",
                                                                                                  style: TextStyle(color: Appcolor.black, fontWeight: FontWeight.bold, fontSize: 16),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.all(5.0),
                                                                                              child: Text(
                                                                                                textAlign: TextAlign.justify,
                                                                                                maxLines: 5,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                Listdetaillistofscheme_mvs[index]["longitude"].toString(),
                                                                                                style: const TextStyle(color: Appcolor.black, fontWeight: FontWeight.w400, fontSize: 16),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        )
                                                                                      : const SizedBox(),
                                                                                  Listdetaillistofscheme_mvs[index]["Message"] == "" || Listdetaillistofscheme_mvs[index]["Message"] == null
                                                                                      ? const SizedBox()
                                                                                      : Row(
                                                                                          children: [
                                                                                            const SizedBox(
                                                                                              child: Padding(
                                                                                                padding: EdgeInsets.all(5.0),
                                                                                                child: Text(
                                                                                                  "Status :",
                                                                                                  style: TextStyle(color: Appcolor.black, fontWeight: FontWeight.bold, fontSize: 16),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.all(5.0),
                                                                                              child: Text(
                                                                                                textAlign: TextAlign.justify,
                                                                                                maxLines: 5,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                Listdetaillistofscheme_mvs[index]["Message"].toString(),
                                                                                                style: const TextStyle(color: Appcolor.red, fontWeight: FontWeight.w400, fontSize: 16),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                  const Divider(
                                                                                    height: 10,
                                                                                    color: Appcolor.lightgrey,
                                                                                    thickness: 1,
                                                                                  ),
                                                                                  Container(
                                                                                    margin: const EdgeInsets.all(5),
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerRight,
                                                                                      child: Listdetaillistofscheme_mvs[index]["existTagWaterSourceId"].toString() == "0" && Listdetaillistofscheme_mvs[index]["isApprovedState"].toString() == "0"
                                                                                          ? ElevatedButton(
                                                                                              style: ButtonStyle(
                                                                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                                  RoundedRectangleBorder(
                                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                                    side: const BorderSide(color: Appcolor.btncolor),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              onPressed: () async {
                                                                                                bool isRecordPresent = await databaseHelperJalJeevan!.isRecordExistsProceedtotag(_mySchemeid, Listdetaillistofscheme_mvs[index]["habitationId"].toString(), Listdetaillistofscheme_mvs[index]["location"]);
                                                                                                if (isRecordPresent) {
                                                                                                  Stylefile.showmessageforvalidationfalse(context, "A record already tagged offline.");
                                                                                                } else {
                                                                                                  Get.to(NewTagScreen(
                                                                                                    selectscheme: Listdetaillistofscheme_mvs[index]["Schemename"],
                                                                                                    selecthabitation: Listdetaillistofscheme_mvs[index]["habitationName"],
                                                                                                    selecthabitationid: Listdetaillistofscheme_mvs[index]["habitationId"],
                                                                                                    selectlocationlanmark: Listdetaillistofscheme_mvs[index]["location"],
                                                                                                    villageid: widget.villageid,
                                                                                                    assettaggingid: getclickedstatus,
                                                                                                    StateId: box.read("stateid").toString(),
                                                                                                    schemeid: _mySchemeid,
                                                                                                    SourceId: Listdetaillistofscheme_mvs[index]["SourceId"].toString(),
                                                                                                    sourcetypelocal: sourcetypelocal,
                                                                                                    HabitationId: Listdetaillistofscheme_mvs[index]["habitationId"].toString(),
                                                                                                    SourceTypeId: sourcetypeidfroproced,
                                                                                                    SourceTypeCategoryId: sourceTypeCategoryid,
                                                                                                    villagename: widget.villagename,
                                                                                                    districtname: Listdetaillistofscheme_mvs[index]["DistrictName"].toString(),
                                                                                                    blockname: Listdetaillistofscheme_mvs[index]["BlockName"].toString(),
                                                                                                    sourcetype: Listdetaillistofscheme_mvs[index]["SourceType"].toString(),
                                                                                                    panchayatname: Listdetaillistofscheme_mvs[index]["PanchayatName"].toString(),
                                                                                                  ));
                                                                                                }
                                                                                              },
                                                                                              child: const Text(
                                                                                                "Proceed & tag",
                                                                                                style: TextStyle(color: Appcolor.btncolor, fontSize: 14, fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                            )
                                                                                          : const SizedBox(),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          }),
                                                    )
                                                  ],
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  )),
                              Visibility(
                                  visible: messagenowatersourcecontactofc,
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: Text(
                                              "Details of PWS source :",
                                              style: TextStyle(
                                                  color: Appcolor.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          const Divider(
                                            height: 10,
                                            color: Colors.grey,
                                            thickness: 1,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Center(
                                              child: Container(
                                            decoration: BoxDecoration(
                                              color: Appcolor.lightyello,
                                              border: Border.all(
                                                color: Appcolor.red,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(
                                                  5.0,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text: 'Alert!',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color:
                                                              Appcolor.black),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text:
                                                                ' Till date no water source entry has been \ndone for this scheme. Kindly contact to your \ndivision officer for data entry.',
                                                            style: new TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 14,
                                                                color: Appcolor
                                                                    .black)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  )),
                              localsibpendinglist.length == 0
                                  ? const SizedBox()
                                  : Visibility(
                                      visible: offlinesiblistvosibleornot,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                "Information boards : ",
                                                style: TextStyle(
                                                    color: Appcolor.grey,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFFFFFF)
                                                    .withOpacity(0.3),
                                                border: Border.all(
                                                  color: Colors.grey,
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
                                                  itemCount: localsibpendinglist
                                                      .length,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (context, int index) {
                                                    int counter = index + 1;
                                                    return Container(
                                                        margin: const EdgeInsets
                                                            .all(5),
                                                        width: double.infinity,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child: Material(
                                                          child: InkWell(
                                                            splashColor:
                                                                Appcolor
                                                                    .lightyello,
                                                            onTap: () {},
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5.0),
                                                                  child: Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Text(
                                                                        "" +
                                                                            counter.toString() +
                                                                            ".",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      )),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              0,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                      child: SizedBox(
                                                                          child: Text(
                                                                        textAlign:
                                                                            TextAlign.justify,
                                                                        maxLines:
                                                                            5,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        "Habitation :",
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Appcolor.black),
                                                                      )),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              0,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                      child: SizedBox(
                                                                          width: 180,
                                                                          child: Text(
                                                                            textAlign:
                                                                                TextAlign.justify,
                                                                            maxLines:
                                                                                5,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            localsibpendinglist![index].HabitationName.toString(),
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 16,
                                                                                color: Appcolor.black),
                                                                          )),
                                                                    )
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              0,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                      child: SizedBox(
                                                                          child: Text(
                                                                        "Location :",
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Appcolor.black),
                                                                      )),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              0,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                      child: SizedBox(
                                                                          width: 170,
                                                                          child: Text(
                                                                            textAlign:
                                                                                TextAlign.justify,
                                                                            maxLines:
                                                                                5,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            localsibpendinglist![index].landmark.toString(),
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 16,
                                                                                color: Appcolor.black),
                                                                          )),
                                                                    )
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              0,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                      child: SizedBox(
                                                                          child: Text(
                                                                        "Latitude : ",
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Appcolor.black),
                                                                      )),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              0,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                      child: SizedBox(
                                                                          width: 170,
                                                                          child: Text(
                                                                            textAlign:
                                                                                TextAlign.justify,
                                                                            maxLines:
                                                                                5,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            localsibpendinglist![index].latitude.toString(),
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 16,
                                                                                color: Appcolor.black),
                                                                          )),
                                                                    )
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              0,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                      child: SizedBox(
                                                                          child: Text(
                                                                        "Longitude : ",
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Appcolor.black),
                                                                      )),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              5,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                      child: SizedBox(
                                                                          width: 170,
                                                                          child: Text(
                                                                            textAlign:
                                                                                TextAlign.justify,
                                                                            maxLines:
                                                                                5,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            localsibpendinglist![index].longitude.toString(),
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 16,
                                                                                color: Appcolor.black),
                                                                          )),
                                                                    )
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              0,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                      child: SizedBox(
                                                                          child: Text(
                                                                        "Status : ",
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Appcolor.black),
                                                                      )),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              5,
                                                                          bottom:
                                                                              5,
                                                                          top:
                                                                              5),
                                                                      child: SizedBox(
                                                                          width: 170,
                                                                          child: Text(
                                                                            textAlign:
                                                                                TextAlign.justify,
                                                                            maxLines:
                                                                                5,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            localsibpendinglist![index].Status.toString(),
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 16,
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
                                                                          .all(
                                                                          8.0),
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
                                                                          child:
                                                                              ElevatedButton.icon(
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              primary: Appcolor.lightgrey,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(5.0),
                                                                              ),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Get.to(ZoomImage(imgurl: localsibpendinglist![index].photo, lat: localsibpendinglist[index].latitude, long: localsibpendinglist[index].longitude));
                                                                            },
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.remove_red_eye_outlined,
                                                                              size: 18,
                                                                              color: Appcolor.white,
                                                                            ),
                                                                            label:
                                                                                const Text(
                                                                              "View",
                                                                              style: TextStyle(color: Appcolor.white, fontSize: 12, fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              25,
                                                                          child:
                                                                              ElevatedButton.icon(
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              primary: Appcolor.pink,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(5.0),
                                                                              ),
                                                                            ),
                                                                            onPressed:
                                                                                () async {
                                                                              _SIBshowAlertDialogforuntaggeoloc(localsibpendinglist[index].id.toString(), index);
                                                                            },
                                                                            icon:
                                                                                const Icon(
                                                                              size: 18.0,
                                                                              Icons.delete_outline_outlined,
                                                                              color: Appcolor.white,
                                                                            ),
                                                                            label:
                                                                                const Text(
                                                                              "Remove",
                                                                              style: TextStyle(color: Appcolor.white, fontSize: 12, fontWeight: FontWeight.bold),
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
                                      )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> showuntagedalertbox(
      String selectscheme,
      String selecthabitation,
      String selectlocationlanmark,
      String villageid,
      String assettaggingid,
      String StateId,
      String schemeid,
      String SourceId,
      String HabitationId,
      String SourceTypeId,
      String SourceTypeCategoryId,
      String villagename,
      double latitute,
      double longitute) async {
    return await showDialog(
          context: context,
          builder: (context) => Container(
            margin: const EdgeInsets.all(30),
            child: AlertDialog(
              titlePadding: const EdgeInsets.only(top: 20, left: 0, right: 5),
              contentPadding:
                  const EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 20),
              insetPadding: const EdgeInsets.symmetric(horizontal: 10),
              title: const Padding(
                padding: EdgeInsets.only(left: 25, right: 20),
                child: Text(
                  "This scheme already has PWS source.Do you want to add a new source?",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                                side: BorderSide(color: Appcolor.btncolor)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Appcolor.btncolor),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Appcolor.btncolor,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  side: BorderSide(color: Appcolor.btncolor))),
                          onPressed: () {
                            AddNewSourceScreen(
                                Sourceid_typesend :  Sourceid_type,
                                source_typeCategorysend:      source_typeCategory,

                                SourceTypeCategoryIdsend:SourceTypeCategoryId,
                                selectscheme: selectscheme,
                                selecthabitation: selecthabitation,
                                selectlocationlanmark: selectlocationlanmark,
                                villageid: villageid,
                                assettaggingid: assettaggingid,
                                StateId: StateId,
                                schemeid: schemeid,
                                SourceId: SourceId,
                                HabitationId: HabitationId,
                                SourceTypeId: SourceTypeId,
                                SourceTypeCategoryId: SourceTypeCategoryId,
                                villagename: villagename,
                                latitute: _currentPosition?.latitude,
                                longitute: _currentPosition?.longitude,
                                districtname: districtname,
                                blockname: blockname,
                                sourcetype: sourcetypelocal,
                                panchayatname: panchayatname);

                            Navigator.of(context).pop(false);
                          },
                          child: const Text('Ok',
                              style: TextStyle(color: Appcolor.white)),
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
                    " Are you sure you want to remove it?",
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
                  Navigator.of(context).pop();

                  await databaseHelperJalJeevan!.clearRowById(id);

                  Stylefile.showmessageforvalidationtrue(context, "Deleted");
                  setState(() {
                    localpwspendingDataList.removeAt(index);
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _SIBshowAlertDialogforuntaggeoloc(id, int index) async {
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
                    " Are you sure you want to remove it?",
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
                  Navigator.of(context).pop();
                  /*await   databaseHelperJalJeevan!.removeDataByIndex(index);*/
                  await databaseHelperJalJeevan!.SIBclearRowById(id);
                  Stylefile.showmessageforvalidationtrue(context, "Deleted");
                  setState(() {
                    localsibpendinglist.removeAt(index);
                  });
                },
              ),
            ),
          ],
        );
      },
    );
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
                        context, "The record has been saved successfully.");
                  },
                  child: const Text('OK',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Appcolor.black))),
            ),
          ],
        );
      },
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

  Future<void> _showalertboxforaddnewsource(String? countofrecord) async {
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
                    "Source(s) already exist in this selected scheme. Do you want to add more new source?",
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
                  Get.to(AddNewSourceScreen(
                      Sourceid_typesend :  Sourceid_type,
                      source_typeCategorysend:      source_typeCategory,
                      SourceTypeCategoryIdsend:SourceTypeCategoryId,
                      selectscheme: selectschamename,
                      selecthabitation: selecthabitation_addnewsourcebtn,
                      selectlocationlanmark:
                          selectlocationlanmark_addnewsourcebtn,
                      villageid: widget.villageid,
                      assettaggingid: getclickedstatus.toString(),
                      StateId: StateId_addnewsourcebtn,
                      schemeid: _mySchemeid,
                      //SourceId: Sourceid_new,
                      SourceId: "0",
                      HabitationId: HabitationId_addnewsourcebtn,
                      SourceTypeId: SourceTypeId_addnewsourcebtn,
                      SourceTypeCategoryId:
                          SourceTypeCategoryId_addnewsourcebtn,
                      villagename: getvillagename,
                      latitute: latitute_addnewsourcebtn,
                      longitute: longitute_addnewsourcebtn,
                      districtname: districtname,
                      blockname: blockname,
                      sourcetype: sourcetype,
                      panchayatname: panchayatname));
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showalertboxforaddinformationboards() async {
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
                    "Information board already exist in selected scheme. Do you want to add more other information board?",
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
                  _mySchemeid.toString() == "-- Select id  --"
                      ? Fluttertoast.showToast(
                          msg: "Please select scheme",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0)
                      : setState(() {
                          btnstateicon = false;
                          samesourcesib = "2";

                          isGetGeoLocatonlatlong = true;
                          Takephotovisibility = false;
                          ESR_Selectalreadytaggedsource = false;
                          selectschemesource = false;
                          selectschemesourcemessage_mvc = false;
                          SelectalreadytaggedsourceSIB = true;
                          messagevisibility = false;
                          geotaggedonlydropdown = false;
                          Getgeolocation_SIB = true;
                          viewVisible = true;
                          offlinesiblistvosibleornot = true;
                        });

                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
