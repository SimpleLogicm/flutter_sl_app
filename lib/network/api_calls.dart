import 'dart:convert';
import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/roalwisemenue.dart';
import '../model/user_details_model.dart';
import '../Utils/utils.dart';
import '../model/process_details_model.dart';

class api_call {

 late List<user_details_model> userData = [];


 Future<List<List<roalwisemenue>>> getroalwisemenue( int processID, int userId) async {
   late List<List<roalwisemenue>> menulist =[];
   var payload = json.encode({
     "processID": processID,
     "userID": userId
   });

   
   final menuresponse = await http.post(Uri.parse(utils().base_url+"GetProcessRoleWiseMenu"),body: payload, headers: {
     "Content-Type" : "application/json"
   });

   var Menuedata = jsonDecode(menuresponse.body.toString());
   if(menuresponse.statusCode==201 || menuresponse.statusCode==200){
     log(utils().base_url+"/api/SignIn/GetProcessRoleWiseMenu"+payload);
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
    final userDetailsResponse = await http.get(Uri.parse(utils().base_url+"GetUserDetails?EmailId=$email"));

    var data = jsonDecode(userDetailsResponse.body.toString());

    if(userDetailsResponse.statusCode == 200 && userDetailsResponse.body.isNotEmpty)
      {
        log(utils().base_url+"GetUserDetails?EmailId=$email");
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

    final processResponse = await http.get(Uri.parse(utils().base_url+"GetUserWiseProcess?Username=$email")) ;

    var Processdata = jsonDecode(processResponse.body.toString());

    if(processResponse.statusCode == 200)
      {
        log(utils().base_url+"GetUserWiseProcess?Username=$email");
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
   final userDetailsResponse = await http.get(Uri.parse(utils().base_url+"GetUserDetails?EmailId=$email"),
   headers: {
     "Authorization" : "Bearer " + "$accessToken",
     "Content-Type" : "application/json"
   });

   var data = jsonDecode(userDetailsResponse.body.toString());

   if(userDetailsResponse.statusCode == 200 && userDetailsResponse.body.isNotEmpty)
   {
     log(utils().base_url+"GetUserDetails?EmailId=$email");
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