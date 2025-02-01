import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class FriendsScreen extends StatefulWidget {
  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final List<Map<String, String>> friends = [
    {'name': 'JohnDoe_57', 'username': '@johnDoe', 'image': 'assets/simba.jpg'},
    {'name': 'Winky', 'username': '@iamwinky', 'image': 'assets/whispers.jpg'},
    {'name': 'Hedwig', 'username': '@hedwighere', 'image': 'assets/shelly.jpg'},
    {'name': 'Snuffles', 'username': '@Snuffles', 'image': 'assets/bruno.jpg'},
    {'name': 'Allie234', 'username': '@234allie', 'image': 'assets/bambi.jpg'},
  ];
  List<Map<String, String>> searchResults = [];

  void searchFriend(String query) {
    setState(() {
      searchResults = friends
          .where((friend) => friend['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
            width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: Color(0xFFF5E1C0),
        appBar: AppBar(
          backgroundColor: Color(0xFF86A23C),
          title: Row(
            children: [
              Icon(Icons.people, color: Colors.black),
              SizedBox(width: 30),
              Text(
                'Friends',
                style: GoogleFonts.sansita(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  onChanged: searchFriend,
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.black54),
                    hintText: 'Look for a friend!!!',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.isNotEmpty ? searchResults.length : friends.length,
                  itemBuilder: (context, index) {
                    final friend = searchResults.isNotEmpty ? searchResults[index] : friends[index];
      
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white, // White background effect
                        radius: 28,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(friend['image']!),
                          backgroundColor: Colors.transparent, // Prevents grey color in case of errors
                        ),
                      ),
                      title: Text(
                        friend['name']!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(friend['username']!),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: searchResults.isNotEmpty ? Colors.green : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          searchResults.isNotEmpty ? 'Add Friend' : 'Remove',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}