import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawcrastinot/chess/chess_board.dart';
import 'package:pawcrastinot/minesweeper/minesweeper_board.dart';
import 'package:pawcrastinot/pages/home_Page.dart';
import 'package:pawcrastinot/pages/maze_Page.dart';
import 'package:pawcrastinot/pages/trivia_page.dart';
import 'package:pawcrastinot/ping_pong/pong_page.dart';
import 'package:pawcrastinot/tetris/tetris_page.dart';
import 'package:pawcrastinot/widgets/widgets.dart';
import 'package:velocity_x/velocity_x.dart';

class GameMenuScreen extends StatefulWidget {
  @override
  State<GameMenuScreen> createState() => _GameMenuScreenState();
}

class _GameMenuScreenState extends State<GameMenuScreen> {
  int _coins = 0;

  final List<Map<String, dynamic>> games = [
    {'name': 'TRIVIA', 'icon': 'trivia'},
    {'name': 'MAZE', 'icon': 'maze'},
    {'name': 'TETRIS', 'icon': 'tetris'},
    {'name': 'CHESS', 'icon': 'chess'},
    {'name': 'MINISWEEPER', 'icon': 'minisweeper'},
    {'name': 'PING PONG', 'icon': 'pingpong'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
            width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: Color(0xFFF5E1C0),
        appBar: AppBar(
          backgroundColor: Color(0xFF86A23C),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              nextScreen(context, HomePage());
            },
          ),
          title: Text(
            'Pawcrastinot',
            style: GoogleFonts.sansita(
              fontWeight: FontWeight.bold,
              fontSize: 35,
              color: Colors.black,
            ),
          ),
        ),
        body: StreamBuilder(
          stream:  FirebaseFirestore.instance
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
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'GAMES',
                    style: GoogleFonts.sansita(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 30,
                      color: const Color.fromARGB(255, 65, 46, 39),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(228, 218, 185, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/coin.png",
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(width: 5),
                        Text(
                          _coins.toString(),
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: games.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5.0),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.yellow[600],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              leading: Image.asset(
                                "assets/${games[index]['icon']}.png",
                                width: 40,
                                height: 40,
                              ),
                              title: Text(
                                games[index]['name'],
                                style: GoogleFonts.stardosStencil(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.brown,
                                ),
                              ),
                              onTap: () {
                                if ("${games[index]['name']}" == "CHESS") {
                                  nextScreen(context, ChessBoard());
                                }
                                if ("${games[index]['name']}" == "MINISWEEPER") {
                                  nextScreen(context, MinesweeperBoard());
                                }
                                if ("${games[index]['name']}" == "PING PONG") {
                                  nextScreen(context, PongPage());
                                }
                                if ("${games[index]['name']}" == "TRIVIA") {
                                  nextScreen(context, TriviaPage());
                                }
                                if ("${games[index]['name']}" == "MAZE") {
                                  nextScreen(context, MazePage());
                                }
                                if ("${games[index]['name']}" == "TETRIS") {
                                  nextScreen(context, TetrisPage());
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
