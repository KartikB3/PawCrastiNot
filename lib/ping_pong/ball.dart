import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  final double x;
  final double y;
  const MyBall({super.key,required this.x,required this.y});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(x, y),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent,
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(2, 2)
            )
          ]
        ),
      ),
    );
  }
}