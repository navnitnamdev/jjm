

class Adddisinfectionhouseholdmodal{
String name = "";
String fathername = "";
String address = "";


Adddisinfectionhouseholdmodal(this.name, this.fathername, this.address,
);

Map<String, dynamic> toJson() => {
'name': name,
'fathername': fathername,
'address': address,

};
}

