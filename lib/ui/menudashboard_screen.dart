import 'package:flutter/material.dart';
import 'package:sl_app/Utils/shared_pref.dart';

class menudashboard_screen extends StatefulWidget {

  const menudashboard_screen({Key? key, required int processId, required String userId}) : super(key: key);

  @override
  State<menudashboard_screen> createState() => _menudashboard_screenState();
}



class _menudashboard_screenState extends State<menudashboard_screen> {
  String? useremail;



  @override
  void initState() {
    // TODO: implement initState
    getusername();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(appBar: AppBar(
      backgroundColor: Colors.amberAccent,
    ),
    body: Container(),
      drawer: Drawer(
        child: drawermenue(),

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

   getusername() async {
   useremail= shared_pref().getString_SharedprefData("useremail").toString();
  }
}
