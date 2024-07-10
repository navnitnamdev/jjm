import 'dart:convert';

SibGeotagmodal sibGeotagmodalFromJson(String str) =>
    SibGeotagmodal.fromJson(json.decode(str));

String sibGeotagmodalToJson(SibGeotagmodal data) => json.encode(data.toJson());

class SibGeotagmodal {
  final bool? status;
  final String? message;
  final String? district;
  final String? block;
  final String? panchayat;
  final String? headingMessage;
  final List<Result>? result;

  SibGeotagmodal({
    this.status,
    this.message,
    this.district,
    this.block,
    this.panchayat,
    this.headingMessage,
    this.result,
  });

  factory SibGeotagmodal.fromJson(Map<String, dynamic> json) => SibGeotagmodal(
    status: json["Status"],
    message: json["Message"],
    district: json["District"],
    block: json["Block"],
    panchayat: json["Panchayat"],
    headingMessage: json["HeadingMessage"],
    result: json["Result"] != null
        ? List<Result>.from(json["Result"].map((x) => Result.fromJson(x)))
        : null,
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Message": message,
    "District": district,
    "Block": block,
    "Panchayat": panchayat,
    "HeadingMessage": headingMessage,
    "Result": result != null
        ? List<dynamic>.from(result!.map((x) => x.toJson()))
        : null,
  };
}

class Result {
  final int? taggedId;
  final String? schemeName;
  final String? imageUrl;
  final int? stateId;
  final int? villageId;
  final String? districtName;
  final String? blockName;
  final String? panchayatName;
  final String? villageName;
  final String? sourceName;
  final dynamic sourceCatogery;
  final dynamic sourcetype;
  final String? latitude;
  final String? longitude;
  final int? photoStatus;
  final int? capicityInltr;
  final dynamic storageStructureType;
  final dynamic otherCategory;
  final String? habitationName;
  final int? isApprovedDivisionBy;
  final int? isApprovedStateBy;
  final int? status;
  final String? message;

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
