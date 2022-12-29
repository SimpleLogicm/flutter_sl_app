import 'package:flutter/material.dart';

// To parse this JSON data, do
//
//     final dashboard_submenues = dashboard_submenuesFromJson(jsonString);

import 'dart:convert';

List<dashboard_submenues> dashboard_submenuesFromJson(String str) => List<dashboard_submenues>.from(json.decode(str).map((x) => dashboard_submenues.fromJson(x)));

String dashboard_submenuesToJson(List<dashboard_submenues> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class dashboard_submenues {
  dashboard_submenues({
    required this.fieldMappingId,
    required this.pageid,
    required this.menuid,
    required this.processid,
    required this.pageTableName,
    required this.fieldName,
    required this.fieldType,
    required this.abbreviation,
    required this.formParentId,
    required this.fieldTypeId,
    required this.fieldId,
    required this.fieldSequence,
    required this.label,
    required this.tabName,
    required this.fieldMinLength,
    required this.fieldMaxLength,
    required this.isMandatory,
    required this.isEditable,
    required this.isvisible,
    required this.isExistsValue,
    required this.isSave,
    required this.defaultValue,
    required this.tableName,
    required this.whereCondition,
    required this.procedureNameToBindField,
    required this.queryToBindField,
    required this.dropdownTextColumn,
    required this.dropdownValueColumn,
    required this.isDropdowntextValue,
    required this.javascriptFunction,
    required this.validations,
    required this.className,
    required this.isDynamicSearchRequired,
    this.dynamicSelectColumns,
    this.dynamicSearchWhereCondition,
    this.dynamicBindColumnsFieldId,
    this.isCasacade,
    this.cascadingFieldsId,
    this.cascadeValue,
    this.isActionChange,
    this.actionChangeValue,
    required this.isDependant,
  });

  dynamic fieldMappingId;
  dynamic pageid;
  dynamic menuid;
  dynamic processid;
  dynamic pageTableName;
  dynamic fieldName;
  dynamic fieldType;
  dynamic abbreviation;
  dynamic formParentId;
  dynamic fieldTypeId;
  dynamic fieldId;
  dynamic fieldSequence;
  dynamic label;
  dynamic tabName;
  dynamic fieldMinLength;
  dynamic fieldMaxLength;
  dynamic isMandatory;
  dynamic isEditable;
  dynamic isvisible;
  dynamic isExistsValue;
  dynamic isSave;
  dynamic defaultValue;
  dynamic tableName;
  dynamic whereCondition;
  dynamic procedureNameToBindField;
  dynamic queryToBindField;
  dynamic dropdownTextColumn;
  dynamic dropdownValueColumn;
  dynamic isDropdowntextValue;
  dynamic javascriptFunction;
  dynamic validations;
  dynamic className;
  dynamic isDynamicSearchRequired;
  dynamic dynamicSelectColumns;
  dynamic dynamicSearchWhereCondition;
  dynamic dynamicBindColumnsFieldId;
  dynamic isCasacade;
  dynamic cascadingFieldsId;
  dynamic cascadeValue;
  dynamic isActionChange;
  dynamic actionChangeValue;
  dynamic isDependant;

  factory dashboard_submenues.fromJson(Map<String, dynamic> json) => dashboard_submenues(
    fieldMappingId: json["FieldMappingID"],
    pageid: json["pageid"],
    menuid: json["menuid"],
    processid: json["processid"],
    pageTableName: json["PageTableName"] ,
    fieldName: json["FieldName"],
    fieldType: json["FieldType"],
    abbreviation: json["Abbreviation"],
    formParentId: json["FormParentID"] ,
    fieldTypeId: json["FieldTypeID"],
    fieldId: json["FieldID"],
    fieldSequence: json["FieldSequence"],
    label: json["Label"],
    tabName: json["TabName"],
    fieldMinLength: json["FieldMinLength"],
    fieldMaxLength: json["FieldMaxLength"],
    isMandatory: json["IsMandatory"],
    isEditable: json["IsEditable"],
    isvisible: json["ISVISIBLE"],
    isExistsValue: json["IsExistsValue"] ,
    isSave: json["IsSave"],
    defaultValue: json["DefaultValue"],
    tableName: json["TableName"] ,
    whereCondition: json["WhereCondition"] ,
    procedureNameToBindField: json["ProcedureNameToBindField"],
    queryToBindField: json["QueryToBindField"],
    dropdownTextColumn: json["DropdownTextColumn"] ,
    dropdownValueColumn: json["DropdownValueColumn"],
    isDropdowntextValue: json["IsDropdowntextValue"] ,
    javascriptFunction: json["JavascriptFunction"],
    validations: json["Validations"],
    className: json["ClassName"],
    isDynamicSearchRequired: json["IsDynamicSearchRequired"],
    dynamicSelectColumns: json["DynamicSelectColumns"],
    dynamicSearchWhereCondition: json["DynamicSearchWhereCondition"],
    dynamicBindColumnsFieldId: json["DynamicBindColumnsFieldID"],
    isCasacade: json["IsCasacade"],
    cascadingFieldsId: json["CascadingFieldsID"],
    cascadeValue: json["CascadeValue"],
    isActionChange: json["IsActionChange"],
    actionChangeValue: json["ActionChangeValue"],
    isDependant: json["IsDependant"] ,
  );

  Map<String, dynamic> toJson() => {
    "FieldMappingID": fieldMappingId,
    "pageid": pageid,
    "menuid": menuid,
    "processid": processid,
    "PageTableName": pageTableName == null ? null : pageTableName,
    "FieldName": fieldName,
    "FieldType": fieldType,
    "Abbreviation": abbreviation,
    "FormParentID": formParentId == null ? null : formParentId,
    "FieldTypeID": fieldTypeId,
    "FieldID": fieldId,
    "FieldSequence": fieldSequence,
    "Label": label,
    "TabName": tabName,
    "FieldMinLength": fieldMinLength,
    "FieldMaxLength": fieldMaxLength,
    "IsMandatory": isMandatory,
    "IsEditable": isEditable,
    "ISVISIBLE": isvisible,
    "IsExistsValue": isExistsValue == null ? null : isExistsValue,
    "IsSave": isSave,
    "DefaultValue": defaultValue,
    "TableName": tableName == null ? null : tableName,
    "WhereCondition": whereCondition == null ? null : whereCondition,
    "ProcedureNameToBindField": procedureNameToBindField,
    "QueryToBindField": queryToBindField,
    "DropdownTextColumn": dropdownTextColumn == null ? null : dropdownTextColumn,
    "DropdownValueColumn": dropdownValueColumn == null ? null : dropdownValueColumn,
    "IsDropdowntextValue": isDropdowntextValue == null ? null : isDropdowntextValue,
    "JavascriptFunction": javascriptFunction,
    "Validations": validations == null ? null : validations,
    "ClassName": className,
    "IsDynamicSearchRequired": isDynamicSearchRequired,
    "DynamicSelectColumns": dynamicSelectColumns,
    "DynamicSearchWhereCondition": dynamicSearchWhereCondition,
    "DynamicBindColumnsFieldID": dynamicBindColumnsFieldId,
    "IsCasacade": isCasacade,
    "CascadingFieldsID": cascadingFieldsId,
    "CascadeValue": cascadeValue,
    "IsActionChange": isActionChange,
    "ActionChangeValue": actionChangeValue,
    "IsDependant": isDependant == null ? null : isDependant,
  };
}
