import 'package:flutter/material.dart';
import 'package:pawcrastinot/widgets/widgets.dart';
import 'package:velocity_x/velocity_x.dart';
import 'greeting_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawcrastinot/service/database_service.dart';

class PetPickerPage extends StatefulWidget {
  @override
  _PetPickerPageState createState() => _PetPickerPageState();
}

class _PetPickerPageState extends State<PetPickerPage> {
  final List<Map<String, String>> pets = [
    {"name": "Simba", "image": "assets/simba.jpg"},
    {"name": "Shelly", "image": "assets/shelly.jpg"},
    {"name": "Bambi", "image": "assets/bambi.jpg"},
    {"name": "Bunny", "image": "assets/bunny.jpg"},
    {"name": "Bruno", "image": "assets/bruno.jpg"},
    {"name": "Whispers", "image": "assets/whispers.jpg"},
  ];

  String? selectedPet;

  void _selectPet(String petName) {
    setState(() {
      selectedPet = petName;
    });
  }

  void _confirmSelection() async {
    if (selectedPet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a pet to continue!')),
      );
    } else {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      try {
        await DatabaseService(uid: userId).updatePetDetails(
          selectedPet!,
          "assets/${selectedPet!}_happy.jpg",
          "assets/${selectedPet!}_sad.jpg"
        );
        showDialog(
            context: context,
            builder: (context) => Center(
                  child: CircularProgressIndicator(),
                ));
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop();
          nextScreen(context, GreetingPage(selectedPet: selectedPet!));
        });
      } catch (err) {
        print("Failed to update pet details: ${err}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                "failed to save pet details. please try again".text.make()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Your Pet'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                final isSelected = selectedPet == pet['name'];
                return GestureDetector(
                  onTap: () => _selectPet(pet['name']!),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.green : Colors.grey,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(pet['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.black54,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        pet['name']!,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _confirmSelection,
              child: Text('Confirm Selection'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                disabledBackgroundColor: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
