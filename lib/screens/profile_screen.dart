import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        // decoration: BoxDecoration(
        //   gradient: const LinearGradient(
        //     begin: Alignment.centerLeft,
        //     end: Alignment.centerRight,
        //     colors: [
        //       Color(0xFF8DBDFF),
        //       Color(0xFF3C7DD9),
        //     ],
        //   ),
        //   borderRadius: BorderRadius.circular(12),
        // ),
        color: Colors.white,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.all(20.0)),
            CircleAvatar(
              radius: 130,
              backgroundImage: AssetImage("assets/mypic.jpg"),
            ),
            SizedBox(
              height: 20,
            ),

            Row(
              children: [
                Padding(padding: EdgeInsets.all(20.0)),
                Icon(Icons.edit),
                Text("Edit"),
              ],
            ),

            // ElevatedButton(
            //   onPressed: () {},
            //   child: Text(""),
            //   style: ElevatedButton.styleFrom(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 150, vertical: 25),
            //     backgroundColor: Colors.white,
            //     shadowColor: Colors.black,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     textStyle: const TextStyle(
            //       fontSize: 18,
            //       fontWeight: FontWeight.w400,
            //     ),
            //     foregroundColor: Colors.white,
            //   ),
            // ),
          ],
        ),
      )),
    );
  }
}
