class Localpwspendinglistmodal {
  int? id;
  final String schemeName;
  final String imageUrl;
  final String stateId;
  final String villageId;
  final String districtName;
  final String blockName;
  final String panchayatName;
  final String villageName;
  final String sourceName;
  final String sourceType;
  final String location;
  final double latitude;
  final double longitude;
  final String habitationName;
  final String sourceCatogery;
  final String status;

  Localpwspendinglistmodal({
    this.id,
    required this.schemeName,
    required this.imageUrl,
    required this.stateId,
    required this.villageId,
    required this.districtName,
    required this.blockName,
    required this.panchayatName,
    required this.villageName,
    required this.sourceName,
    required this.sourceType,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.habitationName,
    required this.sourceCatogery,
    required this.status,
  });

  factory Localpwspendinglistmodal.fromjson(Map<String, dynamic> map) {
    return Localpwspendinglistmodal(
      id: map['id'],
      schemeName: map['schemename'],
      imageUrl: map['imageUrl'],
      stateId: map['stateId'],
      villageId: map['villageId'],
      districtName: map['districtName'],
      blockName: map['blockName'],
      panchayatName: map['panchayatName'],
      villageName: map['villageName'],
      sourceName: map['sourceName'],
      sourceType: map['sourceType'],
      location: map['location'],
      latitude: double.parse(map['latitude']),
      longitude: double.parse(map['longitude']),
      habitationName: map['habitationName'],
      sourceCatogery: map['sourceCatogery'],
      status: map['status'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'SchemeName': schemeName,
      'ImageURL': imageUrl,
      'StateId': stateId,
      'VillageId': villageId,
      'DistrictName': districtName,
      'BlockName': blockName,
      'PanchayatName': panchayatName,
      'VillageName': villageName,
      'SourceName': sourceName,
      'sourcetype': sourceType,
      'location': location,
      'Latitude': latitude,
      'Longitude': longitude,
      'HabitationName': habitationName,
      'SourceCatogery': sourceCatogery,
      'Status': status,
    };
  }
}
