import 'package:flutter/material.dart';
class utils{
  //UAT
  var base_url= "http://20.235.17.50/api/SignIn/";
  bool isLoggedOut = false;

  void showError(dynamic ex , BuildContext context) {
    //showMessage(ex.toString());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ex.toString())));
    debugPrint(ex.toString());
  }

  void showMessage(String text, BuildContext context) {
    // var alert = AlertDialog(content: Text(text), actions: <Widget>[
    //   TextButton(
    //       child: const Text('Ok'),
    //       onPressed: () {
    //         Navigator.pop(context);
    //       })
    // ]);
    // showDialog(context: context, builder: (BuildContext context) => alert);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  }


}