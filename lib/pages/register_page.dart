import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawcrastinot/helper/helper_function.dart';
import 'package:pawcrastinot/pages/Login_Page.dart';
import 'package:pawcrastinot/pages/home_Page.dart';
import 'package:pawcrastinot/pages/pet_picker_page.dart';
import 'package:pawcrastinot/service/auth_service.dart';
import 'package:pawcrastinot/widgets/widgets.dart';
import 'package:velocity_x/velocity_x.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthService authService = AuthService();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  bool _isObscured = false;
  String email = "";
  String password = "";
  String fullname = "";
  @override
  Widget build(BuildContext context) {
    return Container(
            width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
          backgroundColor: Colors.grey[150],
          body: Stack(children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background_image.png'),
                      fit: BoxFit.cover)),
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(color: Colors.lightGreen))
                : Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Hello",
                            style: GoogleFonts.bebasNeue(fontSize: 30),
                          ),
                          SizedBox(height: 5),
                          Text("Sign Up Now!", style: TextStyle(fontSize: 20)),
                          SizedBox(height: 20),
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  onChanged: (value) =>
                                      setState(() => fullname = value),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "UserId can't be empty";
                                    }
                                    return null;
                                  },
                                  decoration:
                                      inputDecoration("UserID", Icons.person),
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  onChanged: (value) =>
                                      setState(() => email = value),
                                  validator: (value) {
                                    return RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value!)
                                        ? null
                                        : "Please enter a valid email";
                                  },
                                  decoration:
                                      inputDecoration("Email", Icons.email),
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  onChanged: (value) =>
                                      setState(() => password = value),
                                  obscureText: _isObscured,
                                  validator: (value) {
                                    if (value!.length < 8) {
                                      return "Password must have at least 8 characters";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.lightGreen,
                                      labelStyle: TextStyle(color: Colors.black),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.yellow, width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 2),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 2),
                                      ),
                                      labelText: "Password",
                                      prefixIcon: Icon(Icons.visibility,
                                          color: Colors.yellow),
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isObscured = !_isObscured;
                                            });
                                          },
                                          child: Icon(
                                            Icons.visibility_off,
                                            color: Colors.yellow,
                                          ))),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  setState(() => isLoading = true);
                                  bool result = await authService
                                      .registerUserWithEmailAndPassword(
                                    fullname,
                                    email,
                                    password,
                                  );
                                  setState(() => isLoading = false);
      
                                  if (result) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Registration Successful!")),
                                    );
                                    await HelperFunction.saveUserLoggedInStatus(
                                        true);
                                    await HelperFunction.saveUserNameSF(fullname);
                                    await HelperFunction.saveEmailSF(email);
                                    await HelperFunction.savePassweord(password);
                                    nextScreen(context, PetPickerPage());
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text("Registration Failed")),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                "Register",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ).pOnly(left: 100, right: 100),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already Registered?",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(width: 5),
                              GestureDetector(
                                onTap: () => nextScreen(context, LoginPage()),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).p12(),
                  )
          ])),
    );
  }

  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.lightGreen,
      labelStyle: TextStyle(color: Colors.black),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.yellow, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.yellow),
    );
  }
}
