import 'dart:async';
import 'package:daily_discipleship/services/auth.dart';
import 'package:daily_discipleship/services/firestore.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    AuthService().user?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  checkEmailVerified() async {
    await AuthService().user?.reload();

    setState(() {
      isEmailVerified = AuthService().user!.emailVerified;
    });

    if (isEmailVerified) {
      if (context.mounted) {
        FirestoreService().verifyUser(AuthService().user);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email Successfully Verified")));
        Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
      }
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    debugPrint("Calling dispose");
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Verification')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 35),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Center(
                child: Text(
                  'We sent an email to ${AuthService().user?.email}. Please check your email to verify your email address.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Center(
                child: Text(
                  'Verifying...',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 57),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ElevatedButton(
                child: const Text('Resend'),
                onPressed: () {
                  try {
                    AuthService().user?.sendEmailVerification();
                    if (context.mounted) {
                      var snackBar = SnackBar(
                          content: Center(
                              child: Text(
                                  'We sent an email to ${AuthService().user?.email}')),
                          duration: const Duration(milliseconds: 5000),
                          width: 280.0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 10.0,
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  } catch (e) {
                    debugPrint('$e');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
