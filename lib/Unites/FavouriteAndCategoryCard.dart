

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madaris/bloc/Cubit.dart';
import 'package:madaris/bloc/States.dart';
import 'package:madaris/helper/Consts.dart';
import 'package:madaris/helper/Theme.dart';
import 'package:madaris/screens/CarDetails.dart';
import 'package:madaris/screens/InsuranceDetails.dart';

class FavouriteAndCategoryCard extends StatefulWidget {
  Map info;
   FavouriteAndCategoryCard({Key? key,required this.info}) : super(key: key);

  @override
  _FavouriteAndCategoryCardState createState() => _FavouriteAndCategoryCardState();
}

class _FavouriteAndCategoryCardState extends State<FavouriteAndCategoryCard> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyCubit,MyState>(builder: (context, state) {
      return InkWell(
        onTap: () {
          if(widget.info.containsKey("kmDriven")){
            navTo(context, CarDetails(id: widget.info["id"],));

          }else{
            navTo(context, InsuranceDetails(id: widget.info["id"],));
          }

        },
        child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          margin: EdgeInsets.only(bottom: 15),
          height: 130,
          decoration: BoxDecoration(
              color: MyTheme.primaryColor,
              borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            Expanded(
                flex: 15,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              "${widget.info["image"]}"),
                          fit: BoxFit.fill)),
                )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 23,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "${widget.info["name"]}",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyTheme.mainText,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      if(widget.info.containsKey("kmDriven"))
                      Spacer(),
                      if(widget.info.containsKey("kmDriven"))
                      Column(children: [
                        Center(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.all(4),
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(71, 71, 85, 1),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      textAlign: TextAlign.center,

                                      "${widget.info["year"]}",
                                      style: TextStyle(color: MyTheme.mainText),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child:
                                  Container(
                                    margin: EdgeInsets.all(4),
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(71, 71, 85, 1),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      "${widget.info["engine"]}",
                                      style: TextStyle(color: MyTheme.mainText),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Container(
                          child: Center(
                              child: Text(
                                "${widget.info["transmission"]}",
                                style: TextStyle(color: MyTheme.mainText),
                              )),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(71, 71, 85, 1),
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ]),
                    ],
                  ),
                ))
          ]),
        ),
      );
    }, listener:  (context, state){});
  }
}
