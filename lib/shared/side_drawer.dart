import 'package:daily_discipleship/about.dart';
import 'package:daily_discipleship/profile.dart';
import 'package:daily_discipleship/services/models.dart';
import 'package:daily_discipleship/settings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:daily_discipleship/services/auth.dart';

class SideDrawer extends StatefulWidget {
  final User userData;
  const SideDrawer({super.key, required this.userData});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xff6750A4),
            ),
            child: Text(
              'Grace to you, \n${widget.userData.name}!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
          InkWell(
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutScreen()))
            },
            child: const ListTile(
              leading: Icon(Icons.message),
              title: Text('About'),
            ),
          ),
          InkWell(
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                            userData: widget.userData,
                          )))
            },
            child: const ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
          ),
          InkWell(
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingScreen(
                            userData: widget.userData,
                          )))
            },
            child: const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(
                  FontAwesomeIcons.rightFromBracket,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(8),
                backgroundColor: const Color(0xff6750A4),
              ),
              onPressed: () async {
                await AuthService().signOut();
                if (mounted) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                }
              },
              label: const Text('Logout',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}
