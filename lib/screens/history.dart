import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madaris/Unites/FavouriteAndCategoryCard.dart';
import 'package:madaris/bloc/Cubit.dart';
import 'package:madaris/bloc/States.dart';
import 'package:madaris/helper/Consts.dart';
import 'package:madaris/helper/Theme.dart';
import 'package:madaris/screens/CarDetails.dart';
import 'package:madaris/screens/favorite.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      MyCubit.get(context).getOrder();
      return BlocConsumer<MyCubit, MyState>(
          builder: (context, state) => Scaffold(
                body: body(state),
              ),
          listener: (context, state) {});
    });
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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [featuredCars(state)]),
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
            "Order",
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
    if (state is LoadingState6) {
      //return Center(child: CircularProgressIndicator());
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
      if (MyCubit.get(context).orderCars.isNotEmpty) {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 100),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: MyCubit.get(context).orderCars.length,
          itemBuilder: (context, index) {
            return Dismissible(
              background: Container(color: Colors.red),
              key: Key("${MyCubit.get(context).orderCars[index]["id"]}"),
              onDismissed: (s) async {
                await MyCubit.get(context). removeOrder(
                    MyCubit.get(context).orderCars[index]["id"]);
              },
              child: FavouriteAndCategoryCard(
                  info: MyCubit.get(context).orderCars[index]),
            );
          },
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(top: 200),
          child: Text(
            "No Orders yet",
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
