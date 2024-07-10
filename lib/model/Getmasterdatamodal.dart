import 'dart:convert';

Getmasterdatamodal getmasterdatamodalFromJson(String str) =>
    Getmasterdatamodal.fromJson(json.decode(str));

String getmasterdatamodalToJson(Getmasterdatamodal data) =>
    json.encode(data.toJson());

class Getmasterdatamodal {
  List<Villagelist?>? villagelist;
  List<VillageDetail?>? villageDetails;
  List<Schmelist?>? schmelist;
  List<Sourcelist?>? sourcelist;
  List<Habitationlist?>? habitationlist;
  List<InformationBoardList?>? informationBoardList;
  var API_DateTime;

  Getmasterdatamodal({
    this.villagelist,
    this.villageDetails,
    this.schmelist,
    this.sourcelist,
    this.habitationlist,
    this.informationBoardList,
    this.API_DateTime,
  });

  factory Getmasterdatamodal.fromJson(Map<String, dynamic> json) =>
      Getmasterdatamodal(
        villagelist: (json["Villagelist"] as List<dynamic>?)
            ?.map((x) => Villagelist.fromJson(x))
            .toList(),
        villageDetails: (json["VillageDetails"] as List<dynamic>?)
            ?.map((x) => VillageDetail.fromJson(x))
            .toList(),
        schmelist: (json["Schmelist"] as List<dynamic>?)
            ?.map((x) => Schmelist.fromJson(x))
            .toList(),
        sourcelist: (json["Sourcelist"] as List<dynamic>?)
            ?.map((x) => Sourcelist.fromJson(x))
            .toList(),
        habitationlist: (json["Habitationlist"] as List<dynamic>?)
            ?.map((x) => Habitationlist.fromJson(x))
            .toList(),
        informationBoardList: (json["InformationBoardList"] as List<dynamic>?)
            ?.map((x) => InformationBoardList.fromJson(x))
            .toList(),
        API_DateTime: json["API_DateTime"],
      );

  Map<String, dynamic> toJson() => {
    "Villagelist": List<dynamic>.from(
        (villagelist ?? []).map((x) => x?.toJson() ?? {})),
    "VillageDetails": List<dynamic>.from(
        (villageDetails ?? []).map((x) => x?.toJson() ?? {})),
    "Schmelist":
    List<dynamic>.from((schmelist ?? []).map((x) => x?.toJson() ?? {})),
    "Sourcelist": List<dynamic>.from(
        (sourcelist ?? []).map((x) => x?.toJson() ?? {})),
    "Habitationlist": List<dynamic>.from(
        (habitationlist ?? []).map((x) => x?.toJson() ?? {})),
    "InformationBoardList": List<dynamic>.from(
        (informationBoardList ?? []).map((x) => x?.toJson() ?? {})),
    "API_DateTime": API_DateTime.toString(),
  };
}

class Apidatetime {
  int? userId;
  String? API_DateTime;

  Apidatetime({this.userId, this.API_DateTime});

  factory Apidatetime.fromJson(Map<String, dynamic> json) => Apidatetime(
    userId: json["UserId"],
    API_DateTime: json["API_DateTime"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "API_DateTime": API_DateTime,
  };
}

class Habitationlist {
  int? villageId;
  int? habitationId;
  String? habitationName;

  Habitationlist({
    this.villageId,
    this.habitationId,
    this.habitationName,
  });

  factory Habitationlist.fromJson(Map<String, dynamic> json) => Habitationlist(
    villageId: json["VillageId"],
    habitationId: json["HabitationId"],
    habitationName: json["HabitationName"],
  );

  Map<String, dynamic> toJson() => {
    "VillageId": villageId,
    "HabitationId": habitationId,
    "HabitationName": habitationName,
  };
}

class Schmelist {
  int? source_type;
  int? schemeid;
  int? villageId;
  String? schemename;
  String? category;

  int? SourceTypeCategoryId;
  String? source_typeCategory;

  Schmelist({
    this.source_type,
    this.schemeid,
    this.villageId,
    this.schemename,
    this.category,
    this.SourceTypeCategoryId,
    this.source_typeCategory,
  });

  factory Schmelist.fromJson(Map<String, dynamic> json) => Schmelist(
    source_type: json["source_type"],
    schemeid: json["Schemeid"],
    villageId: json["VillageId"],
    schemename: json["Schemename"],
    category: json["Category"],
    SourceTypeCategoryId: json["SourceTypeCategoryId"],
    source_typeCategory: json["source_typeCategory"],
  );

  Map<String, dynamic> toJson() => {
    "source_type": source_type,
    "Schemeid": schemeid,
    "VillageId": villageId,
    "Schemename": schemename,
    "Category": category,
    "SourceTypeCategoryId": SourceTypeCategoryId,
    "source_typeCategory": source_typeCategory,
  };
}

class Sourcelist {
  int? schemeId;
  String? schemeName;
  int? sourceId;
  int? sourceTypeId;
  int? sourceTypeCategoryId;
  int? habitationId;
  int? existTagWaterSourceId;
  int? isApprovedState;
  dynamic landmark;
  double? latitude;
  double? longitude;
  String? habitationName;
  String? location;
  String? sourceTypeCategory;
  String? sourceType;
  String? stateName;
  String? districtName;
  String? blockName;
  String? panchayatName;
  String? villageName;
  int? stateid;
  int? districtId;
  String? villageId;

  Sourcelist({
    this.schemeId,
    this.schemeName,
    this.sourceId,
    this.sourceTypeId,
    this.sourceTypeCategoryId,
    this.habitationId,
    this.existTagWaterSourceId,
    this.isApprovedState,
    this.landmark,
    this.latitude,
    this.longitude,
    this.habitationName,
    this.location,
    this.sourceTypeCategory,
    this.sourceType,
    this.stateName,
    this.districtName,
    this.blockName,
    this.panchayatName,
    this.villageName,
    this.stateid,
    this.districtId,
    this.villageId,
  });

  factory Sourcelist.fromJson(Map<String, dynamic> json) => Sourcelist(
    schemeId: json["SchemeId"],
    schemeName: json["SchemeName"],
    sourceId: json["SourceId"],
    sourceTypeId: json["SourceTypeId"],
    sourceTypeCategoryId: json["SourceTypeCategoryId"],
    habitationId: json["HabitationId"],
    existTagWaterSourceId: json["ExistTagWaterSourceId"],
    isApprovedState: json["IsApprovedState"],
    landmark: json["landmark"],
    latitude: json["Latitude"]?.toDouble(),
    longitude: json["Longitude"]?.toDouble(),
    habitationName: json["HabitationName"],
    location: json["location"],
    sourceTypeCategory: json["SourceTypeCategory"],
    sourceType: json["SourceType"],
    stateName: json["StateName"],
    districtName: json["DistrictName"],
    blockName: json["BlockName"],
    panchayatName: json["PanchayatName"],
    villageName: json["VillageName"],
    stateid: json["stateid"],
    districtId: json["DistrictId"],
    villageId: json["VillageId"],
  );

  Map<String, dynamic> toJson() => {
    "SchemeId": schemeId,
    "SchemeName": schemeName,
    "SourceId": sourceId,
    "SourceTypeId": sourceTypeId,
    "SourceTypeCategoryId": sourceTypeCategoryId,
    "HabitationId": habitationId,
    "ExistTagWaterSourceId": existTagWaterSourceId,
    "IsApprovedState": isApprovedState,
    "landmark": landmark,
    "Latitude": latitude,
    "Longitude": longitude,
    "HabitationName": habitationName,
    "location": location,
    "SourceTypeCategory": sourceTypeCategory,
    "SourceType": sourceType,
    "StateName": stateName,
    "DistrictName": districtName,
    "BlockName": blockName,
    "PanchayatName": panchayatName,
    "VillageName": villageName,
    "stateid": stateid,
    "DistrictId": districtId,
    "VillageId": villageId,
  };
}

class VillageDetail {
  dynamic message;
  bool? status;
  String? stateName;
  String? districtName;
  String? blockName;
  String? panchayatName;
  int? stateId;
  int? userId;
  int? villageId;
  String? villageName;
  int? totalNoOfScheme;
  int? totalNoOfWaterSource;
  int? totalWsGeoTagged;
  int? pendingWsTotal;
  int? balanceWsTotal;
  int? totalSsGeoTagged;
  int? pendingApprovalSsTotal;
  int? totalIbRequiredGeoTagged;
  int? totalIbGeoTagged;
  int? pendingIbTotal;
  int? balanceIbTotal;
  int? totalOaGeoTagged;
  int? balanceOaTotal;
  int? totalNoOfSchoolScheme;
  int? totalNoOfPwsScheme;

  VillageDetail({
    this.message,
    this.status,
    this.stateName,
    this.districtName,
    this.blockName,
    this.panchayatName,
    this.stateId,
    this.userId,
    this.villageId,
    this.villageName,
    this.totalNoOfScheme,
    this.totalNoOfWaterSource,
    this.totalWsGeoTagged,
    this.pendingWsTotal,
    this.balanceWsTotal,
    this.totalSsGeoTagged,
    this.pendingApprovalSsTotal,
    this.totalIbRequiredGeoTagged,
    this.totalIbGeoTagged,
    this.pendingIbTotal,
    this.balanceIbTotal,
    this.totalOaGeoTagged,
    this.balanceOaTotal,
    this.totalNoOfSchoolScheme,
    this.totalNoOfPwsScheme,
  });

  factory VillageDetail.fromJson(Map<String, dynamic> json) => VillageDetail(
    message: json["Message"],
    status: json["Status"],
    stateName: json["StateName"],
    districtName: json["DistrictName"],
    blockName: json["BlockName"],
    panchayatName: json["PanchayatName"],
    stateId: json["StateId"],
    userId: json["UserId"],
    villageId: json["VillageId"],
    villageName: json["VillageName"],
    totalNoOfScheme: json["TotalNoOfScheme"],
    totalNoOfWaterSource: json["TotalNoOfWaterSource"],
    totalWsGeoTagged: json["TotalWsGeoTagged"],
    pendingWsTotal: json["PendingWsTotal"],
    balanceWsTotal: json["BalanceWsTotal"],
    totalSsGeoTagged: json["TotalSSGeoTagged"],
    pendingApprovalSsTotal: json["PendingApprovalSSTotal"],
    totalIbRequiredGeoTagged: json["TotalIBRequiredGeoTagged"],
    totalIbGeoTagged: json["TotalIBGeoTagged"],
    pendingIbTotal: json["PendingIBTotal"],
    balanceIbTotal: json["BalanceIBTotal"],
    totalOaGeoTagged: json["TotalOAGeoTagged"],
    balanceOaTotal: json["BalanceOATotal"],
    totalNoOfSchoolScheme: json["TotalNoOfSchoolScheme"],
    totalNoOfPwsScheme: json["TotalNoOfPWSScheme"],
  );

  Map<String, dynamic> toJson() => {
    "Message": message,
    "Status": status,
    "StateName": stateName,
    "DistrictName": districtName,
    "BlockName": blockName,
    "PanchayatName": panchayatName,
    "StateId": stateId,
    "UserId": userId,
    "VillageId": villageId,
    "VillageName": villageName,
    "TotalNoOfScheme": totalNoOfScheme,
    "TotalNoOfWaterSource": totalNoOfWaterSource,
    "TotalWsGeoTagged": totalWsGeoTagged,
    "PendingWsTotal": pendingWsTotal,
    "BalanceWsTotal": balanceWsTotal,
    "TotalSSGeoTagged": totalSsGeoTagged,
    "PendingApprovalSSTotal": pendingApprovalSsTotal,
    "TotalIBRequiredGeoTagged": totalIbRequiredGeoTagged,
    "TotalIBGeoTagged": totalIbGeoTagged,
    "PendingIBTotal": pendingIbTotal,
    "BalanceIBTotal": balanceIbTotal,
    "TotalOAGeoTagged": totalOaGeoTagged,
    "BalanceOATotal": balanceOaTotal,
    "TotalNoOfSchoolScheme": totalNoOfSchoolScheme,
    "TotalNoOfPWSScheme": totalNoOfPwsScheme,
  };
}

class Villagelist {
  int? userId;
  int? villageId;
  int? stateId;
  String? VillageName;

  Villagelist({
    this.userId,
    this.villageId,
    this.stateId,
    this.VillageName,
  });

  factory Villagelist.fromJson(Map<String, dynamic> json) => Villagelist(
    userId: json["UserId"],
    villageId: json["VillageId"],
    stateId: json["StateId"],
    VillageName: json["VillageName"],
  );

  Map<String, dynamic> toJson() => {
    "UserId": userId,
    "VillageId": villageId,
    "StateId": stateId,
    "VillageName": VillageName,
  };
}


class InformationBoardList {
  int? userId;
  int? villageId;
  int? stateId;
  int? schemeId;
  String? districtName;
  String? blockName;
  String? panchayatName;
  String? villageName;
  String? habitationName;
  double? latitude;
  double? longitude;
  String? sourceName;
  String? schemeName;
  String? message;
  bool? status;

  InformationBoardList({
    this.userId,
    this.villageId,
    this.stateId,
    this.schemeId,
    this.districtName,
    this.blockName,
    this.panchayatName,
    this.villageName,
    this.habitationName,
    this.latitude,
    this.longitude,
    this.sourceName,
    this.schemeName,
    this.message,
    this.status,
  });

  factory InformationBoardList.fromJson(Map<String, dynamic> json) =>
      InformationBoardList(
        userId: json["UserId"],
        villageId: json["VillageId"],
        stateId: json["StateId"],
        schemeId: json["schemeId"],
        districtName: json["DistrictName"],
        blockName: json["BlockName"],
        panchayatName: json["PanchayatName"],
        villageName: json["VillageName"],
        habitationName: json["HabitationName"],
        latitude: json["Latitude"]?.toDouble(),
        longitude: json["Longitude"]?.toDouble(),
        sourceName: json["SourceName"],
        schemeName: json["SchemeName"],
        message: json["Message"],
        status: json["Status"],
      );

  Map<String, dynamic> toJson() => {
    "UserId": userId,
    "VillageId": villageId,
    "StateId": stateId,
    "schemeId": schemeId,
    "DistrictName": districtName,
    "BlockName": blockName,
    "PanchayatName": panchayatName,
    "VillageName": villageName,
    "HabitationName": habitationName,
    "Latitude": latitude,
    "Longitude": longitude,
    "SourceName": sourceName,
    "SchemeName": schemeName,
    "Message": message,
    "Status": status,
  };
}