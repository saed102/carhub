
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madaris/bloc/Cubit.dart';
import 'package:madaris/bloc/States.dart';
import 'package:madaris/helper/Consts.dart';
import 'package:madaris/helper/SaveData.dart';
import 'package:madaris/helper/Theme.dart';
import 'package:madaris/screens/Onboarding.dart';
import 'package:madaris/screens/Splash.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
   await CacheHelper.init_shared();

  isLogin= await CacheHelper.getData(key:"isLogin")??false;
  showOnBoarding= await CacheHelper.getData(key:"onBoarding")??true;
  uId= await CacheHelper.getData(key:"uID")??"";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyCubit()..getDataUser(uId),
      child: BlocConsumer<MyCubit, MyState> (
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                scaffoldBackgroundColor: MyTheme.background,
                focusColor:const Color.fromRGBO (254, 114, 76, 1),
                textTheme:
                    TextTheme(headline4: TextStyle(color: Colors.orange[900])),
                primarySwatch: Colors.deepOrange,
              ),
              home: showOnBoarding?  Onboarding():Splash(),
            );
          },
          listener: (context, state) {}),
    );
  }
}





