import 'package:daily_discipleship/change_notifiers/confetti_notifier.dart';
import 'package:daily_discipleship/devotions/devotions_state.dart';
import 'package:daily_discipleship/devotions/hymn_audio_player.dart';
import 'package:daily_discipleship/devotions/hymn_pdf_viewer.dart';
import 'package:daily_discipleship/services/auth.dart';
import 'package:daily_discipleship/services/firestore.dart';
import 'package:daily_discipleship/services/models.dart';
import 'package:daily_discipleship/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DevotionsScreen extends StatelessWidget {
  final User userData;
  final int devotionNumber;
  final bool includeMarkAsComplete;
  const DevotionsScreen(
      {super.key,
      required this.userData,
      required this.devotionNumber,
      required this.includeMarkAsComplete});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => DevotionsState(),
        child: FutureBuilder(
          future: FirestoreService().getDevotion(devotionNumber.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            } else if (snapshot.hasError) {
              return Center(
                child: ErrorMessage(message: snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              var data = snapshot.data!;
              var state = Provider.of<DevotionsState>(context);
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Daily Devotion'),
                  leading: IconButton(
                    icon: const Icon(FontAwesomeIcons.xmark),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  controller: state.controller,
                  itemBuilder: (BuildContext context, int idx) {
                    if (idx == 0) {
                      return PrayerPage(
                          prayer: data.prayer,
                          userData: userData,
                          includeMarkAsComplete: includeMarkAsComplete);
                    } else if (idx == 1) {
                      return ReadingPage(
                          reading: data.reading,
                          userData: userData,
                          includeMarkAsComplete: includeMarkAsComplete);
                    } else {
                      return HymnPage(
                          hymn: data.hymn,
                          userData: userData,
                          includeMarkAsComplete: includeMarkAsComplete);
                    }
                  },
                ),
              );
            } else {
              return const Text('No passage found');
            }
          },
        ));
  }
}

class PrayerPage extends StatelessWidget {
  final User userData;
  final bool includeMarkAsComplete;

  final Prayer prayer;
  const PrayerPage(
      {super.key,
      required this.prayer,
      required this.userData,
      required this.includeMarkAsComplete});

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<DevotionsState>(context);
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            prayer.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                prayer.text,
                style: const TextStyle(
                  fontSize: 16, // Adjust the font size as per your preference
                  // You can also specify other text style properties here if needed
                ),
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: false,
                maintainSize: includeMarkAsComplete,
                maintainAnimation: true,
                maintainState: true,
                child: IconButton(
                  onPressed: state.previousPage,
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              Visibility(
                  visible: includeMarkAsComplete,
                  maintainSize: false,
                  maintainAnimation: true,
                  maintainState: true,
                  child: (userData.history.last.prayerCompleted
                      ? ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple[300]),
                          icon: const Icon(
                            FontAwesomeIcons.check,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Completed",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => {},
                        )
                      : const CompleteButton(field: "prayerCompleted"))),
              IconButton(
                onPressed: state.nextPage,
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ReadingPage extends StatelessWidget {
  final User userData;
  final bool includeMarkAsComplete;
  final Reading reading;
  const ReadingPage(
      {super.key,
      required this.reading,
      required this.userData,
      required this.includeMarkAsComplete});

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<DevotionsState>(context);
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            reading.passage,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                reading.text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: state.previousPage,
                icon: const Icon(Icons.arrow_back),
              ),
              includeMarkAsComplete
                  ? (userData.history.last.readingCompleted
                      ? ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple[300]),
                          icon: const Icon(
                            FontAwesomeIcons.check,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Completed",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => {},
                        )
                      : const CompleteButton(field: "readingCompleted"))
                  : const SizedBox(width: 0, height: 0),
              IconButton(
                onPressed: state.nextPage,
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class HymnPage extends StatelessWidget {
  final User userData;
  final bool includeMarkAsComplete;
  final Hymn hymn;
  const HymnPage(
      {super.key,
      required this.hymn,
      required this.userData,
      required this.includeMarkAsComplete});

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<DevotionsState>(context);
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hymn.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Divider(),
          HymnPdfViewer(storagePath: hymn.pdfFilePath),
          HymnAudioPlayer(
            storagePath: hymn.audioFilePath,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: state.previousPage,
                icon: const Icon(Icons.arrow_back),
              ),
              Visibility(
                  visible: includeMarkAsComplete,
                  maintainSize: false,
                  maintainAnimation: true,
                  maintainState: true,
                  child: (userData.history.last.hymnCompleted
                      ? ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple[300]),
                          icon: const Icon(
                            FontAwesomeIcons.check,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Completed",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => {},
                        )
                      : const CompleteButton(field: "hymnCompleted"))),
              Visibility(
                visible: false,
                maintainSize: includeMarkAsComplete,
                maintainAnimation: true,
                maintainState: true,
                child: IconButton(
                  onPressed: state.previousPage,
                  icon: const Icon(Icons.arrow_forward),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CompleteButton extends StatefulWidget {
  final String field;

  const CompleteButton({super.key, required this.field});

  @override
  State<CompleteButton> createState() => _CompleteButtonState();
}

class _CompleteButtonState extends State<CompleteButton> {
  Color? _buttonColor = kDefaultIconLightColor;
  Color? _textColor = Colors.purple[800];
  Color? _iconColor = Colors.purple[800];
  String _buttonText = 'Mark as Complete';

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(backgroundColor: _buttonColor),
      onPressed: () async {
        await FirestoreService().markAsComplete(widget.field);
        setState(() {
          _buttonColor = Colors.purple[300];
          _buttonText = "Completed";
          _textColor = Colors.white;
          _iconColor = Colors.white;
        });
        User userData =
            await FirestoreService().getUserData(AuthService().user?.uid);
        if (continuePersonalDevotionStreak(userData.history)) {
          debugPrint("Adding 1 to daily streak!");
          FirestoreService().continueDailyDevotionStreak();
        }
        if (userData.history.last.hymnCompleted &&
            userData.history.last.prayerCompleted &&
            userData.history.last.readingCompleted) {
          if (context.mounted) {
            Navigator.pop(context);
            var snackBar = SnackBar(
                content:
                    const Center(child: Text('Daily Devotions Completed! 🥳')),
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
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            final confettiNotifier =
                Provider.of<ConfettiNotifier>(context, listen: false);
            confettiNotifier.playConfetti();
          }
        }
      },
      icon: Icon(
        FontAwesomeIcons.check,
        color: _iconColor,
      ),
      label: Text(
        _buttonText,
        style: TextStyle(color: _textColor),
      ),
    );
  }
}

bool continuePersonalDevotionStreak(List<HistoryDay> history) {
  if (history.last.hymnCompleted &&
      history.last.prayerCompleted &&
      history.last.readingCompleted) {
    return true;
  }
  return false;
}
