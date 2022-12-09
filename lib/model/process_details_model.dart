// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<process_details_model> welcomeFromJson(String str) => List<process_details_model>.from(json.decode(str).map((x) => process_details_model.fromJson(x)));


String welcomeToJson(List<process_details_model> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class process_details_model {
  process_details_model({
    required this.processId,
    required this.processCode,
    required this.processName,
    required this.connectionsString,
    required this.encryKey,
  });

  int processId;
  String processCode;
  String processName;
  String connectionsString;
  String encryKey;

  factory process_details_model.fromJson(Map<String, dynamic> json) => process_details_model(
    processId: json["ProcessID"],
    processCode: json["ProcessCode"],
    processName: json["ProcessName"],
    connectionsString: json["ConnectionsString"],
    encryKey: json["EncryKey"],
  );

  Map<String, dynamic> toJson() => {
    "ProcessID": processId,
    "ProcessCode": processCode,
    "ProcessName": processName,
    "ConnectionsString": connectionsString,
    "EncryKey": encryKey,
  };
}
