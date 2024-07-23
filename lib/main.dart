import 'package:bookstore/localization/languages.dart';
import 'package:bookstore/screens/homeScreen.dart';
import 'package:bookstore/screens/loginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

late Box box1;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  box1 = await Hive.openBox('bookstore');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Flutter Demo',
          translations: Languages(),
          locale: Locale('en', 'US'),
          fallbackLocale: Locale('en', 'US'),
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          home: box1.get('isLogedin', defaultValue: false)
              ? HomeScreen()
              : LoginScreen()
          // home: ProfileScreen(),
        );
      },
    );
  }
}
