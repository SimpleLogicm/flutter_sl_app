import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sl_app/Utils/shared_pref.dart';
import 'package:sl_app/ui/login_identityserever.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sl_app/Utils/shared_pref.dart';
import '../Utils/utils.dart';
import '../model/process_details_model.dart';
import '../network/api_calls.dart';

class dashboard_screen extends StatefulWidget {
  final String email;
  final String userId;
  final String logoutUrl;
  const dashboard_screen( {Key? key,required this.email,required this.userId,required this.logoutUrl}) : super(key: key);

  @override
  State<dashboard_screen> createState() => _dashboard_screenState(email,userId,logoutUrl);
}

class _dashboard_screenState extends State<dashboard_screen> {
  late Future<List<process_details_model>> processDetailObject;
  final String email;
  final String userId;
  final String logoutUrl;
  var sizelist;
  _dashboard_screenState(this.email,this.userId,this.logoutUrl);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    try {
      processDetailObject = api_call().getProccessDetails(email);
     processDetailObject.then((value) {
       if(value.isNotEmpty)
         {
           sizelist=value.length;
           for(var i in value)
             {
               log(i.toJson().toString());
             }
         }
     });
    }catch (e){
      log("Process data error : "+e.toString());
      utils().showError(e, context);
    }




  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: Text("Processes"),backgroundColor: Colors.amber,
          actions: [
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () => {
                LogoutBtn(context,logoutUrl)}
          ),
        ],),
        body: Container(
          child: FutureBuilder<List<process_details_model>>(
            future: processDetailObject,
              builder: (BuildContext context,AsyncSnapshot<List<process_details_model>> snapshot)
             {

               if(snapshot.hasData)
                 {
                   return GridView.builder(

                       shrinkWrap: true,
                       scrollDirection: Axis.vertical,
                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                         mainAxisSpacing: 10.0,crossAxisSpacing: 5.0,childAspectRatio: 1/1.5
                       ),
                       itemCount: sizelist,
                       itemBuilder: (BuildContext context, int index){
                         return  Container(
                       //  child: Text(snapshot.data![index].processName),
                            // margin: EdgeInsets.only(top: 10,left: 5,right: 5,bottom: 5),
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(5.0),
                               color: Colors.white,
                               boxShadow: [
                                 BoxShadow(
                                   color: Colors.grey,
                                   offset: Offset(0.0, 1.0), //(x,y)
                                   blurRadius: 6.0,
                                 ),
                               ],
                             ),

                             child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                               children: [
                                 Align(
                                   alignment: Alignment.center,
                                     child: Icon(Icons.work_history_outlined,size: 50.0,color: Colors.black26,)),
                                 Container(

                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                       children: [
                                         Text("Process Id : ${snapshot.data![index].processId}"),
                                         Text("Process Code : ${snapshot.data![index].processCode}"),
                                         Text("Process Name : ${snapshot.data![index].processName}"),
                                         Container(
                                          // margin: EdgeInsets.symmetric(horizontal: 10.0),

                                           child: ElevatedButton(onPressed:() => connectProcess(snapshot.data![index].processId,userId), child: Text('Connect'),style: ElevatedButton.styleFrom(
                                             backgroundColor: Colors.amber,
                                             elevation: 6.0,
                                             shape: RoundedRectangleBorder(
                                                 borderRadius: BorderRadius.circular(20.0)),

                                           ),
                                           ),
                                         ),
                                       ],
                                     ),
                                 ),


                               ],
                             ),
                           );

                       }
                   );
                 }
               else{
                 return Center(child: CircularProgressIndicator());
               }

            }
          ) ,
        ),
      ),
    );
  }

  connectProcess(int processId, String userId) {

    log(processId.toString()+" "+userId);


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
            onPressed: () => Navigator.pop(context,true),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  LogoutBtn(BuildContext context, String logoutUrl) async {
    try{
      if (await canLaunch(logoutUrl)) {
    await launch(logoutUrl, forceWebView: true);
    } else {
    utils().showError("Could not launch logout url", context);
    }
    await Future.delayed(Duration(seconds: 2));
      shared_pref().removeSharedPreference();
      //Navigator.push(context, MaterialPageRoute(builder: (context) => login_identityserever()));
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => login_identityserever()));
     // login_identityserever();
     //Navigator.pop(context);

    }catch (e)
    {
      utils().showError(e, context);
    }
    closeWebView();
  }

}
