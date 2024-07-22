import 'package:daily_discipleship/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:daily_discipleship/services/auth.dart';

class ReauthenticateScreen extends StatefulWidget {
  const ReauthenticateScreen({Key? key}) : super(key: key);

  @override
  _ReauthenticateScreenState createState() => _ReauthenticateScreenState();
}

class _ReauthenticateScreenState extends State<ReauthenticateScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    String providerId =
        AuthService().user?.providerData.first.providerId.toString() ?? '';
    debugPrint(AuthService().user?.providerData.first.providerId.toString());

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Delete Account'),
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.xmark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: screenHeight),
          child: IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Please Sign In Again to Permanently Delete Your Account.",
                    style: TextStyle(fontSize: screenWidth * 0.05),
                  ),
                  const SizedBox(height: 20),
                  if (providerId == 'password') const LoginFormContent(),
                  if (providerId == 'google.com')
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton.icon(
                        icon: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: const Icon(
                            FontAwesomeIcons.google,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: _handleDeleteAccountWithGoogle,
                        label: const Text(
                          'Delete Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleDeleteAccountWithGoogle() async {
    try {
      FocusScope.of(context).unfocus();
      await AuthService().deleteAccountWithGoogle();

      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
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
                    'Delete Account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final loginMessageFuture = await AuthService()
                        .deleteAccountWithEmail(email, password);
                    setState(() {
                      loginMessage = loginMessageFuture;
                    });
                    debugPrint(loginMessage.toString());
                  }
                  if (loginMessage == "") {
                    if (mounted) {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/', (route) => false);
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
