import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madaris/bloc/Cubit.dart';
import 'package:madaris/bloc/States.dart';
import 'package:madaris/helper/Theme.dart';


class ForgetPassword extends StatelessWidget {
TextEditingController email=TextEditingController();
  @override
  Widget build(BuildContext context) {
   return BlocConsumer<MyCubit,MyState>(builder: (context, state) {
      return Scaffold(
        body: Stack(

          children: [
            RegistrationBackGround(
                context// Screen background color
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(height: 35,),
                    Padding(
                      padding: EdgeInsets.only(left: 26, top: 114, right: 53),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "Resset Password",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600, fontSize: 38),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 26, top: 25, right: 113),
                      child: Container(
                        height: 29,
                        width: MediaQuery.of(context).size.width,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            textAlign: TextAlign.start,
                            "Please enter your email address to\nrequest a password reset",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: MyTheme.secondText),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 38,
                    ),
                    myField(context, "Enter Your Email",email),
                    SizedBox(
                      height: 58,
                    ),
                    state is loadingresetPasswordState?
                    Center(child: CircularProgressIndicator()):
                    myBottom(context, "Resset Password"),
                    SizedBox(
                      height: 58,
                    ),
                    if( state is resetPasswordState)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Please chick your email address to reset your password",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.green),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
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
                      child: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: Colors.white,
                      )),
                ),
              ),
            ),

          ],
        ),
      );
    }, listener: (context, state){});
  }
  Widget myField(context,label,c){
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 26,vertical: 9),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: TextFormField(
          controller: c,
          keyboardType:TextInputType.emailAddress ,
          style: TextStyle(fontSize: 20,color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color.fromRGBO(57, 57, 72, 1),
            floatingLabelBehavior:
            FloatingLabelBehavior.never,
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xffFE724C),
                ),
                borderRadius:
                BorderRadius.circular(15)),
            labelText: label,
            labelStyle: TextStyle( color: MyTheme.secondText,fontSize: 16),
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );

  }

  Widget myBottom(context,title){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 65),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: Color(0xffFE724C).withOpacity(0.6),
                blurRadius: 4,
                spreadRadius: 1,
                offset: Offset(1, 2),
              ),
            ]),
        child: ElevatedButton(
          onPressed: ()async {
               await MyCubit.get(context).resetPassword(email.text, context);
          },
          style: ElevatedButton.styleFrom(
              shadowColor: Color(0xffFE724C),
              primary: Color(0xffFE724C),
              fixedSize:
              Size(MediaQuery.of(context).size.width, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              )),
          child: Text(
            title,
            style: TextStyle(
              letterSpacing: 2,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget RegistrationBackGround (context){
    return Container(
      decoration: BoxDecoration(
      ),
      child: Stack(
        children: [
          Positioned(
            top: -21,
            left:-42,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                // color: ,
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xffFE724C), width: 25),
              ),
            ),
          ),
          Positioned(
            top: -99,
            left: -5,
            child: Container(
              height: MediaQuery.of(context).size.height*0.25,
              width: MediaQuery.of(context).size.width*0.4,
              decoration: BoxDecoration(
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffFE724C),),
            ),
          ),
        ],
      ),
    );

  }
}