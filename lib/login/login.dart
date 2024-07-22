import 'package:daily_discipleship/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:daily_discipleship/services/auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        'assets/circle_logo.png',
                        width: screenWidth * 0.3,
                        height: screenWidth * 0.3,
                      ),
                      Text("Daily Discipleship",
                          style: TextStyle(fontSize: screenWidth * 0.1)),
                    ],
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LoginFormContent(),
                      // Row(children: <Widget>[
                      // Expanded(
                      //   child: Container(
                      //       margin: const EdgeInsets.only(
                      //           left: 10.0, right: 20.0),
                      //       child: const Divider(
                      //         color: Colors.black,
                      //         height: 36,
                      //       )),
                      // ),
                      //   const Text("OR"),
                      //   Expanded(
                      //     child: Container(
                      //         margin: const EdgeInsets.only(
                      //             left: 20.0, right: 10.0),
                      //         child: const Divider(
                      //           color: Colors.black,
                      //           height: 36,
                      //         )),
                      //   ),
                      // ]),
                      // const SizedBox(height: 16),
                      // Container(
                      //   margin: const EdgeInsets.only(bottom: 10),
                      //   child: ElevatedButton.icon(
                      //     icon: Container(
                      //       margin: const EdgeInsets.symmetric(horizontal: 10),
                      //       child: const Icon(
                      //         FontAwesomeIcons.google,
                      //         color: Colors.white,
                      //         size: 30,
                      //       ),
                      //     ),
                      //     style: TextButton.styleFrom(
                      //       padding: const EdgeInsets.all(15),
                      //       backgroundColor: const Color(0xff6750A4),
                      //     ),
                      //     onPressed: () async {
                      //       try {
                      //         FocusScope.of(context).unfocus();
                      //         await AuthService().googleLogin();
                      //         await FirestoreService().addUserIfNotExists(
                      //             AuthService().user?.email ?? "",
                      //             AuthService().user?.displayName ?? "");
                      //       } catch (e) {
                      //         debugPrint(e.toString());
                      //       }
                      //     },
                      //     label: const Text('Sign in with Google',
                      //         textAlign: TextAlign.center,
                      //         style: TextStyle(
                      //             color: Colors.white,
                      //             fontWeight: FontWeight.bold,
                      //             fontSize: 15)),
                      //   ),
                      // ),
                      // Container(
                      //   margin: const EdgeInsets.only(bottom: 10),
                      //   child: ElevatedButton.icon(
                      //     icon: Container(
                      //       margin: const EdgeInsets.symmetric(horizontal: 10),
                      //       child: const Icon(
                      //         FontAwesomeIcons.apple,
                      //         color: Colors.white,
                      //         size: 30,
                      //       ),
                      //     ),
                      //     style: TextButton.styleFrom(
                      //       padding: const EdgeInsets.all(15),
                      //       backgroundColor: const Color(0xff21005D),
                      //     ),
                      //     onPressed: () async {
                      //       try {
                      //         FocusScope.of(context).unfocus();
                      //         await AuthService().signInWithApple();
                      //         await FirestoreService().addUserIfNotExists(
                      //             AuthService().user?.email ?? "",
                      //             AuthService().user?.displayName ?? "");
                      //       } catch (e) {
                      //         debugPrint(e.toString());
                      //       }
                      //     },
                      //     label: const Text('Sign in with Apple',
                      //         textAlign: TextAlign.center,
                      //         style: TextStyle(
                      //             color: Colors.white,
                      //             fontWeight: FontWeight.bold,
                      //             fontSize: 15)),
                      //   ),
                      // ),
                      // LoginButton(
                      //   icon: FontAwesomeIcons.userNinja,
                      //   text: 'Continue as Guest',
                      //   loginMethod: AuthService().anonLogin,
                      //   color: Colors.lightGreen,
                      // ),
                    ],
                  )
                ],
              ),
            ),
          ),
        )));
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton(
      {super.key,
      required this.text,
      required this.icon,
      required this.color,
      required this.loginMethod});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        icon: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(15),
          backgroundColor: color,
        ),
        onPressed: () => loginMethod(),
        label: Text(text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15)),
      ),
    );
  }
}

class LoginFormContent extends StatefulWidget {
  const LoginFormContent({Key? key}) : super(key: key);

  @override
  State<LoginFormContent> createState() => _LoginFormContentState();
}

class _LoginFormContentState extends State<LoginFormContent> {
  bool _isPasswordVisible = false;
  String email = "";
  String password = "";
  String loginMessage = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              onChanged: (value) {
                email = value;
                debugPrint("lastName: $email");
              },
              validator: (value) {
                // add email validation
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                if (!emailValid) {
                  return 'Please enter a valid email';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              onChanged: (value) {
                password = value;
                debugPrint("lastName: $password");
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final loginMessageFuture =
                        await AuthService().emailLogin(email, password);
                    setState(() {
                      loginMessage = loginMessageFuture;
                    });
                    debugPrint(loginMessage.toString());
                    if (!(AuthService().user?.emailVerified ?? true)) {
                      setState(() {
                        loginMessage =
                            "Please verify your email. Another verification email has been sent.";
                      });
                      AuthService().user?.sendEmailVerification();
                      AuthService().signOut();
                    }
                  }
                },
              ),
            ),
            _gap(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  loginMessage,
                  style: const TextStyle(color: Colors.red),
                ),
                if (loginMessage == "Incorrect password. ")
                  InkWell(
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xff6750A4)),
                    ),
                    onTap: () {
                      AuthService().sendPasswordResetEmail(email);
                      if (context.mounted) {
                        var snackBar = SnackBar(
                            content: Center(
                                child: Text(
                                    'Reset password email sent to $email')),
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
                    },
                  ),
              ],
            ),
            _gap(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account?'),
                const SizedBox(width: 5.0),
                InkWell(
                  child: const Text(
                    'Create an account',
                    style: TextStyle(color: Color(0xff6750A4)),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/create-account');
                  },
                ),
              ],
            ),
            _gap(),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
