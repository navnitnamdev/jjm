class Localsaveofflinevillages {
  final int? id;
  final String? villageId;
  final String? villageName;

  Localsaveofflinevillages(
      {this.id, required this.villageId, required this.villageName});

  Localsaveofflinevillages.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        villageId = res['villageId'],
        villageName = res['villageName'];

  factory Localsaveofflinevillages.fromJson(Map<String, dynamic> json) {
    return Localsaveofflinevillages(
      id: json['id'] as int,
      villageId: json['villageId'] as String,
      villageName: json['villageName'] as String,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'villageId': villageId,
      'villageName': villageName,
    };
  }
}
