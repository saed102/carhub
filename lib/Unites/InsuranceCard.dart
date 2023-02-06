import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madaris/helper/Consts.dart';
import 'package:madaris/helper/Theme.dart';
import 'package:madaris/screens/CarDetails.dart';
import 'package:madaris/screens/InsuranceDetails.dart';

import '../bloc/Cubit.dart';
import '../bloc/States.dart';

class InsuranceCard extends StatefulWidget {
  Map info;

  InsuranceCard({Key? key, required this.info}) : super(key: key);

  @override
  _InsuranceCardState createState() => _InsuranceCardState();
}

class _InsuranceCardState extends State<InsuranceCard> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyCubit, MyState>(
        builder: (context, state) {
          return InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              navTo(
                  context,
                  InsuranceDetails(
                    id: widget.info["id"],
                  ));
            },
            child: Stack(
              children: [
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                      color: MyTheme.primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 12,
                            child: Container(
                              color: Colors.red,
                              child: Image.network(
                                  fit: BoxFit.fill, "${widget.info["image"]}"),
                            )),
                        Expanded(
                            flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
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
                            )),
                      ]),
                ),
              ],
            ),
          );
        },
        listener: (context, state) {});
  }
}
