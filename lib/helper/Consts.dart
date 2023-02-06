
import 'package:flutter/material.dart';
int currentLang=0;
String uId="";
bool isLogin=false;
bool showOnBoarding=true;
List mainCategory=[
  {"name":"Sport","image":"assets/images/Sport.png"},
  {"name":"Sedan","image":"assets/images/Sedan.png"},
  {"name":"Hatchback","image":"assets/images/Hatchback.png"},
  {"name":"SUV","image":"assets/images/Suv.png"},
  {"name":"Cabriolet","image":"assets/images/Cabriolet.png"},
  {"name":"Coupe","image":"assets/images/Coupe.png"},
];


 navTo(context,page){
 Navigator.push(context, MaterialPageRoute(builder:(context) => page, ));
 }

navAndKaill(context,page){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) => page,), (route) => false);
}


showMessage(context,ms,backGround){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: backGround,
      content: Row(
        children:  [
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              ms,
            ),
          ),
        ],
      )));

}