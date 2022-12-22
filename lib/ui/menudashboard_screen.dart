import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sl_app/Utils/shared_pref.dart';

import '../Utils/utils.dart';
import '../model/roalwisemenue.dart';
import '../network/api_calls.dart';

class menudashboard_screen extends StatefulWidget {

  final int processId;
  final int userId;
  const menudashboard_screen({Key? key,required this.processId,required this.userId}) : super(key: key);

  @override
  State<menudashboard_screen> createState() => _menudashboard_screenState(processId,userId);
}



class _menudashboard_screenState extends State<menudashboard_screen> {
   String? useremail;

  final int userId;
  final int processId;

  late Future<List<List<roalwisemenue>>> roalmenuDetails;
  _menudashboard_screenState(this.processId,this.userId);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shared_pref().getString_SharedprefData("useremail").then((value) {
      setState(() {
        useremail = value.toString();
      });
    });
    log("Process Id : "+processId.toString()+" User Id"+userId.toString());
    //log(" User Email : "+useremail);
    try {
      roalmenuDetails = api_call().getroalwisemenue(processId, userId);
      log("Init Call : "+roalmenuDetails.toString());
    }
    catch (e)
    {
      log(e.toString());
      utils().showError(e, context);
    }
    // roalmenuDetails.then((value) {
    //
    //   var a = value[0];
    //   //log(a.toString());
    //   for (var i = 0; i < a.length; i++) { log(a[i].toJson().toString());}
    // });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(appBar: AppBar(
      backgroundColor: Colors.amberAccent,
    ),
    body: Container(),
      drawer: Drawer(
        child: ListView(
            children: [
              ExpansionTile(
                title: Text("Expansion Title"),
                children: <Widget>[Text("children 1"), Text("children 2")],
              )
            ],
        ),

      ),

    );
  }

  drawermenue() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(child: Text(useremail != "" ? useremail.toString() : "User email not found",
          style: TextStyle(color:Colors.black),),

          decoration: BoxDecoration(color: Colors.amberAccent),


        ),

        ListTile(
          title:Text("Admin"),
          subtitle: Text("Sunita"),
          onTap: (){
             Navigator.pop(context);
          },
        )

      ],


    );


  }


}
