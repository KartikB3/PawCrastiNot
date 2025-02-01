import 'package:flutter/material.dart';
import 'package:pawcrastinot/pages/home_Page.dart';
import 'package:pawcrastinot/widgets/widgets.dart';
import 'dart:async';
import 'pet_picker_page.dart';

class GreetingPage extends StatefulWidget {
  final String selectedPet;
  final int typingSpeedMilliseconds;

  GreetingPage({required this.selectedPet, this.typingSpeedMilliseconds = 100});

  @override
  _GreetingPageState createState() => _GreetingPageState();
}

class _GreetingPageState extends State<GreetingPage> {
  late String _displayedText = '';
  late String _fullText;
  late int _charIndex = 0;

  @override
  void initState() {
    super.initState();
    _fullText =
        'Ready to start your productivity journey\nwith Paw-crasti-not and your buddy ${widget.selectedPet}!\nLet’s crush those goals together!';
    _startTypewriterAnimation();
  }

  void _startTypewriterAnimation() {
    Timer.periodic(Duration(milliseconds: widget.typingSpeedMilliseconds),
        (timer) {
      if (_charIndex < _fullText.length) {
        setState(() {
          _charIndex++;
          _displayedText = _fullText.substring(0, _charIndex);
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
            width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Greetings!',
            style: TextStyle(
              fontFamily: 'play',
              fontSize: 20,
            ),
          ),
        ),
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_image.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _displayedText,
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.lightGreen,
                        fontFamily: 'play',
                      ),
                      textAlign: TextAlign.center,
                      semanticsLabel: _fullText,
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap:(){
                        nextScreen(
                          context,
                          HomePage()
                        );
                      },
                      child: Icon(
                        Icons.arrow_forward,
                        size: 50,
                        color: Colors.black26,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
