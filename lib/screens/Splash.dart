import 'dart:async';

import 'package:flutter/material.dart';
import 'package:madaris/helper/Consts.dart';
import 'package:madaris/helper/Theme.dart';
import 'package:madaris/screens/MainPage.dart';
import 'package:madaris/screens/login.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => isLogin? MyHomePage():Login(),
        ),
        (route) => false,
      );
      timer.cancel();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: MyTheme.mainColor,
              image: DecorationImage(fit: BoxFit.cover, image: AssetImage("assets/images/Splash .png"))
            ),

          ),
        ],
      ),
    );
  }
}
