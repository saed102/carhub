
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madaris/Unites/CarCard.dart';
import 'package:madaris/bloc/Cubit.dart';
import 'package:madaris/bloc/States.dart';
import 'package:madaris/helper/Consts.dart';
import 'package:madaris/helper/Theme.dart';
import 'package:madaris/screens/CarDetails.dart';

class CategoryCars extends StatefulWidget {
  int index;
   CategoryCars({Key? key, required this.index}) : super(key: key);

  @override
  _CategoryCarsState createState() => _CategoryCarsState();
}

class _CategoryCarsState extends State<CategoryCars> {

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        MyCubit.get(context).getCategoryCar(mainCategory[widget.index]["name"]);
        return BlocConsumer<MyCubit, MyState>(
            builder: (context, state) => Scaffold(
              body:state is LoadingState4?Center(child: CircularProgressIndicator()):  body(),
            ), listener: (context, state) {
        });
      }
    );
  }


  Widget body(){
    return Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20,top: 20,bottom: 5),
      child: Column(
        children: [

          header(),
            Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: featuredCars(),
            ),
          ),
        ],
      ),
    );
  }
  Widget header() {
    return Padding(
      padding: const EdgeInsets.only(top: 20,bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
          onTap:(){
    Navigator.pop(context);
    },
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: MyTheme.primaryColor,
          borderRadius: BorderRadius.circular(7),

        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    ),

          Text(
            mainCategory[widget.index]["name"],
            style: TextStyle(
                fontSize: 25, color: MyTheme.mainText),
          ),

          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=2000")),
                color: MyTheme.secondText,
                borderRadius: BorderRadius.circular(12)),
          ),
        ],
      ),
    );
  }
  Widget featuredCars() {
    if(MyCubit.get(context).categoryCar.isNotEmpty){
      return GridView.builder(
        padding: EdgeInsets.only(bottom: 20,top: 20),
        physics: NeverScrollableScrollPhysics(),
        // 2
        //addAutomaticKeepAlives: true,
        itemCount:MyCubit.get(context).categoryCar.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.618),
        // padding: EdgeInsets.all(16),
        //physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return CarCard(info: MyCubit.get(context).categoryCar[index]);
        },
      );
    }
    else{
      return Padding(
        padding: const EdgeInsets.only(top: 200),
        child: Text("No Cars for this Category yet",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: MyTheme.secondText),),
      );
    }

  }
  }

