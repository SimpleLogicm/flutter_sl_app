// To parse this JSON data, do
//
//     final roalwisemenue = roalwisemenueFromJson(jsonString);

import 'dart:convert';


List<List<roalwisemenue>> roalwisemenueFromJson(String str) => List<List<roalwisemenue>>.from(json.decode(str).map((x) => List<roalwisemenue>.from(x.map((x) => roalwisemenue.fromJson(x)))));

String roalwisemenueToJson(List<List<roalwisemenue>> data) => json.encode(List<dynamic>.from(data.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))));

class roalwisemenue {
  roalwisemenue({
    required this.menuId,
    required this.menuheader,
    required this.menuname,
    required this.menuid,
    required this.processid,
    required this.parentid,
    required this.roleid,
    required this.rolename,
    required this.controllername,
    required this.actionname,
    required this.menulogo,
  });

  dynamic menuId;
  dynamic menuheader;
  dynamic menuname;
  dynamic menuid;
  dynamic processid;
  dynamic parentid;
  dynamic roleid;
  dynamic rolename;
  dynamic controllername;
  dynamic actionname;
  dynamic menulogo;
  //Menulogo menulogo;

  factory roalwisemenue.fromJson(Map<String, dynamic> json) => roalwisemenue(
    menuId: json["menuID"] ,
    menuheader: json["menuheader"],
    menuname: json["menuname"] ,
    menuid: json["menuid"] ,
    processid: json["processid"] ,
    parentid: json["parentid"],
    roleid: json["roleid"] ,
    rolename: json["rolename"],
    controllername: json["controllername"],
    actionname: json["actionname"],
      menulogo:json["menulogo"]
   // menulogo: json["menulogo"] == null ? null : Menulogo.fromJson(json["menulogo"]),
  );

  Map<String, dynamic> toJson() => {
    "menuID": menuId == null ? null : menuId,
    "menuheader": menuheader,
    "menuname": menuname == null ? null : menuname,
    "menuid": menuid == null ? null : menuid,
    "processid": processid == null ? null : processid,
    "parentid": parentid == null ? null : parentid,
    "roleid": roleid == null ? null : roleid,
    "rolename": rolename == null ? null : rolename,
    "controllername": controllername == null ? null : controllername,
    "actionname": actionname == null ? null : actionname,
    "menulogo": menulogo == null ? null : menulogo
    //"menulogo": menulogo == null ? null : menulogo?.toJson(),
  };
}

// class Menulogo {
//   Menulogo();
//
//   factory Menulogo.fromJson(Map<String, dynamic> json) => Menulogo(
//   );
//
//   Map<String, dynamic> toJson() => {
//   };
// }
