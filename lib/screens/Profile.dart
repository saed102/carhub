import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madaris/bloc/Cubit.dart';
import 'package:madaris/bloc/States.dart';
import 'package:madaris/helper/Consts.dart';
import 'package:madaris/helper/Theme.dart';
import 'package:madaris/screens/EditProfile.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        MyCubit.get(context).getFavouriteCars();
        MyCubit.get(context).getOrder();
        MyCubit.get(context).getDataUserasStream(MyCubit.get(context).dataUser["uid"]);
        return BlocConsumer<MyCubit, MyState>(
            builder: (context, state) {
              return Scaffold(
                body: Stack(
                  children: [
                    background(context),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              topSection(),
                              info(),
                              Divider(
                                color: MyTheme.secondText,
                                height: 1,
                                thickness: 0.5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                          MyTheme.mainColor)),
                                  onPressed: () {
                                    navTo(context, const EditProfile());
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Edit Profile",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
              );
            },
            listener: (context, state) {});
      }
    );
  }

  Widget background(context) {
    return Stack(
      children: [
        Positioned(
          top: -21,
          left: -42,
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              // color: ,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xffFE724C), width: 25),
            ),
          ),
        ),
        Positioned(
          top: -99,
          left: -5,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffFFECE7),
            ),
          ),
        ),
        Positioned(
          top: -109,
          right: -104,
          child: Container(
            height: 181,
            width: 181,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffFE724C),
            ),
          ),
        ),
      ],
    );
  }

  Widget topSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 60.0, bottom: 10),
          child: CircleAvatar(
            backgroundColor: MyTheme.secondText,
            maxRadius: 55,
            foregroundImage:
            NetworkImage("${ MyCubit.get(context).dataUser["image"]}"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            "${MyCubit.get(context).dataUser["name"]}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, color: MyTheme.mainText),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Text(
            "${MyCubit.get(context).dataUser["phone"]}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: MyTheme.secondText),
          ),
        ),
      ],
    );
  }

  Widget info() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, right: 50, left: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              MyCubit.get(context).changeNavBar(3);
            },
            child: Column(
              children: [
                Text(
                  "${MyCubit.get(context).favouriteCars.length}",
                  style: TextStyle(
                      color: MyTheme.secondText,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
                Text(
                  "Favourite",
                  style: TextStyle(color: MyTheme.secondText),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              MyCubit.get(context).changeNavBar(2);
            },
            child: Column(
              children: [
                Text(
                  "${MyCubit.get(context).orderCars.length}",
                  style: TextStyle(
                      color: MyTheme.secondText,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.car_repair,
                    color: MyTheme.mainColor,
                    size: 30,
                  ),
                ),
                Text(
                  "Orders",
                  style: TextStyle(color: MyTheme.secondText),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
