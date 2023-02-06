import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madaris/bloc/Cubit.dart';
import 'package:madaris/bloc/States.dart';
import 'package:madaris/helper/Consts.dart';
import 'package:madaris/helper/Theme.dart';
import 'package:madaris/screens/ForgetPasword.dart';
import 'package:madaris/screens/MainPage.dart';
import 'package:madaris/screens/SignUp.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool show = false;
  String type = "User";
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  var formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyCubit, MyState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                background(context),
                Stack(
                  children: [
                    SafeArea(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //selectedType(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 31, top: 80),
                                child: pageTitle("Login"),
                              ),
                              // Email
                              myField(context, "E-mail", "Your email or phone",
                                  false,email),
                              myField(context, "Password", "Password", true,pass),
                              // Password
                              const SizedBox(
                                height: 20,
                              ),
                              forgetPassword(context),
                              const SizedBox(
                                height: 30,
                              ),
                              // Button SIGN UP
                              if (!MyCubit.get(context).isLoading)
                                myBottom(context, "LOGIN"),
                              if (MyCubit.get(context).isLoading)
                                Center(
                                    child: CircularProgressIndicator(
                                  color: MyTheme.mainColor,
                                )),
                              // Already have an account? Login
                              const SizedBox(
                                height: 32,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 78),
                                  child: GestureDetector(
                                    onTap: () => navTo(context, SignUp()),
                                    child: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: "Don’t have an account? ",
                                            style: TextStyle(
                                              color: MyTheme.secondText,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            )),
                                        const TextSpan(
                                            text: "Sign Up",
                                            style: TextStyle(
                                              color: Color(0xffFE724C),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            )),
                                      ]),
                                    ),
                                  ),
                                ),
                              ),
                              // SizedBox(height: 100,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        listener: (context, state) {});
  }

  Widget selectedType() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(top: 75, right: 26, left: 26),
      decoration: BoxDecoration(
          border: Border.all(color: MyTheme.secondText),
          borderRadius: BorderRadius.circular(25)),
      child: Row(children: [
        Expanded(
            child: InkWell(
          onTap: () {
            setState(() {
              type = "User";
            });
          },
          child: Container(
            decoration: BoxDecoration(
                color: type == "User" ? MyTheme.mainColor : null,
                borderRadius: BorderRadius.circular(28)),
            child: Center(
                child: Text(
              "User",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            )),
          ),
        )),
        Expanded(
            child: InkWell(
          onTap: () {
            setState(() {
              type = "Provider";
            });
          },
          child: Container(
            decoration: BoxDecoration(
                color: type == "Provider" ? MyTheme.mainColor : null,
                borderRadius: BorderRadius.circular(28)),
            child: Center(
                child: Text(
              "Provider",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            )),
          ),
        )),
      ]),
    );
  }

  Widget pageTitle(title) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 26),
      child: Container(
        // color: Colors.red,
        width: MediaQuery.of(context).size.width / 3,
        height: 42,
        child: FittedBox(
          fit: BoxFit.cover,
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 36),
          ),
        ),
      ),
    );
  }

  Widget background(context) {
    return Container(
      decoration: BoxDecoration(),
      child: Stack(
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
                border: Border.all(color: Color(0xffFE724C), width: 25),
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
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffFE724C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget myField(context, title, label, isPass,c) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26, vertical: 9),
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
                if(value!.isEmpty){
                  return "It shouldn't be empty";
                }
              },
              style: TextStyle(fontSize: 20, color: Colors.white),
              obscureText: isPass ? MyCubit.get(context).isHidePassword : false,
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: isPass
                      ? IconButton(
                          onPressed: () {
                            MyCubit.get(context).changePasswordIcon();
                          },
                          icon: Icon(
                            !MyCubit.get(context).isHidePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: MyTheme.secondText,
                          ))
                      : null,
                ),
                filled: true,
                fillColor: Color.fromRGBO(57, 57, 72, 1),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xffFE724C),
                    ),
                    borderRadius: BorderRadius.circular(15)),
                labelText: label,
                labelStyle: TextStyle(color: MyTheme.secondText, fontSize: 16),
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

  Widget forgetPassword(context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 78),
        child: GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => ForgetPassword())),
          child: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: "Forgot password?",
                  style: TextStyle(
                    color: Color(0xffFE724C),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myBottom(context, title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 65),
      child: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(35), boxShadow: [
          BoxShadow(
            color: Color(0xffFE724C).withOpacity(0.6),
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(1, 2),
          ),
        ]),
        child: ElevatedButton(
          onPressed: () async {
            if(formKey.currentState!.validate()){
              await MyCubit.get(context)
                  .userLogin(email: email.text.trim(), password: pass.text,context: context);
            }

          },
          style: ElevatedButton.styleFrom(
              shadowColor: Color(0xffFE724C),
              primary: Color(0xffFE724C),
              fixedSize: Size(MediaQuery.of(context).size.width, 60),
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

  Widget lodaingContaner() {
    return Center(
      child: Container(
        height: 300,
        width: 300,
        color: Colors.deepOrange.withOpacity(0.4),
        child: Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        )),
      ),
    );
  }
}
