import 'package:flutter/material.dart';

class TriviaPage extends StatefulWidget {
  @override
  _TriviaPageState createState() => _TriviaPageState();
}

class _TriviaPageState extends State<TriviaPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;

  List<Map<String, dynamic>> _questions = [
    {
      'question': 'Which dog breed is known for being the best swimmer?',
      'answers': ['Labrador Retriever', 'Poodle', 'Bulldog', 'Chihuahua'],
      'correctAnswer': 'Labrador Retriever',
    },
    {
      'question': 'What is a group of kittens called?',
      'answers': ['Litter', 'Pack', 'Herd', 'Flock'],
      'correctAnswer': 'Litter',
    },
    {
      'question': 'Which animal has the best sense of smell?',
      'answers': ['Dog', 'Cat', 'Elephant', 'Shark'],
      'correctAnswer': 'Dog',
    },
    {
      'question': 'What is the world’s smallest dog breed?',
      'answers': ['Chihuahua', 'Pomeranian', 'Dachshund', 'Pug'],
      'correctAnswer': 'Chihuahua',
    },
    {
      'question': 'Which pet can recognize their owner’s voice?',
      'answers': ['Dog', 'Cat', 'Both', 'None'],
      'correctAnswer': 'Both',
    },
    {
      'question': 'What do cats use their whiskers for?',
      'answers': ['Balance', 'Navigation', 'Hearing', 'Smelling'],
      'correctAnswer': 'Navigation',
    },
    {
      'question': 'Which pet is known to "knead" when happy?',
      'answers': ['Dog', 'Cat', 'Rabbit', 'Guinea Pig'],
      'correctAnswer': 'Cat',
    },
  ];

  void _answerQuestion(String answer) {
    if (answer == _questions[_currentQuestionIndex]['correctAnswer']) {
      setState(() {
        _score++;
      });
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _showScore();
    }
  }

  void _showScore() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('🎉 Quiz Over!'),
        content: Text('You scored 🏆 $_score out of ${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _currentQuestionIndex = 0;
                _score = 0;
              });
            },
            child: Text('Try Again', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Container(
            width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: Color(0xFFFAF0E1),
        appBar: AppBar(
          title: Text('🐾 Pet Trivia Game 🎮'),
          backgroundColor: Color(0xFF86A23C),
          elevation: 5,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentQuestion['question'],
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreen),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ...currentQuestion['answers'].map((answer) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () => _answerQuestion(answer),
                    child: Text(
                      answer,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Score: 🏅 $_score',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Icon(
                Icons.pets,
                size: 40,
                color: Colors.orangeAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}