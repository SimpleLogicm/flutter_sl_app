
import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class shared_pref{

  Future<String?> getString_SharedprefData(String key) async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   return sharedPreferences.getString(key);

  }

    Future<bool?> getBool_SharedprefData(String key) async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(key);

  }

 Future<int?> getInt_SharedprefData(String key) async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(key);

  }
   Future<double?> getDouble_SharedprefData(String key) async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getDouble(key);

  }
   Future<List?>getListString_SharedprefData(String key) async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList(key);

  }


  Future<void>putBool_Sharedvalue(String key, bool value) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(key, value);
  }

  Future<void> putDouble_Sharedvalue(String key, double value) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     sharedPreferences.setDouble(key, value);
  }

  Future<void> putInt_Sharedvalue(String key, int value) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt(key, value);
  }

  Future<void> putString_Sharedvalue(String key, String value) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     sharedPreferences.setString(key, value);
  }

  Future<void> putStringList_Sharedvalue(String key, List<String> value) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     sharedPreferences.setStringList(key, value);
  }


 void removeSharedPreference() async
 {
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   await sharedPreferences.clear();
   // sharedPreferences.remove(key1);
   // sharedPreferences.remove(key2);
   // sharedPreferences.remove(key3);

 }


}