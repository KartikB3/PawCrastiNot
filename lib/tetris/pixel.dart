import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class MyPixel extends StatelessWidget {
  final color;
  const MyPixel({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
    ).p1();
  }
}
