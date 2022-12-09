import 'dart:convert';
import 'dart:developer';

import '../model/azure_profile_model.dart';
import 'package:http/http.dart' as http;

class Network{
Future<azure_profile_model> getAzureProfileInfo(idToken) async {
  final graphResponse = await http.get(Uri.parse("https://graph.microsoft.com/v1.0/me/"),
      headers: {
        "Authorization" : "Bearer " + "$idToken",
        "Content-Type" : "application/json"
      }

  );

  if(graphResponse.statusCode == 200)
    {
      log(graphResponse.toString());
      return azure_profile_model.fromJson(json.decode(graphResponse.body));

    }
  else{
    log("Error while fetching data");
    throw Exception("Error while");
  }

}

}