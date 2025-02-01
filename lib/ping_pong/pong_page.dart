import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pawcrastinot/pages/games_page.dart';
import 'package:pawcrastinot/ping_pong/ball.dart';
import 'package:pawcrastinot/ping_pong/paddle.dart';
import 'package:pawcrastinot/ping_pong/coverscreen.dart';
import 'package:pawcrastinot/widgets/widgets.dart';
import 'package:velocity_x/velocity_x.dart';

class PongPage extends StatefulWidget {
  @override
  State<PongPage> createState() => _PongPageState();
}

enum direction { UP, DOWN, LEFT, RIGHT }

class _PongPageState extends State<PongPage> {
  bool gameHasStarted = false;
  int _coins = 0;
  double ballX = 0;
  int count = 0;
  int score = 0;
  double ballY = 0;
  double ballSpeed = 0.003;
  double paddleX = 0;
  double paddleWidth = 0.4;
  var balLYDirection = direction.DOWN;
  var balLXDirection = direction.LEFT;

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 1), (timer) {
      updateDirection();
      moveBall();
      if (isPlayerDead()) {
        updateCoins(score*10);
        timer.cancel();
        resetGame();
        showGameOverDialog();
      }
    });
  }

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

  void showGameOverDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.deepPurple,
            title: Center(
              child: Text(
                "    Game Over\nCoins Earned:${score * 10}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange[800],
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    count++;
                    Navigator.pop(context);
                    resetGame();
                    setState(() {
                      score = 0;
                      ;
                    });
                  },
                  child:
                      Text("PLAY AGAIN", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          );
        });
  }

  void resetGame() {
    setState(() {
      gameHasStarted = false;
      ballX = 0;
      ballY = 0;
      paddleX = 0;
      balLXDirection = (count % 2 == 0) ? direction.LEFT : direction.RIGHT;
      balLYDirection = direction.DOWN;
    });
  }

  bool isPlayerDead() {
    if (ballY >= 1) {
      return true;
    }
    return false;
  }

  void updateDirection() {
    setState(() {
      if (ballY >= 0.9 && paddleX + paddleWidth >= ballX && paddleX <= ballX) {
        balLYDirection = direction.UP;
        score += 1;
      } else if (ballY <= -0.9) {
        balLYDirection = direction.DOWN;
      }

      if (ballX >= 1) {
        balLXDirection = direction.LEFT;
      } else if (ballX <= -1) {
        balLXDirection = direction.RIGHT;
      }
    });
  }

  void moveBall() {
    setState(() {
      if (balLYDirection == direction.UP) {
        ballY -= ballSpeed;
      } else if (balLYDirection == direction.DOWN) {
        ballY += ballSpeed;
      }

      if (balLXDirection == direction.LEFT) {
        ballX -= ballSpeed;
      } else if (balLXDirection == direction.RIGHT) {
        ballX += ballSpeed;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GestureDetector(
        onTap: startGame,
        onHorizontalDragUpdate: (details) {
          setState(() {
            paddleX += details.delta.dx / MediaQuery.of(context).size.width * 2;
            paddleX = paddleX.clamp(-1, 1);
          });
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text("Ping Pong "),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                nextScreen(context, GameMenuScreen());
              },
            ),
          ),
          backgroundColor: Colors.grey[900],
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.deepPurple, Colors.black87],
              ),
            ),
            child: Center(
              child: Stack(
                children: [
                  Positioned(
                      top: 50,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          "${score}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  Coverscreen(
                    gameHasStarted: gameHasStarted,
                  ),
                  MyBall(x: ballX, y: ballY),
                  MyBrick(
                    x: paddleX,
                    y: 0.9,
                    brickWidth: paddleWidth,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
