// To parse this JSON data, do
//
//     final pageActions = pageActionsFromJson(jsonString);

import 'dart:convert';

List<PageActions> pageActionsFromJson(String str) => List<PageActions>.from(json.decode(str).map((x) => PageActions.fromJson(x)));

String pageActionsToJson(List<PageActions> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PageActions {
  PageActions({
    required this.actionId,
    required this.actionName,
    required this.attachmentPanel,
    required this.remarksPanel,
    required this.validationRequire,
  });

  int actionId;
  String actionName;
  int attachmentPanel;
  int remarksPanel;
  int validationRequire;

  factory PageActions.fromJson(Map<String, dynamic> json) => PageActions(
    actionId: json["ActionID"],
    actionName: json["ActionName"],
    attachmentPanel: json["AttachmentPanel"],
    remarksPanel: json["RemarksPanel"],
    validationRequire: json["ValidationRequire"],
  );

  Map<String, dynamic> toJson() => {
    "ActionID": actionId,
    "ActionName": actionName,
    "AttachmentPanel": attachmentPanel,
    "RemarksPanel": remarksPanel,
    "ValidationRequire": validationRequire,
  };
}
