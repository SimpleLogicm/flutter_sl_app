import 'dart:developer';

import 'package:aad_oauth/model/config.dart';
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

  var emaiId;
  final String _clientId = 'sl-app-flutter';
  static const String _issuer = 'https://sldev-identityapi.azurewebsites.net';
  //static const String _issuer = 'https://8a92d38ca051.ngrok.io';
  final List<String> _scopes = <String>[
    'email',
    'flutter.app'
  ];
  String logoutUrl = "";


  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("Login"),
              onPressed: () async {
                var tokenInfo = await authenticate(
                    Uri.parse(_issuer), _clientId, _scopes);
                print(tokenInfo.accessToken);
              },
            ),
            ElevatedButton(
              child: Text("Logout"),
              onPressed: () async {
                logout();
              },
            ),
          ],
        ),
      ),
    );

  }

  Future<TokenResponse> authenticate(
      Uri uri, String clientId, List<String> scopes) async {
    // create the client
    var issuer = await Issuer.discover(uri);
    var client = new Client(issuer, clientId);

    // create a function to open a browser with an url
    urlLauncher(String url) async {
      // if (await canLaunch(url))
      // {
      //   await launch(url, forceWebView: true, enableJavaScript: true);
      // } else {
      //   throw 'Could not launch $url';
      // }

      if(await canLaunchUrl(Uri.parse(url)))
        {
          await launchUrl(Uri.parse(url),mode: LaunchMode.inAppWebView);
        }
      else{
        throw "Could not launch $url";
      }

      //await launchUrl(Uri.parse(url),mode: LaunchMode.inAppWebView);
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
      emaiId = value.email.toString();
      getUserDetails(emaiId, res.accessToken.toString());
    });
    setState(() {
      logoutUrl = c.generateLogoutUrl().toString();
    });
    log(res.accessToken.toString());
   // log()


    return res;
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


  void getUserDetails(String Email,String accessToken)
  {

    late Future<List<user_details_model>> userProfileObject;
    userProfileObject = api_call().getUserDetailsByOpenId(emaiId,accessToken);
    userProfileObject.then((value) {
    log(value[0].firstName.toString());
    });

  }


}

