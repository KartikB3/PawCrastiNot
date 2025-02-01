import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class MyNumberBox extends StatelessWidget {
  final child;
  final bool revealed;
  final function;
  const MyNumberBox({required this.child, required this.revealed,required this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
     child: Container(
        decoration: BoxDecoration(
          gradient: revealed 
              ? LinearGradient(
                  colors: [Colors.white, Colors.green.shade100], 
                  begin: Alignment.topLeft, 
                  end: Alignment.bottomRight)
              : LinearGradient(
                  colors: [Colors.grey.shade400, Colors.grey.shade300], 
                  begin: Alignment.topLeft, 
                  end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            revealed? (child==0?"":child.toString()):"",style: TextStyle(fontWeight: FontWeight.bold,color: child==1?Colors.blue:(child==2?Colors.green:Colors.red)),
        )),
      ).p(2),
    );
  }
}
