import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawcrastinot/helper/helper_function.dart';
import 'package:pawcrastinot/pages/Login_Page.dart';
import 'package:pawcrastinot/pages/Task_Page.dart';
import 'package:pawcrastinot/pages/friends_page.dart';
import 'package:pawcrastinot/pages/games_page.dart';
import 'package:pawcrastinot/pages/leaderboard_page.dart';
import 'package:pawcrastinot/pages/pet_picker_page.dart';
import 'package:pawcrastinot/pages/store_page.dart';
import 'package:pawcrastinot/service/auth_service.dart';
import 'package:pawcrastinot/service/database_service.dart';
import 'package:pawcrastinot/widgets/widgets.dart';
import 'package:random_string/random_string.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? petName;
  String? petImage;
  bool _isLoading = true;
  double _happyProgress = 0.5;
  double _hungerProgress = 0.7;
  int _coins = 100;
  double get happyProgress => _happyProgress;
  AuthService authService = AuthService();

  void startDecay() {
    Timer.periodic(Duration(minutes: 1), (timer) async {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      double currentHunger = documentSnapshot['hunger'] ?? 0.5;
      double currentHappiness = documentSnapshot['happiness'] ?? 0.5;
      double newHappiness = currentHappiness - 0.01;
      double newHunger = currentHunger - 0.01;
      if (newHappiness < 0) {
        newHappiness = 0;
      }
      if (newHunger < 0) {
        newHunger = 0;
      }

      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'happiness': newHappiness}).then((value) {
        print("Happiness decayed to:$newHappiness");
      }).catchError((err) {
        print("failed to decay happiness:$err");
      });

      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'hunger': newHunger}).then((value) {
        print("Hunger decayed to:$newHunger");
      }).catchError((err) {
        print("failed to decay hunger:$err");
      });
    });
  }

  Future<void> updateHappinessProgress(double increment) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      _happyProgress = (_happyProgress + increment).clamp(0, 1);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'happiness': _happyProgress});
      setState(() {});
    } catch (err) {
      print("Cant update happiness indicator:$err");
    }
  }

  Future<void> fetchPetDetails() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final dbService = DatabaseService(uid: userId);
    try {
      // double? fetchedPetHappiness =
      //     (await dbService.getPetHappiness()) as double?;
      String? fetchedPetName = await dbService.getPetName();
      String? fetchedPetImageHappy = await dbService.getPetImageHappy();
      String? fetchedPetImageSad = await dbService.getPetImageSad();

      // double? fetchedPetHunger = (await dbService.getPetHunger()) as double?;

      setState(() {
        petImage = fetchedPetImageHappy;
        petName = fetchedPetName;
        // _happyProgress = fetchedPetHappiness ?? 0.5;
        // _hungerProgress = fetchedPetHunger ?? 0.5;
        _isLoading = false;
      });
    } catch (err) {
      print("error fetching pet details:$err");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPetDetails();
    startDecay();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.green)),
      );
    }
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Container(
      height: screenheight,
      width: screenWidth,
      child: Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                );
              }
              if (!snapshot.hasData) {
                return Center(
                  child: "null".text.make(),
                );
              }
              var userDoc = snapshot.data!;
              _happyProgress = userDoc['happiness']?.toDouble() ?? 0.5;
              _hungerProgress = userDoc['hunger']?.toDouble() ?? 0.7;
              _coins = userDoc['coins'] ?? 100;
              if (_happyProgress > 0.4) {
                petImage = userDoc['pet']['image_happy'].toString();
              } else {
                petImage = userDoc['pet']['image_sad'].toString();
              }
              return Container(
                color: Color.fromRGBO(255, 234, 206, 1.0),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage(petImage!),
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${petName}",
                      style: GoogleFonts.spicyRice(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(32, 70, 13, 1.00),
                      ),
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                      color: Color.fromRGBO(252, 191, 106, 1),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/coin.png'),
                          Text("${_coins}",style: GoogleFonts.spicyRice(fontSize: 24,fontWeight: FontWeight.bold),)
                        ],
                      ),
                      
                    ).pOnly(left: 143,right: 143),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "😄",
                          style: TextStyle(fontSize: 20),
                        ).pOnly(left: 10),
                        Expanded(
                          child: Stack(children: [
                            LinearProgressIndicator(
                              value: _happyProgress,
                              backgroundColor: Colors.grey,
                              minHeight: 15,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.green),
                            ).pOnly(left: 20, right: 20),
                            Positioned(
                                left: 317,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  child: Text(
                                    "${(_happyProgress * 100).toStringAsFixed(1)}%",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ).pOnly(bottom: 1))
                          ]),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "🍔",
                          style: TextStyle(fontSize: 20),
                        ).pOnly(left: 10),
                        Expanded(
                          child: Stack(children: [
                            LinearProgressIndicator(
                              value: _hungerProgress,
                              backgroundColor: Colors.grey,
                              minHeight: 15,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.green),
                            ).pOnly(left: 20, right: 20),
                            Positioned(
                                left: 317,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  child: Text(
                                    "${(_hungerProgress * 100).toStringAsFixed(1)}%",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ).pOnly(bottom: 1))
                          ]),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            nextScreen(context, TaskPage());
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                "TASKS",
                                style: GoogleFonts.spicyRice(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(214, 255, 50, 1.00),
                                    fontSize: 20),
                              ),
                            ),
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(96, 150, 75, 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ).pOnly(left: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            nextScreen(context, GameMenuScreen());
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                "GAMES",
                                style: GoogleFonts.spicyRice(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(214, 255, 50, 1.00),
                                    fontSize: 20),
                              ),
                            ),
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(96, 150, 75, 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ).pOnly(left: 50),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            nextScreen(context, StoreScreen());
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                "STORE",
                                style: GoogleFonts.spicyRice(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(214, 255, 50, 1.00),
                                    fontSize: 20),
                              ),
                            ),
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(96, 150, 75, 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ).pOnly(left: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            nextScreen(context, LeaderboardScreen());
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                "LEADERBOARD",
                                style: GoogleFonts.spicyRice(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(214, 255, 50, 1.00),
                                    fontSize: 20),
                              ),
                            ),
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(96, 150, 75, 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ).pOnly(left: 50),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            nextScreen(context, PetPickerPage());
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                "AVATAR",
                                style: GoogleFonts.spicyRice(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(214, 255, 50, 1.00),
                                    fontSize: 20),
                              ),
                            ),
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(96, 150, 75, 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ).pOnly(left: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            nextScreen(context, FriendsScreen());
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                "FRIENDS",
                                style: GoogleFonts.spicyRice(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(214, 255, 50, 1.00),
                                    fontSize: 20),
                              ),
                            ),
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(96, 150, 75, 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ).pOnly(left: 50),
                        )
                      ],
                    ),
                  ],
                ),
              );
            }),
        appBar: AppBar(
          title: Text(
            "  PawCrastiNot",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Color.fromRGBO(32, 70, 13, 1.00),
                shadows: [
                  Shadow(offset: Offset(0, 2), blurRadius: 3, color: Colors.black)
                ]),
          ),
          backgroundColor: Color.fromRGBO(149, 249, 140, 1.00),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.account_circle),
              iconSize: 30,
            )
          ],
        ),
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    "Drawer",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "play",
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 80,
                  child: ElevatedButton.icon(
                    label: Icon(Icons.logout),
                    style: ElevatedButton.styleFrom(
                        elevation: 1,
                        backgroundColor: Vx.yellow100,
                        shadowColor: Vx.gray300,
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    onPressed: () {
                      authService.signOut();
                      nextScreen(context, const LoginPage());
                    },
                  ).p12(),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 1,
                        backgroundColor: Vx.yellow100,
                        shadowColor: Vx.gray800,
                      ),
                      onPressed: () {
                        nextScreen(context, PetPickerPage());
                      },
                      child: "Change Pet".text.bold.black.make()),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
