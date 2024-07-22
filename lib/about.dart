import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final Future<PackageInfo> _packageInfo = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Daily Discipleship is a faith-based accountability app that tracks your personal devotions and spiritual growth.",
                  style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Text(
                  "KJV Bible sourced from https://www.o-bible.com/download/kjv.txt.",
                  style: TextStyle(fontSize: screenWidth * 0.05),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Text(
                  "Hymnal resources (PDFs and MP3s) sourced from Open Hymnal at http://openhymnal.org/index.html.",
                  style: TextStyle(fontSize: screenWidth * 0.05),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                FutureBuilder<PackageInfo>(
                  future: _packageInfo,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        'Version: ${snapshot.data!.version}',
                        style: TextStyle(fontSize: screenWidth * 0.04),
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return const CircularProgressIndicator(); // Or some other placeholder widget
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
