import 'dart:developer';

import 'package:aad_oauth/model/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sl_app/Utils/shared_pref.dart';
import 'package:sl_app/ui/dashboard_screen.dart';
import '../network/AzureUserProfile.dart';
import '../network/api_calls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:sl_app/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/azure_profile_model.dart';
import '../model/user_details_model.dart';
import '../model/process_details_model.dart';
import '../Utils/utils.dart';
import 'package:openid_client/openid_client.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class login_identityserever extends StatefulWidget {
  const login_identityserever({Key? key}) : super(key: key);

  @override
  State<login_identityserever> createState() => _login_identitysereverState();
}

class _login_identitysereverState extends State<login_identityserever> {

  String? userId;
  late Future<List<user_details_model>> userDetailsObject;
  String sharedemail = "";
  String shareduserId = "";
 var  sharedtoken;
  final String _clientId = 'sl-app-flutter';
  static const String _issuer = 'https://sldev-identityapi.azurewebsites.net';
  //static const String _issuer = 'https://8a92d38ca051.ngrok.io';
  final List<String> _scopes = <String>[
    'email',
    'flutter.app'
  ];
  String logoutUrl = "";




  @override
  void initState() {
    // TODO: implement initState

    shared_pref().getString_SharedprefData("useremail").then((value) {
      shared_pref().getString_SharedprefData("userId").then((valueUserId){
        setState(() {
          sharedemail = value.toString();
          shareduserId = valueUserId.toString();

          log("Shared Preference : "+sharedemail+" UserId: "+shareduserId);
          debugPrint(sharedemail);
          if(sharedemail == 'null'){
            getloginopen(Uri.parse(_issuer), _clientId, _scopes);
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context) => dashboard_screen( email: sharedemail, userId: shareduserId,)));
          }
        });
      });

    });

    // shared_pref().getString_SharedprefData("usertoken").then((value){
    //
    //   setState(() {
    //     sharedtoken= value.toString();
    //     debugPrint(sharedtoken);
    //   });
    // });


    super.initState();
  }



  @override
  Widget build(BuildContext context) {



    return Container(
      color: Colors.white,
      child: Center(child: CircularProgressIndicator()),
    );

  }



  Future<void> logout() async {
    if (await canLaunch(logoutUrl)) {
      await launch(logoutUrl, forceWebView: true);
    } else {
      throw 'Could not launch $logoutUrl';
    }
    await Future.delayed(Duration(seconds: 2));
    closeWebView();
  }

  Future<void> getloginopen(Uri uri, String clientId,List<String> scopes) async {

    var issuer = await Issuer.discover(uri);
    var client = new Client(issuer, clientId);


    // create a function to open a browser with an url
    urlLauncher(String url) async {

      if(await canLaunchUrl(Uri.parse(url)))
      {
        await launchUrl(Uri.parse(url),mode: LaunchMode.inAppWebView);
      }
      else{
        throw "Could not launch $url";
      }
    }

    // create an authenticator
    var authenticator = Authenticator(
      client,
      scopes: scopes,
      urlLancher: urlLauncher,
      port: 3000,
    );

    // starts the authentication
    var c = await authenticator.authorize();
    // close the webview when finished
    closeWebView();

    var res = await c.getTokenResponse();




    var ema = await c.getUserInfo().then((value){
      log(value.email.toString());
      var emaiId = value.email.toString();
      userDetailsObject = api_call().getUserDetails(emaiId);
      userDetailsObject.then((value){
        userId = value[0].userId.toString();
        shared_pref().putString_Sharedvalue("useremail", emaiId);
        shared_pref().putString_Sharedvalue("usertoken", res.accessToken.toString());
        shared_pref().putString_Sharedvalue("userId", userId!);

        getUserdertails2(emaiId,res.accessToken.toString());
      });



    });

    log(res.accessToken.toString());

  }

  void getUserdertails2(String emaiId, String accessToken) {
    late Future<List<user_details_model>> userProfileObject;
    userProfileObject = api_call().getUserDetailsByOpenId(emaiId,accessToken);
    userProfileObject.then((value) {
      log(value[0].firstName.toString());
      if(value.isNotEmpty){
        Navigator.push(context, MaterialPageRoute(builder: (context) => dashboard_screen( email: value[0].emailId, userId: value[0].userId.toString(),)));
      }
      else{
        utils().showError("User is not active", context);
      }
    });
  }



}







