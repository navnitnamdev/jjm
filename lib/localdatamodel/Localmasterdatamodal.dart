class Localmasterdatanodal {
  final String? UserId;
  final String? villageId;
  final String? StateId;
  final String? villageName;

  Localmasterdatanodal(
      {this.UserId, this.villageId, this.StateId, this.villageName});

  Map<String, dynamic> toMap() {
    return {
      'UserId': UserId.toString(),
      'villageId': villageId.toString(),
      'StateId': StateId.toString(),
      'villageName': villageName.toString(),
    };
  }

  factory Localmasterdatanodal.fromMap(Map<String, dynamic> map) {
    return Localmasterdatanodal(
      UserId: map['UserId'],
      villageId: map['villageId'],
      StateId: map['StateId'],
      villageName: map['villageName'],
    );
  }
}

class Localmasterdatamodal_VillageDetails {
  final String? status;
  String? stateName;
  String? districtName;
  String? blockName;
  String? panchayatName;
  String? stateId;
  String? userId;
  String? villageId;

  String? villageName;
  String? totalNoOfScheme;
  String? totalNoOfWaterSource;
  String? totalWsGeoTagged;
  String? pendingWsTotal;
  String? balanceWsTotal;
  String? totalSsGeoTagged;
  String? pendingApprovalSsTotal;
  String? totalIbRequiredGeoTagged;
  String? totalIbGeoTagged;
  String? pendingIbTotal;
  String? balanceIbTotal;
  String? totalOaGeoTagged;
  String? balanceOaTotal;
  String? totalNoOfSchoolScheme;
  String? totalNoOfPwsScheme;

  Localmasterdatamodal_VillageDetails({
    required this.status,
    required this.stateName,
    required this.districtName,
    required this.blockName,
    required this.panchayatName,
    required this.stateId,
    required this.userId,
    required this.villageId,
    required this.villageName,
    required this.totalNoOfScheme,
    required this.totalNoOfWaterSource,
    required this.totalWsGeoTagged,
    required this.pendingWsTotal,
    required this.balanceWsTotal,
    required this.totalSsGeoTagged,
    required this.pendingApprovalSsTotal,
    required this.totalIbRequiredGeoTagged,
    required this.totalIbGeoTagged,
    required this.pendingIbTotal,
    required this.balanceIbTotal,
    required this.totalOaGeoTagged,
    required this.balanceOaTotal,
    required this.totalNoOfSchoolScheme,
    required this.totalNoOfPwsScheme,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status != null ? 1 : 0,
      'stateName': stateName,
      'districtName': districtName,
      'blockName': blockName,
      'panchayatName': panchayatName,
      'stateId': stateId,
      'userId': userId,
      'villageId': villageId,
      'villageName': villageName,
      'totalNoOfScheme': totalNoOfScheme,
      'totalNoOfWaterSource': totalNoOfWaterSource,
      'totalWsGeoTagged': totalWsGeoTagged,
      'pendingWsTotal': pendingWsTotal,
      'balanceWsTotal': balanceWsTotal,
      'totalSsGeoTagged': totalSsGeoTagged,
      'pendingApprovalSsTotal': pendingApprovalSsTotal,
      'totalIbRequiredGeoTagged': totalIbRequiredGeoTagged,
      'totalIbGeoTagged': totalIbGeoTagged,
      'pendingIbTotal': pendingIbTotal,
      'balanceIbTotal': balanceIbTotal,
      'totalOaGeoTagged': totalOaGeoTagged,
      'balanceOaTotal': balanceOaTotal,
      'totalNoOfSchoolScheme': totalNoOfSchoolScheme,
      'totalNoOfPwsScheme': totalNoOfPwsScheme,
    };
  }

  factory Localmasterdatamodal_VillageDetails.fromJson(
      Map<String, dynamic> json) {
    return Localmasterdatamodal_VillageDetails(
      status: json['status'] ?? '',
      stateName: json['stateName'] ?? '',
      districtName: json['districtName'] ?? '',
      blockName: json['blockName'] ?? '',
      panchayatName: json['panchayatName'] ?? '',
      stateId: json['stateId'] ?? '0',
      userId: json['userId'] ?? '0',
      villageId: json['villageId'] ?? '0',
      villageName: json['villageName'] ?? '',
      totalNoOfScheme: json['totalNoOfScheme'] ?? '0',
      totalNoOfWaterSource: json['totalNoOfWaterSource'] ?? '0',
      totalWsGeoTagged: json['totalWsGeoTagged'] ?? '0',
      pendingWsTotal: json['pendingWsTotal'] ?? '0',
      balanceWsTotal: json['balanceWsTotal'] ?? '0',
      totalSsGeoTagged: json['totalSsGeoTagged'] ?? '0',
      pendingApprovalSsTotal: json['pendingApprovalSsTotal'] ?? '0',
      totalIbRequiredGeoTagged: json['totalIbRequiredGeoTagged'] ?? '0',
      totalIbGeoTagged: json['totalIbGeoTagged'] ?? '0',
      pendingIbTotal: json['pendingIbTotal'] ?? '0',
      balanceIbTotal: json['balanceIbTotal'] ?? '0',
      totalOaGeoTagged: json['totalOaGeoTagged'] ?? '0',
      balanceOaTotal: json['balanceOaTotal'] ?? '0',
      totalNoOfSchoolScheme: json['totalNoOfSchoolScheme'] ?? ' 0',
      totalNoOfPwsScheme: json['totalNoOfPWSScheme'] ?? '0',
    );
  }
}

class Localmasterdatamoda_Scheme {
  String? source_type;
  String? schemeid;
  String? villageId;
  String? schemename;
  String? category;
  String? SourceTypeCategoryId;
  String? source_typeCategory;


  Localmasterdatamoda_Scheme(
      {required this.source_type,
      required this.schemeid,
      required this.schemename,
      required this.villageId,
      required this.category,
      required this.SourceTypeCategoryId,
      required this.source_typeCategory


      });



  Map<String, dynamic> toMap() {
    return {
      'source_type': source_type,
      'schemeid': schemeid,
      'villageId': villageId,
      'schemename': schemename,
      'category': category,
      'SourceTypeCategoryId': SourceTypeCategoryId,
      'source_typeCategory': source_typeCategory,
    };
  }

  factory Localmasterdatamoda_Scheme.fromJson(Map<String, dynamic> json) {
    return Localmasterdatamoda_Scheme(
    source_type: json['source_type'],
      schemeid: json['schemeid'],
      villageId: json['villageId'],
      schemename: json['schemename'],
      category: json['category'],
      SourceTypeCategoryId: json['SourceTypeCategoryId'],
      source_typeCategory: json['source_typeCategory'],
    );
  }
}

class LocalSourcelistdetailsModal {
  final String? schemeId;
  final String? schemeName;
  final String? sourceId;
  final String? sourceTypeId;
  final String? sourceTypeCategoryId;
  final String? habitationId;
  final String? existTagWaterSourceId;
  final String? isApprovedState;
  final String? landmark;
  final String? latitude;
  final String? longitude;
  final String? habitationName;
  final String? location;
  final String? sourceTypeCategory;
  final String? sourceType;
  final String? stateName;
  final String? districtName;
  final String? blockName;
  final String? panchayatName;
  final String? villageName;
  final String? stateId;
  final String? districtId;
  final String? villageId;

  LocalSourcelistdetailsModal({
    required this.schemeId,
    required this.schemeName,
    required this.sourceId,
    required this.sourceTypeId,
    required this.sourceTypeCategoryId,
    required this.habitationId,
    required this.existTagWaterSourceId,
    required this.isApprovedState,
    this.landmark,
    required this.latitude,
    required this.longitude,
    required this.habitationName,
    required this.location,
    required this.sourceTypeCategory,
    required this.sourceType,
    required this.stateName,
    required this.districtName,
    required this.blockName,
    required this.panchayatName,
    required this.villageName,
    required this.stateId,
    required this.districtId,
    required this.villageId,
  });

  Map<String, dynamic> toMap() {
    return {
      'schemeId': schemeId,
      'schemeName': schemeName,
      'sourceId': sourceId,
      'sourceTypeId': sourceTypeId,
      'sourceTypeCategoryId': sourceTypeCategoryId,
      'habitationId': habitationId,
      'existTagWaterSourceId': existTagWaterSourceId,
      'isApprovedState': isApprovedState,
      'landmark': landmark,
      'latitude': latitude,
      'longitude': longitude,
      'habitationName': habitationName,
      'location': location,
      'sourceTypeCategory': sourceTypeCategory,
      'sourceType': sourceType,
      'stateName': stateName,
      'districtName': districtName,
      'blockName': blockName,
      'panchayatName': panchayatName,
      'villageName': villageName,
      'stateId': stateId,
      'districtId': districtId,
      'villageId': villageId,
    };
  }

  factory LocalSourcelistdetailsModal.fromJson(Map<String, dynamic> json) {
    return LocalSourcelistdetailsModal(
      schemeId: json['SchemeId'],
      schemeName: json['SchemeName'],
      sourceId: json['SourceId'],
      sourceTypeId: json['SourceTypeId'],
      sourceTypeCategoryId: json['SourceTypeCategoryId'],
      habitationId: json['HabitationId'],
      existTagWaterSourceId: json['ExistTagWaterSourceId'],
      isApprovedState: json['IsApprovedState'],
      landmark: json['landmark'] as String? ?? "",
      latitude: json['Latitude'] as String?,
      longitude: json['Longitude'] as String?,
      habitationName: json['HabitationName'] as String? ?? "",
      location: json['location'] as String? ?? "",
      sourceTypeCategory: json['SourceTypeCategory'] as String? ?? "",
      sourceType: json['SourceType'],
      stateName: json['StateName'],
      districtName: json['DistrictName'],
      blockName: json['BlockName'],
      panchayatName: json['PanchayatName'],
      villageName: json['VillageName'],
      stateId: json['stateid'],
      districtId: json['DistrictId'],
      villageId: (json['VillageId']),
    );
  }
}

class LocalHabitaionlistModal {
  String? villageId;
  String? HabitationId;
  String? HabitationName;

  LocalHabitaionlistModal({
    required this.villageId,
    required this.HabitationId,
    required this.HabitationName,
  });

  Map<String, dynamic> toMap() {
    return {
      'villageId': villageId,
      'HabitationId': HabitationId,
      'HabitationName': HabitationName,
    };
  }
}

class Localmasterdatetime {
  String? UserId;
  String? API_DateTime;

  Localmasterdatetime({
    this.UserId,
    this.API_DateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'UserId': UserId,
      'API_DateTime': API_DateTime,
    };
  }

  factory Localmasterdatetime.fromMap(Map<String, dynamic> map) {
    return Localmasterdatetime(
      UserId: map['UserId'],
      API_DateTime: map['API_DateTime'].toString(),
    );
  }
}

class LocalmasterInformationBoardItemModal {
  String? userId;
  String? villageId;
  String? stateId;
  String? schemeId;
  String? districtName;
  String? blockName;
  String? panchayatName;
  String? villageName;
  String? habitationName;
  String? latitude;
  String? longitude;
  String? sourceName;
  String? schemeName;
  String? message;
  final String? status;

  LocalmasterInformationBoardItemModal({
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

  Map<String, dynamic> toMap() {
    return {
      'UserId': userId,
      'VillageId': villageId,
      'StateId': stateId,
      'schemeId': schemeId,
      'DistrictName': districtName,
      'BlockName': blockName,
      'PanchayatName': panchayatName,
      'VillageName': villageName,
      'HabitationName': habitationName,
      'Latitude': latitude,
      'Longitude': longitude,
      'SourceName': sourceName,
      'SchemeName': schemeName,
      'Message': message,
      'status': status != null ? 1 : 0,
    };
  }

  factory LocalmasterInformationBoardItemModal.fromMap(
      Map<String, dynamic> map) {
    return LocalmasterInformationBoardItemModal(
      userId: map['UserId'],
      villageId: map['VillageId'].toString(),
      stateId: map['StateId'],
      schemeId: map['schemeId'],
      districtName: map['DistrictName'],
      blockName: map['BlockName'],
      panchayatName: map['PanchayatName'],
      villageName: map['VillageName'],
      habitationName: map['HabitationName'],
      latitude: map['Latitude'],
      longitude: map['Longitude'],
      sourceName: map['SourceName'],
      schemeName: map['SchemeName'],
      message: map['Message'],
      status: map['status'] ?? '',
    );
  }
}
