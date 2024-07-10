class Schememodal {
  String Schemeid = "";
  String Schemename = "";
  String Category = "";

  Schememodal(this.Schemeid, this.Schemename, this.Category);

  Map<String, dynamic> toJson() => {
        'Schemeid': Schemeid,
        'Schemename': Schemename,
        'Category': Category,
      };
}
