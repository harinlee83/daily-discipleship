import 'package:daily_discipleship/services/firestore.dart';
import 'package:daily_discipleship/services/models.dart';
import 'package:flutter/material.dart';
import 'package:daily_discipleship/dashboard/dashboard.dart';
import 'package:daily_discipleship/login/login.dart';
import 'package:daily_discipleship/services/auth.dart';
import 'package:daily_discipleship/shared/shared.dart';
import 'package:daily_discipleship/utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return const Center(
            child: ErrorMessage(),
          );
        } else if (snapshot.hasData &&
            (AuthService().user?.emailVerified ?? false)) {
          return StreamBuilder(
            stream: FirestoreService().userDataStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
              } else if (snapshot.hasError) {
                return Center(
                  child: ErrorMessage(message: snapshot.error.toString()),
                );
              } else if (snapshot.hasData && snapshot.data!.data() != null) {
                // Make sure data is not null before casting
                User userData = User.fromJson(
                    snapshot.data!.data() as Map<String, dynamic>);
                debugPrint("userDataStream sent new data");
                if (isFirstLoginToday(userData.history)) {
                  FirestoreService().addNewHistoryDay();
                }
                if (isDailyDevotionStreakBroken(userData.history)) {
                  debugPrint("Resetting daily devotion streak!");
                  FirestoreService().endDailyDevotionStreak(0);
                }
                if (isSpiritualHealthStreakBroken(userData.history)) {
                  debugPrint("Resetting spiritual health streak!");
                  FirestoreService().endSpiritualHealthStreak(0);
                }
                return DashboardScreen(userData: userData);
              } else {
                // Handle the case when the user is deleted or logged out
                // You might want to navigate to a login screen or show a message
                return const Center(
                  child: Text("No user data available. Please login again."),
                );
              }
            },
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
