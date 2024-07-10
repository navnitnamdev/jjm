class LocalPWSSavedData {
  final int? id;
  final String sourceId;
  final String userId;
  final String villageId;
  final String assetTaggingId;
  final String stateId;
  final String schemeId;
  final String schemename;
  final String blockName;
  final String villageName;
  final String panchayatName;
  final String sourceName;
  final String sourceType;
  final String sourceTypeCategoryId;
  final String divisionId;
  final String habitationId;
  final String habitationName;
  final String landmark;
  final String latitude;
  final String longitude;
  final String accuracy;
  final String image;
  final String subsourceaddnew;
  final String Status;

  LocalPWSSavedData({
    this.id,
    required this.sourceId,
    required this.userId,
    required this.villageId,
    required this.assetTaggingId,
    required this.stateId,
    required this.schemeId,
    required this.schemename,
    required this.blockName,
    required this.villageName,
    required this.panchayatName,
    required this.sourceName,
    required this.sourceType,
    required this.sourceTypeCategoryId,
    required this.divisionId,
    required this.habitationId,
    required this.habitationName,
    required this.landmark,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.image,
    required this.subsourceaddnew,
    required this.Status,
  });

  factory LocalPWSSavedData.fromJson(Map<String, dynamic> json) {
    return LocalPWSSavedData(
      id: json['id'] as int,
      sourceId: json['SourceId'] as String,
      userId: json['Userid'] as String,
      villageId: json['Villageid'] as String,
      assetTaggingId: json['Assettaggingid'] as String,
      stateId: json['Stateid'] as String,
      schemeId: json['Schemeid'] as String,
      schemename: json['schemename'] as String,
      blockName: json['blockName'] as String,
      villageName: json['villageName'] as String,
      panchayatName: json['panchayatName'] as String,
      sourceName: json['sourceName'] as String,
      sourceType: json['sourceType'] as String,
      sourceTypeCategoryId: json['sourceTypeCategoryId'] as String,
      divisionId: json['DivisionId'] as String,
      habitationId: json['habitationId'] as String,
      habitationName: json['habitationName'] as String,
      landmark: json['landmark'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      accuracy: json['Accuracy'] as String,
      image: json['Image'] as String,
      subsourceaddnew: json['subsourceaddnew'] as String,
      Status: json['Status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'SourceId': sourceId,
      'Userid': userId,
      'Villageid': villageId,
      'Assettaggingid': assetTaggingId,
      'Stateid': stateId,
      'Schemeid': schemeId,
      'schemename': schemename,
      'blockName': blockName,
      'villageName': villageName,
      'panchayatName': panchayatName,
      'sourceName': sourceName,
      'sourceType': sourceType,
      'sourceTypeCategoryId': sourceTypeCategoryId,
      'DivisionId': divisionId,
      'habitationId': habitationId,
      'habitationName': habitationName,
      'landmark': landmark,
      'latitude': latitude,
      'longitude': longitude,
      'Accuracy': accuracy,
      'Image': image,
      'subsourceaddnew': subsourceaddnew,
      'Status': Status,
    };
  }
}
