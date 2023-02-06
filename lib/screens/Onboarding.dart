import 'package:flutter/material.dart';
import 'package:madaris/helper/Consts.dart';
import 'package:madaris/helper/SaveData.dart';
import 'package:madaris/helper/Theme.dart';
import 'package:madaris/screens/login.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  List images=[
    AssetImage("assets/images/Onboarding One.png"),
    AssetImage("assets/images/Onboarding Two.png"),
    AssetImage("assets/images/Onboarding Three.png"),
  ];
  int index=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(flex: 4, child: Container(
          margin: EdgeInsets.only(top: 50),
          decoration:  BoxDecoration(
              image: DecorationImage(fit: BoxFit.fill, image: images[index])
          ),
        )),
        Expanded(
            child: Container(
          child: Center(
            child: FloatingActionButton(
              backgroundColor: MyTheme.mainColor,
              onPressed: () async{
                if(index==2){
                  await CacheHelper.saveData(key: "onBoarding", value: false);
                        navTo(context, Login());
                }else{
                  setState(() {
                    index++;
                  });
                }

              },
              child: Icon(Icons.arrow_forward_sharp),
            ),
          ),
        )),
      ]),
    );
  }
}
