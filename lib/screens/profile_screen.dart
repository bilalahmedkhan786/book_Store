import 'package:bookstore/auth/firebase_auth.dart';
import 'package:bookstore/screens/edit_profile.dart';
import 'package:bookstore/screens/homeScreen.dart';
import 'package:bookstore/shared/widgets/profile_menu_wideget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Auth myauth = Auth();
  bool _isDarkMode = Get.isDarkMode;

  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String name = "";
  String email = "";
  String phone = "";
  String description = "";
  String profileImageUrl = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      DocumentSnapshot userData =
          await _firestore.collection('users').doc(user!.uid).get();
      if (userData.exists) {
        setState(() {
          name = userData['name'] ?? '';
          email = userData['email'] ?? '';
          phone = userData['phone'] ?? '';
          description = userData['description'] ?? '';
          profileImageUrl = userData['image_url'] ?? '';
        });
      }
    }
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.to(HomeScreen());
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Center(child: Text("Profile")),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              Get.changeThemeMode(
                  _isDarkMode ? ThemeMode.light : ThemeMode.dark);
              _toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: profileImageUrl.isNotEmpty
                      ? NetworkImage(profileImageUrl)
                      : null,
                  child: profileImageUrl.isEmpty
                      ? Icon(Icons.person, size: 80)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              email,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              phone,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () async {
                  // Navigate to EditProfile and wait for result
                  final result = await Get.to(() => const EditProfile());
                  if (result == true) {
                    // Refresh user data after editing
                    _fetchUserData();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 125, 164, 231),
                  shadowColor: Colors.black,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.transparent),
            const SizedBox(height: 10),
            ProfileMenuWidget(
                title: "Favorites", icon: Icons.favorite, onPress: () {}),
            ProfileMenuWidget(
                title: "Billing Details", icon: Icons.wallet, onPress: () {}),
            ProfileMenuWidget(
                title: "User Management",
                icon: Icons.supervised_user_circle_outlined,
                onPress: () {}),
            const Divider(color: Color.fromARGB(17, 0, 0, 0)),
            const SizedBox(height: 10),
            ProfileMenuWidget(
                title: "Information",
                icon: Icons.info_outline_rounded,
                onPress: () {}),
            ProfileMenuWidget(
              title: "Logout",
              textColor: Colors.red,
              icon: Icons.logout_sharp,
              endIcon: false,
              onPress: () {
                myauth.logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
