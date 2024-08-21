import 'package:bookstore/screens/homeScreen.dart';
import 'package:bookstore/screens/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Auth {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> register(
      String name, String email, String phone, String password) async {
    try {
      // Create a new user with email and password
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the current user
      User? user = userCredential.user;

      if (user != null) {
        // Save the user details to Firestore
        await firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'phone': phone,
          'description': '', // or any other default value
          'image_url': '', // or any other default value
        });

        print('User registered and firestore saved to Firestore successfully.');
      }
    } catch (e) {
      print('Error during registration: $e');
      Get.snackbar("Sign Up Error", e.toString());
    }
  }

  Future<bool> login(String email, String password) async {
    bool isLogedIn = false;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      isLogedIn = true;
      Get.snackbar("User Login", "Login Successfully");
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
    }
    return isLogedIn;
  }

  void logout(BuildContext context) {
    auth.signOut().then((value) {
      Get.snackbar("User Logout", "Logout Successful");
      Get.offAll(() => const LoginScreen());
    });
  }

  void forgetpassword(String myemail, BuildContext context) {
    auth.sendPasswordResetEmail(email: myemail).then((value) {
      Get.snackbar("Forgot Password", "Email Sent");
    });
  }
}
