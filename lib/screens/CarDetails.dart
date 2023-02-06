import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madaris/bloc/Cubit.dart';
import 'package:madaris/bloc/States.dart';
import 'package:madaris/helper/Theme.dart';

class CarDetails extends StatefulWidget {
  String id;

  CarDetails({Key? key, required this.id}) : super(key: key);

  @override
  _CarDetailsState createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  TextEditingController message = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      MyCubit.get(context).getCarInfo(widget.id);
      return BlocConsumer<MyCubit, MyState>(
          builder: (context, state) {
            return Scaffold(
              body: state is LoadingState1
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Stack(
                        fit: StackFit.expand,
                        alignment: Alignment.bottomCenter,
                        children: [
                          SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  topSection(),
                                  title(),
                                  info(
                                    "kmDriven",
                                    "type",
                                  ),
                                  info(
                                    "engine",
                                    "transmission",
                                  ),
                                  info(
                                    "seats",
                                    "brand",
                                  ),
                                  info(
                                    "owner",
                                    "year",
                                  ),
                                  price(),
                                  description(),
                                  const SizedBox(
                                    height: 90,
                                  )
                                ]),
                          ),
                          Positioned(
                              bottom: 0,
                              child: state is LoadingState7
                                  ? const Center(
                                      child: Padding(
                                      padding:
                                          EdgeInsets.only(bottom: 20),
                                      child: CircularProgressIndicator(),
                                    ))
                                  : orderBottom())
                        ],
                      ),
                    ),
            );
          },
          listener: (context, state) {});
    });
  }

  void addMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: AlertDialog(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              actionsAlignment: MainAxisAlignment.end,
              actions: [
                TextButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await MyCubit.get(context).order(
                            MyCubit.get(context).carInfo[0]["id"],
                            MyCubit.get(context).carInfo[0]["order"],
                            MyCubit.get(context).carInfo[0],
                            "Cars",
                            message.text);
                        message.clear();
                        Navigator.pop(context);
                      }
                    },
                    child: Text("OK",
                        style: TextStyle(
                            color: MyTheme.secondText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      message.clear();
                    },
                    child: Text("Cancel",
                        style: TextStyle(
                            color: MyTheme.secondText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
              ],
              backgroundColor: MyTheme.primaryColor,
              alignment: AlignmentDirectional.center,
              scrollable: true,
              title: MyCubit.get(context).isLoading
                  ? Center(
                      child: Padding(
                      padding: const EdgeInsets.all(50),
                      child: CircularProgressIndicator(),
                    ))
                  : Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Form(
                        key: formKey,
                        child: myField(context, "Your Message...", message),
                      ),
                    ),
              elevation: 17,
            ),
          );
        });
  }

  Widget myField(context, label, c) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 9),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "When sending your request, you must pay 2% of the offered amount",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: MyTheme.secondText,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              controller: c,
              maxLines: 10,
              validator: (value) {
                if (value!.isEmpty) {
                  return "It shouldn't be empty";
                }
              },
              style: TextStyle(fontSize: 20, color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(57, 57, 72, 1),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xffFE724C),
                    ),
                    borderRadius: BorderRadius.circular(15)),
                //labelText: label,
                hintText: label,
                hintStyle: TextStyle(color: MyTheme.secondText, fontSize: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topSection() {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      "${MyCubit.get(context).carInfo[0]["image"]}")),
              color: MyTheme.primaryColor,
              borderRadius: BorderRadius.circular(15)),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 37,
                  width: 37,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: MyTheme.primaryColor,
                    ),
                  )),
                ),
              ),
              IconButton(
                  onPressed: () {
                    //print(MyCubit.get(context).cars[widget.index]["favorite"]);
                    MyCubit.get(context).favourite(
                        MyCubit.get(context).carInfo[0]["id"],
                        MyCubit.get(context).carInfo[0]["favorite"],
                        "Cars");
                  },
                  icon: MyCubit.get(context)
                          .carInfo[0]["favorite"]
                          .contains(MyCubit.get(context).dataUser["uid"])
                      ? CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.9),
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ))
                      : CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.9),
                          child: Icon(
                            Icons.favorite_outline,
                            color: Colors.red,
                          ))),
            ],
          ),
        )
      ],
    );
  }

  Widget title() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Text(
        "${MyCubit.get(context).carInfo[0]["name"]}",
        style: TextStyle(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget orderBottom() {
    if (MyCubit.get(context)
        .carInfo[0]["order"]
        .contains(MyCubit.get(context).dataUser["uid"])) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          extendedIconLabelSpacing: 20,
          backgroundColor: Colors.red,
          onPressed: () async {
            await MyCubit.get(context).order(
                MyCubit.get(context).carInfo[0]["id"],
                MyCubit.get(context).carInfo[0]["order"],
                MyCubit.get(context).carInfo[0],
                "Cars",
                "");
            //showLoading();
          },
          label: const Text(
            "Cancel your Request",
            style: TextStyle(
              letterSpacing: 2,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    } else {
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
              child: Icon(Icons.lock, color: MyTheme.mainColor),
            )),
          ),
          extendedIconLabelSpacing: 20,
          backgroundColor: MyTheme.mainColor,
          onPressed: () {
            addMessage();
            //showLoading();
          },
          label: const Text(
            "Order",
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

  Widget info(key, key2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                //textAlign: TextAlign.center,
                "$key: ${MyCubit.get(context).carInfo[0]["$key"]}",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
              SizedBox(
                width: 15,
              ),
              Expanded(
                  child: Text(
                "$key2: ${MyCubit.get(context).carInfo[0]["$key2"]}",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget price() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Text(
        "Price: ${MyCubit.get(context).carInfo[0]["sellingPrice"]}",
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget description() {
    return Text(
      "${MyCubit.get(context).carInfo[0]["description"]}",
      style: TextStyle(color: MyTheme.secondText, fontSize: 16),
    );
  }

  void showLoading() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "No",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    )),
              ],
              actionsAlignment: MainAxisAlignment.end,
              backgroundColor: Colors.white,
              alignment: AlignmentDirectional.center,
              title: const Text("Ara you Want Order this Car?",
                  style: TextStyle(color: Colors.black, fontSize: 17)),
              elevation: 17,
            ),
          );
        });
  }
}
