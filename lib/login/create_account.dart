import 'package:daily_discipleship/services/auth.dart';
import 'package:daily_discipleship/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:daily_discipleship/utils.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        // Allows the body to be scrollable
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height - // AppBar height
                  MediaQuery.of(context).padding.top, // Status bar height
            ),
            child: const IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CreateAccountFormContent(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CreateAccountFormContent extends StatefulWidget {
  const CreateAccountFormContent({Key? key}) : super(key: key);

  @override
  State<CreateAccountFormContent> createState() => __FormContentState();
}

class __FormContentState extends State<CreateAccountFormContent> {
  bool _isPasswordVisible = false;
  bool _isReEnterPasswordVisible = false;
  String password = "";
  String reEnterPassword = "";
  String firstName = "";
  String lastName = "";
  String email = "";
  String createAccountMessage = "";
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
                firstName = capitalizeFirstLetter(value.trim());
                debugPrint("firstName: $firstName");
              },
              validator: (value) {
                // add email validation
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                // Regex allows letters and space characters, but not numbers or symbols
                RegExp nameRegExp = RegExp(r"^[a-zA-Z\s'-]+$");
                if (!nameRegExp.hasMatch(value.trim())) {
                  return 'Please enter a valid name';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'First Name',
                hintText: 'Enter your first name',
                prefixIcon: Icon(FontAwesomeIcons.f),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              onChanged: (value) {
                lastName = capitalizeFirstLetter(value.trim());
                debugPrint("lastName: $lastName");
              },
              validator: (value) {
                // add email validation
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                RegExp nameRegExp = RegExp(r"^[a-zA-Z\s'-]+$");
                if (!nameRegExp.hasMatch(value.trim())) {
                  return 'Please enter a valid name';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Last Name',
                hintText: 'Enter your last name',
                prefixIcon: Icon(FontAwesomeIcons.l),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              onChanged: (value) {
                email = value;
                debugPrint("email: $email");
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
                prefixIcon: Icon(FontAwesomeIcons.envelope),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              onChanged: (value) {
                password = value;
                debugPrint("first password: $password");
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
                  prefixIcon: const Icon(FontAwesomeIcons.lock),
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
            TextFormField(
              onChanged: (value) {
                reEnterPassword = value;
                debugPrint("Re-enter password: $reEnterPassword");
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }

                if (reEnterPassword != password) {
                  return 'Passwords do not match';
                }
                return null;
              },
              obscureText: !_isReEnterPasswordVisible,
              decoration: InputDecoration(
                  labelText: 'Re-enter Password',
                  hintText: 'Enter your Password',
                  prefixIcon: const Icon(FontAwesomeIcons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isReEnterPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isReEnterPasswordVisible = !_isReEnterPasswordVisible;
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
                    'Create Account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    debugPrint("firstName: $firstName");
                    debugPrint("lastName: $lastName");
                    debugPrint("email: $email");
                    debugPrint("password: $reEnterPassword");
                    try {
                      final createAccountMessageFuture =
                          await FirestoreService()
                              .createNewUserWithEmailAndPassword(
                                  email, password, "$firstName $lastName");
                      setState(() {
                        createAccountMessage = createAccountMessageFuture;
                      });
                      if (createAccountMessageFuture == "" && context.mounted) {
                        Navigator.pushNamed(context, '/verify-email');
                      }
                    } catch (e) {
                      debugPrint('$e');
                    }
                  }
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  createAccountMessage,
                  style: const TextStyle(color: Colors.red),
                ),
                if (createAccountMessage ==
                    "An account already exists for this email. ")
                  InkWell(
                    child: const Text(
                      'Reset Password?',
                      style: TextStyle(color: Colors.blue),
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
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
