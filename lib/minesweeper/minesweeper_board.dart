import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pawcrastinot/minesweeper/bomb.dart';
import 'package:pawcrastinot/minesweeper/numberBox.dart';
import 'package:pawcrastinot/pages/games_page.dart';
import 'package:pawcrastinot/widgets/widgets.dart';

class MinesweeperBoard extends StatefulWidget {
  const MinesweeperBoard({super.key});

  @override
  State<MinesweeperBoard> createState() => _MinesweeperBoardState();
}

class _MinesweeperBoardState extends State<MinesweeperBoard> {
  int numberOfSquares = 9 * 9;
  int numberInEachRow = 9;
  int _coins = 0;

  var squareStatus = [];

  bool bombsRevealed = false;

  List<int> bombLocations = [];

  Timer? _timer;
  int _elapsedTime = 0;

  @override
  void initState() {
    startTimer();
    generateBombLocations();
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < numberOfSquares; i++) {
      squareStatus.add([0, false]);
    }
    scanBombs();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stopTimer();
  }

  void restartGame() {
    setState(() {
      bombsRevealed = false;
      for (int i = 0; i < numberOfSquares; i++) {
        squareStatus[i][1] = false;
      }
    });
  }

  void revealBoxNumbers(int index) {
    if (squareStatus[index][0] != 0) {
      setState(() {
        squareStatus[index][1] = true;
      });
    } else if (squareStatus[index][0] == 0) {
      setState(() {
        squareStatus[index][1] = true;

        if (index % numberInEachRow != 0) {
          if (squareStatus[index - 1][0] == 0 &&
              squareStatus[index - 1][1] == false) {
            revealBoxNumbers(index - 1);
          }
          squareStatus[index - 1][1] = true;
        }

        if (index % numberInEachRow != 0 && index >= numberInEachRow) {
          if (squareStatus[index - 1 - numberInEachRow][0] == 0 &&
              squareStatus[index - 1 - numberInEachRow][1] == false) {
            revealBoxNumbers(index - 1 - numberInEachRow);
          }
          squareStatus[index - 1 - numberInEachRow][1] = true;
        }
        if (index >= numberInEachRow) {
          if (squareStatus[index - numberInEachRow][0] == 0 &&
              squareStatus[index - numberInEachRow][1] == false) {
            revealBoxNumbers(index - numberInEachRow);
          }
          squareStatus[index - numberInEachRow][1] = true;
        }

        if (index >= numberInEachRow &&
            index % numberInEachRow != numberInEachRow - 1) {
          if (squareStatus[index + 1 - numberInEachRow][0] == 0 &&
              squareStatus[index + 1 - numberInEachRow][1] == false) {
            revealBoxNumbers(index + 1 - numberInEachRow);
          }
          squareStatus[index + 1 - numberInEachRow][1] = true;
        }

        if (index % numberInEachRow != numberInEachRow - 1) {
          if (squareStatus[index + 1][0] == 0 &&
              squareStatus[index + 1][1] == false) {
            revealBoxNumbers(index + 1);
          }
          squareStatus[index + 1][1] = true;
        }

        if (index < numberOfSquares - numberInEachRow &&
            index % numberInEachRow != numberInEachRow - 1) {
          if (squareStatus[index + 1 + numberInEachRow][0] == 0 &&
              squareStatus[index + 1 + numberInEachRow][1] == false) {
            revealBoxNumbers(index + 1 - numberInEachRow);
          }
          squareStatus[index + 1 + numberInEachRow][1] = true;
        }

        if (index < numberOfSquares - numberInEachRow) {
          if (squareStatus[index + numberInEachRow][0] == 0 &&
              squareStatus[index + numberInEachRow][1] == false) {
            revealBoxNumbers(index + numberInEachRow);
          }
          squareStatus[index + numberInEachRow][1] = true;
        }

        if (index < numberOfSquares - numberInEachRow &&
            index % numberInEachRow != 0) {
          if (squareStatus[index - 1 + numberInEachRow][0] == 0 &&
              squareStatus[index - 1 + numberInEachRow][1] == false) {
            revealBoxNumbers(index - 1 - numberInEachRow);
          }
          squareStatus[index - 1 + numberInEachRow][1] = true;
        }
      });
    }
  }

  void scanBombs() {
    for (int i = 0; i < numberOfSquares; i++) {
      int numberOfBombsAround = 0;

      if (i % numberInEachRow != 0 && bombLocations.contains(i - 1)) {
        numberOfBombsAround++;
      } //left not [x][0]

      if (bombLocations.contains(i - 1 - numberInEachRow) &&
          i % numberInEachRow != 0 &&
          i >= numberInEachRow) {
        numberOfBombsAround++;
      } //top left not [0][0]

      if (i >= numberInEachRow && bombLocations.contains(i - numberInEachRow)) {
        numberOfBombsAround++;
      } //top not first row

      if (bombLocations.contains(i + 1 - numberInEachRow) &&
          i % numberInEachRow != numberInEachRow - 1 &&
          i >= numberInEachRow) {
        numberOfBombsAround++;
      } //top right not first row ya last col

      if (i % numberInEachRow != numberInEachRow - 1 &&
          bombLocations.contains(i + 1)) {
        numberOfBombsAround++;
      } //right  not last col

      if (bombLocations.contains(i + 1 + numberInEachRow) &&
          i % numberInEachRow != numberInEachRow - 1 &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      } //bottom right not last col ya last row

      if (i < (numberOfSquares - numberInEachRow) &&
          bombLocations.contains(i + numberInEachRow)) {
        numberOfBombsAround++;
      } //bottom not last row

      if (bombLocations.contains(i - 1 + numberInEachRow) &&
          i % numberInEachRow != 0 &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      } //bottom left not last row or first col

      setState(() {
        squareStatus[i][0] = numberOfBombsAround;
      });
    }
  }

  void playerLost() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[800],
            title: Center(
              child: Text(
                "YOU LOST!",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              MaterialButton(
                color: Colors.white,
                onPressed: () {
                  restartGame();
                  Navigator.pop(context);
                },
                child: Icon(Icons.refresh),
              )
            ],
          );
        });
  }

  void checkWinner() {
    int unrevealedBoxes = 0;
    for (int i = 0; i < numberOfSquares; i++) {
      if (squareStatus[i][1] == false) {
        unrevealedBoxes++;
      }
    }
    if (unrevealedBoxes == bombLocations.length) {
      playerWon();
    }
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime++;
      });
    });
  }

  void stopTimer() {
    if (_timer != null) {
      _timer?.cancel();
    }
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      _elapsedTime = 0;
    });
    startTimer();
  }

  void generateBombLocations() {
    int bombCount = 15;
    Set<int> bombSet = {};

    while (bombSet.length < bombCount) {
      bombSet.add((new Random()).nextInt(numberOfSquares));
    }

    bombLocations = bombSet.toList();
  }

  void playerWon() {
    updateCoins(50);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[800],
            title: Center(
              child: Text(
                "YOU WON!",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              MaterialButton(
                color: Colors.white,
                onPressed: () {
                  restartGame();
                  Navigator.pop(context);
                },
                child: Icon(Icons.refresh),
              )
            ],
          );
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

  @override
  Widget build(BuildContext context) {
    return Container(
            width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () => nextScreen(context, GameMenuScreen()),
              child: Icon(Icons.arrow_back)),
          title: Text(
            "MINESWEEPER",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Color(0xFFDAFF7D),
                shadows: [
                  Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black54)
                ]),
          ),
          backgroundColor: Color(0xFF2E7D32),
        ),
        backgroundColor: Colors.grey[200],
        body: Column(
          children: [
            Container(
              height: 150,
              color: Colors.green[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        bombLocations.length.toString(),
                        style: TextStyle(fontSize: 40),
                      ),
                      Text("B O M B"),
                    ],
                  ),
                  GestureDetector(
                    onTap:(){
                       restartGame();
                       resetTimer();},
                    child: Card(
                      child: Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 40,
                      ),
                      color: Colors.grey[700],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _elapsedTime.toString(),
                        style: TextStyle(fontSize: 40),
                      ),
                      Text('T I M E'),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: numberOfSquares,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: numberInEachRow),
                    itemBuilder: (context, index) {
                      if (bombLocations.contains(index)) {
                        return MyBomb(
                          revealed: squareStatus[index][1],
                          function: () {
                            setState(() {
                              bombsRevealed = true;
                              playerLost();
                            });
                          },
                        );
                      } else {
                        return MyNumberBox(
                          child: squareStatus[index][0],
                          revealed: squareStatus[index][1],
                          function: () {
                            checkWinner();
                            revealBoxNumbers(index);
                          },
                        );
                      }
                    }))
          ],
        ),
      ),
    );
  }
}
