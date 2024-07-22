import 'package:daily_discipleship/change_notifiers/confetti_notifier.dart';
import 'package:daily_discipleship/health/health_state.dart';
import 'package:daily_discipleship/services/auth.dart';
import 'package:daily_discipleship/services/firestore.dart';
import 'package:daily_discipleship/services/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HealthScreen extends StatelessWidget {
  final User userData;
  const HealthScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => HealthState(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Fruit of the Spirit'),
            leading: IconButton(
              icon: const Icon(FontAwesomeIcons.xmark),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            controller: HealthState().controller,
            itemBuilder: (BuildContext context, int idx) {
              if (idx == 0) {
                return FruitOfSpiritPage(userData: userData);
              } else if (idx == 1) {
                return const DeedsOfFleshPage();
              } else {
                return const CompletedPage();
              }
            },
          ),
        ));
  }
}

class FruitOfSpiritPage extends StatelessWidget {
  final User userData;
  const FruitOfSpiritPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            'Tap through the buttons to show if you are growing (green) or struggling (red) in these areas',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            softWrap: true,
            maxLines: 4,
          ),
        ),
        const CirclesGrid(),
        const SizedBox(height: 10),
        ElevatedButton(
            onPressed: () async {
              await FirestoreService().updateFruitOfSpiritCount(
                  Provider.of<HealthState>(context, listen: false)
                      .fruitOfTheSpiritState);
              await FirestoreService()
                  .markAsComplete("spiritualHealthCheckCompleted");
              debugPrint("Marking Spiritual Health as Completed");
              User userData =
                  await FirestoreService().getUserData(AuthService().user?.uid);
              debugPrint("Updating User Data");
              var snackBar = SnackBar(
                  content: const Center(
                      child: Text('Spiritual Health Check Completed! 🥳')),
                  duration: const Duration(milliseconds: 3000),
                  width: 280.0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 10.0,
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ));
              debugPrint(userData.history.last.spiritualHealthCheckCompleted
                  .toString());
              if (userData.history.last.spiritualHealthCheckCompleted) {
                debugPrint("Spiritual Health Check Completed");
                if (continueSpiritualHealthStreak(userData.history)) {
                  debugPrint("Adding 1 to daily streak!");
                  FirestoreService().continueSpiritualHealthStreak();
                }
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  final confettiNotifier =
                      Provider.of<ConfettiNotifier>(context, listen: false);
                  confettiNotifier.playConfetti();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(screenWidth - 30, 60),
            ),
            child: const Text('Submit', style: TextStyle(fontSize: 25))),
        const SizedBox(height: 40)
      ]),
    );
  }
}

class DeedsOfFleshPage extends StatelessWidget {
  const DeedsOfFleshPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CompletedPage extends StatelessWidget {
  const CompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CirclesGrid extends StatelessWidget {
  const CirclesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    const String svgString = '''
<?xml version="1.0" encoding="iso-8859-1"?>
<!-- Uploaded to: SVG Repo, www.svgrepo.com, Generator: SVG Repo Mixer Tools -->
<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" 
	 viewBox="93 -10 419 619" preserveAspectRatio="xMidYMid meet">
<g id="XMLID_1159_" transform="scale(1.9)">
	<path id="XMLID_18_" style="fill:#91DC5A;" d="M80.627,30.365c0,0-7.682,43.532,17.07,68.285
		c24.754,24.752,68.285,17.071,68.285,17.071s8.535-42.678-17.072-68.284C123.305,21.83,80.627,30.365,80.627,30.365z"/>
	<path id="XMLID_1160_" style="fill:#804C09;" d="M174.5,109V46c0-8.822,7.178-16,16-16h9c8.284,0,15-6.716,15-15s-6.716-15-15-15
		h-9c-25.364,0-46,20.636-46,46v63H174.5z"/>
	<path id="XMLID_1161_" style="fill:#91DC5A;" d="M269.5,149c0-22.092-17.908-40-40-40c-0.42,0-0.836,0.019-1.253,0.031
		C223.818,91.764,208.15,79,189.5,79c-11.951,0-22.67,5.248-30,13.557C152.17,84.248,141.451,79,129.5,79
		c-18.65,0-34.318,12.764-38.747,30.031C90.336,109.019,89.92,109,89.5,109c-22.092,0-40,17.908-40,40s17.908,40,40,40
		c1.271,0,2.525-0.066,3.766-0.182C84.836,196.151,79.5,206.949,79.5,219c0,22.092,17.908,40,40,40c1.899,0,3.765-0.142,5.593-0.397
		c-3.549,5.974-5.593,12.945-5.593,20.397c0,22.092,17.908,40,40,40s40-17.908,40-40c0-7.452-2.044-14.424-5.593-20.397
		c1.828,0.256,3.693,0.397,5.593,0.397c22.092,0,40-17.908,40-40c0-12.051-5.336-22.849-13.766-30.182
		c1.24,0.115,2.495,0.182,3.766,0.182C251.592,189,269.5,171.092,269.5,149z"/>
	<path id="XMLID_1162_" style="fill:#64C37D;" d="M159.5,92.557C152.17,84.248,141.451,79,129.5,79
		c-18.65,0-34.318,12.764-38.747,30.031C90.336,109.019,89.92,109,89.5,109c-22.092,0-40,17.908-40,40s17.908,40,40,40
		c1.271,0,2.525-0.066,3.766-0.182C84.836,196.151,79.5,206.949,79.5,219c0,22.092,17.908,40,40,40c1.899,0,3.765-0.142,5.593-0.397
		c-3.549,5.974-5.593,12.945-5.593,20.397c0,22.092,17.908,40,40,40C159.5,275,159.5,148.5,159.5,92.557z"/>
</g>
</svg>
''';
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(children: [
      SvgPicture.string(
        svgString,
        width: screenWidth,
        fit: BoxFit.contain,
      ),
      Positioned(
        top: screenWidth * .4,
        left: screenWidth * .22,
        child: const CircleWidget(fruitOfSpiritArea: "Love"),
      ),
      Positioned(
        top: screenWidth * .55,
        left: screenWidth * .01,
        child: const CircleWidget(fruitOfSpiritArea: "Joy"),
      ),
      Positioned(
        top: screenWidth * .4,
        left: screenWidth * .52,
        child: const CircleWidget(fruitOfSpiritArea: "Peace"),
      ),
      Positioned(
        top: screenWidth * .55,
        left: screenWidth * .73,
        child: const CircleWidget(fruitOfSpiritArea: "Patience"),
      ),
      Positioned(
        top: screenWidth * .9,
        left: screenWidth * .18,
        child: const CircleWidget(fruitOfSpiritArea: "Kindness"),
      ),
      Positioned(
        top: screenWidth * .9,
        left: screenWidth * .56,
        child: const CircleWidget(fruitOfSpiritArea: "Goodness"),
      ),
      Positioned(
        top: screenWidth * .65,
        left: screenWidth * .24,
        child: const CircleWidget(fruitOfSpiritArea: "Faithfulness"),
      ),
      Positioned(
        top: screenWidth * .65,
        left: screenWidth * .50,
        child: const CircleWidget(fruitOfSpiritArea: "Gentleness"),
      ),
      Positioned(
        top: screenWidth * 1.18,
        left: screenWidth * .37,
        child: const CircleWidget(fruitOfSpiritArea: "Self-Control"),
      ),
      Positioned(
        top: screenWidth * .27,
        left: screenWidth * .2,
        child: const Text(
          "2 Peter 1:8",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ]);
  }
}

class CircleWidget extends StatefulWidget {
  final String fruitOfSpiritArea;

  const CircleWidget({super.key, required this.fruitOfSpiritArea});

  @override
  State<CircleWidget> createState() => _CircleWidgetState();
}

class _CircleWidgetState extends State<CircleWidget> {
  int state = 0;
  Color backgroundColor = Colors.transparent;
  final List<Color> circleColors = [
    Colors.red[300]!,
    Colors.red[100]!,
    Colors.white,
    Colors.green[100]!,
    Colors.green[300]!,
  ];

  final List<String> degree = [
    "Strong",
    "Somewhat",
    "Neutral",
    "Somewhat",
    "Strong"
  ];

  // final List<String> fruitOfTheSpirit = [
  //   "Love",
  //   "Joy",
  //   "Peace",
  //   "Patience",
  //   "Kindness",
  //   "Goodness",
  //   "Faithfulness",
  //   "Gentleness",
  //   "Self-Control"
  // ];

  @override
  void initState() {
    super.initState();
    state = 2;
    backgroundColor = circleColors[state];
  }

  void toggleState() {
    var providerState = Provider.of<HealthState>(context, listen: false);
    setState(() {
      state = (state + 1) % 5;
      backgroundColor = circleColors[state];
      providerState.updateFoSCount(widget.fruitOfSpiritArea, state - 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: toggleState,
      child: Container(
        width: screenWidth * .22,
        height: screenWidth * .22,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Center(
            child: RichText(
          textAlign: TextAlign.center,
          textScaleFactor: 1.1,
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                  text: '${widget.fruitOfSpiritArea}\n',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * .03)),
              TextSpan(
                  text: degree[state],
                  style: TextStyle(fontSize: screenWidth * .03)),
            ],
          ),
        )),
      ),
    );
  }
}

bool continueSpiritualHealthStreak(List<HistoryDay> history) {
  if (history.last.spiritualHealthCheckCompleted) {
    return true;
  }
  return false;
}
