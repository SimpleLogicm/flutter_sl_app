class azure_profile_model {
  String? odataContext;
  String? displayName;
  String? givenName;
  String? jobTitle;
  Null? mail;
  Null? mobilePhone;
  Null? officeLocation;
  Null? preferredLanguage;
  String? surname;
  String? userPrincipalName;
  String? id;

  azure_profile_model(
      {this.odataContext,
        this.displayName,
        this.givenName,
        this.jobTitle,
        this.mail,
        this.mobilePhone,
        this.officeLocation,
        this.preferredLanguage,
        this.surname,
        this.userPrincipalName,
        this.id});

  azure_profile_model.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    displayName = json['displayName'];
    givenName = json['givenName'];
    jobTitle = json['jobTitle'];
    mail = json['mail'];
    mobilePhone = json['mobilePhone'];
    officeLocation = json['officeLocation'];
    preferredLanguage = json['preferredLanguage'];
    surname = json['surname'];
    userPrincipalName = json['userPrincipalName'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@odata.context'] = this.odataContext;
    data['displayName'] = this.displayName;
    data['givenName'] = this.givenName;
    data['jobTitle'] = this.jobTitle;
    data['mail'] = this.mail;
    data['mobilePhone'] = this.mobilePhone;
    data['officeLocation'] = this.officeLocation;
    data['preferredLanguage'] = this.preferredLanguage;
    data['surname'] = this.surname;
    data['userPrincipalName'] = this.userPrincipalName;
    data['id'] = this.id;
    return data;
  }
}