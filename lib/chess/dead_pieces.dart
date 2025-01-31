import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class DeadPiece extends StatelessWidget {
  final String imagePath;
  final bool isWhite;
  const DeadPiece({
    super.key,
    required this.isWhite,
    required this.imagePath
    });

  @override
  Widget build(BuildContext context) {
    return Image.asset(imagePath,color: isWhite?Colors.white:Colors.black,).pOnly(top: 13);
  }
}
