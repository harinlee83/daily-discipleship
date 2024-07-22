import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_discipleship/services/auth.dart';
import 'package:daily_discipleship/services/models.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final user = AuthService().user;
  final userDataStream = FirebaseFirestore.instance
      .collection('users')
      .doc(AuthService().user?.uid)
      .snapshots();

  Future<Devotion> getDevotion(String devotionId) async {
    var ref = _db.collection('devotions').doc(devotionId);
    var snapshot = await ref.get();
    return Devotion.fromJson(snapshot.data() ?? {});
  }

  Future<String> createNewUserWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      debugPrint("Creating new user with email...");
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint("Created new user with email: $email");
      debugPrint("Adding new user to firestore users collection");
      await createNewUser(name, email, userCredential.user?.uid, false);
      debugPrint("Added new user to firestore users collection");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
        return "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        debugPrint('An account already exists for this email.');
        return "An account already exists for this email. ";
      }
    }
    return "";
  }

  Future<bool> doesUserExist(String uid) async {
    try {
      DocumentSnapshot userDoc = await _db.collection('users').doc(uid).get();
      return userDoc.exists;
    } catch (e) {
      debugPrint('Error checking user existence: $e');
      return false;
    }
  }

  Future<void> addUserIfNotExists(String email, String name) async {
    try {
      final user = AuthService().user;
      if (user != null) {
        bool userExists = await doesUserExist(user.uid);
        if (!userExists) {
          await createNewUser(name, email, user.uid, true);
          debugPrint('New user added successfully');
        } else {
          debugPrint('User already exists');
        }
      } else {
        debugPrint('No user is currently signed in');
      }
    } catch (e) {
      debugPrint('Error adding user: $e');
    }
  }

  Future<void> createNewUser(
      String name, String email, uid, bool isVerifiedEmail) async {
    try {
      debugPrint('Creating new user...');
      await _db.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'uid': AuthService().user?.uid,
        "dailyDevotionStreak": 0,
        "spiritualHealthStreak": 0,
        "emailIsVerified": isVerifiedEmail,
        "notificationTime": "8:00",
        'history': [
          {
            "date": DateTime.now(),
            "readingCompleted": false,
            "hymnCompleted": false,
            "prayerCompleted": false,
            "spiritualHealthCheckCompleted": false,
            "fruitOfSpiritRunningSum": {
              "love": 0,
              "joy": 0,
              "peace": 0,
              "patience": 0,
              "kindness": 0,
              "goodness": 0,
              "faithfulness": 0,
              "gentleness": 0,
              "selfControl": 0
            }
          }
        ]
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> verifyUser(user) async {
    debugPrint("Verifying user email...");
    DocumentReference documentReference = _db.collection('users').doc(user.uid);
    await documentReference.update({'emailIsVerified': true});
    debugPrint('Field updated successfully.');
  }

  Future<void> markAsComplete(String field) async {
    try {
      // Fetch the current document
      DocumentSnapshot documentSnapshot =
          await _db.collection('users').doc(user?.uid).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data()! as Map<String, dynamic>;
        List<dynamic> listField = data['history'] ?? [];

        // Ensure the list is not empty before modifying
        if (listField.isNotEmpty) {
          // Assuming each item in the list is a map
          Map<String, dynamic> lastItem =
              listField.last as Map<String, dynamic>;

          // Modify the field within the last item
          lastItem[field] = true; // Set to the value you want
          debugPrint(listField.last.toString());

          // Update the modified list back to Firestore
          await _db
              .collection('users')
              .doc(user?.uid)
              .update({'history': listField});

          debugPrint('Last item in list field updated successfully!');
        } else {
          debugPrint('List is empty, nothing to update.');
        }
      } else {
        debugPrint('Document does not exist.');
      }
    } catch (e) {
      debugPrint('Error updating last item in list field: $e');
    }
  }

  Future<void> updateFruitOfSpiritCount(
    Map<String, int> fruitOfSpiritState,
  ) async {
    try {
      // Fetch the current document
      DocumentSnapshot documentSnapshot =
          await _db.collection('users').doc(user?.uid).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data()! as Map<String, dynamic>;
        List<dynamic> history = data['history'] ?? [];

        // Find the last item where ["fruitOfSpiritRunningSum"]["love"] is not null
        Map<String, dynamic>? notNullLastItem;
        for (int i = history.length - 1; i >= 0; i--) {
          Map<String, dynamic> currentItem = history[i] as Map<String, dynamic>;
          if (currentItem["fruitOfSpiritRunningSum"]["love"] != null) {
            notNullLastItem = currentItem;
            break; // Stop searching once we find the desired item
          }
        }

        // Assuming each item in the list is a map
        Map<String, dynamic> lastItem = history.last as Map<String, dynamic>;

        if (notNullLastItem != null) {
          // Modify the field within the last item
          lastItem["fruitOfSpiritRunningSum"] = {
            "love": notNullLastItem["fruitOfSpiritRunningSum"]["love"] +
                fruitOfSpiritState["Love"],
            "joy": notNullLastItem["fruitOfSpiritRunningSum"]["joy"] +
                fruitOfSpiritState["Joy"],
            "peace": notNullLastItem["fruitOfSpiritRunningSum"]["peace"] +
                fruitOfSpiritState["Peace"],
            "patience": notNullLastItem["fruitOfSpiritRunningSum"]["patience"] +
                fruitOfSpiritState["Patience"],
            "kindness": notNullLastItem["fruitOfSpiritRunningSum"]["kindness"] +
                fruitOfSpiritState["Kindness"],
            "goodness": notNullLastItem["fruitOfSpiritRunningSum"]["goodness"] +
                fruitOfSpiritState["Goodness"],
            "faithfulness": notNullLastItem["fruitOfSpiritRunningSum"]
                    ["faithfulness"] +
                fruitOfSpiritState["Faithfulness"],
            "gentleness": notNullLastItem["fruitOfSpiritRunningSum"]
                    ["gentleness"] +
                fruitOfSpiritState["Gentleness"],
            "selfControl": notNullLastItem["fruitOfSpiritRunningSum"]
                    ["selfControl"] +
                fruitOfSpiritState["Self-Control"]
          };
        } else {
          // Handle the case where no item meets the condition
          debugPrint('No item with a non-null "love" field found.');
        }

        // Update the modified list back to Firestore
        await _db
            .collection('users')
            .doc(user?.uid)
            .update({'history': history});

        debugPrint('Last item in list field updated successfully!');
      } else {
        debugPrint('Document does not exist.');
      }
    } catch (e) {
      debugPrint('Error updating last item in list field: $e');
    }
  }

  Future<void> addNewHistoryDay() async {
    DocumentReference docRef = _db.collection('users').doc(user?.uid);

    DocumentSnapshot docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      List<dynamic> history = data['history'] ?? [];
      Map<String, dynamic> newHistoryDay = Map.from(history.last);
      newHistoryDay["date"] = DateTime.now();
      newHistoryDay["hymnCompleted"] = false;
      newHistoryDay["readingCompleted"] = false;
      newHistoryDay["prayerCompleted"] = false;
      newHistoryDay["spiritualHealthCheckCompleted"] = false;
      newHistoryDay["fruitOfSpiritRunningSum"] = {
        "love": null,
        "joy": null,
        "peace": null,
        "patience": null,
        "kindness": null,
        "goodness": null,
        "faithfulness": null,
        "gentleness": null,
        "selfControl": null
      };
      history.add(newHistoryDay);
      await docRef.update({'history': history});
    }
  }

  Future<void> continueDailyDevotionStreak() async {
    try {
      DocumentReference docRef = _db.collection('users').doc(user?.uid);

      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        await docRef
            .update({'dailyDevotionStreak': data["dailyDevotionStreak"] + 1});
      }
    } catch (e) {
      debugPrint("Error with continueDailyDevotionsStreak");
    }
  }

  Future<void> continueSpiritualHealthStreak() async {
    try {
      DocumentReference docRef = _db.collection('users').doc(user?.uid);

      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        await docRef.update(
            {'spiritualHealthStreak': data["spiritualHealthStreak"] + 1});
      }
    } catch (e) {
      debugPrint("Error with spiritualHealthStreak");
    }
  }

  Future<void> endDailyDevotionStreak(int number) async {
    try {
      DocumentReference docRef = _db.collection('users').doc(user?.uid);
      await docRef.update({'dailyDevotionStreak': number});
    } catch (e) {
      debugPrint("Error with endDailyDevotionsStreak");
    }
  }

  Future<void> endSpiritualHealthStreak(int number) async {
    try {
      DocumentReference docRef = _db.collection('users').doc(user?.uid);
      await docRef.update({'spiritualHealthStreak': number});
    } catch (e) {
      debugPrint("Error with spiritualHealthStreak");
    }
  }

  Future<User> getUserData(String? uid) async {
    var ref = _db.collection('users').doc(uid);
    var snapshot = await ref.get();
    return User.fromJson(snapshot.data() ?? {});
  }

  Future<void> updateNotificationTime(
      String uid, TimeOfDay notificationTime) async {
    await FirebaseFirestore.instance
        .collection('users') // Assuming 'users' is your collection
        .doc(uid) // The document ID of the user
        .update({
      'notificationTime':
          '${notificationTime.hour}:${notificationTime.minute.toString().padLeft(2, '0')}'
    }).catchError((error) {
      // Handle errors here
      debugPrint("Error updating document: $error");
    });
  }

  Future<void> deleteUserAccount(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
