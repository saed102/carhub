import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madaris/bloc/Cubit.dart';
import 'package:madaris/bloc/States.dart';
import 'package:madaris/helper/Theme.dart';

class InsuranceDetails extends StatefulWidget {
  String id;

  InsuranceDetails({Key? key, required this.id}) : super(key: key);

  @override
  _InsuranceDetailsState createState() => _InsuranceDetailsState();
}

class _InsuranceDetailsState extends State<InsuranceDetails> {
  TextEditingController message = TextEditingController();
  var formKey=GlobalKey<FormState>();
  @override
  void initState() {
    MyCubit.get(context).setViwersInsurance(widget.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Builder(
      builder: (context) {
        MyCubit.get(context).getInsuranceInfo(widget.id);
        return BlocConsumer<MyCubit, MyState>(
            builder: (context, state) {
              return Scaffold(
                body: state is LoadingState2?
                const Center(child: CircularProgressIndicator()):
                Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              topSection(),
                              title(),

                              description(),
                              const SizedBox(height: 90,)
                            ]),
                      ),
                    ),
                    Positioned(
                        bottom: 30,
                        child:  state is LoadingState7
                            ? Center(
                            child: Padding(
                              padding:
                              const EdgeInsets.only(bottom: 20),
                              child: CircularProgressIndicator(),
                            ))
                            : orderBottom())

                  ],
                ),
              );
            },
            listener: (context, state) {});
      }
    );

  }

  void addMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: AlertDialog(clipBehavior:Clip.antiAliasWithSaveLayer ,
              actionsAlignment: MainAxisAlignment.end,
              actions: [
                TextButton(
                    onPressed: () async {
                      if(formKey.currentState!.validate()){
                        await MyCubit.get(context).order(
                            MyCubit.get(context).insuranceInfo[0]["id"],
                            MyCubit.get(context).insuranceInfo[0]["order"],
                            MyCubit.get(context).insuranceInfo[0],"Insurance",message.text);
                        message.clear();
                        Navigator.pop(context);
                      }
                    },
                    child:  Text("OK",
                        style: TextStyle(
                            color: MyTheme.secondText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      message.clear();
                    },
                    child:  Text("Cancel",
                        style:  TextStyle(
                            color: MyTheme.secondText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
              ],
              backgroundColor: MyTheme.primaryColor,
              alignment: AlignmentDirectional.center,
              scrollable: true,
              title:MyCubit.get(context).isLoading?Center(child: Padding(
                padding: const EdgeInsets.all(50),
                child: CircularProgressIndicator(),
              )):   Padding(
                padding: EdgeInsets.all(10.0),
                child: Form(
                  key: formKey,
                  child: myField(context, "Your Message...",
                      message),
                ),
              )
              ,
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
              maxLines: 10 ,
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
                  image: NetworkImage("${MyCubit.get(context).insuranceInfo[0]["image"]}")),
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
        "${MyCubit.get(context).insuranceInfo[0]["name"]}",
        style: TextStyle(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }
  Widget orderBottom() {
    if (MyCubit.get(context)
        .insuranceInfo[0]["order"]
        .contains(MyCubit.get(context).dataUser["uid"])) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          extendedIconLabelSpacing: 20,
          backgroundColor: Colors.red,
          onPressed: () async {
            await MyCubit.get(context).order(
                MyCubit.get(context).insuranceInfo[0]["id"],
                MyCubit.get(context).insuranceInfo[0]["order"],
                MyCubit.get(context).insuranceInfo[0],
                "Insurance","");
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
  Widget description() {
    return Text(
      "${MyCubit.get(context).insuranceInfo[0]["Description"]}",
      style: TextStyle(color: MyTheme.secondText, fontSize: 16),
    );
  }


}
