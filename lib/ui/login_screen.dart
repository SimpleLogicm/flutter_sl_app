
import 'package:aad_oauth/model/config.dart';
import '../network/AzureUserProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:sl_app/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/azure_profile_model.dart';


class login_screen extends StatefulWidget {
  const login_screen(GlobalKey<NavigatorState> navigatorKey, {Key? key}) : super(key: key);

  @override
  State<login_screen> createState() => _login_screenState(navigatorKey);
}

class _login_screenState extends State<login_screen> {
  late Future<azure_profile_model> azureProfileObject;
  var idToken;
  bool checkLoginAzure = false;
  _login_screenState(GlobalKey<NavigatorState> navigatorKey);

  TextEditingController email_TEF_controller = TextEditingController();
  TextEditingController password_TEF_controller = TextEditingController();

  static final Config config = Config(
      tenant: "1697e051-14c5-4db9-9b1a-4fc79fcd1892",
      clientId: "89a0e295-b48c-4507-bd21-898058a43193",
      redirectUri: "https://login.microsoftonline.com/common/oauth2/nativeclient",
      //redirectUri: "https://login.live.com/oauth20_desktop.srf",
      scope: "openid profile offline_access User.read",
      navigatorKey: navigatorKey);


final AadOAuth oAuth = AadOAuth(config);





  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.amber,
    ));

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2.7,
              decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100.0))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 80.0),
                      child: Icon(Icons.blur_circular_outlined,color: Colors.white,size: 80.0,),
                    ),
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30.0,bottom: 20.0),
                      child: Text("Login",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w100,fontSize: 28.0,fontFamily: 'NotoSerif'),),
                    ),
                 alignment: Alignment.bottomRight, )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(

                      width: MediaQuery.of(context).size.width/1.15,
                      height: MediaQuery.of(context).size.height/15,
                      child: TextField(
                        controller: email_TEF_controller,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber),borderRadius: BorderRadius.all(Radius.circular(20.0))),
                            labelText: 'User name',
                            floatingLabelStyle: TextStyle(color: Colors.amber),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: const OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(20.0))),
                          )
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width/1.15,
                      height: MediaQuery.of(context).size.height/15,
                      child: TextField(
                        controller: password_TEF_controller,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber),borderRadius: BorderRadius.all(Radius.circular(20.0))),
                            labelText: 'Password',
                            floatingLabelStyle: TextStyle(color: Colors.amber),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: const OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(20.0))),
                          )),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 20,right: 25),
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  child: Text('Forgot Password?',style: TextStyle(
                    color: Colors.black54,)
                    ,),
                  onTap: forgotPasswordClick,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0,vertical: 30.0),
              height: MediaQuery.of(context).size.height/17,
              child: ElevatedButton(onPressed: onLoginBtnClick, child: Text('LOGIN'),style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                elevation: 6.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),

              ),
              ),
            ),
            InkWell(child: Text('Logout',style: TextStyle(color: Colors.white),),onTap: azureLogoutClick,),
            // InkWell(
            //   child: Container(
            //     height: MediaQuery.of(context).size.height/15,
            //     width: MediaQuery.of(context).size.width/10,
            //     decoration: BoxDecoration(
            //       image: DecorationImage(
            //           image: AssetImage('assets/images/AzurLogo2.png'),
            //           fit: BoxFit.contain
            //       ),
            //       borderRadius: BorderRadius.all(new Radius.circular(100.00)),
            //     ),
            //   ),
            //   onTap: azurLoginClick,
            // ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0,vertical: 5.0),
              child: ElevatedButton.icon(onPressed: azurLoginClick,
                style: ElevatedButton.styleFrom(
                  primary: Colors.amberAccent,
                  onPrimary: Colors.black,
                  minimumSize: Size(double.infinity,50),
                ),
                icon:FaIcon(
                  FontAwesomeIcons.microsoft,
                  color: Colors.purple,
                ) ,
                label: Text('Sign in with Azure'),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0,vertical: 5.0),
              child: ElevatedButton.icon(onPressed: loginWithGoogle,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amberAccent,
                    onPrimary: Colors.black,
                    minimumSize: Size(double.infinity,50),
                  ),
                  icon:FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.purpleAccent,
                  ) ,
                  label: Text('Sign in with google'),
              ),
            )

          ],
        ),
      ),
    );
  }

  void azurLoginClick() async
  {
   // debugPrint("Azure Click");
    try{
     await oAuth.login();
       idToken  = await oAuth.getAccessToken();
    // azureProfileObject = Network().getAzureProfileInfo(idToken);


       checkLoginAzure = true;
       debugPrint(idToken.toString());
       //debugPrint('Response : '+graphResponse.body);
      //showMessage('Logged in successfully, your access token: '+graphResponse.statusCode.toString());
      // if(graphResponse.statusCode == 200){
      //   showMessage("Login Successful "+graphResponse.body);
      //
      // }

    } catch (e) {
      showError(e);
    }


  }

  void forgotPasswordClick() {
    debugPrint("Forgot password Click");
  }

  void onLoginBtnClick()
  {
    var email = email_TEF_controller.text;
    var pass = password_TEF_controller.text;
    debugPrint(email+" "+pass);
    email_TEF_controller.clear();
    password_TEF_controller.clear();
  }

  void azureLogoutClick() async {
    // await oAuth.logout();
    // showMessage('Logged out');

    if(checkLoginAzure == false )
      {
        await GoogleSignInApi.logout();
        showMessage('Logged out');
      }
    else{
      await oAuth.logout();
      showMessage('Logged out');
      checkLoginAzure = false;
    }


  }

  void showError(dynamic ex) {
    showMessage(ex.toString());
    debugPrint(ex.toString());
  }

  void showMessage(String text) {
    var alert = AlertDialog(content: Text(text), actions: <Widget>[
      TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
          })
    ]);
    showDialog(context: context, builder: (BuildContext context) => alert);
  }



  Future loginWithGoogle() async {
  final user =  await GoogleSignInApi.login();
  if(user == null)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signing with google is failed")));
    }
  else{
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(user.displayName.toString())));
  }
  }
}

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
  static Future<GoogleSignInAccount?> logout() => _googleSignIn.disconnect();
}