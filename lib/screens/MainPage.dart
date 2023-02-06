import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madaris/bloc/Cubit.dart';
import 'package:madaris/bloc/States.dart';
import 'package:madaris/helper/Theme.dart';
import 'package:madaris/screens/Home.dart';
import 'package:madaris/screens/Insurance.dart';
import 'package:madaris/screens/Profile.dart';
import 'package:madaris/screens/favorite.dart';
import 'package:madaris/screens/history.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List pages = [
    Home(),
    Insurance(),
    History(),
    Favorite(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyCubit, MyState>(
        builder: (context, state) {
          return Scaffold(
              body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Row(children: [
                Expanded(
                    flex: 15,
                    child: Container(
                      padding: EdgeInsets.only(top: 60, bottom: 20),
                      color: MyTheme.background,
                      child: myDrawer(state),
                    )),
                Spacer(
                  flex: 12,
                ),
              ]),
              TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: MyCubit.get(context).v),
                  duration: Duration(
                    milliseconds: 500,
                  ),
                  builder: (_, double v, __) {
                    return (Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, -0.001)
                        ..setEntry(0, 3, -200 * v)
                        ..rotateY((pi / 6) * v),
                      child: GestureDetector(
                          onHorizontalDragUpdate: (e) {
                            if (e.delta.dx < 0) {
                              //MyCubit.get(context).openDrawer();
                            } else {
                              //HomeCubit.get(context).clps();
                            }
                          },
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              pages[MyCubit.get(context).currentIndex],
                              navBar(),
                            ],
                          )),
                    ));
                  }),
              //pages[MyCubit.get(context).currentIndex],
            ],
          ));
        },
        listener: (context, state) {});
  }

  Widget orderBottom(state) {
    if(state is SignOutState){
      return Center(child: CircularProgressIndicator());
    }else{
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          icon: Container(
            height: 37,
            width: 37,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              //borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Icon(Icons.logout, color: MyTheme.mainColor),
                )),
          ),
          extendedIconLabelSpacing: 10,
          backgroundColor: MyTheme.mainColor,
          onPressed: () async{
           await MyCubit.get(context).signOut(context);
            MyCubit.get(context).closeDrawer();
            //showLoading();
          },
          label: const Text(
            "Logout",
            style: TextStyle(
              letterSpacing: 2,
              fontSize: 23,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }


  }


  Widget navBar() {
    return Positioned(
      child: Container(
        margin: EdgeInsets.only(
          bottom: 30,
          left: 20,
          right: 20,
        ),
        height: 60,
        decoration: BoxDecoration(
            color: MyTheme.primaryColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 1.5),
                  blurRadius: 2)
            ]),
        child: Row(children: [
          navBarItem(Icons.home, 0),
          navBarItem(Icons.account_balance_wallet, 1),
          navBarItem(Icons.history, 2),
          navBarItem(Icons.favorite, 3),
          navBarItem(Icons.person, 4),
        ]),
      ),
    );
  }

  Widget navBarItem(icon, index) {
    return Expanded(
      flex: MyCubit.get(context).currentIndex == index ? 15 : 10,
      child: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () {
          MyCubit.get(context).changeNavBar(index);
        },
        icon: Icon(
          icon,
          color: MyCubit.get(context).currentIndex == index
              ? MyTheme.mainColor
              : MyTheme.secondText,
          size: MyCubit.get(context).currentIndex == index ? 30 : 22,
        ),
      ),
    );
  }

  Widget drawerItem(title,icon,fc) {
    return ListTile(
      onTap: fc,
      leading: Icon(
        icon,
        size: 30,
        color: MyTheme.mainColor,
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 20,
            color: MyTheme.secondText,
            fontWeight: FontWeight.w700),
      ),
    );
  }

 Widget myDrawer(state) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            maxRadius: 50,
            foregroundImage: NetworkImage(
                "${MyCubit.get(context).dataUser["image"]}"),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${MyCubit.get(context).dataUser["name"]}",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 25, color: MyTheme.mainText),
          ),
          SizedBox(
            height: 20,
          ),
          drawerItem("Profile",Icons.person,(){
            MyCubit.get(context).closeDrawer();
            MyCubit.get(context).changeNavBar(4);
          }), drawerItem("Insurance",Icons.account_balance_wallet_rounded,(){
            MyCubit.get(context).closeDrawer();
            MyCubit.get(context).changeNavBar(1);
          }),
          drawerItem("Favourite",Icons.favorite,(){
            MyCubit.get(context).closeDrawer();

            MyCubit.get(context).changeNavBar(3);
          }),
          drawerItem("History",Icons.history,(){
            MyCubit.get(context).closeDrawer();
            MyCubit.get(context).changeNavBar(2);
          }),

          Spacer(),
          orderBottom(state)
        ]);
  }
}
