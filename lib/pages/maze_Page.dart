import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MazePage extends StatefulWidget {
  @override
  _MazePageState createState() => _MazePageState();
}

class _MazePageState extends State<MazePage> {
  int currentLevel = 0; // Current maze level

  // Define 3 maze levels (0 = empty path, 1 = wall, 2 = goal)
  final List<List<List<int>>> levels = [
    // Level 1: Easy (larger maze)
    [
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 1, 0, 0, 0, 1, 1],
      [1, 0, 1, 0, 1, 0, 1, 0, 1, 1],
      [1, 0, 1, 0, 0, 0, 1, 0, 1, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 1, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 2, 1],
    ],
    // Level 2: Medium (larger maze)
    [
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 1, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 0, 1, 1, 0, 0, 1],
      [1, 0, 0, 0, 0, 1, 1, 0, 1, 1],
      [1, 1, 0, 0, 1, 1, 0, 0, 0, 1],
      [1, 0, 1, 0, 0, 1, 1, 0, 1, 1],
      [1, 1, 1, 0, 1, 1, 1, 0, 2, 1],
    ],
    // Level 3: Hard (larger maze)
    [
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 1, 0, 0, 0, 1, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 1, 1],
      [1, 0, 0, 0, 1, 1, 0, 0, 1, 1],
      [1, 0, 1, 0, 0, 0, 0, 0, 1, 1],
      [1, 1, 0, 0, 1, 0, 1, 0, 0, 1],
      [1, 1, 1, 1, 1, 0, 1, 1, 0, 1],
      [1, 1, 1, 0, 1, 1, 0, 1, 2, 1],
    ]
  ];

  // Starting positions for each level
  final List<Map<String, int>> startPositions = [
    {'row': 1, 'col': 1}, // Level 1
    {'row': 1, 'col': 1}, // Level 2
    {'row': 1, 'col': 1}, // Level 3
  ];

  int petRow = 1;
  int petCol = 1;

  @override
  void initState() {
    super.initState();
    _setLevel(currentLevel);
  }

  void _setLevel(int level) {
    setState(() {
      currentLevel = level;
      petRow = startPositions[level]['row']!;
      petCol = startPositions[level]['col']!;
    });
  }

  void movePet(int dRow, int dCol) {
    int newRow = petRow + dRow;
    int newCol = petCol + dCol;
    List<List<int>> maze = levels[currentLevel];

    if (newRow >= 0 &&
        newRow < maze.length &&
        newCol >= 0 &&
        newCol < maze[0].length &&
        maze[newRow][newCol] != 1) {
      setState(() {
        petRow = newRow;
        petCol = newCol;

        if (maze[petRow][petCol] == 2) {
          if (currentLevel < levels.length - 1) {
            _showNextLevelDialog();
          } else {
            _showWinDialog();
          }
        }
      });
    }
  }

  void _showNextLevelDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("🎉 Level Cleared!"),
        content: Text("Your pet made it! Get ready for the next level."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _setLevel(currentLevel + 1);
            },
            child: Text("Next Level"),
          ),
        ],
      ),
    );
  }

  void _showWinDialog() {
    updateCoins(100);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("🏆 You Won!"),
        content: Text("Your pet has escaped all the mazes! 🐶"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _setLevel(0);
            },
            child: Text("Restart"),
          ),
        ],
      ),
    );
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
    List<List<int>> maze = levels[currentLevel];

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: Color(0xFFF5E1C0),
        appBar: AppBar(
          title: Text('Pet Maze - Level ${currentLevel + 1}'),
          backgroundColor: Color(0xFF86A23C),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: List.generate(maze.length, (row) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(maze[row].length, (col) {
                    if (row == petRow && col == petCol) {
                      return _buildCell("🐶", Colors.orangeAccent);
                    } else if (maze[row][col] == 1) {
                      return _buildCell("🟫", Colors.brown);
                    } else if (maze[row][col] == 2) {
                      return _buildCell("🏁", Colors.green);
                    } else {
                      return _buildCell("", Colors.white);
                    }
                  }),
                );
              }),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildArrowButton(Icons.arrow_upward, () => movePet(-1, 0)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildArrowButton(Icons.arrow_back, () => movePet(0, -1)),
                SizedBox(width: 20),
                _buildArrowButton(Icons.arrow_forward, () => movePet(0, 1)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildArrowButton(Icons.arrow_downward, () => movePet(1, 0)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCell(String emoji, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black),
      ),
      alignment: Alignment.center,
      child: Text(
        emoji,
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildArrowButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, size: 40, color: Colors.black),
      onPressed: onPressed,
    );
  }
}
