import 'dart:convert';
import 'dart:developer';


import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart' as components;
import 'package:sl_app/Utils/shared_pref.dart';
import 'package:sl_app/model/filldropdown.dart';

import '../Utils/utils.dart';
import '../model/Savedata.dart';
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

   var proid;
   var pgid;
  var size;
  var pageId ;
  String dropdownvalue = 'Item 1';

  bool isLoading = true;
  late String fileContent ="";
   var rep;


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
   Future<String>? dynamicwidgit;
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
    body: //getview(),//for normal json


      getflutterview(),

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



  void getdashboardui(menuid) {
 pageId = menuid;


 dynamicwidgit = api_call().getflutterdata(processId, pageId);

dynamicwidgit?.then((value) {

  setState(() {
    shared_pref().putInt_Sharedvalue("processId", processId);
    shared_pref().putInt_Sharedvalue("pageId", pageId);

    shared_pref().getInt_SharedprefData("processId").then((value1) {
      shared_pref().getInt_SharedprefData("pageId").then((value2) {
        setState(() {
          proid = value1;
          pgid = value2;
        });
      });
    });


    fileContent = value.toString();
    log(" file response  "+fileContent.toString());
    log("Id before calling widget : ${processId}${pageId}");
    getflutterview();
  });

} );
  }




 Widget getflutterview() {


    return Center(

      child: SingleChildScrollView(
        child:
        fileContent == ""   ? CircularProgressIndicator() :
        ParsedFormProvider(
          create: (_) => JsonFormManager(),
          content: fileContent,
          //'{ "@name": "form", "id": "pageame", "caption": "Page Caption", "children": [ { "@name": "textField", "id": "VendorCode", "label": "Vendor Code", "inputType": "number", "maxLines": "1", "isEditable": { "expression": "1 == 1" }, "isDependant": { "expression": "1 != 1" }, "isVisible": { "expression": "1 == 1" }, "validations": [ { "@name": "requiredValidation", "message": "Vendor Code is required" }, { "@name": "validation", "message": "Vendor Code minumun length require is 10", "isValid": { "expression": "length(@VendorCode) > 10" } }, { "@name": "validation", "message": "Vendor Code max length is 50", "isValid": { "expression": "length(@VendorCode) < 50" } } ] }, { "@name": "textField", "id": "VendorName", "label": "Vendor Name", "inputType": "text", "maxLines": "1", "isEditable": { "expression": "1 == 1" }, "isDependant": { "expression": "1 != 1" }, "isVisible": { "expression": "1 == 1" }, "validations": [ { "@name": "requiredValidation", "message": "Vendor Name is required" }, { "@name": "validation", "message": "Vendor Name minumun length require is 10", "isValid": { "expression": "length(@VendorName) > 10" } }, { "@name": "validation", "message": "Vendor Name max length is 50", "isValid": { "expression": "length(@VendorName) < 50" } } ] }, { "@name": "dropdownButton", "id": "InvoiceType", "label": "Invoice Type", "dependantFields": [], "cascadeFields": { "IsCasacade": "1", "CascadingFieldsID": "SubInvoiceType", "CascadeValue": "SubInvoiceTypeId" }, "isEditable": { "expression": "1 == 1" }, "isDependant": { "expression": "1 == 1" }, "choices": [ { "@name": "dropdownOption", "value": "1", "label": "PO" }, { "@name": "dropdownOption", "value": "2", "label": "NONPO" }, { "@name": "dropdownOption", "value": "3", "label": "Urgent" } ], "isVisible": { "expression": "1 == 1" }, "validations": [ { "@name": "requiredValidation", "message": "Invoice Type is required" } ] }, { "@name": "textField", "id": "PAN", "label": "PAN", "inputType": "text", "maxLines": "1", "isEditable": { "expression": "1 == 1" }, "isDependant": { "expression": "1 != 1" }, "isVisible": { "expression": "1 == 1" }, "validations": [ { "@name": "requiredValidation", "message": "PAN is required" }, { "@name": "validation", "message": "PAN minumun length require is 10", "isValid": { "expression": "length(@PAN) > 10" } }, { "@name": "validation", "message": "PAN max length is 50", "isValid": { "expression": "length(@PAN) < 50" } } ] }, { "@name": "textField", "id": "PONumber", "label": "PO Number", "inputType": "text", "maxLines": "1", "isEditable": { "expression": "1 == 1" }, "isDependant": { "expression": "1 != 1" }, "isVisible": { "expression": "1 == 1" }, "validations": [] }, { "@name": "date", "id": "PODate", "label": "PO Date", "format": "yyyy-MM-dd", "firsDate": "01/01/0001 00:00:00", "lastDate": "12/31/9999 23:59:59", "initialDate": "2023-01-03", "isEditable": { "expression": "1 == 1" }, "isDependant": { "expression": "1 != 1" }, "isVisible": { "expression": "1 == 1" }, "validations": [] }, { "@name": "dropdownButton", "id": "SubInvoiceType", "label": "Sub Invoice Type", "dependantFields": [], "isEditable": { "expression": "1 == 1" }, "isDependant": { "expression": "1 == 1" }, "choices": [ { "@name": "dropdownOption", "value": "po sub type 1", "label": "po sub type 1" }, { "@name": "dropdownOption", "value": "po sub type 2", "label": "po sub type 2" }, { "@name": "dropdownOption", "value": "non po sub type 1", "label": "non po sub type 1" }, { "@name": "dropdownOption", "value": "non po sub type 2", "label": "non po sub type 2" }, { "@name": "dropdownOption", "value": "urgent sub type 1", "label": "urgent sub type 1" }, { "@name": "dropdownOption", "value": "urgent  sub type 2", "label": "urgent  sub type 2" } ], "isVisible": { "expression": "1 == 1" }, "validations": [ { "@name": "requiredValidation", "message": "Sub Invoice Type is required" } ] } ] }',
          parsers: components.getDefaultParserList(),
          child: Column(
            children: [
              FormRenderer<JsonFormManager>(
                renderers: components.getRenderers(),
              ),
              // Using Builder to obtain a BuildContext already containg JsonFormManager
              Builder(
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      child: Text('Submit'),
                      onPressed: () {
                        if( FormProvider.of<JsonFormManager>(context).isFormValid){
                          var formProperties =
                          FormProvider.of<JsonFormManager>(context)
                              .getFormProperties();

                          _submitToServer(context, formProperties);
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("please enter value")));

                        }


                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );



  }



   void _submitToServer(BuildContext context, List<FormPropertyValue> formProperties) {
     // Only showing dialog with the form data for demo purposes

   int j =1;


   // var prosid;
   // var pageid;


   var data = formProperties.map((e) =>
   {'"AutoID":${j++},"FieldID":"${e.id}","FieldValue":"${e.value}"'}).toList();
   var resBody = {};
   resBody['"dtFieldData"'] = data.toString();
   resBody['"mode"'] = '"String"';
   resBody['"pageID"'] = pgid;
   resBody['"autoID"'] = 0;
   resBody['"processId"'] = proid;
   print("responsebody   "+resBody.toString().trim());

  
 


   // showDialog(
   //       context: context,
   //       builder: (context) {
   //         return AlertDialog(
   //           title: Text('Form data'),
   //           content: Container(
   //             width: double.maxFinite,
   //             height: 300.0,
   //             child: ListView(
   //               padding: EdgeInsets.all(8.0),
   //               //map List of our data to the ListView
   //               children: formProperties
   //                   .map((riv) =>
   //                   Text('${riv.id} : ${riv.value}')
   //
   //               )
   //                   .toList(),
   //             ),
   //           ),
   //           actions: <Widget>[
   //             TextButton(
   //               child: Text('Ok'),
   //               onPressed: () {
   //                 Navigator.of(context).pop();
   //               },
   //             )
   //           ],
   //         );
   //       },
   //     );
  //   }


   var res=  api_call().savedata(resBody.toString().trim());
   res.then((value) {
if(value.contains("Success")){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data Submitted Successfully...")));
}else{
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something Went Wrong...")));
}
   });


   }




}
