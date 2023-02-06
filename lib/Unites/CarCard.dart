import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madaris/bloc/Cubit.dart';
import 'package:madaris/bloc/States.dart';
import 'package:madaris/helper/Consts.dart';
import 'package:madaris/helper/Theme.dart';
import 'package:madaris/screens/CarDetails.dart';

class CarCard extends StatefulWidget {
  Map info;
  CarCard({Key? key, required this.info}) : super(key: key);


  @override
  _CarCardState createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyCubit,MyState>(builder: (context, state) {
        return InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {

          navTo(context, CarDetails(id: widget.info["id"],));

        },
        child: Stack(
          children: [
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                  color: MyTheme.primaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    flex: 12,
                    child: Container(
                      color: Colors.red,
                      child: Image.network(
                          fit: BoxFit.fill,
                          "${widget.info["image"]}"),
                    )),
                Expanded(
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                          Spacer(),
                          Column(children: [
                            Container(

                              child: Center(
                                  child: Text(
                                    "${widget.info["year"]} / ${widget.info["engine"]}",
                                    style: TextStyle(color: MyTheme.mainText),
                                  )),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(71, 71, 85, 1),
                                  borderRadius: BorderRadius.circular(5)),
                            ),

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
                    )),
              ]),
            ),
            Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onPressed: (){
                  //print(widget.info["favorite"]);
                  MyCubit.get(context).favourite(widget.info["id"],
                      widget.info["favorite"],"Cars");

                }, icon:
                widget.info["favorite"].contains(MyCubit.get(context).dataUser["uid"])?
                CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: Icon(Icons.favorite,color:Colors.red,)):
                CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: Icon(Icons.favorite_outline,color: Colors.red,))
                ))
          ],
        ),
      );
    }, listener:  (context, state){});
  }
}
