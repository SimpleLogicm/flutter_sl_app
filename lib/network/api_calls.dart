import 'dart:convert';
import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/user_details_model.dart';

class api_call {

 late List<user_details_model> userData = [];

  Future<List<user_details_model>> getUserDetails(String email) async
  {
    final userDetailsResponse = await http.get(Uri.parse("http://20.235.17.50/api/SignIn/GetUserDetails?EmailId=$email"));

    var data = jsonDecode(userDetailsResponse.body.toString());

    if(userDetailsResponse.statusCode == 200 && userDetailsResponse.body.isNotEmpty)
      {
        log(userDetailsResponse.body);
        //   for(Map<String, dynamic> index in data)
        //   {
        //     userData.add(user_details_model.fromJson(index));
        //
        //   }
        //
        //   return userData;

        final List<user_details_model> users = user_details_modelFromJson(userDetailsResponse.body);
        return users;

      }
    else{
      log("error while fetching user details");
      //throw Exception("error while fetching user details");
      return userData;
    }
  }

  
}