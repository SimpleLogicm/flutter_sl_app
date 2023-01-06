import 'dart:convert';
import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sl_app/model/Page_actions.dart';
import '../Utils/shared_pref.dart';
import '../model/dashboard_submenues.dart';
import '../model/filldropdown.dart';
import '../model/roalwisemenue.dart';
import '../model/user_details_model.dart';
import '../Utils/utils.dart';
import '../model/process_details_model.dart';

class api_call {

 late List<user_details_model> userData = [];


Future<List<PageActions>> getpage_actions (int processId,int PageId ,int userId,String userRole ) async {
  var payload = json.encode({
    "processID":processId,
    "pageID": PageId,
    "userRole":userRole.toString(),
    "autoID": 0,
    "userID": userId.toString(),
    "status": "string",
    "actionID": 0
  });


  final response = await http.post(Uri.parse(utils().base_url+"Dynamic/GetPageActions"),body: payload,headers: {
    "Content-Type" : "application/json"
  });

  var dropdownresponse = jsonDecode(response.body.toString());

  late List<PageActions> dropdownresponselist = [];


  if(response.statusCode==200){
    log(utils().base_url+"Dynamic/GetPageActions"+payload);
    log("Page Action Response:- "+dropdownresponse.toString());

    return dropdownresponselist= pageActionsFromJson(response.body);
  } else{
    log("Error while fetching response from server");
    return dropdownresponselist;
  }

}


  
  
  Future<String> savedata(String request) async{
    var payload = request;
    
    final response = await http.post(Uri.parse(utils().base_url+"Dynamic/Save"),body: payload,headers:{ "Content-Type" : "application/json"} );
    var dataresponse = response.body.toString();
    if
    (response.statusCode==200){
      log("response String  "   +dataresponse.toString());
      return dataresponse.toString();
    }else{
      log("Error while fetching response from server");
      return dataresponse.toString();
    }
    
}
 
 
Future<String> getflutterdata(int processId, int pageId) async {

  var payload=json.encode({
    "pageId": pageId,
    "processId": processId,
    "fieldMappingID": 0,
    "fieldID": 0,
    "textValue": "string",
    "connectionString": "string",
    "isNotFlutter": false

  });
  final response = await http.post(Uri.parse(utils().base_url+"Dynamic/GetPageControls"),body: payload,headers: { "Content-Type" : "application/json"} );

  var dataresponse =response.body.toString();


  late List<dashboard_submenues> responselist  =[];
  if
  (response.statusCode == 200){
    log(utils().base_url+"Dynamic/GetPageControls"+ payload);
    log("dataresponse  "   +dataresponse.toString());


    shared_pref().putString_Sharedvalue("datarepo", dataresponse.toString());


    return dataresponse.toString();

  }
  else{
    log("Error while fetching response from server");
    return dataresponse.toString();
  }


}


 // Future<List<dashboard_submenues>> getdashboard_menuclick(int processId, int pageId) async{
 //   var payload=json.encode({
 //     "pageId": pageId,
 //     "processId": processId,
 //     "fieldMappingID": 0,
 //     "fieldID": 0,
 //     "textValue": "string",
 //     "connectionString": "string",
 //     "isNotFlutter": false
 //
 //   });
 //
 //   final response = await http.post(Uri.parse(utils().base_url+"Dynamic/GetPageControls"),body: payload,headers: { "Content-Type" : "application/json"} );
 //
 //   var dataresponse = jsonDecode(response.body.toString());
 //   late List<dashboard_submenues> responselist  =[];
 //   if
 //   (response.statusCode == 200){
 //     log(utils().base_url+"Dynamic/GetPageControls"+ payload);
 //     log(dataresponse.toString());
 //
 //
 //     return responselist = dashboard_submenuesFromJson(response.body);
 //
 //   }
 //   else{
 //     log("Error while fetching response from server");
 //     return responselist;
 //   }
 //
 // }







 Future<List<List<roalwisemenue>>> getroalwisemenue( int processID, int userId) async {
   late List<List<roalwisemenue>> menulist =[];
   var payload = json.encode({
     "processID": processID,
     "userID": userId
   });



   
   final menuresponse = await http.post(Uri.parse(utils().base_url+"SignIn/GetProcessRoleWiseMenu"),body: payload, headers: {
     "Content-Type" : "application/json"
   });

   var Menuedata = jsonDecode(menuresponse.body.toString());
   if(menuresponse.statusCode==201 || menuresponse.statusCode==200){
     log(utils().base_url+"SignIn/GetProcessRoleWiseMenu"+payload);
     log(Menuedata.toString());



     menulist = roalwisemenueFromJson(menuresponse.body);

     // for(Map<String, dynamic> index in Menuedata){
     //   menulist.add(Roalwisemenue.fromJson(index));
     //
     // }
     return menulist;
   }else{
     log("Error while fetching response from server");
     return menulist;
   }

 }

  Future<List<user_details_model>> getUserDetails(String email) async
  {
    final userDetailsResponse = await http.get(Uri.parse(utils().base_url+"SignIn/GetUserDetails?EmailId=$email"));

    var data = jsonDecode(userDetailsResponse.body.toString());

    if(userDetailsResponse.statusCode == 200 && userDetailsResponse.body.isNotEmpty)
      {
        log(utils().base_url+"SignIn/GetUserDetails?EmailId=$email");
        log(userDetailsResponse.body);
          for(Map<String, dynamic> index in data)
          {
            userData.add(user_details_model.fromJson(index));

          }

          return userData;

      }
    else{
      log("error while fetching user details");
      //throw Exception("error while fetching user details");
      return userData;
    }
  }


  Future<List<process_details_model>> getProccessDetails(String email) async{

    late List<process_details_model> processList = [];

    final processResponse = await http.get(Uri.parse(utils().base_url+"SignIn/GetUserWiseProcess?Username=$email")) ;

    var Processdata = jsonDecode(processResponse.body.toString());

    if(processResponse.statusCode == 200)
      {
        log(utils().base_url+"SignIn/GetUserWiseProcess?Username=$email");
        log(processResponse.body.toString());
        for(Map<String, dynamic> index in Processdata)
        {
          processList.add(process_details_model.fromJson(index));

        }

        return processList;
      }
    else{

      log("Error while fetching response from server");
      return processList;
    }
  }

 Future<List<user_details_model>> getUserDetailsByOpenId(String email,String accessToken) async
 {
   final userDetailsResponse = await http.get(Uri.parse(utils().base_url+"SignIn/GetUserDetails?EmailId=$email"),
   headers: {
     "Authorization" : "Bearer " + "$accessToken",
     "Content-Type" : "application/json"
   });

   var data = jsonDecode(userDetailsResponse.body.toString());

   if(userDetailsResponse.statusCode == 200 && userDetailsResponse.body.isNotEmpty)
   {
     log(utils().base_url+"SignIn/GetUserDetails?EmailId=$email");
     log(userDetailsResponse.body);
     for(Map<String, dynamic> index in data)
     {
       userData.add(user_details_model.fromJson(index));

     }

     return userData;

   }
   else{
     log("error while fetching user details");
     //throw Exception("error while fetching user details");
     return userData;
   }
 }
  
}