// To parse this JSON data, do
//
//     final savedata = savedataFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';





Savedata savedataFromJson(String str) => Savedata.fromJson(json.decode(str));

String savedataToJson(Savedata data) => json.encode(data.toJson());
@JsonSerializable()
class Savedata {
  Savedata({
    required this.dtFieldData,
  });

  List<DtFieldDatum> dtFieldData;

  factory Savedata.fromJson(Map<String, dynamic> json) => Savedata(
    dtFieldData: List<DtFieldDatum>.from(json["dtFieldData"].map((x) => DtFieldDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "dtFieldData": List<dynamic>.from(dtFieldData.map((x) => x.toJson())),
  };
}

class DtFieldDatum {
  DtFieldDatum({
    required this.autoId,
    required this.fieldId,
    required this.fieldValue,
  });

  int autoId;
  String fieldId;
  String fieldValue;

  factory DtFieldDatum.fromJson(Map<String, dynamic> json) => DtFieldDatum(
    autoId: json["AutoID"],
    fieldId: json["FieldID"],
    fieldValue: json["FieldValue"],
  );

  Map<String, dynamic> toJson() => {
    "AutoID": autoId,
    "FieldID": fieldId,
    "FieldValue": fieldValue,
  };
}
