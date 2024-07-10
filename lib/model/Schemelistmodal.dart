import 'dart:convert';

Schemelistmodal schemelistmodalFromJson(String str) =>
    Schemelistmodal.fromJson(json.decode(str));

String schemelistmodalToJson(Schemelistmodal data) =>
    json.encode(data.toJson());

class Schemelistmodal {
  String message;
  bool status;
  List<Schmelist> schmelist;

  Schemelistmodal({
    required this.message,
    required this.status,
    required this.schmelist,
  });

  factory Schemelistmodal.fromJson(Map<String, dynamic> json) =>
      Schemelistmodal(
        message: json["Message"],
        status: json["Status"],
        schmelist: List<Schmelist>.from(
            json["schmelist"].map((x) => Schmelist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Status": status,
        "schmelist": List<dynamic>.from(schmelist.map((x) => x.toJson())),
      };
}

class Schmelist {
  int schemeid;
  String schemename;
  String category;

  Schmelist({
    required this.schemeid,
    required this.schemename,
    required this.category,
  });

  factory Schmelist.fromJson(Map<String, dynamic> json) => Schmelist(
        schemeid: json["Schemeid"],
        schemename: json["Schemename"],
        category: json["Category"],
      );

  Map<String, dynamic> toJson() => {
        "Schemeid": schemeid,
        "Schemename": schemename,
        "Category": category,
      };
}
