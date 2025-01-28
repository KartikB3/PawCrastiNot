import 'dart:async';
import 'package:pawcrastinot/pages/home_Page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  late final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Future saveUserData(String fullname, String email, String password) async {
    return await userCollection
        .doc(uid)
        .set({"fullname": fullname, "email": email, "password": password});
  }

  //getter func for user data snapshot
  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //task add
  Future addTask(Map<String, dynamic> userMap, String id) async {
    await FirebaseFirestore.instance.collection("Tasks").doc(id).set(userMap);
  }

  //getter fn for task
  Future<Stream<QuerySnapshot>> getTask(String taskCollection) async {
    return await FirebaseFirestore.instance
        .collection(taskCollection)
        .snapshots();
  }

  Future updatePetDetails(String petName, String petImage) async {
    if (uid == null) {
      throw Exception("User id is null, cannot update pet details");
    }
    return await userCollection.doc(uid).update({
      "happiness":0.5,
      "hunger":0.7,
      "pet": {
        "name": petName,
        "image": petImage,
      },
    });
  }

  Future<String?> getPetName() async {
    try {
      DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? userData =
            documentSnapshot.data() as Map<String, dynamic>;
        var petData = userData?["pet"];
        if (petData != null && petData["name"] != null) {
          return petData["name"];
        }
      }
    } catch (err) {
      print("Error Fetching pet name: $err");
    }
    return null;
  }

  Future<String?> getPetImage() async {
    try {
      DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? userData =
            documentSnapshot.data() as Map<String, dynamic>?;
        var petData = userData?["pet"];
        if (petData != null && petData["image"] != null) {
          return petData["image"];
        }
      }
    } catch (err) {
      print("Error Fetching pet image:${err}");
    }
    return null;
  }

  Future<double?> getPetHappiness() async {
    try {
      DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? userData =
            documentSnapshot.data() as Map<String, dynamic>?;
        var petData = userData?["pet"];
        if (petData != null && petData["happiness"] != null) {
          return petData["happiness"];
        }
      }
    } catch (err) {
      print("Error Fetching pet happiness:${err}");
    }
    return null;
  }

  Future<void> updatePetHappiness(double newProgress) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    try {
      await _db.collection('users').doc(uid).update({'happiness': newProgress});
      print("happiness updated");
    } catch (err) {
      print("Cant update happiness:$err");
    }
  }

  Future<double?> getPetHunger() async {
    try {
      DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? userData =
            documentSnapshot.data() as Map<String, dynamic>?;
        var petData = userData?["pet"];
        if (petData != null && petData["hunger"] != null) {
          return petData["hunger"];
        }
      }
    } catch (err) {
      print("Error Fetching pet hunger:${err}");
    }
    return null;
  }

  //deleting task from firebasestore once its completed
  Future<void> completeAndRemoveTask(String id, String taskCollection) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return firestore.runTransaction((transaction) async {
      DocumentReference taskRef = firestore.collection(taskCollection).doc(id);

      // Retrieve the task document
      DocumentSnapshot taskSnapshot = await transaction.get(taskRef);

      if (!taskSnapshot.exists) {
        throw Exception("Task does not exist!");
      }

      // Mark the task as completed (you can modify the fields as needed)
      transaction.update(taskRef, {"Completed": true});

      // Delete the task after marking it as completed
      transaction.delete(taskRef);
    });
  }
}
