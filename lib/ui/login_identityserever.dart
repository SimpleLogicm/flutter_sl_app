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
import 'package:webview_flutter/webview_flutter.dart';
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


  bool _showCircle = false;
  WebViewController? controllerGlobal;
  String? userId;
  late Future<List<user_details_model>> userDetailsObject;
  String sharedemail = "";
  String shareduserId = "";
  String sharedlogoutUrl = "";
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
   // getSharedPreferenceData();



    shared_pref().getString_SharedprefData("useremail").then((value) {
      shared_pref().getString_SharedprefData("userId").then((valueUserId){
        shared_pref().getString_SharedprefData("logoutUrl").then((valuelogoutUrl) {
          setState(() {
            sharedemail = value.toString();
            shareduserId = valueUserId.toString();
            sharedlogoutUrl = valuelogoutUrl.toString();

            log("Shared Preference : "+sharedemail+" UserId: "+shareduserId+" LogoutUrl : "+sharedlogoutUrl);
            debugPrint(sharedemail);
            if(sharedemail != 'null'){
              Navigator.push(context, MaterialPageRoute(builder: (context) => dashboard_screen( email: sharedemail, userId: shareduserId, logoutUrl: sharedlogoutUrl,)));

            }
          });
        });

      });

    });




    super.initState();
  }



  @override
  Widget build(BuildContext context) {


    return  WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width ,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://w0.peakpx.com/wallpaper/263/546/HD-wallpaper-simple-abstract-black-designs-half-modern-orange-shadow-white.jpg'),
                fit: BoxFit.fill,
              ),

            ),
          ),

          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.symmetric(horizontal: 70.0,vertical: 15.0),
            child: ElevatedButton.icon(onPressed:() => getSharedPreferenceData(),
              style: ElevatedButton.styleFrom(
                primary: Colors.amberAccent,
                onPrimary: Colors.black,
                minimumSize: Size(double.infinity,50),
              ),
              icon:FaIcon(
                FontAwesomeIcons.server,
                color: Colors.purpleAccent,
              ) ,
              label: Text('Sign in '),
            ),
          ),
          Center(
            child: Visibility(
              visible: _showCircle,
              child: CircularProgressIndicator(color: Colors.blueAccent,),
            ),
          ),

        ],
        ),
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
        await launchUrl(Uri.parse(url),mode: LaunchMode.inAppWebView,);
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

    setState(() {
      logoutUrl = c.generateLogoutUrl().toString();
      shared_pref().putString_Sharedvalue("logoutUrl", logoutUrl);
    });
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => dashboard_screen( email: value[0].emailId, userId: value[0].userId.toString(), logoutUrl: logoutUrl,)));
      }
      else{
        utils().showError("User is not active", context);
      }
    });
  }

  void getSharedPreferenceData() async
  {
    shared_pref().getString_SharedprefData("useremail").then((value) {
        shared_pref().getString_SharedprefData("userId").then((valueUserId){
          shared_pref().getString_SharedprefData("logoutUrl").then((valuelogoutUrl) {
            setState(() {

              //_showCircle = !_showCircle;
              sharedemail = value.toString();
              shareduserId = valueUserId.toString();
              sharedlogoutUrl = valuelogoutUrl.toString();

              log("Shared Preference : "+sharedemail+" UserId: "+shareduserId+" LogoutUrl : "+sharedlogoutUrl);
              debugPrint(sharedemail);
              if(sharedemail == 'null'){

                getloginopen(Uri.parse(_issuer), _clientId, _scopes);
              }else{

                Navigator.push(context, MaterialPageRoute(builder: (context) => dashboard_screen( email: sharedemail, userId: shareduserId, logoutUrl: sharedlogoutUrl,)));
              }
            });
          });

        });

      });



  }

  Future<bool> _onWillPop() async {

    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
           // onPressed: () => Navigator.pop(context,true),
            onPressed: () => SystemNavigator.pop(),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

}







