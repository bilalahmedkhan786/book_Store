import 'package:bookstore/screens/homeScreen.dart';
import 'package:bookstore/screens/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Auth {
  FirebaseAuth auth = FirebaseAuth.instance;

  void register(String email, password) {
    auth.createUserWithEmailAndPassword(email: email, password: password);
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
