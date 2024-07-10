import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaljeevanmissiondynamic/database/DataBaseHelperJalJeevan.dart';
import 'package:jaljeevanmissiondynamic/model/Villagelistmodal.dart';
import 'package:jaljeevanmissiondynamic/view/LoginScreen.dart';
import '../model/GetSourceCategoryModal.dart';
import '../model/Getmasterdatamodal.dart';

class Apiservice {
     // static String baseurl = "http://10.22.3.161:8086/api/";
    static String baseurl = "https://ejalshakti.gov.in/krcpwa/api/";


  static GetStorage box = GetStorage();
  late DatabaseHelperJalJeevan databaseHelperJalJeevan;

  static Future Loginapi(
    BuildContext context,
    String userid,
    String password,
    String randomsalt,
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
    var response = await http.post(
      Uri.parse('${baseurl}' + "JJM_Mobile/Login"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        "LoginId": userid,
        "Password": password,
        "txtSaltedHash": randomsalt
      }),
    );
    Get.back();

    if (response.statusCode == 200) {
    }
    return jsonDecode(response.body);
  }


  static Future PWSSourceSavetaggingapi(
    BuildContext context,
    String token,
    String UserId,
    String VillageId,
    String AssetTagging,
    String StateId,
    String SchemeId,
    String SourceId,
    String DivisionId,
    String HabitationId,
    String SourceTypeId,
    String SourceCategoryId,
    String Landmark,
    String Latitude,
    String Longitude,
    String Accuracy,
    String Photo,
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

    var response = await http.post(
      Uri.parse('${baseurl}' + "JJM_Mobile/SaveTagWaterSource"),
      headers: {
        'Content-Type': 'application/json',
        'APIKey': token ?? 'DEFAULT_API_KEY'
      },
      body: jsonEncode({
        "UserId": box.read("userid"),
        "VillageId": VillageId,
        "AssetTagging": AssetTagging,
        "StateId": StateId,
        "SchemeId": SchemeId,
        "SourceId": SourceId,
        "DivisionId": DivisionId,
        "HabitationId": HabitationId,
        "SourceTypeId": SourceTypeId,
        "SourceCategoryId": SourceCategoryId,
        "Landmark": Landmark,
        "Latitude": Latitude,
        "Longitude": Longitude,
        "Accuracy": Accuracy,
        "Photo": Photo
      }),
    );
    Get.back();
    if (response.statusCode == 200) {
      var responsede = response.body;
    } else {
      var responsede = response.body;
    }
    return jsonDecode(response.body);
  }

  static Future<Getmasterdatamodal> Getmasterapi(BuildContext context) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception("No internet connection available");
      }

      var uri = Uri.parse("${Apiservice.baseurl}JJM_Mobile/Get_MasterData?&StateId=" + box.read("stateid") + "&UserId=" + box.read("userid"));

      var response = await http.get(uri).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        Map<String, dynamic> mResposne = jsonDecode(response.body);
        var appvaersion = mResposne["APKVersion"];
        var appDownloadSize = mResposne["DownloadSize"];
        var appAPKVersionMessage = mResposne["APKVersionMessage"];
        var appAPKURL = mResposne["APKURL"];

        box.write("appvaersion", appvaersion);
        box.write("appDownloadSize", appDownloadSize);
        box.write("appAPKVersionMessage", appAPKVersionMessage);
        box.write("appAPKURL", appAPKURL);

        return Getmasterdatamodal.fromJson(jsonDecode(response.body));
      } else {
        Map<String, dynamic> mResposne = jsonDecode(response.body);
        throw Exception("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }

  static Future SIBSavetaggingapi(
    BuildContext context,
    String token,
    String UserId,
    String VillageId,
    String CapturePointTypeId,
    String StateId,
    String SchemeId,
    String SourceId,
    String DivisionId,
    String HabitationId,
    String Landmark,
    String Latitude,
    String Longitude,
    String Accuracy,
    String Photo,
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
    var response = await http.post(
      Uri.parse('${baseurl}' + "JJM_Mobile/SaveInformationBoard"),
      headers: {
        'Content-Type': 'application/json',
        'APIKey': token ?? 'DEFAULT_API_KEY'
      },
      body: jsonEncode({
        "UserId": box.read("userid"),
        "VillageId": VillageId,
        "CapturePointTypeId": CapturePointTypeId,
        "StateId": StateId,
        "SchemeId": SchemeId,
        "SourceId": SourceId,
        "DivisionId": DivisionId,
        "HabitationId": HabitationId,
        "Landmark": Landmark,
        "Latitude": Latitude,
        "Longitude": Longitude,
        "Accuracy": Accuracy,
        "Photo": Photo
      }),
    );
    Get.back();
    if (response.statusCode == 200) {
      var responsede = response.body;
    }
    return jsonDecode(response.body);
  }

  static Future OtherassetSavetaggingapi(
    BuildContext context,
    String token,
    String UserId,
    String VillageId,
    String StateId,
    String SchemeId,
    String SourceId,
    String DivisionId,
    String HabitationId,
    String Landmark,
    String Latitude,
    String Longitude,
    String Accuracy,
    String Photo,
    String assetOtherCategory,
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

    var response = await http.post(
      Uri.parse('${baseurl}' + "JJM_Mobile/SaveTagWater_Others"),
      headers: {
        'Content-Type': 'application/json',
        'APIKey': token ?? 'DEFAULT_API_KEY'
      },
      body: jsonEncode({
        "UserId": box.read("userid"),
        "VillageId": VillageId,
        "StateId": StateId,
        "SchemeId": SchemeId,
        "SourceId": SourceId,
        "DivisionId": DivisionId,
        "HabitationId": HabitationId,
        "Landmark": Landmark,
        "Latitude": Latitude,
        "Longitude": Longitude,
        "Accuracy": Accuracy,
        "Photo": Photo,
        "AssetOtherCategory": assetOtherCategory
      }),
    );
    Get.back();
    if (response.statusCode == 200) {
    } else {
    }
    return jsonDecode(response.body);
  }

  static Future StoragestructureSavetaggingapi(
    BuildContext context,
    String token,
    String UserId,
    String VillageId,
    String StateId,
    String SchemeId,
    String SourceId,
    String DivisionId,
    String HabitationId,
    String Landmark,
    String Latitude,
    String Longitude,
    String Accuracy,
    String Photo,
    String capacityInltr,
    String storageStructureType,
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
    var response = await http.post(
      Uri.parse('${baseurl}' + "JJM_Mobile/SaveTagWater_StorageStructure"),
      headers: {
        'Content-Type': 'application/json',
        'APIKey': token ?? 'DEFAULT_API_KEY'
      },
      body: jsonEncode({
        "UserId": box.read("userid"),
        "VillageId": VillageId,
        "StateId": StateId,
        "SchemeId": SchemeId,
        "SourceId": SourceId,
        "DivisionId": DivisionId,
        "HabitationId": HabitationId,
        "Landmark": Landmark,
        "Latitude": Latitude,
        "Longitude": Longitude,
        "Accuracy": Accuracy,
        "Photo": Photo,
        "CapacityInltr": capacityInltr,
        "StorageStructureType": storageStructureType
      }),
    );
    Get.back();
    if (response.statusCode == 200) {
      var responsede = response.body;
    } else {
      var responsede = response.body;
    }
    return jsonDecode(response.body);
  }

  static Future SaveOfflinevilaagesApi(
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

    var response = await http.post(
      Uri.parse('${baseurl}' + "JJM_Mobile/SaveOfflineVillage"),
      headers: {
        'Content-Type': 'application/json',
        'APIKey': token ?? 'DEFAULT_API_KEY'
      },
      body: jsonEncode({
        "UserId": box.read("userid"),
        "VillageList": Villagelist,
        "StateId": StateId,
      }),
    );
    Get.back();
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<void> cleartable_localmasterschemelisttable() async {
    await databaseHelperJalJeevan?.cleardb_localmasterschemelist();
    await databaseHelperJalJeevan!.cleartable_villagelist();
    await databaseHelperJalJeevan!.cleartable_villagedetails();
    await databaseHelperJalJeevan!.cleardb_localhabitaionlisttable();
    await databaseHelperJalJeevan!.cleardb_sourcedetailstable();
    await databaseHelperJalJeevan!.cleardb_sibmasterlist();
  }

  static Future<GetSourceCategoryModal> Getmastersourcecategoryapi() async {
    try {
      var uri = Uri.parse('${baseurl}Master/GetSourceCategorylist?UserId=' +
          box.read("userid"));
      var response = await http
          .get(uri)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        Map<String, dynamic> mResposne = jsonDecode(response.body);
        return GetSourceCategoryModal.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Timeout or network error occurred');
    }
  }

  static Future getuserprofile(
    BuildContext context,
    String userid,
    String stateid,
    String token,
  ) async {
    var response = await http.post(
      Uri.parse('${baseurl}' + "JJM_Mobile/User_profile"),
      headers: {
        'Content-Type': 'application/json',
        'APIKey': token ?? 'DEFAULT_API_KEY'
      },
      body: jsonEncode({
        "Userid": userid,
        "StateId": stateid,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<void> fetchData(
    BuildContext context,
    String userid,
    String stateid,
    String villageid,
    String token,
  ) async {
    final String baseUrl =
        'https://ejalshakti.gov.in/krcpwa/api/JJM_Mobile/GetSourceScheme';
    final Map<String, dynamic> queryParams = {
      'UserId': userid,
      'StateId': stateid,
      'villageid': villageid,
    };
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    try {
      final http.Response response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'APIKey': token ?? 'DEFAULT_API_KEY'
        },
      );
      if (response.statusCode == 200) {
      } else {}
    } catch (e) {}
  }

  static Future PWSPendingapprovalAPI(String villageid, String stateid,
      String userid, String token, String status) async {
    var response = await http.get(
      Uri.parse("${baseurl}JJM_Mobile/GetGeotaggedWaterSource?VillageId=" +
          villageid +
          "&StateId=" +
          stateid +
          "&UserId=" +
          userid +
          "&Status=" +
          status),
      headers: {
        'Content-Type': 'application/json',
        'APIKey': token ?? 'DEFAULT_API_KEY'
      },
    );

    if (response.statusCode == 200) {}
  }

  static Future getvillagelistapi(
      String userid, String stateid, String token) async {
    List<Villagelistmodal> list = [];

    try {
      var response = await http.get(
        Uri.parse('${baseurl}' +
            "JJM_Mobile/GetAssignedVillages?StateId=" +
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
        List<dynamic> ListResponse = mapResponse['Villagelist_Datas'];
      } else {
        var mapResponse = jsonDecode(response.body);

        var status = mapResponse['Status'];
        if (status == "false") {
          Get.off(LoginScreen());
        }
      }
      return jsonDecode(response.body);
    } catch (e) {
      return list;
    }
  }

  static Future getvillagedetailsApi(BuildContext context, String villageid,
      String stateid, String userid, String token) async {
    try {
      var response = await http.get(
        Uri.parse('${baseurl}' +
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
        return mapResponse;
      }
    } catch (e) {}
  }

  static Future pandingfor_getpwssource(String villageid, String stateid,
      String userid, String token, String Status) async {
    try {
      var response = await http.get(
        Uri.parse('${baseurl}' +
            "JJM_Mobile/GetGeotaggedWaterSource?VillageId=" +
            villageid +
            "&StateId=" +
            stateid +
            "&UserId=" +
            userid +
            "&Status=" +
            Status),
        headers: {
          'Content-Type': 'application/json',
          'APIKey': token ?? 'DEFAULT_API_KEY'
        },
      );
      if (response.statusCode == 200) {
        var mapResponse = jsonDecode(response.body);
        return mapResponse;
      } else {}
      return jsonDecode(response.body);
    } catch (e) {}
  }

    static Future OTPVerificationapi(
        BuildContext context,

        )
    async {
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
                    //child: Lottie.asset('images/loadereverification.json'),)
                    child: CircularProgressIndicator()),
              ],
            );
          });
      var response = await http.post(
        Uri.parse("${baseurl}JJM_Mobile/Login"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          /*   "LoginId": userid,
        "Password": password,
        "txtSaltedHash": randomsalt*/
        }),
      );
      Get.back();

      if (response.statusCode == 200) {
      }
      return jsonDecode(response.body);
    }
    static Future OTPResendapi(
        BuildContext context,

        )
    async {
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
                    //child: Lottie.asset('images/loadereverification.json'),)
                    child: CircularProgressIndicator()),
              ],
            );
          });
      var response = await http.post(
        Uri.parse("${baseurl}JJM_Mobile/Login"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          /*   "LoginId": userid,
        "Password": password,
        "txtSaltedHash": randomsalt*/
        }),
      );
      Get.back();

      if (response.statusCode == 200) {
      }
      return jsonDecode(response.body);
    }
}
