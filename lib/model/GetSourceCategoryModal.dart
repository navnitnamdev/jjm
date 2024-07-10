
import 'dart:convert';

GetSourceCategoryModal getSourceCategoryModalFromJson(String str) => GetSourceCategoryModal.fromJson(json.decode(str));

String getSourceCategoryModalToJson(GetSourceCategoryModal data) => json.encode(data.toJson());

class GetSourceCategoryModal {
  bool status;
  String message;
  List<Result> result;

  GetSourceCategoryModal({
    required this.status,
    required this.message,
    required this.result,
  });

  factory GetSourceCategoryModal.fromJson(Map<String, dynamic> json) => GetSourceCategoryModal(
    status: json["Status"],
    message: json["Message"],
    result: List<Result>.from(json["Result"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Message": message,
    "Result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class Result {
  int sourceTypeId;
  String sourceType;
  int sourceTypeCategoryId;
  String sourceTypeCategory;

  Result({
    required this.sourceTypeId,
    required this.sourceType,
    required this.sourceTypeCategoryId,
    required this.sourceTypeCategory,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    sourceTypeId: json["SourceTypeId"],
    sourceType: json["SourceType"],
    sourceTypeCategoryId: json["SourceTypeCategoryId"],
    sourceTypeCategory: json["SourceTypeCategory"],
  );

  Map<String, dynamic> toJson() => {
    "SourceTypeId": sourceTypeId,
    "SourceType": sourceType,
    "SourceTypeCategoryId": sourceTypeCategoryId,
    "SourceTypeCategory": sourceTypeCategory,
  };
}
