// To parse this JSON data, do
//
//     final filldropdown = filldropdownFromJson(jsonString);

import 'dart:convert';

List<Filldropdown> filldropdownFromJson(String str) => List<Filldropdown>.from(json.decode(str).map((x) => Filldropdown.fromJson(x)));

String filldropdownToJson(List<Filldropdown> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Filldropdown {
  Filldropdown({
    required this.text,
    required this.value,
  });

  String text;
  int value;

  factory Filldropdown.fromJson(Map<String, dynamic> json) => Filldropdown(
    text: json["Text"],
    value: json["Value"],
  );

  Map<String, dynamic> toJson() => {
    "Text": text,
    "Value": value,
  };
}
