class Villagelistlocaldata {
  final String? villageId;
  final String? villageName;

  Villagelistlocaldata({required this.villageId, required this.villageName});

  Villagelistlocaldata.fromMap(Map<String, dynamic> res)
      : villageId = res['VillageId'],
        villageName = res['VillageName'];

  Map<String, Object?> toMap() {
    return {
      'VillageId': villageId,
      'VillageName': villageName,
    };
  }
}
