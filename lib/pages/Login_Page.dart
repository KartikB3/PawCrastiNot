import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawcrastinot/helper/helper_function.dart';
import 'package:pawcrastinot/pages/home_Page.dart';
import 'package:pawcrastinot/pages/register_page.dart';
import 'package:pawcrastinot/service/auth_service.dart';
import 'package:pawcrastinot/service/database_service.dart';
import 'package:pawcrastinot/widgets/widgets.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscured = false;
  AuthService authService = AuthService();
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
            width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
          // backgroundColor: Colors.grey[150],
          body: Stack(children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background_image.png'),
                  fit: BoxFit.cover)),
        ),
        SingleChildScrollView(
          child: isLoading
              ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                )
              : Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SafeArea(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Hello",
                                style: GoogleFonts.bebasNeue(fontSize: 30),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Welcome Back!",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                onChanged: (value) => {
                                  setState(() {
                                    email = value;
                                  })
                                },
                                validator: (value) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value!)
                                      ? null
                                      : "Please Enter a Valid Email";
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.lightGreen,
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.yellow, width: 2)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 2)),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2)),
                                  labelText: "Email",
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.yellowAccent,
                                  ),
                                ),
                              ).p12(),
                              TextFormField(
                                onChanged: (value) => {
                                  setState(() {
                                    password = value;
                                  })
                                },
                                obscureText: _isObscured,
                                decoration: InputDecoration(
                                    filled: true,
                                    labelStyle: TextStyle(color: Colors.black),
                                    fillColor: Colors.lightGreen,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Vx.yellow400, width: 2)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Vx.green600, width: 2)),
                                    errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Vx.red500, width: 2)),
                                    labelText: "Password",
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.yellow,
                                    ),
                                    suffixIcon: GestureDetector(
                                        onTap: () => {
                                          setState(() {
                                            _isObscured=!_isObscured;
                                          }),
      
                                        },
                                        child: Icon(
                                          _isObscured ? Icons.visibility : Icons.visibility_off,
                                          color: Colors.yellowAccent,
                                        ))),
                                validator: (value) {
                                  if (value!.length < 8) {
                                    return "Password must atleast have 8 characters";
                                  } else {
                                    return null;
                                  }
                                },
                              ).p12(),
                              SizedBox(
                                height: 0.25,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12))),
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        setState(() => isLoading = true);
                                        bool result = await authService
                                            .loginWithEmailAndPassword(
                                          email,
                                          password,
                                        );
                                        setState(() => isLoading = false);
      
                                        if (result) {
                                          QuerySnapshot snapshot =
                                              await DatabaseService(
                                                      uid: FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                  .getUserData(email);
      
                                          await HelperFunction
                                              .saveUserLoggedInStatus(true);
                                          await HelperFunction.saveEmailSF(email);
                                          await HelperFunction.savePassweord(
                                              password);
                                          await HelperFunction.saveUserNameSF(
                                              snapshot.docs[0]['fullname']);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content:
                                                    Text("login Successful!")),
                                          );
      
                                          nextScreen(context, HomePage());
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text("login Failed")),
                                          );
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      }
                                    },
                                    child: Text(
                                      "Sign In",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    )).pOnly(left: 10, right: 10),
                              ).pOnly(left: 100, right: 100),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't Have An Account?",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  WidthBox(5),
                                  GestureDetector(
                                    onTap: () {
                                      nextScreen(context, RegisterPage());
                                    },
                                    child: Text(
                                      "Register",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ).pOnly(top: 150),
                        ),
                      ),
                    ],
                  ),
                ),
        )
      ])),
    );
  }
}
