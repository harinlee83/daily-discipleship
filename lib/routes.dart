import 'package:daily_discipleship/home/home.dart';
import 'package:daily_discipleship/login/create_account.dart';
import 'package:daily_discipleship/login/email_verification_page.dart';
import 'package:daily_discipleship/login/login.dart';
import 'package:daily_discipleship/login/reauthenticate.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/create-account': (context) => const CreateAccountScreen(),
  '/verify-email': (context) => const EmailVerificationScreen(),
  '/reauthenticate': (context) => const ReauthenticateScreen()
};
