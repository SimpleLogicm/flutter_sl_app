import 'package:flutter/material.dart';
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
  final String _clientId = 'sl-app-flutter';
  static const String _issuer = 'https://sldev-identityapi.azurewebsites.net';
  //static const String _issuer = 'https://8a92d38ca051.ngrok.io';
  final List<String> _scopes = <String>[
    'openid',
    'profile',
    'email',
    'offline_access',
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
      if (await canLaunch(url)) {
        await launch(url, forceWebView: true, enableJavaScript: true);
      } else {
        throw 'Could not launch $url';
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
    setState(() {
      logoutUrl = c.generateLogoutUrl().toString();
    });
    print(res.accessToken);
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

}

