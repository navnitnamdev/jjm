class Myresponse {
  bool? status;
  String? message;
  String? userName;
  String? userDescription;
  int? UserId;
  String? Mobile;
  String? Designation;
  List<Result>? result;

  Myresponse(
      {this.status,
      this.message,
      this.userName,
      this.userDescription,
      this.UserId,
      this.Mobile,
      this.Designation,
      this.result});

  Myresponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    userName = json['UserName'];
    userDescription = json['UserDescription'];
    UserId = json['UserId'];
    Mobile = json['Mobile'];
    Designation = json['Designation'];
    if (json['Result'] != null) {
      result = <Result>[];
      json['Result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['UserName'] = this.userName;
    data['UserDescription'] = this.userDescription;
    data['UserId'] = this.UserId;
    data['Mobile'] = this.Mobile;
    data['Designation'] = this.Designation;
    if (this.result != null) {
      data['Result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? menuId;
  String? heading;
  List<SubHeadingmenulist>? subHeadingmenulist;

  Result({this.menuId, this.heading, this.subHeadingmenulist});

  Result.fromJson(Map<String, dynamic> json) {
    menuId = json['MenuId'];
    heading = json['Heading'];
    if (json['SubHeadingmenulist'] != null) {
      subHeadingmenulist = <SubHeadingmenulist>[];
      json['SubHeadingmenulist'].forEach((v) {
        subHeadingmenulist!.add(new SubHeadingmenulist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MenuId'] = this.menuId;
    data['Heading'] = this.heading;
    if (this.subHeadingmenulist != null) {
      data['SubHeadingmenulist'] =
          this.subHeadingmenulist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubHeadingmenulist {
  String? subHeadingMenuId;
  String? subHeading;
  String? subHeadingParentId;
  List<SubResult>? result;

  SubHeadingmenulist(
      {this.subHeadingMenuId,
      this.subHeading,
      this.subHeadingParentId,
      this.result});

  SubHeadingmenulist.fromJson(Map<String, dynamic> json) {
    subHeadingMenuId = json['SubHeadingMenuId'];
    subHeading = json['SubHeading'];
    subHeadingParentId = json['SubHeadingParentId'];
    if (json['Result'] != null) {
      result = <SubResult>[];
      json['Result'].forEach((v) {
        result!.add(new SubResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SubHeadingMenuId'] = this.subHeadingMenuId;
    data['SubHeading'] = this.subHeading;
    data['SubHeadingParentId'] = this.subHeadingParentId;
    if (this.result != null) {
      data['Result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubResult {
  String? lableMenuId;
  String? lableText;
  String? lableValue;
  String? icon;

  SubResult({this.lableMenuId, this.lableText, this.lableValue, this.icon});

  SubResult.fromJson(Map<String, dynamic> json) {
    lableMenuId = json['lableMenuId'];
    lableText = json['LableText'];
    lableValue = json['LableValue'];
    icon = json['Icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lableMenuId'] = this.lableMenuId;
    data['LableText'] = this.lableText;
    data['LableValue'] = this.lableValue;
    data['Icon'] = this.icon;
    return data;
  }
}
