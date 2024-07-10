class Villagelistforsend {
  String villagename = "";
  String villageid = "";
  String OfflineStatus = "";
  bool isChecked = false;
  String PanchayatName = "";
  String BlockName = "";
  String DistrictName = "";

  Villagelistforsend(this.villagename, this.villageid, this.OfflineStatus,
      this.PanchayatName, this.BlockName, this.DistrictName);

  Map<String, dynamic> toJson() => {
        'villagename': villagename,
        'villageid': villageid,
        'OfflineStatus': OfflineStatus,
        'PanchayatName': PanchayatName,
        'BlockName': BlockName,
        'DistrictName': DistrictName,
      };
}
