import 'dart:convert';

PwsPendingapprovalmodal pwsPendingapprovalmodalFromJson(String str) => PwsPendingapprovalmodal.fromJson(json.decode(str));

String pwsPendingapprovalmodalToJson(PwsPendingapprovalmodal data) => json.encode(data.toJson());

class PwsPendingapprovalmodal {
  bool? status;
  String? message;
  String? district;
  String? block;
  String? panchayat;
  String? headingMessage;
  List<Result>? result;

  PwsPendingapprovalmodal({
    this.status,
    this.message,
    this.district,
    this.block,
    this.panchayat,
    this.headingMessage,
    this.result,
  });

  factory PwsPendingapprovalmodal.fromJson(Map<String, dynamic> json) => PwsPendingapprovalmodal(
    status: json["Status"],
    message: json["Message"],
    district: json["District"],
    block: json["Block"],
    panchayat: json["Panchayat"],
    headingMessage: json["HeadingMessage"],
    result: List<Result>.from(json["Result"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Message": message,
    "District": district,
    "Block": block,
    "Panchayat": panchayat,
    "HeadingMessage": headingMessage,
    "Result": List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class Result {
  int? taggedId;
  String? schemeName;
  String? imageUrl;
  int? stateId;
  int? villageId;
  String? districtName;
  String? blockName;
  String? panchayatName;
  String? villageName;
  String? sourceName;
  String? sourceCatogery;
  String? sourcetype;
  String? latitude;
  String? longitude;
  int? photoStatus;
  int? capicityInltr;
  dynamic storageStructureType;
  dynamic otherCategory;
  String? habitationName;
  int? isApprovedDivisionBy;
  int? isApprovedStateBy;
  int? status;
  String? message;

  Result({
    this.taggedId,
    this.schemeName,
    this.imageUrl,
    this.stateId,
    this.villageId,
    this.districtName,
    this.blockName,
    this.panchayatName,
    this.villageName,
    this.sourceName,
    this.sourceCatogery,
    this.sourcetype,
    this.latitude,
    this.longitude,
    this.photoStatus,
    this.capicityInltr,
    this.storageStructureType,
    this.otherCategory,
    this.habitationName,
    this.isApprovedDivisionBy,
    this.isApprovedStateBy,
    this.status,
    this.message,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    taggedId: json["TaggedId"],
    schemeName: json["SchemeName"],
    imageUrl: json["ImageURL"],
    stateId: json["StateId"],
    villageId: json["VillageId"],
    districtName: json["DistrictName"],
    blockName: json["BlockName"],
    panchayatName: json["PanchayatName"],
    villageName: json["VillageName"],
    sourceName: json["SourceName"],
    sourceCatogery: json["SourceCatogery"],
    sourcetype: json["sourcetype"],
    latitude: json["Latitude"],
    longitude: json["Longitude"],
    photoStatus: json["PhotoStatus"],
    capicityInltr: json["CapicityInltr"],
    storageStructureType: json["StorageStructureType"],
    otherCategory: json["OtherCategory"],
    habitationName: json["HabitationName"],
    isApprovedDivisionBy: json["IsApprovedDivisionBy"],
    isApprovedStateBy: json["IsApprovedStateBy"],
    status: json["Status"],
    message: json["Message"],
  );

  Map<String, dynamic> toJson() => {
    "TaggedId": taggedId,
    "SchemeName": schemeName,
    "ImageURL": imageUrl,
    "StateId": stateId,
    "VillageId": villageId,
    "DistrictName": districtName,
    "BlockName": blockName,
    "PanchayatName": panchayatName,
    "VillageName": villageName,
    "SourceName": sourceName,
    "SourceCatogery": sourceCatogery,
    "sourcetype": sourcetype,
    "Latitude": latitude,
    "Longitude": longitude,
    "PhotoStatus": photoStatus,
    "CapicityInltr": capicityInltr,
    "StorageStructureType": storageStructureType,
    "OtherCategory": otherCategory,
    "HabitationName": habitationName,
    "IsApprovedDivisionBy": isApprovedDivisionBy,
    "IsApprovedStateBy": isApprovedStateBy,
    "Status": status,
    "Message": message,
  };
}
