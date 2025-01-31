import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboard = [
    {"name": "Dobby", "username": "@dobby", "score": 2430, "image": "assets/dobby.png"},
    {"name": "Jackson", "username": "@jackson", "score": 1847, "image": "assets/jackson.png"},
    {"name": "Emma Aria", "username": "@emma", "score": 1674, "image": "assets/emma.png"},
    {"name": "Fluffy", "username": "@fluffy", "score": 1124, "image": "assets/fluffy.png"},
    {"name": "Jason", "username": "@jason", "score": 875, "image": "assets/jason.png"},
    {"name": "Natalie", "username": "@natalie", "score": 774, "image": "assets/natalie.png"},
    {"name": "Serenity", "username": "@serenity", "score": 723, "image": "assets/serenity.png"},
    {"name": "Hannah", "username": "@hannah", "score": 559, "image": "assets/hannah.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 245, 241),
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Pawcrastinot", style: GoogleFonts.sansita(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Text(
            "Leaderboard",
            style: GoogleFonts.sansita(fontSize: 24, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 28, 41, 12)),
          ),
          SizedBox(height: 10),
          _buildTopThree(),
          Expanded(child: _buildLeaderboardList()),
        ],
      ),
    );
  }

  Widget _buildTopThree() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(child: _buildProfileCard(leaderboard[1], 2)), // Second place
          Flexible(child: _buildProfileCard(leaderboard[0], 1, isWinner: true)), // First place
          Flexible(child: _buildProfileCard(leaderboard[2], 3)), // Third place
        ],
      ),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> player, int rank, {bool isWinner = false}) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            CircleAvatar(
              radius: isWinner ? 45 : 40,
              backgroundImage: AssetImage(player['image']),
            ),
            if (isWinner)
              Positioned(
                top: -5,
                child: Icon(Icons.emoji_events, color: Colors.orange, size: 24),
              ),
          ],
        ),
        SizedBox(height: 5),
        Text(player["name"], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(player["username"], style: TextStyle(fontSize: 14, color: const Color.fromARGB(203, 19, 147, 102))),
        Text(player["score"].toString(), style: TextStyle(fontSize: 16, color: Colors.green)),
      ],
    );
  }

  Widget _buildLeaderboardList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 10),
      itemCount: leaderboard.length - 3,
      itemBuilder: (context, index) {
        final player = leaderboard[index + 3];
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 172, 215, 191),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 2)],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(player['image']),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(player["name"], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(player["username"], style: TextStyle(fontSize: 14, color: const Color.fromARGB(122, 14, 105, 79))),
              ],
            ),
            trailing: Text(player["score"].toString(), style: TextStyle(fontSize: 16, color: Colors.green)),
          ),
        );
      },
    );
  }
}