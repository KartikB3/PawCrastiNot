import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velocity_x/velocity_x.dart';

class StoreScreen extends StatefulWidget {
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  int _coins = 0;
  int selectedItemIndex = -1;

  final List<Map<String, dynamic>> items = [
    {"image": "assets/cookies.png", "price": 100},
    {"image": "assets/egg.png", "price": 150},
    {"image": "assets/hotdoggg.png", "price": 200},
    {"image": "assets/friess.png", "price": 300},
    {"image": "assets/burgerrr.png", "price": 400},
    {"image": "assets/pizzaaa.png", "price": 500},
  ];

  @override
  void initState() {
    super.initState();
    // _loadCoinBalance();
  }

  // Future<void> _loadCoinBalance() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     coinBalance = prefs.getInt("coinBalance") ?? 500; // Default 250 if not saved
  //   });
  // }

  // Future<void> _saveCoinBalance(int newBalance) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt("coinBalance", newBalance);
  // }

  Future<void> updateCoins(int increment) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      int newCoins = documentSnapshot['coins'] ?? 100;
      final userId = FirebaseAuth.instance.currentUser!.uid;
      newCoins = (newCoins + increment);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'coins': newCoins});
      setState(() {});
    } catch (err) {
      print("Cant update coins:$err");
    }
  }

  void buyItem() async {
    if (selectedItemIndex != -1) {
      int itemPrice = items[selectedItemIndex]["price"];
      updateCoins(-itemPrice);
      if (_coins >= itemPrice) {
        setState(() {
          _coins -= itemPrice;
          selectedItemIndex = -1; // Reset selection
        });

        // Save updated balance

        // Update hunger in Firestore
        final userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null) {
          final dbRef =
              FirebaseFirestore.instance.collection('users').doc(userId);

          try {
            double hungerIncrease = itemPrice / 1000; // Scaling hunger increase
            await dbRef.update({
              'hunger': FieldValue.increment(hungerIncrease),
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Item purchased! Hunger increased.")),
            );
          } catch (error) {
            print("Error updating hunger: $error");
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Not enough coins!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder(
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
            _coins = userDoc['coins'] ?? 100;
            return Scaffold(
              backgroundColor: Color(0xFFFFE5B4),
              appBar: AppBar(
                title: Text(
                  "PawCrastiNot",
                  style: GoogleFonts.sansita(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Color.fromARGB(255, 68, 47, 12),
                    shadows: [
                      Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 3,
                          color: Colors.black)
                    ],
                  ),
                ),
                backgroundColor: Color.fromRGBO(227, 175, 64, 1),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.account_circle),
                    iconSize: 30,
                  )
                ],
              ),
              body: Column(
                children: [
                  const SizedBox(height: 20),
                  // Coin balance display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/coin.png", width: 50, height: 50),
                      SizedBox(width: 10),
                      Text(
                        "${_coins}",
                        style: GoogleFonts.roboto(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "STORE",
                    style: GoogleFonts.spicyRice(
                      fontSize: 35,
                      fontStyle: FontStyle.italic,
                      color: const Color.fromARGB(255, 71, 38, 3),
                      shadows: [
                        Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 3,
                            color: Colors.black)
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        itemCount: items.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.7,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedItemIndex = index;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: selectedItemIndex == index
                                    ? Border.all(color: Colors.black, width: 2)
                                    : null,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Image.asset(items[index]["image"],
                                          height: 110),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.brown,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "\$${items[index]["price"]}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: selectedItemIndex == -1
                            ? null
                            : _coins >= items[selectedItemIndex]["price"]
                                ? buyItem
                                : null,
                        child: const Text(
                          "BUY",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
