import 'package:daily_discipleship/devotions/devotion_calendar_page.dart';
import 'package:daily_discipleship/devotions/devotions_screen.dart';
import 'package:daily_discipleship/services/models.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class DevotionCalendar extends StatelessWidget {
  final User userData;
  const DevotionCalendar({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<bool>> events = {};

    for (var historyDay in userData.history) {
      final date = DateTime.utc(
          historyDay.date.year, historyDay.date.month, historyDay.date.day);
      events[date] = [
        historyDay.hymnCompleted,
        historyDay.prayerCompleted,
        historyDay.readingCompleted,
      ];
    }

    var fontSize = MediaQuery.of(context).size.width * 0.03;

    TextStyle todayTextStyle = TextStyle(
        color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.bold);

    return Stack(children: [
      TableCalendar(
        focusedDay: DateTime.now(),
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2024, 12, 31),
        calendarFormat: CalendarFormat.week,
        headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            rightChevronVisible: false,
            leftChevronVisible: false),
        rowHeight: 90,
        eventLoader: (date) {
          return events[date] ?? [];
        },
        calendarBuilders: CalendarBuilders(
          todayBuilder: (context, day, focusedDay) {
            return Column(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Align text to the top
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: Color(0xff6750A4), shape: BoxShape.circle),
                      child: Text(day.day.toString(), style: todayTextStyle)),
                ),
                // You can add other widgets here if needed
              ],
            );
          },
          outsideBuilder: (context, day, focusedDay) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child: Text(day.day.toString(),
                        style: TextStyle(
                            fontSize: fontSize,
                            color: const Color(0xFFAEAEAE))),
                  ),
                ),
                // You can add other widgets here if needed
              ],
            );
          },
          defaultBuilder: (context, date, events) {
            return Column(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Align text to the top
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: fontSize,
                      ),
                    ),
                  ),
                ),
                // You can add other widgets here if needed
              ],
            );
          },
          markerBuilder: (context, date, events) {
            if (events.isNotEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  events[0] as bool
                      ? const Opacity(opacity: 1, child: Text(" 🎵"))
                      : const Opacity(opacity: .25, child: Text("🎵")),
                  events[2] as bool
                      ? const Opacity(opacity: 1, child: Text("📖"))
                      : const Opacity(opacity: .25, child: Text("📖")),
                  events[1] as bool
                      ? const Opacity(opacity: 1, child: Text("🙏"))
                      : const Opacity(opacity: .25, child: Text("🙏")),
                ],
              );
            } else {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Opacity(opacity: .25, child: Text("🎵")),
                  Opacity(opacity: .25, child: Text("📖")),
                  Opacity(opacity: .25, child: Text("🙏")),
                ],
              );
            }
          },
        ),
        onDaySelected: (selectedDay, focusedDay) {
          DateTime firstDayOfYear = DateTime(selectedDay.year, 1, 1);
          debugPrint("first day is ${firstDayOfYear.toString()}");
          DateTime selectedDayWithoutTime =
              DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
          debugPrint("selectedDay is ${selectedDayWithoutTime.toString()}");
          // Calculate the number of days since the start of the year
          Duration daysSinceStartOfYear =
              selectedDayWithoutTime.difference(firstDayOfYear);
          int daysCount = daysSinceStartOfYear.inDays;
          debugPrint(
              "daysSinceStartOfYear is ${daysSinceStartOfYear.toString()}");
          // Calculate devotionNumber (1-30 cycle)
          int devotionNumber = (daysCount % 30) + 1;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DevotionsScreen(
                        userData: userData,
                        includeMarkAsComplete: false,
                        devotionNumber: devotionNumber,
                      )));
        },
      ),
      Positioned(
        top: -5,
        right: 0,
        child: IconButton(
          icon: const Icon(FontAwesomeIcons.expand),
          onPressed: () {
            debugPrint("Touched!");
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    DevotionCalendarPage(userData: userData, events: events)));
          },
        ),
      )
    ]);
  }
}
