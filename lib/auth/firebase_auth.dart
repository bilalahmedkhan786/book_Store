import 'package:bookstore/screens/homeScreen.dart';
import 'package:bookstore/screens/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Auth {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore data = FirebaseFirestore.instance;

  void register(String email, password) {
   var date =  DateTime.now();
    auth.createUserWithEmailAndPassword(email: email, password: password);
    data.collection("users").doc(date.toString()).set({
      "useremail": email,
      "userpass": password,
    }).then(
        (value) => ScaffoldMessenger(child: Text("User Added successfully")));
  }

  Future<bool> login(String email, password, BuildContext context) async {
    bool isLogedIn = false;
    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => {
              Get.snackbar("User Login", "Login Successfully"),
              isLogedIn = true,
              Get.offAll(
                const HomeScreen(),
              ),
            });

    return isLogedIn;
  }

  void logout(BuildContext context) {
    auth.signOut().then((value) => {
          Get.snackbar("User Logout", "Logout Suceesfull"),
          Get.offAll(LoginScreen()),
        });
  }

  void forgetpassword(String myemail, BuildContext context) {
    auth
        .sendPasswordResetEmail(email: myemail)
        .then((value) => {Get.snackbar("Forgot Password", "Email Sent")});
  }
}
