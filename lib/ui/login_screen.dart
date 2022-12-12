
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


class login_screen extends StatefulWidget {
  const login_screen(GlobalKey<NavigatorState> navigatorKey, {Key? key}) : super(key: key);

  @override
  State<login_screen> createState() => _login_screenState(navigatorKey);
}

class _login_screenState extends State<login_screen> {
  late Future<azure_profile_model> azureProfileObject;
  late Future<List<user_details_model>> userDetailsObject;
  late Future<List<process_details_model>> processDetailObject;
  var accessToken;
  bool checkLoginAzure = false;
  bool checkLoginGoogle = false;
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
              height: 250,
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

                      width: MediaQuery.of(context).size.width,
                      height: 40,
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
                      width: MediaQuery.of(context).size.width,
                      height: 40,
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
                  onTap: () => Login("ForgetPassword"),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0,vertical: 30.0),
              height: 40,
              child: ElevatedButton(onPressed:() => Login("LoginWithIdPass"), child: Text('LOGIN'),style: ElevatedButton.styleFrom(
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
              child: ElevatedButton.icon(onPressed: () => Login("AzureLogin"),
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
              child: ElevatedButton.icon(onPressed:() =>  Login("GoogleLogin"),
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

  // void azurLoginClick() async
  // {
  //  // debugPrint("Azure Click");
  //   try{
  //    await oAuth.login();
  //    accessToken  = await oAuth.getAccessToken();
  //    azureProfileObject = Network().getAzureProfileInfo(accessToken);
  //
  //
  //
  //     // debugPrint(idToken);
  //        log(accessToken.toString());
  //        azureProfileObject.then((value) {
  //          userDetailsObject = api_call().getUserDetails(value.userPrincipalName.toString());
  //          userDetailsObject.then((value) {
  //            var isActive = value[0].isActive;
  //            log("$isActive");
  //            checkLoginAzure = true;
  //            nevigate_to_dashboard(isActive);
  //          });
  //        log(value.jobTitle.toString());
  //        });
  //
  //
  //    // showMessage('Logged in successfully');
  //   }
  //   catch (e) {
  //     showError(e);
  //   }
  //
  //
  // }

  /////hhhh//////
  // void forgotPasswordClick() {
  //   debugPrint("Forgot password Click");
  // }

  // void onLoginBtnClick()
  // {
  //   var email = email_TEF_controller.text;
  //   var pass = password_TEF_controller.text;
  //   debugPrint(email+" "+pass);
  //   email_TEF_controller.clear();
  //   password_TEF_controller.clear();
  // }

  void azureLogoutClick() async {
    // await oAuth.logout();
    // showMessage('Logged out');

    if(checkLoginAzure == false )
      {

        await GoogleSignInApi.logout();
        //showMessage('google account logged out');
        utils().showMessage("google account logged out", context);
        checkLoginGoogle = false;
      }
    else{
      await oAuth.logout();
      // showMessage('Azure account logged out');
      utils().showMessage("Azure account logged out", context);
      checkLoginAzure = false;
    }





  }

  // void showError(dynamic ex) {
  //   //showMessage(ex.toString());
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ex.toString())));
  //   debugPrint(ex.toString());
  // }
  //
  // void showMessage(String text) {
  //   // var alert = AlertDialog(content: Text(text), actions: <Widget>[
  //   //   TextButton(
  //   //       child: const Text('Ok'),
  //   //       onPressed: () {
  //   //         Navigator.pop(context);
  //   //       })
  //   // ]);
  //   // showDialog(context: context, builder: (BuildContext context) => alert);
  //
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  //
  // }

  // Future loginWithGoogle() async {
  // final user =  await GoogleSignInApi.login();
  // if(user == null)
  //   {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signing with google is failed")));
  //   }
  // else{
  //  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(user.displayName.toString())));
  //   log(user.email);
  //   userDetailsObject = api_call().getUserDetails(user.email);
  //   userDetailsObject.then((value){
  //     if(value.length == 0)
  //       {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User is not register")));
  //       }
  //     else{
  //       var isActive = value[0].isActive;
  //       log("$isActive");
  //       nevigate_to_dashboard(isActive);
  //     }
  //
  //   });
  // }
  // }


  void nevigate_to_dashboard(var isActive, String email)
  {
    if(isActive == 1)
    {
     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User is active")));

      processDetailObject = api_call().getProccessDetails(email);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => dashboard_screen()));


    }
    else{
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User is not active")));
      //showMessage("User is not active");
      utils().showMessage("User is not active", context);
    }
  }


  void Login(String LoginMedium)
  async
  {
    switch(LoginMedium) {
      case "AzureLogin":
        {


          try{
            await oAuth.login();
            accessToken  = await oAuth.getAccessToken();
           azureProfileObject = Network().getAzureProfileInfo(accessToken);
            // debugPrint(idToken);
            log(accessToken.toString());
            azureProfileObject.then((value) {
              userDetailsObject = api_call().getUserDetails(value.userPrincipalName.toString());
              checkLoginAzure = true;
              userDetailsObject.then((value2) {
                var isActive = value2[0].isActive;
                log("$isActive");

              //  nevigate_to_dashboard(isActive,value.userPrincipalName.toString());
              });
              log(value.jobTitle.toString());
            });


            // showMessage('Logged in successfully');
          }
          catch (e) {
            //showError(e);
            utils().showError(e, context);
          }




        }
        break;

      case "GoogleLogin":
        {


          try{
            final user =  await GoogleSignInApi.login();
            if(user == null)
            {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signing with google is failed")));
            }
            else{
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(user.displayName.toString())));
              log(user.email);
              userDetailsObject = api_call().getUserDetails(user.email);
              userDetailsObject.then((value){
                if(value.length == 0)
                {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User is not register")));
                }
                else{
                  var isActive = value[0].isActive;
                  log("$isActive");

                  nevigate_to_dashboard(isActive,user.email);
                }

              });
            }
          }
          catch(e)
    {
     // showError(e);
      utils().showError(e, context);

    }



        }
        break;

      case "ForgetPassword":
        {

          debugPrint("Forgot password Click");

        }
        break;

      case "LoginWithIdPass":{

        var email = email_TEF_controller.text;
        var pass = password_TEF_controller.text;
        debugPrint(email+" "+pass);
        email_TEF_controller.clear();
        password_TEF_controller.clear();

      }
      break;
      default:{
        
      }
      break;
    }
  }

}

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
  static Future<GoogleSignInAccount?> logout() => _googleSignIn.disconnect();
}
