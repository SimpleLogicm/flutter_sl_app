// class user_details_model {
//   var userID;
//   var username;
//   var emailID;
//   var defaultRoleID;
//   var firstName;
//   var lastName;
//   var contactNumber;
//   var address;
//   var domainID;
//   var isActive;
//   var passwordChangedDate;
//   var lastLoginTime;
//   var isLocked;
//   var isLockedTime;
//   var isOTPRequired;
//   var oTP;
//   var oTPTime;
//   var oTPGeneratedCount;
//   var isloggedIn;
//   var rolename;
//   var processname;
//   var clientname;
//   var connectionsString;
//
//   user_details_model(
//       {this.userID,
//         this.username,
//         this.emailID,
//         this.defaultRoleID,
//         this.firstName,
//         this.lastName,
//         this.contactNumber,
//         this.address,
//         this.domainID,
//         this.isActive,
//         this.passwordChangedDate,
//         this.lastLoginTime,
//         this.isLocked,
//         this.isLockedTime,
//         this.isOTPRequired,
//         this.oTP,
//         this.oTPTime,
//         this.oTPGeneratedCount,
//         this.isloggedIn,
//         this.rolename,
//         this.processname,
//         this.clientname,
//         this.connectionsString});
//
//   user_details_model.fromJson(Map<String, dynamic> json) {
//     userID = json['UserID'];
//     username = json['Username'];
//     emailID = json['EmailID'];
//     defaultRoleID = json['DefaultRoleID'];
//     firstName = json['FirstName'];
//     lastName = json['LastName'];
//     contactNumber = json['ContactNumber'];
//     address = json['Address'];
//     domainID = json['DomainID'];
//     isActive = json['IsActive'];
//     passwordChangedDate = json['PasswordChangedDate'];
//     lastLoginTime = json['LastLoginTime'];
//     isLocked = json['IsLocked'];
//     isLockedTime = json['IsLockedTime'];
//     isOTPRequired = json['IsOTPRequired'];
//     oTP = json['OTP'];
//     oTPTime = json['OTPTime'];
//     oTPGeneratedCount = json['OTPGeneratedCount'];
//     isloggedIn = json['IsloggedIn'];
//     rolename = json['rolename'];
//     processname = json['processname'];
//     clientname = json['clientname'];
//     connectionsString = json['ConnectionsString'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['UserID'] = this.userID;
//     data['Username'] = this.username;
//     data['EmailID'] = this.emailID;
//     data['DefaultRoleID'] = this.defaultRoleID;
//     data['FirstName'] = this.firstName;
//     data['LastName'] = this.lastName;
//     data['ContactNumber'] = this.contactNumber;
//     data['Address'] = this.address;
//     data['DomainID'] = this.domainID;
//     data['IsActive'] = this.isActive;
//     data['PasswordChangedDate'] = this.passwordChangedDate;
//     data['LastLoginTime'] = this.lastLoginTime;
//     data['IsLocked'] = this.isLocked;
//     data['IsLockedTime'] = this.isLockedTime;
//     data['IsOTPRequired'] = this.isOTPRequired;
//     data['OTP'] = this.oTP;
//     data['OTPTime'] = this.oTPTime;
//     data['OTPGeneratedCount'] = this.oTPGeneratedCount;
//     data['IsloggedIn'] = this.isloggedIn;
//     data['rolename'] = this.rolename;
//     data['processname'] = this.processname;
//     data['clientname'] = this.clientname;
//     data['ConnectionsString'] = this.connectionsString;
//     return data;
//   }
// }


// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';




List<user_details_model> user_details_modelFromJson(String str) => List<user_details_model>.from(json.decode(str).map((x) => user_details_model.fromJson(x)));

String user_details_modelToJson(List<user_details_model> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class user_details_model {
  user_details_model({
    required this.userId,
    required this.username,
    required this.emailId,
    required this.defaultRoleId,
    required this.firstName,
    this.lastName,
    this.contactNumber,
    this.address,
    this.domainId,
    required this.isActive,
    this.passwordChangedDate,
    this.lastLoginTime,
    this.isLocked,
    this.isLockedTime,
    this.isOtpRequired,
    this.otp,
    this.otpTime,
    this.otpGeneratedCount,
    this.isloggedIn,
    required this.rolename,
    required this.processname,
    required this.clientname,
    required this.connectionsString,
  });

  int userId;
  String username;
  String emailId;
  int defaultRoleId;
  String firstName;
  dynamic lastName;
  dynamic contactNumber;
  dynamic address;
  dynamic domainId;
  int isActive;
  dynamic passwordChangedDate;
  dynamic lastLoginTime;
  dynamic isLocked;
  dynamic isLockedTime;
  dynamic isOtpRequired;
  dynamic otp;
  dynamic otpTime;
  dynamic otpGeneratedCount;
  dynamic isloggedIn;
  String rolename;
  String processname;
  String clientname;
  String connectionsString;

  factory user_details_model.fromJson(Map<String, dynamic> json) => user_details_model(
    userId: json["UserID"],
    username: json["Username"],
    emailId: json["EmailID"],
    defaultRoleId: json["DefaultRoleID"],
    firstName: json["FirstName"],
    lastName: json["LastName"],
    contactNumber: json["ContactNumber"],
    address: json["Address"],
    domainId: json["DomainID"],
    isActive: json["IsActive"],
    passwordChangedDate: json["PasswordChangedDate"],
    lastLoginTime: json["LastLoginTime"],
    isLocked: json["IsLocked"],
    isLockedTime: json["IsLockedTime"],
    isOtpRequired: json["IsOTPRequired"],
    otp: json["OTP"],
    otpTime: json["OTPTime"],
    otpGeneratedCount: json["OTPGeneratedCount"],
    isloggedIn: json["IsloggedIn"],
    rolename: json["rolename"],
    processname: json["processname"],
    clientname: json["clientname"],
    connectionsString: json["ConnectionsString"],
  );

  Map<String, dynamic> toJson() => {
    "UserID": userId,
    "Username": username,
    "EmailID": emailId,
    "DefaultRoleID": defaultRoleId,
    "FirstName": firstName,
    "LastName": lastName,
    "ContactNumber": contactNumber,
    "Address": address,
    "DomainID": domainId,
    "IsActive": isActive,
    "PasswordChangedDate": passwordChangedDate,
    "LastLoginTime": lastLoginTime,
    "IsLocked": isLocked,
    "IsLockedTime": isLockedTime,
    "IsOTPRequired": isOtpRequired,
    "OTP": otp,
    "OTPTime": otpTime,
    "OTPGeneratedCount": otpGeneratedCount,
    "IsloggedIn": isloggedIn,
    "rolename": rolename,
    "processname": processname,
    "clientname": clientname,
    "ConnectionsString": connectionsString,
  };
}

