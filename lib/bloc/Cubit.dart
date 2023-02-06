import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madaris/helper/Consts.dart';
import 'package:madaris/helper/SaveData.dart';
import 'package:madaris/screens/MainPage.dart';
import 'package:madaris/screens/login.dart';
import 'package:uuid/uuid.dart';
import 'States.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MyCubit extends Cubit<MyState> {
  MyCubit() : super(InitState());

  static MyCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  bool isHidePassword = true;
  bool isLoading = false;
  Map<String, dynamic> dataUser = {};
  List<Map<String, dynamic>> cars = [];
  List<Map<String, dynamic>> insuranceInfo = [];
  List<Map<String, dynamic>> insurance = [];
  List<Map<String, dynamic>> favouriteCars = [];
  List<Map<String, dynamic>> orderCars = [];
  List<Map<String, dynamic>> carInfo = [];
  List<Map<String, dynamic>> categoryCar = [];
  var uuid = const Uuid();
  double v = 0;

  changePasswordIcon() {
    isHidePassword = !isHidePassword;
    emit(ChangeIconState());
  }

  openDrawer() {
    v == -1 ? v = 0 : v = -1;
    emit(changeNavBarState());
  }

  closeDrawer() {
    v = 0;
    emit(changeNavBarState());
  }

  changeNavBar(index) {
    currentIndex = index;
    emit(changeNavBarState());
  }

  signOut(context) async {
    emit(SignOutState());
    await CacheHelper.removeData(key: "isLogin");
    navAndKaill(context, const Login());
    await FirebaseAuth.instance.signOut();
    emit(userSignUpState());
  }

  resetPassword(email,context)async{
    emit(loadingresetPasswordState());
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
      emit(resetPasswordState());
    }).catchError((e){
      showMessage(context,"${e.message.toString()}", Colors.red);
      emit(erorresetPasswordState());
    });
  }

  userLogin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    isLoading = true;
    emit(userLoginState());
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      uId = value.user!.uid;
      await getDataUser(value.user!.uid);
      if (dataUser["type"] == "user") {
        navAndKaill(context, const MyHomePage());
        showMessage(context, "Successful login", Colors.green);
        await CacheHelper.saveData(key: "isLogin", value: true);
        await CacheHelper.saveData(key: "uID", value: value.user!.uid);
      } else {
        showMessage(context, "this account is not found", Colors.red);
      }
    }).catchError((error) {
      showMessage(context, "${error.message.toString()}", Colors.red);
    });

    isLoading = false;
    emit(userLoginState());
  }

  getDataUser(String id) async{
    if (id.isNotEmpty) {
     await FirebaseFirestore.instance
          .collection("Users")
          .doc(id)
          .get()
          .then((value) {
        dataUser = value.data()!;
        print(dataUser);
        emit(getDataUserSate());
      });
    }
  }


  getDataUserasStream(String id) {
    if (id.isNotEmpty) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(id)
          .snapshots()
          .listen((value) {
        dataUser = value.data()!;
        print(dataUser);
        emit(getDataUserasStreamState());
      });
    }
  }

  userSignUp(email, password, phone, name, context) async {
    isLoading = true;
    emit(userSignUpState());
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      await setDataUser(
        name,
        phone,
        email,
        value.user!.uid,
      );
      navAndKaill(context, const Login());
      showMessage(context,
          "The account has been created successfully,login now", Colors.green);
    }).catchError((e) {
      print("mt erorr is ${e.toString()}");
    });
    isLoading = false;
    emit(userSignUpState());
  }

  setDataUser(name, phone, email, uid) {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .set({
          "name": name,
          "email": email,
          "phone": phone,
          "uid": uid,
          "type": "user",
          "image":
              "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=2000",
        })
        .then((value) {})
        .catchError((onError) {
          print(onError.toString());
        });
  }

  updateDataUser(name, phone, String pass, context) async {
    emit(LoadingupdateDataUserState());
    if (profileImage == null) {
     await updateDataUserWithoutImage(name, phone, pass, context);
    } else {
     await updateDataUserWithImage(name, phone, pass, context);
    }
    await getDataUser(dataUser["uid"]);
    emit(getImageFromCameraState());
  }

  updateDataUserWithoutImage(name, phone, pass, context) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(dataUser["uid"])
        .update({
      "name": name.isNotEmpty ? name : dataUser["name"],
      "phone": phone.isNotEmpty ? phone : dataUser["phone"],
    }).then((value) async {
      if (pass.isNotEmpty) {
        await FirebaseAuth.instance.currentUser!
            .updatePassword(pass)
            .then((value) {
          print("pass change");
        }).catchError((e) {
          showMessage(context, "${e.message.toString()}", Colors.red);
        });
      }
      emit(getImageFromCameraState());
    });
  }

  updateDataUserWithImage(name, phone, pass, context) async {
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child("Image/${Uri.file(profileImage!.path).pathSegments.last}")
        .putFile(profileImage!)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) async {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(dataUser["uid"])
            .update({
          "name": name.isNotEmpty ? name : dataUser["name"],
          "phone": phone.isNotEmpty ? phone : dataUser["phone"],
          "image": value,
        }).then((value) async {

          if (pass.isNotEmpty) {
            await FirebaseAuth.instance.currentUser!
                .updatePassword(pass)
                .then((value) {
              print("pass change");
            }).catchError((e) {
              showMessage(context, "${e.message.toString()}", Colors.red);
            });
          }
          emit(getImageFromCameraState());
        });
      });
    });
  }

  File? insuranceImage;
  File? profileImage;
  final ImagePicker picker = ImagePicker();

  Future getInsuranceImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      insuranceImage = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    emit(getImageFromCameraState());
  }

  Future getProfileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    emit(getImageFromCameraState());
  }

  getCarInfo(id) {
    emit(LoadingState1());
    FirebaseFirestore.instance
        .collection("Cars")
        .where("id", isEqualTo: id)
        .snapshots()
        .listen((value) {
      carInfo = [];
      value.docs.forEach((element) {
        carInfo.add(element.data());
      });
      print(carInfo);
      emit(userSignUpState());
    });
    // emit(userSignUpState());
  }

  setViwersInsurance(id) {
    FirebaseFirestore.instance.collection("Insurance").doc(id).update({
      "viwers": FieldValue.arrayUnion([dataUser["uid"]])
    });
  }

  //
  //[]



  getInsuranceInfo(id) {
    emit(LoadingState2());
    FirebaseFirestore.instance
        .collection("Insurance")
        .where("id", isEqualTo: id)
        .snapshots()
        .listen((value) {
      insuranceInfo = [];
      value.docs.forEach((element) {
        insuranceInfo.add(element.data());
      });
      print(insuranceInfo);
      emit(changeNavBarState());
    });
  }

  getInsurance() {
    emit(LoadingState3());
    FirebaseFirestore.instance
        .collection("Insurance")
        .snapshots()
        .listen((value) {
      insurance = [];
      value.docs.forEach((element) {
        insurance.add(element.data());
      });
      emit(changeNavBarState());
    });
  }

  setRequestsUsers(id, e) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(dataUser["uid"])
        .collection("history")
        .doc(id)
        .set(e);
  }

  deleteRequestsUsers(
    id,
  ) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(dataUser["uid"])
        .collection("history")
        .doc(id)
        .delete()
        .then((value) {
      emit(userSignUpState());
    });
  }

  setRequests(id, e,collection,ms) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .collection("Requests")
        .doc(dataUser["uid"])
        .set({
      "ms": ms,
      "image": dataUser["image"],
      "name": dataUser["name"],
      "phone": dataUser["phone"],
    }).then((value) async {
      await setRequestsUsers(id, e);
      emit(userSignUpState());
    });
  }

  deleteRequests(id,collection) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .collection("Requests")
        .doc(dataUser["uid"])
        .delete()
        .then((value) async {
      print("Requests is delete");
      await deleteRequestsUsers(id);
      emit(userSignUpState());
    });
  }

  getCategoryCar(type) {
    emit(LoadingState4());
    FirebaseFirestore.instance
        .collection("Cars")
        .where("type", isEqualTo: type)
        .snapshots()
        .listen((value) {
      categoryCar = [];
      value.docs.forEach((element) {
        categoryCar.add(element.data());
      });
      emit(userSignUpState());
    });
    // emit(userSignUpState());
  }

  getCars() {
    FirebaseFirestore.instance.collection("Cars").snapshots().listen((value) {
      cars = [];
      value.docs.forEach((element) {
        cars.add(element.data());
      });
      emit(userSignUpState());
    });
  }

  Future<void> getFavouriteCars() async {
    emit(LoadingState5());
    FirebaseFirestore.instance
        .collection("Cars")
        .where("favorite", arrayContains: dataUser["uid"])
        .snapshots()
        .listen((event) {
      favouriteCars = [];
      event.docs.forEach((element) {
        favouriteCars.add(element.data());
      });
      emit(getData());
    });
  }

  getOrder() {
    emit(LoadingState6());
    FirebaseFirestore.instance
        .collection("Users")
        .doc(dataUser["uid"])
        .collection("history")
        .snapshots()
        .listen((event) {
      orderCars = [];
      event.docs.forEach((element) {
        orderCars.add(element.data());
      });
      emit(userSignUpState());
    });
  }

  removeFavourite(y) async {
    await FirebaseFirestore.instance.collection("Cars").doc(y).update({
      "favorite": FieldValue.arrayRemove([dataUser["uid"]]),
    }).then((value) {
      emit(getData());
    });
  }

  removeOrder(y) async {

   await FirebaseFirestore.instance
        .collection("Users")
        .doc(dataUser["uid"])
        .collection("history")
        .doc(y)
        .delete().then((value) {
          emit(userSignUpState());
   });
    await FirebaseFirestore.instance.collection("Cars").doc(y).update({
      "order": FieldValue.arrayRemove([dataUser["uid"]]),
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection("Cars")
          .doc(y)
          .collection("Requests")
          .doc(dataUser["uid"])
          .delete().then((value) {
        emit(userSignUpState());
      });
    });
  }

  favourite(y, List o, collection) async {
    if (o.contains(dataUser["uid"])) {
      await FirebaseFirestore.instance.collection(collection).doc(y).update({
        "favorite": FieldValue.arrayRemove([dataUser["uid"]]),
      }).then((value) {
        emit(userSignUpState());
      });
      getFavouriteCars();
    } else {
      await FirebaseFirestore.instance.collection(collection).doc(y).update({
        "favorite": FieldValue.arrayUnion([dataUser["uid"]]),
      }).then((value) {
        emit(userSignUpState());
      });
      getFavouriteCars();
    }
  }




   signInWithGoogle() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount? googleSignInAccount =
  await googleSignIn.signIn();
  if (googleSignInAccount != null) {
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
  accessToken: googleSignInAuthentication.accessToken,
  idToken: googleSignInAuthentication.idToken,
  );
  await auth.signInWithCredential(credential).then((value){
    print(value.user!.email);
    print(value.user!.phoneNumber);
    print(value.user!.photoURL);
    print(value.user!.displayName);
  });
  }
  }



  order(id, List o, e,collection,ms) async {
    isLoading = true;
    emit(LoadingState7());
    if (o.contains(dataUser["uid"])) {
      await FirebaseFirestore.instance.collection(collection).doc(id).update({
        "order": FieldValue.arrayRemove([dataUser["uid"]]),
      });
      await deleteRequests(id,collection);
    } else {
      await FirebaseFirestore.instance.collection(collection).doc(id).update({
        "order": FieldValue.arrayUnion([dataUser["uid"]]),
      });
      await setRequests(id, e,collection,ms);
    }
    isLoading = false;
    emit(userSignUpState());
  }
}
