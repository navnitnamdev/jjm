

import 'dart:convert';

Saveoffinevillagemodal saveoffinevillagemodalFromJson(String str) => Saveoffinevillagemodal.fromJson(json.decode(str));

String saveoffinevillagemodalToJson(Saveoffinevillagemodal data) => json.encode(data.toJson());

class Saveoffinevillagemodal {
  final bool? status;
  final String? message;
  final int? id;
  final List<Villagelist>? villagelist;

  Saveoffinevillagemodal({
    this.status,
    this.message,
    this.id,
    this.villagelist,
  });

  factory Saveoffinevillagemodal.fromJson(Map<String, dynamic> json) => Saveoffinevillagemodal(
    status: json["Status"],
    message: json["Message"],
    id: json["Id"],
    villagelist: List<Villagelist>.from(json["Villagelist"].map((x) => Villagelist.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Message": message,
    "Id": id,
    "Villagelist": List<dynamic>.from(villagelist!.map((x) => x.toJson())),
  };
}

class Villagelist {
  final int villageId;
  final String villageName;
  final int offlineStatus;

  Villagelist({
    required this.villageId,
    required this.villageName,
    required this.offlineStatus,
  });

  factory Villagelist.fromJson(Map<String, dynamic> json) => Villagelist(
    villageId: json["VillageId"],
    villageName: json["VillageName"],
    offlineStatus: json["OfflineStatus"],
  );

  Map<String, dynamic> toJson() => {
    "VillageId": villageId,
    "VillageName": villageName,
    "OfflineStatus": offlineStatus,
  };
}
