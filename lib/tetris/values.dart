import 'package:flutter/material.dart';

enum Tetromino { L, J, I, O, S, Z, T }

int rowLength = 10;
int colLength = 15;

enum Direction { left, right, down }

const Map<Tetromino, Color> tetroominoColors = {
  Tetromino.L: Color(0xFFE65100),
  Tetromino.I: Color(0xFF00E5FF), 
  Tetromino.O: Color(0xFFFFEB3B), 
  Tetromino.S: Color(0xFF00C853), 
  Tetromino.Z: Color(0xFFD50000), 
  Tetromino.T: Color(0xFFAA00FF),
};
