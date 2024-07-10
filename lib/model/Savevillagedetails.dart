
import 'dart:convert';

Savevillagedetails savevillagedetailsFromJson(String str) => Savevillagedetails.fromJson(json.decode(str));

String savevillagedetailsToJson(Savevillagedetails data) => json.encode(data.toJson());

class Savevillagedetails {
  final dynamic message;
  final bool? status;
  final String? stateName;
  final String? districtName;
  final String? blockName;
  final String? panchayatName;
  final int? stateId;
  final int? userId;
  final int? villageId;
  final String? villageName;
  final int? totalNoOfScheme;
  final int? totalNoOfWaterSource;
  final int? totalWsGeoTagged;
  final int? pendingWsTotal;
  final int? balanceWsTotal;
  final int? totalSsGeoTagged;
  final int? pendingApprovalSsTotal;
  final int? totalIbRequiredGeoTagged;
  final int? totalIbGeoTagged;
  final int? pendingIbTotal;
  final int? balanceIbTotal;
  final int? totalOaGeoTagged;
  final int? balanceOaTotal;
  final int? totalNoOfSchoolScheme;
  final int? totalNoOfPwsScheme;

  Savevillagedetails({
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

  factory Savevillagedetails.fromJson(Map<String, dynamic> json) => Savevillagedetails(
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
