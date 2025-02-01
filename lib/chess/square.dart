import 'package:flutter/material.dart';
import 'package:pawcrastinot/chess/colors.dart';
import 'package:pawcrastinot/chess/piece.dart';
import 'package:velocity_x/velocity_x.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValidMove;
  final void Function()? onTap;
  const Square(
      {super.key,
      required this.isWhite,
      required this.piece,
      required this.isSelected,
      required this.onTap,
      required this.isValidMove});

  @override
  Widget build(BuildContext context) {
Color? squareColor;

if (isSelected) {
  squareColor = Colors.green; 
} else if (isValidMove) {
  squareColor = Colors.green[300]; 
} else {
  squareColor = isWhite ? foregroundColor : backgroundColor;
}

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isWhite
                        ? [Colors.brown.shade300, Colors.brown.shade500]
                        : [Colors.brown.shade700, Colors.brown.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),),
        margin: EdgeInsets.all(isValidMove?8:0),
        // color: squareColor,
        child: piece != null
            ? Image.asset(
                piece!.imagePath,
                color: piece!.isWhite ? Colors.white : Colors.black,
              ).pOnly(top: 7, bottom: 7)
            : null,
      ),
    );
  }
}
