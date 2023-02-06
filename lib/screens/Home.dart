import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madaris/Unites/CarCard.dart';
import 'package:madaris/bloc/Cubit.dart';
import 'package:madaris/bloc/States.dart';
import 'package:madaris/helper/Consts.dart';
import 'package:madaris/helper/Theme.dart';
import 'package:madaris/screens/CategoryCars.dart';
import 'package:madaris/screens/Search.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey();

    return Builder(
      builder: (context) {
        MyCubit.get(context).getCars();
        return BlocConsumer<MyCubit, MyState>(
            builder: (context, state) => Scaffold(
                body: body()), listener: (context, state) {});
      }
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 5),
      child: Column(
        children: [
          header(),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    searchField(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(
                        "Category",
                        style: TextStyle(fontSize: 22, color: MyTheme.mainText),
                      ),
                    ),
                    category(),
                    InkWell(
                      onTap: () {
                        MyCubit.get(context).signInWithGoogle();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          "All Cars",
                          style: TextStyle(fontSize: 22, color: MyTheme.mainText),
                        ),
                      ),
                    ),
                    featuredCars()
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        mainAxisAlignment:MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
             MyCubit.get(context).openDrawer();
            },
            child: Container(
              height: 37,
              width: 37,
              decoration: BoxDecoration(
                color: MyTheme.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //SizedBox(height: 10,),
                  Divider(
                    thickness: 2,
                    height: 2,
                    color: MyTheme.mainText,
                    indent: 10,
                    endIndent: 10,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    thickness: 3,
                    height: 2,
                    color: MyTheme.mainText,
                    indent: 10,
                    endIndent: 15,
                  ),
                ],
              ),
            ),
          ),
          Text(
            "CarHub",
            style: TextStyle(fontSize: 25, color: MyTheme.mainText),
          ),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                image:MyCubit.get(context).dataUser.isNotEmpty? DecorationImage(
                    fit: BoxFit.cover,
                    image:
                        NetworkImage(MyCubit.get(context).dataUser["image"])):null,
                color: MyTheme.secondText,
                borderRadius: BorderRadius.circular(12)),
          ),
        ],
      ),
    );
  }





  Widget searchField() {
    return InkWell(
      onTap: () {
        navTo(context, Search());
      },
      child: TextFormField(
        onTap: () {},
        enabled: false,
        style: const TextStyle(fontSize: 20, color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: MyTheme.secondText,
              )),
          filled: true,
          fillColor: Color.fromRGBO(57, 57, 72, 1),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelText: "Find for Car or restaurant...",
          labelStyle: TextStyle(color: MyTheme.secondText, fontSize: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget category() {
    return SizedBox(
      height: 110,
      child:
      ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: mainCategory.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              navTo(context, CategoryCars(index: index,));
            },
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: EdgeInsets.only(right: 12),
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                  color: MyTheme.primaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      child: Image.asset("${mainCategory[index]["image"]}",
                          fit: BoxFit.cover,
                          ),
                    )),
                Expanded(
                    child: Container(
                  child: Center(
                      child: Text(
                        "${mainCategory[index]["name"]}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: MyTheme.mainText),
                  )),
                )),
              ]),
            ),
          );
        },
      ),
    );
  }

  Widget featuredCars() {
    if(MyCubit.get(context).cars.isNotEmpty){
      return GridView.builder(
        padding: EdgeInsets.only(bottom: 100,top: 20),
        physics: NeverScrollableScrollPhysics(),
        // 2
        //addAutomaticKeepAlives: true,
        itemCount: MyCubit.get(context).cars.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.618),
        // padding: EdgeInsets.all(16),
        //physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return CarCard(info: MyCubit.get(context).cars[index]);
        },
      );
    }else{
      return GridView.builder(
        padding: EdgeInsets.only(bottom: 100,top: 20),
        physics: NeverScrollableScrollPhysics(),
        // 2
        //addAutomaticKeepAlives: true,
        itemCount: 21,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.618),
        // padding: EdgeInsets.all(16),
        //physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return             Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
                color: MyTheme.primaryColor,
                borderRadius: BorderRadius.circular(10)),

          );
        },
      );
    }

  }
}


