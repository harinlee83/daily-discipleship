import 'package:daily_discipleship/services/models.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final User userData;
  const ProfileScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // const SizedBox(height: 40), // Spacer
            // CircleAvatar(
            //   radius: 50, // Size of the profile image
            //   backgroundImage:
            //       const NetworkImage("https://via.placeholder.com/150"),
            //   backgroundColor: Colors.grey.shade200, // Placeholder color
            // ),
            const SizedBox(height: 20), // Spacer
            Text(
              userData.name,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 24,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
            const SizedBox(height: 10), // Spacer
            Text(
              userData.email,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10), // Spacer
            Text(
              "uid: ${userData.uid}",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
