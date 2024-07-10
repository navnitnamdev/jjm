import 'dart:convert';

Villagelistmodal villagelistmodalFromJson(String str) =>
    Villagelistmodal.fromJson(json.decode(str));

String villagelistmodalToJson(Villagelistmodal data) =>
    json.encode(data.toJson());

class Villagelistmodal {
  bool status;
  String message;
  List<VillagelistData> villagelistDatas;

  Villagelistmodal({
    required this.status,
    required this.message,
    required this.villagelistDatas,
  });

  factory Villagelistmodal.fromJson(Map<String, dynamic> json) =>
      Villagelistmodal(
        status: json["Status"],
        message: json["Message"],
        villagelistDatas: List<VillagelistData>.from(
            json["Villagelist_Datas"].map((x) => VillagelistData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Villagelist_Datas":
            List<dynamic>.from(villagelistDatas.map((x) => x.toJson())),
      };
}

class VillagelistData {
  int villageId;
  String villageName;
  int offlineStatus;

  VillagelistData({
    required this.villageId,
    required this.villageName,
    required this.offlineStatus,
  });

  factory VillagelistData.fromJson(Map<String, dynamic> json) =>
      VillagelistData(
        villageId: json["VillageId"],
        villageName: json["VillageName"],
        offlineStatus: json["OfflineStatus"],
      );

  Map<String, dynamic> toJson() => {
        "VillageId": villageId,
        "VillageName": villageName,
        "OfflineStatus": offlineStatus,
      };
}
