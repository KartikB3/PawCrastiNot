import 'package:flutter/material.dart';
import 'package:pawcrastinot/helper/helper_function.dart';
import 'package:pawcrastinot/pages/Login_Page.dart';
import 'package:pawcrastinot/widgets/widgets.dart';
import 'pet_picker_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  bool _isSignedIn = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.2)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/main_image1.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                'assets/pawtext.png',
                width: 300,
                height: 300,
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                nextScreen(context, LoginPage());
              },
              child: Icon(
                Icons.arrow_forward,
                size: 65,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
