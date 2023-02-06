


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madaris/bloc/Cubit.dart';
import 'package:madaris/bloc/States.dart';
import 'package:madaris/helper/Theme.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyCubit, MyState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                background(context),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0,right: 20,left: 20),
                  child: Center(
                    child:
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            topSection(),
                            Divider(
                              color: MyTheme.secondText,
                              height: 1,
                              thickness: 0.5,
                            ),
                            SizedBox(height: 15,),
                            myField(context, "Name", "Enter New Name",name),
                            myField(context, "Phone", "Enter New Phone",phone),
                            myField(context, "Password", "Enter New Password",password),

                            state is LoadingupdateDataUserState? Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: CircularProgressIndicator()),
                            ):
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        MyTheme.mainColor)),
                                onPressed: () {
                                  MyCubit.get(context).updateDataUser(name.text, phone.text, password.text,context);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 90,)
                          ]),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 42,
                    horizontal: 27,
                  ),
                  child: Container(
                    height: 38,
                    width: 38,
                    //color: Colors.red,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(),
                            primary: MyTheme.background,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            )),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Colors.white,
                        )),
                  ),
                ),

              ],
            ),
          );
        },
        listener: (context, state) {});
  }

  Widget background(context) {
    return Stack(
      children: [
        Positioned(
          top: -21,
          left: -42,
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              // color: ,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xffFE724C), width: 25),
            ),
          ),
        ),
        Positioned(
          top: -99,
          left: -5,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffFFECE7),
            ),
          ),
        ),
        Positioned(
          top: -109,
          right: -104,
          child: Container(
            height: 181,
            width: 181,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffFE724C),
            ),
          ),
        ),
      ],
    );
  }

  Widget topSection() {
    return Column(
      children: [
        Stack(
          children: [
            MyCubit.get(context).profileImage==null?   Padding(
              padding: const EdgeInsets.only(top: 60.0, bottom: 10),
              child: CircleAvatar(
                backgroundColor: MyTheme.secondText,
                maxRadius: 55,
                foregroundImage:
                NetworkImage("${MyCubit.get(context).dataUser["image"]}"),
              ),
            ): Padding(
              padding: const EdgeInsets.only(top: 60.0, bottom: 10),
              child: CircleAvatar(
                backgroundColor: MyTheme.secondText,
                maxRadius: 55,
                foregroundImage:
                FileImage(MyCubit.get(context).profileImage!),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  MyCubit.get(context).getProfileImage();
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  maxRadius: 16,
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.black,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            "${MyCubit.get(context).dataUser["name"]}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, color: MyTheme.mainText),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Text(
            "${MyCubit.get(context).dataUser["phone"]}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: MyTheme.secondText),
          ),
        ),
      ],
    );
  }

  Widget info() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, right: 50, left: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                "${MyCubit.get(context).favouriteCars.length}",
                style: TextStyle(
                    color: MyTheme.secondText,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              Text(
                "Favourite",
                style: TextStyle(color: MyTheme.secondText),
              )
            ],
          ),
          Column(
            children: [
              Text(
                "${MyCubit.get(context).orderCars.length}",
                style: TextStyle(
                    color: MyTheme.secondText,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.car_repair,
                  color: MyTheme.mainColor,
                  size: 30,
                ),
              ),
              Text(
                "Orders",
                style: TextStyle(color: MyTheme.secondText),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget myField(context, title, label,c ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 9),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: MyTheme.secondText,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: c,
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
  }}
