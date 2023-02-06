import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madaris/Unites/FavouriteAndCategoryCard.dart';
import 'package:madaris/bloc/Cubit.dart';
import 'package:madaris/bloc/States.dart';
import 'package:madaris/helper/Theme.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        MyCubit.get(context).getFavouriteCars();
        return BlocConsumer<MyCubit, MyState>(
            builder: (context, state) => Scaffold(
              body: body(state),
            ),
            listener: (context, state) {});
      }
    );

  }

  Widget body(state) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 5),
      child: Column(
        children: [
          header(),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(children: [featuredCars(state)]),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            "Favorites",
            style: TextStyle(fontSize: 25, color: MyTheme.mainText),
          ),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                image: MyCubit.get(context).dataUser.isNotEmpty
                    ? DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            MyCubit.get(context).dataUser["image"]))
                    : null,
                color: MyTheme.secondText,
                borderRadius: BorderRadius.circular(12)),
          ),
        ],
      ),
    );
  }

  Widget featuredCars(state) {
    if (state is LoadingState5) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 20,
        itemBuilder: (context, index) {
          return Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            margin: EdgeInsets.only(bottom: 15),
            height: 130,
            decoration: BoxDecoration(
                color: MyTheme.primaryColor,
                borderRadius: BorderRadius.circular(10)),
          );
        },
      );
    } else {
      if (MyCubit.get(context).favouriteCars.isNotEmpty) {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 100),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: MyCubit.get(context).favouriteCars.length,
          itemBuilder: (context, index) {
            return Dismissible(
              background: Container(color: Colors.red),
              key: Key("${MyCubit.get(context).favouriteCars[index]["id"]}"),
              onDismissed: (s) {
                MyCubit.get(context).removeFavourite(
                    MyCubit.get(context).favouriteCars[index]["id"]);
              },
              child: FavouriteAndCategoryCard(
                  info: MyCubit.get(context).favouriteCars[index]),
            );
          },
        );
      }
      else {
        return Padding(
          padding: const EdgeInsets.only(top: 200),
          child: Text(
            "No Favourite yet",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: MyTheme.secondText),
          ),
        );
      }
    }
  }
}
