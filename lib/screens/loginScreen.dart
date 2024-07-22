import 'package:bookstore/auth/firebase_auth.dart';
import 'package:bookstore/localization/languages.dart';
import 'package:bookstore/screens/signUpScreen.dart';
import 'package:bookstore/shared/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPassVisible = true;

  Auth myauth = Auth();

  late Box box1;
  @override
  void initState() {
    super.initState();
    createBox();
  }

  void createBox() async {
    box1 = await Hive.openBox('bookstore');
    getdata();
  }

  void getdata() async {
    if (box1.get('isLogedin') != null) {}
  }

  SMIInput<bool>? isChecking;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;
  SMINumber? numLook;
  late StateMachineController? stateMachineController;

  void isCheckFeild() {
    isHandsUp?.change(false);
    isChecking?.change(true);
    numLook?.change(0);
  }

  void moveEyeBall(value) {
    numLook?.change(value.length.toDouble());
  }

  void hidePassword() {
    isHandsUp?.change(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
          child: Text(
            'screenName'.tr,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String languageCode) {
              Languages();
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'en',
                  child: Text('English'),
                  onTap: () {
                    Get.updateLocale(Locale('en', 'US'));
                  },
                ),
                PopupMenuItem(
                  value: 'ur',
                  child: Text('Urdu'),
                  onTap: () {
                    Get.updateLocale(Locale('ur', 'PK'));
                  },
                ),
                // Add more languages here
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: 400,
              child: RiveAnimation.asset(
                'assets/animated_login_character.riv',
                stateMachines: const ["Login Machine"],
                onInit: (artboard) {
                  stateMachineController = StateMachineController.fromArtboard(
                    artboard,
                    "Login Machine",
                  );
                  if (stateMachineController == null) return;
                  artboard.addController(stateMachineController!);
                  isChecking = stateMachineController?.findInput("isChecking");
                  isHandsUp = stateMachineController?.findInput("isHandsUp");
                  trigSuccess =
                      stateMachineController?.findInput("trigSuccess");
                  trigFail = stateMachineController?.findInput("trigFail");
                  numLook = stateMachineController?.findSMI("numLook");
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                alignment: Alignment.center,
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            onChanged: moveEyeBall,
                            onTap: isCheckFeild,
                            controller: emailController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email),
                              hintText: 'hint_email'.tr,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              isDense: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Valid Email";
                              }
                              // Add more robust email validation here if needed
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            onTap: hidePassword,
                            controller: passwordController,
                            obscureText: isPassVisible,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.password),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isPassVisible = !isPassVisible;
                                  });
                                },
                                child: Icon(isPassVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                              hintText: 'hint_password'.tr,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              isDense: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Valid Password";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          MyButton(
                            text: "Sign IN".tr,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                print("Email: ${emailController.text}");
                                print("Password: ${passwordController.text}");

                                // Add authentication logic here
                                bool isLogedIn = await myauth.login(
                                  emailController.text,
                                  passwordController.text,
                                  context,
                                );

                                if (isLogedIn) {
                                  emailController.clear();
                                  passwordController.clear();
                                  box1.put('isLogedin', true);
                                  isChecking!.change(false);
                                  isHandsUp!.change(false);
                                  trigFail!.change(false);
                                  trigSuccess!.change(true);
                                } else {
                                  isChecking!.change(false);
                                  isHandsUp!.change(false);
                                  trigSuccess!.change(false);
                                  trigFail!.change(true);
                                }
                              } else {
                                isChecking!.change(false);
                                isHandsUp!.change(false);
                                trigSuccess!.change(false);
                                trigFail!.change(true);
                              }
                            },
                          ),
                        ],
                      )),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Get.to(const SignUpScreen());
              },
              child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("no account".tr),
                    const SizedBox(width: 5),
                    Text(
                      "Sign UP".tr,
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
