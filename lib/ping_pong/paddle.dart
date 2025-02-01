import 'package:flutter/material.dart';

class MyBrick extends StatelessWidget {
  final double x;
  final double y;
  final brickWidth;
  const MyBrick({super.key, required this.x, required this.y,required this.brickWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2*x+brickWidth)/(2-brickWidth), y),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 20,
          width: MediaQuery.of(context).size.width / 5,
          decoration: BoxDecoration(
            color: Colors.yellow,
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
