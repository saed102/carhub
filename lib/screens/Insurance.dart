

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madaris/Unites/InsuranceCard.dart';
import 'package:madaris/bloc/Cubit.dart';
import 'package:madaris/bloc/States.dart';
import 'package:madaris/helper/Theme.dart';

class Insurance extends StatefulWidget {
  const Insurance({Key? key}) : super(key: key);

  @override
  _InsuranceState createState() => _InsuranceState();
}

class _InsuranceState extends State<Insurance> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
       MyCubit.get(context).getInsurance();
        return BlocConsumer<MyCubit, MyState>(
            builder: (context, state) => Scaffold(
              body: body(state),
            ), listener: (context, state) {
        });
      }
    );
  }

  Widget body(state) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20,top: 20,bottom: 5),
      child: Column(
        children: [

          header(),

          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    featuredCars(state)
                  ]),
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
                children:  [
                  //SizedBox(height: 10,),
                  Divider( thickness: 2, height: 2,color: MyTheme.mainText,indent: 10,endIndent: 10,),
                  SizedBox(height: 5,),
                  Divider( thickness: 3, height: 2,color: MyTheme.mainText,indent: 10,endIndent: 15,),


                ],
              ),
            ),
          ),
          Text(
            "Insurance",
            style: TextStyle(
                fontSize: 25, color: MyTheme.mainText),
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

  Widget featuredCars(state) {
    if(state is LoadingState3){
      return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        // 2
        //addAutomaticKeepAlives: true,
        itemCount: MyCubit.get(context).insurance.length,
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.618),
        // padding: EdgeInsets.all(16),
        //physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InsuranceCard(info: MyCubit.get(context).insurance[index]);
        },
      );
    }else{
      if(MyCubit.get(context).insurance.isNotEmpty){
        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          // 2
          //addAutomaticKeepAlives: true,
          itemCount: MyCubit.get(context).insurance.length,
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.618),
          // padding: EdgeInsets.all(16),
          //physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InsuranceCard(info: MyCubit.get(context).insurance[index]);
          },
        );
      }else{
        return Padding(
          padding: const EdgeInsets.only(top: 200),
          child: Text(
            "No Insurance yet",
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
