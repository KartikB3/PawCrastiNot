import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawcrastinot/chess/chess_board.dart';
import 'package:pawcrastinot/minesweeper/minesweeper_board.dart';
import 'package:pawcrastinot/pages/home_Page.dart';
import 'package:pawcrastinot/widgets/widgets.dart';

class GameMenuScreen extends StatelessWidget {
  final List<Map<String, dynamic>> games = [
    {'name': 'TRIVIA', 'icon': 'trivia'},
    {'name': 'MAZE', 'icon': 'maze'},
    {'name': 'TETRIS', 'icon': 'tetris'},
    {'name': 'CHESS', 'icon': 'chess'},
    {'name': 'MINISWEEPER', 'icon': 'minisweeper'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
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
                    '250',
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
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
