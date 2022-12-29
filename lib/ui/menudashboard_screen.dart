import 'dart:developer';


import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:sl_app/Utils/shared_pref.dart';
import 'package:sl_app/model/filldropdown.dart';

import '../Utils/utils.dart';
import '../model/dashboard_submenues.dart';
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
   List<TextEditingController> _controllers = [];

  final int userId;
  final int processId;
  var size;
   var pageId ;
   String dropdownvalue = 'Item 1';

   // List of items in our dropdown menu
   var items = [
     'Item 1',
     'Item 2',
     'Item 3',
     'Item 4',
     'Item 5',
   ];

   // List of items in our dropdown menu
  List<Filldropdown> dropdownItemList = [
     // {'label': 'apple', 'value': 'apple'}, // label is required and unique
     // {'label': 'banana', 'value': 'banana'},
     // {'label': 'grape', 'value': 'grape'},
     // {'label': 'pineapple', 'value': 'pineapple'},
     // {'label': 'grape fruit', 'value': 'grape fruit'},
     // {'label': 'kiwi', 'value': 'kiwi'},
   ];

  late Future<List<List<roalwisemenue>>> roalmenuDetails;
   Future<List<dashboard_submenues>>? dashboardsubmenu  ;
   Future<List<Filldropdown>>? dropdowndata  ;
  late List<dynamic> showwidgit =[];
   var listlength ;

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
      roalmenuDetails.then((value) {
        log("Init Call : ${value.length}");
        size = value[0].length;
        log("Size : ${size}");
      }
      );


    }
    catch (e)
    {
      log(e.toString());
      utils().showError(e, context);
    }

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(appBar: AppBar(
      backgroundColor: Colors.amberAccent,
    ),
    body: getview(),


      drawer: Drawer(



          child: Column(
            children: [
          DrawerHeader(

            child: Text(useremail != "" ? useremail.toString() : "User email not found",
            style: TextStyle(color:Colors.black),),


            decoration: BoxDecoration(color: Colors.amberAccent),


          ),


              FutureBuilder<List<List<roalwisemenue>>>(
                future: roalmenuDetails,
               builder: (BuildContext context, snapshot){
                 log(snapshot.data.toString());
                 log(size.toString());
                 if(snapshot.hasData){

                   return ListView.builder(
                       scrollDirection: Axis.vertical,
                       shrinkWrap: true,

                     itemCount: size,
                       itemBuilder: (BuildContext context, int index) {


                             return ExpansionTile(
                               title: Text(snapshot.data![0][index].menuheader,style: TextStyle(fontSize: 15.0),),
                               children: <Widget>[
                                 ExpansionTile(title: Text(snapshot.data![1][index].menuname),

                                 children: [

                                   Container(
                                     alignment: Alignment.centerLeft,
                                       child: Padding(
                                         padding: const EdgeInsets.all(15.0),
                                         child: InkWell(child: Text(snapshot.data![2][index].menuname),
                                         onTap: (){
                                     //      debugPrint("pressed ${snapshot.data![2][index].menuname}");

                                           getdashboardui(snapshot.data![2][index].menuid);
                                           Navigator.pop(context);

                                         },)
                                         ,
                                       )
                                   ),

                                   ],)
                               ],
                             );







                       }


                   );
                 }else{
                   return Center(child: CircularProgressIndicator());
                 }

      }

              ),
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



      ],


    );


  }

  void getdashboardui(menuid) {
 pageId = menuid;

// log(pageId.toString());
// log(processId.toString());
    dashboardsubmenu = api_call().getdashboard_menuclick(processId, pageId);




    dashboardsubmenu?.then((value) => {
      listlength = value.length,

      setState(() {
    getview();
      }),

     // log(value[0].fieldType.toString()),
    //  log(listlength.toString()),

   value.forEach((element) {
    // log(element.fieldType);
     showwidgit.add(element.fieldType);

   }),
   //   print(showwidgit),



    });




  }

 Widget getview() {

    return  Container(
      child:  Column(
        children: [
          FutureBuilder<List<dashboard_submenues>>(
            future: dashboardsubmenu ,
            builder: (BuildContext context,snapshot){
              if(snapshot.hasData){
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: listlength,
                    itemBuilder: (BuildContext context, int index) {
                      if(snapshot.data![index].fieldType == "textbox"){
                        final controller = TextEditingController();
                        _controllers.add(controller);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller:  controller,
                            obscureText: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: snapshot.data![index].label,
                              hintText: 'Enter ${snapshot.data![index].label}',
                            ),
                          ),
                        );

                      }else if(snapshot.data![index].fieldType=="dropdown"){
                        getspinnerdata(snapshot.data![index].fieldId,snapshot.data![index].fieldMappingId);

                      return  Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(

                            padding: const EdgeInsets.all(8.0),

                            child:

                            // CoolDropdown(
                            //   resultWidth: MediaQuery.of(context).size.width,
                            //   dropdownWidth: MediaQuery.of(context).size.width/1.5,
                            //   dropdownList: dropdownItemList,
                            //
                            //   onChange: (selectedItem) {
                            //     print(selectedItem[0].toString());
                            //     setState(() {
                            //       dropdownvalue= selectedItem;
                            //     });
                            //   },
                            //   // defaultValue: dropdownItemList[0],
                            // ),

                            DropdownButton(

                              value: dropdownvalue,

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: dropdownItemList .map((dynamic items) {
                          return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                          );
                          }).toList(),

                             onChanged: (a){
                                print(a);
                             },
                            ),





                          ),
                        ),
                      );
                      }else {

                      }
                      return SizedBox();

                    });
              }else{
                return  Center(child: Text(""),);
              }
            },
          ),
          ElevatedButton(onPressed: (){


            // showDialog(
            //   context: context,
            //   builder: (context) {
            //     return AlertDialog(
            //       // Retrieve the text the that user has entered by using the
            //       // TextEditingController.
            //
            //       content: Text(_controllers.toString()),
            //     );
            //   },
            // );

            setState(() {
              List etans = [];
              _controllers.forEach((element) {


                etans.add(element.text);

                print(element.text);

          //      print(dropdownvalue);

              });
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.

                    content: Text(etans.toString()),
                  );
                },
              );



              _controllers.clear();




              // SimpleDialog(
              //   title:const Text('GeeksforGeeks'),
              //   children: <Widget>[
              //     SimpleDialogOption(
              //       onPressed: () { },
              //       child:const Text('Option 1'),
              //     ),
              //     SimpleDialogOption(
              //       onPressed: () { },
              //       child: const Text('Option 2'),
              //     ),
              //   ],
              // );



            });
          },
              child: Text("Save"),


          )
        ],
      ),


    );


  }

  void getspinnerdata(fieldId, fieldMappingId) {


    dropdowndata = api_call().getdropdowndata(processId, pageId, fieldMappingId, fieldId);

    dropdowndata?.then((value)=> {



      dropdownItemList.clear(),
      for(int i =0 ; i < value.length ; i++){
        debugPrint(value[i].text),

    //     dropdownItemList.add(
    // {
    //   'label': '${value[i].text}',
    //   'value': '${value[i].value}'
    // }
    //     )
    //   },
    
    dropdownItemList.add(Filldropdown(text: value[i].text, value: value[i].value)),


      debugPrint(dropdownItemList.toString()),

    }

  });
    print("object  spinner data api");

  }


}
