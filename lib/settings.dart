import 'package:daily_discipleship/services/auth.dart';
import 'package:daily_discipleship/services/firestore.dart';
import 'package:daily_discipleship/services/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

DateTime scheduleTime = DateTime.now();

class SettingScreen extends StatefulWidget {
  final User userData;
  const SettingScreen({super.key, required this.userData});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DatePickerText(userData: widget.userData),
            const SizedBox(height: 20), // For spacing
            ElevatedButton(
              onPressed: () =>
                  {Navigator.pushNamed(context, '/reauthenticate')},
              child: const Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }
}

class DatePickerText extends StatefulWidget {
  final User userData;
  const DatePickerText({Key? key, required this.userData}) : super(key: key);

  @override
  State<DatePickerText> createState() => _DatePickerTextState();
}

class _DatePickerTextState extends State<DatePickerText> {
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    // Initialize selectedTime with userData's notificationTime
    selectedTime = TimeOfDay(
        hour: int.parse(widget.userData.notificationTime.split(":")[0]),
        minute: int.parse(widget.userData.notificationTime.split(":")[1]));
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
      FirestoreService()
          .updateNotificationTime(widget.userData.uid, selectedTime);
      scheduleCustomNotification(selectedTime);
      showPendingNotifications();
    }
  }

  String get formattedTime => selectedTime.format(context);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Your current notifications are set for $formattedTime',
          style: const TextStyle(fontSize: 16),
        ),
        TextButton(
          onPressed: () => _selectTime(context),
          child: const Text(
            'Select Time',
            style: TextStyle(color: Color(0xff6750A4)),
          ),
        ),
      ],
    );
  }
}

Future<void> scheduleCustomNotification(TimeOfDay selectedTime) async {
  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  final location = tz.getLocation(currentTimeZone);
  var now = tz.TZDateTime.now(location);
  var scheduledDate = tz.TZDateTime(location, now.year, now.month, now.day,
      selectedTime.hour, selectedTime.minute);

  // var scheduledDate =
  //     tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1));

  // Check if the scheduled time is in the past, and if so, schedule it for the next day
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }

  debugPrint('Scheduled Date and Time: $scheduledDate');

  const androidDetails = AndroidNotificationDetails(
    'channel_ID',
    'channel_name',
    channelDescription: 'channel_description',
    importance: Importance.max,
    priority: Priority.high,
  );

  const platformDetails = NotificationDetails(android: androidDetails);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Daily Discipleship',
    "It's time for your daily devotion and spiritual health check-in!",
    scheduledDate,
    platformDetails,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents:
        DateTimeComponents.time, // To repeat daily at the same time
  );
}

Future<void> showPendingNotifications() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<PendingNotificationRequest> pendingNotifications =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();

  for (var notification in pendingNotifications) {
    debugPrint(
        'Notification ID: ${notification.id}, Title: ${notification.title}, Body: ${notification.body}');
  }
}
