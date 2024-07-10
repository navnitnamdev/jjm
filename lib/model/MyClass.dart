class MyClass {
  String VillageId="";
  MyClass( this.VillageId);
  Map<String, dynamic> toJson() => {
    'VillageId': VillageId,
  };
}

