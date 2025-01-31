import 'dart:io';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class MyBomb extends StatelessWidget {
  final bool revealed;
  final function;

  const MyBomb({super.key,required this.revealed,required this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        color:revealed? Colors.grey[800]:Colors.grey[400],
      ).p(2),
    );
  }
}
