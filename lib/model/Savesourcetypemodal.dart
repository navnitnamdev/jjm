class Savesourcetypemodal {
  bool? status;
  String? message;
  List<Resultone>? result;

  Savesourcetypemodal({this.status, this.message, this.result});

  Savesourcetypemodal.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['Result'] != null) {
      result = <Resultone>[];
      json['Result'].forEach((v) {
        result!.add(new Resultone.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.result != null) {
      data['Resultone'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Resultone {
  int? id;
  String? assetTaggingType;
  String? remarks;
  Resultone({this.id, this.assetTaggingType, this.remarks});
  Resultone.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    assetTaggingType = json['AssetTaggingType'];
    remarks = json['Remarks'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['AssetTaggingType'] = this.assetTaggingType;
    data['Remarks'] = this.remarks;
    return data;
  }
}
