import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FriendsScreen(),
    );
  }
}

class FriendsScreen extends StatefulWidget {
  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final List<Map<String, String>> friends = [
    {'name': 'JohnDoe_57', 'username': '@johnDoe'},
    {'name': 'Winky', 'username': '@iamwinky'},
    {'name': 'Hedwig', 'username': '@hedwighere'},
    {'name': 'Snuffles', 'username': '@Snuffles'},
    {'name': 'Allie234', 'username': '@234allie'},
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
    return Scaffold(
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
            searchResults.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[400],
                          ),
                          title: Text(
                            searchResults[index]['name']!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(searchResults[index]['username']!),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {},
                            child: Text('Add Friend', style: TextStyle(color: Colors.white)),
                          ),
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: Column(
                      children: [
                        Text(
                          'YOUR FRIENDS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.brown,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: friends.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.grey[400],
                                ),
                                title: Text(
                                  friends[index]['name']!,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(friends[index]['username']!),
                                trailing: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Text('Remove', style: TextStyle(color: Colors.white)),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}