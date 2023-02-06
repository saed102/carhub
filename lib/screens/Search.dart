
import 'package:flutter/material.dart';
import 'package:madaris/bloc/Cubit.dart';
import 'package:madaris/helper/Theme.dart';
import 'package:madaris/screens/CarDetails.dart';

import '../helper/Consts.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  getSearchCar(s){
    cars=[];
    MyCubit.get(context).cars.forEach((element) {
         if(element["searchBrand"].startsWith(s) ||element["searchName"].startsWith(s)){
           cars.add(element);
         }
    });
    setState(() {
    });
    print(cars);
    print(cars.length);
  }
  List cars=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          Container(height: 80,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Row(
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

            Expanded(child: Center(child: Text("Search Cars",style: TextStyle(fontSize: 20,color: MyTheme.secondText),))),
            Container(height: 50,width: 50,decoration: BoxDecoration(
                image: DecorationImage(fit: BoxFit.cover, image: NetworkImage("https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=2000")),
                color: MyTheme.secondText,
                borderRadius: BorderRadius.circular(12)
            ),),


          ]),
          ),
          TextFormField(
            onFieldSubmitted: (value) {
              getSearchCar(value.toUpperCase());
            },
            onChanged: (value){
              if(value.isNotEmpty){
                getSearchCar(value.toUpperCase());
              }else{
                cars=[];
                setState(() {

                });
              }

            },
            validator: (value) {

              if(value!.isEmpty){
                return "It shouldn't be empty";
              }
            },
            autofocus: true,
            enabled: true,
            style: TextStyle(fontSize: 20, color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: IconButton(
                  highlightColor: Colors.transparent,
                  splashColor:Colors.transparent ,
                  onPressed: (){}, icon: Icon(Icons.search,color: MyTheme.secondText,)),
              filled: true,
              fillColor: MyTheme.primaryColor,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xffFE724C),
                  ),
                  borderRadius: BorderRadius.circular(15)),
              labelText: "Find for Car or restaurant...",
              labelStyle: TextStyle(color: MyTheme.secondText, fontSize: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          if(cars.isNotEmpty)
          SizedBox(height: 40,child:
          Center(
            child: Text(
              "Found ${cars.length} results",
              style: TextStyle(
                  fontSize: 25, color: MyTheme.secondText),
            ),
          ),
          ),
          Expanded(
            child:cars.isNotEmpty?
            GridView.builder(
              // 2
              //addAutomaticKeepAlives: true,
              itemCount: cars.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.618),
              // padding: EdgeInsets.all(16),
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {

                return InkWell(
                  onTap: () {
                    navTo(context, CarDetails(id: cars[index]["sellersId"]));
                  },
                  child: Container(
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
                                "${cars[index]["image"]}"),
                          )),
                      Expanded(
                          flex: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${cars[index]["name"]}",
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: MyTheme.mainText,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                // const SizedBox(
                                //   height: 10,
                                // ),
                                Spacer(),
                                Column(children: [
                                  Container(

                                    child: Center(
                                        child: Text(
                                          "${cars[index]["year"]} / ${cars[index]["engine"]}",
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
                                          "${cars[index]["transmission"]}",
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
                );

              },
            ):
            Center(
              child: Text(
                "not found any results",
                style: TextStyle(
                    fontSize: 25, color: MyTheme.secondText),
              ),
            ),

          )

        ]),
      ),
    );
  }
}
