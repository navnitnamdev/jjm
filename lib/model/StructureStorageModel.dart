class StructureStorageModel {
  int? id;
  final String userId;
  final String villageId;
  final String capturePointTypeId;
  final String stateId;
  final String EsrSouce;
  final String samesource;
  final String schemeId;
  final String SchemeName;
  final String sourceId;
  final String sourcename;
  final String SourceTypeId;
  final String divisionId;
  final String habitationId;
  final String HabitationName;
  final String landmark;
  final String latitude;
  final String longitude;
  final String accuracy;
  final String photo;
  final String VillageName;
  final String DistrictName;
  final String BlockName;
  final String PanchayatName;
  final String Status;

  StructureStorageModel({
    this.id,
    required this.userId,
    required this.villageId,
    required this.capturePointTypeId,
    required this.stateId,
    required this.EsrSouce,
    required this.samesource,
    required this.schemeId,
    required this.SchemeName,
    required this.sourceId,
    required this.sourcename,
    required this.SourceTypeId,
    required this.divisionId,
    required this.habitationId,
    required this.HabitationName,
    required this.landmark,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.photo,
    required this.VillageName,
    required this.DistrictName,
    required this.BlockName,
    required this.PanchayatName,
    required this.Status,
  });

  factory StructureStorageModel.fromMap(Map<String, dynamic> map) {
    return StructureStorageModel(
      id: map['id'],
      userId: map['UserId'],
      villageId: map['VillageId'],
      capturePointTypeId: map['CapturePointTypeId'],
      stateId: map['StateId'],
      EsrSouce: map['EsrSource'],
      samesource: map['samesource'],
      schemeId: map['SchemeId'],
      SchemeName: map['SchemeName'],
      sourceId: map['SourceId'],
      sourcename: map['sourcename'],
      SourceTypeId: map['SourceTypeId'],
      divisionId: map['DivisionId'],
      habitationId: map['HabitationId'],
      HabitationName: map['HabitationName'],
      landmark: map['Landmark'],
      latitude: map['Latitude'],
      longitude: map['Longitude'],
      accuracy: map['Accuracy'],
      photo: map['Photo'],
      VillageName: map['VillageName'],
      DistrictName: map['DistrictName'],
      BlockName: map['BlockName'],
      PanchayatName: map['PanchayatName'],
      Status: map['Status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'UserId': userId,
      'VillageId': villageId,
      'CapturePointTypeId': capturePointTypeId,
      'StateId': stateId,
      'EsrSource': EsrSouce,
      'samesource': samesource,
      'SchemeId': schemeId,
      'SchemeName': SchemeName,
      'SourceId': sourceId,
      'sourcename': sourcename,
      'SourceTypeId': SourceTypeId,
      'DivisionId': divisionId,
      'HabitationId': habitationId,
      'HabitationName': HabitationName,
      'Landmark': landmark,
      'Latitude': latitude,
      'Longitude': longitude,
      'Accuracy': accuracy,
      'Photo': photo,
      'VillageName': VillageName,
      'DistrictName': DistrictName,
      'BlockName': BlockName,
      'PanchayatName': PanchayatName,
      'Status': Status,
    };
  }
}
