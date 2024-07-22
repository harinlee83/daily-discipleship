import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:daily_discipleship/devotions/devotion_calendar.dart';
import 'package:daily_discipleship/devotions/devotions_screen.dart';
import 'package:daily_discipleship/health/fruit_of_spirit_line_chart.dart';
import 'package:daily_discipleship/change_notifiers/confetti_notifier.dart';
import 'package:daily_discipleship/health/health_screen.dart';
import 'package:daily_discipleship/services/models.dart';
import 'package:flutter/material.dart';
import 'package:daily_discipleship/shared/side_drawer.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  final User userData;

  const DashboardScreen({super.key, required this.userData});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late User userData;
  @override
  void initState() {
    super.initState();
    userData = widget.userData;
  }

  @override
  Widget build(BuildContext context) {
    final confettiNotifier = Provider.of<ConfettiNotifier>(context);
    userData = widget.userData;

    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(children: [
      Scaffold(
        appBar: AppBar(title: const Text("Dashboard")),
        drawer: SideDrawer(userData: userData),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          children: [
            DashboardHeading(
              title: "Daily Devotions",
              isButtonVisible: (!userData.history.last.hymnCompleted ||
                  !userData.history.last.prayerCompleted ||
                  !userData.history.last.readingCompleted),
              onPressedCallback: () {
                DateTime now = DateTime.now();
                DateTime today = DateTime(now.year, now.month, now.day);
                // debugPrint(today.toString());
                DateTime firstDayOfYear = DateTime(today.year, 1, 1);
                debugPrint("first day is ${firstDayOfYear.toString()}");
                // Calculate the number of days since the start of the year
                Duration daysSinceStartOfYear =
                    today.difference(firstDayOfYear);
                debugPrint(
                    "daysSinceStartOfYear is ${daysSinceStartOfYear.toString()}");
                int daysCount = daysSinceStartOfYear.inDays;

                // Calculate devotionNumber (1-30 cycle)
                int devotionNumber = (daysCount % 30) + 1;
                // debugPrint(devotionNumber.toString());

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DevotionsScreen(
                              userData: userData,
                              includeMarkAsComplete: true,
                              devotionNumber: devotionNumber,
                            )));
              },
            ),
            Visibility(
                visible: userData.dailyDevotionStreak > 0,
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        const TextSpan(
                          text: "You're on a ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            decoration: TextDecoration.none, // Remove underline
                          ),
                        ),
                        TextSpan(
                          text:
                              '${userData.dailyDevotionStreak.toString()} day',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none, // Remove underline
                          ),
                        ),
                        const TextSpan(
                          text: ' streak 🔥',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            decoration: TextDecoration.none, // Remove underline
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            Card(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: DevotionCalendar(userData: userData),
            )),
            const SizedBox(
              height: 25,
            ),
            DashboardHeading(
              title: "Spritual Health",
              isButtonVisible:
                  (!userData.history.last.spiritualHealthCheckCompleted),
              onPressedCallback: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HealthScreen(userData: userData)));
              },
            ),
            Visibility(
                visible: userData.spiritualHealthStreak > 0,
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        const TextSpan(
                          text: "You're on a ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            decoration: TextDecoration.none, // Remove underline
                          ),
                        ),
                        TextSpan(
                          text:
                              '${userData.spiritualHealthStreak.toString()} day',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none, // Remove underline
                          ),
                        ),
                        const TextSpan(
                          text: ' streak 🔥',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            decoration: TextDecoration.none, // Remove underline
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            SizedBox(
              height: 400,
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FruitOfSpiritLineChart(history: userData.history),
              )),
            ),
            // const Card(
            //     child: SizedBox(
            //         width: 300,
            //         height: 200,
            //         child: Center(
            //             child: Text('Deeds of the Flesh Line Graph Here')))),
            // const Divider(),
            // DashboardHeading(
            //   title: "My Groups",
            //   onPressedCallback: () => {debugPrint("Pressed my Groups")},
            //   isButtonVisible: false,
            // ),
          ],
        ),
      ),
      // Confetti for bottom-right shooting towards the northwest direction
      Positioned(
        bottom: 0,
        left: screenWidth * 0.5,
        child: ConfettiWidget(
          confettiController: confettiNotifier.controllerTop,
          blastDirection: -pi / 2,
          particleDrag: 0.001, // apply drag to the confetti
          emissionFrequency: .05, // how often it should emit
          numberOfParticles: 30, // number of particles to emit
          gravity: 0.25, // gravity - or fall speed
          shouldLoop: false,
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink
          ], // manually specify the colors to be used
          strokeWidth: 1,
          strokeColor: Colors.white,
        ),
      ),
    ]);
  }
}

class DashboardHeading extends StatelessWidget {
  final String title;
  final VoidCallback onPressedCallback;
  final bool isButtonVisible;
  const DashboardHeading(
      {super.key,
      required this.title,
      required this.onPressedCallback,
      required this.isButtonVisible});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.06, // Adjust the font size as needed
              fontWeight: FontWeight.bold, // Adjust the font weight as needed
            ),
          ),
        ),
        Visibility(
            visible: isButtonVisible,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: OutlinedButton(
                onPressed: onPressedCallback,
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.symmetric(
                      vertical: 5, horizontal: screenWidth * 0.02),
                  side: const BorderSide(
                    color: Color(0xff6750A4), // Border color
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Complete today's",
                      style: TextStyle(
                        fontSize: 13, // Adjust the font size as needed
                        color: Color(0xff6750A4), // Button text color
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 12, // Adjust the arrow size as needed
                      color: Color(0xff6750A4), // Arrow color
                    ),
                  ],
                ),
              ),
            ))
      ],
    );
  }
}
