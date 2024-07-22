import 'package:daily_discipleship/devotions/devotions_screen.dart';
import 'package:daily_discipleship/services/models.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DevotionCalendarPage extends StatelessWidget {
  final User userData;
  final Map<DateTime, List<bool>> events;
  const DevotionCalendarPage(
      {super.key, required this.events, required this.userData});

  @override
  Widget build(BuildContext context) {
    var fontSize = MediaQuery.of(context).size.width * 0.03;
    TextStyle todayTextStyle = TextStyle(
        color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.bold);
    return Scaffold(
        appBar: AppBar(title: null),
        body: ListView(children: [
          Column(children: [
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'Tap on a day to see devotions',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                softWrap: true,
                maxLines: 4,
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(5.0),
                child: TableCalendar(
                  availableGestures: AvailableGestures.none,
                  focusedDay: DateTime.now(),
                  firstDay: DateTime.utc(2024, 1, 1),
                  lastDay: DateTime.utc(2024, 12, 31),
                  calendarFormat: CalendarFormat.month,
                  headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      headerPadding: EdgeInsets.all(0)),
                  rowHeight: 100,
                  eventLoader: (date) {
                    return events[date] ?? [];
                  },
                  daysOfWeekHeight: 20,
                  daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
                      weekendStyle: TextStyle(fontWeight: FontWeight.bold)),
                  calendarStyle: CalendarStyle(
                      tableBorder: TableBorder.symmetric(
                          inside: const BorderSide(
                              color: Colors.grey, width: 0.5))),
                  calendarBuilders: CalendarBuilders(
                    outsideBuilder: (context, day, focusedDay) {
                      return Column(
                        mainAxisAlignment:
                            MainAxisAlignment.start, // Align text to the top
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
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
                    todayBuilder: (context, day, focusedDay) {
                      return Column(
                        mainAxisAlignment:
                            MainAxisAlignment.start, // Align text to the top
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                    color: Color(0xff6750A4),
                                    shape: BoxShape.circle),
                                child: Text(day.day.toString(),
                                    style: todayTextStyle)),
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
                            padding: const EdgeInsets.all(8.0),
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
                        ],
                      );
                    },
                    markerBuilder: (context, date, events) {
                      if (events.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              events[0] as bool
                                  ? const Opacity(opacity: 1, child: Text("🎵"))
                                  : const Opacity(
                                      opacity: .25, child: Text("🎵")),
                              events[2] as bool
                                  ? const Opacity(opacity: 1, child: Text("📖"))
                                  : const Opacity(
                                      opacity: .25, child: Text("📖")),
                              events[1] as bool
                                  ? const Opacity(opacity: 1, child: Text("🙏"))
                                  : const Opacity(
                                      opacity: .25, child: Text("🙏")),
                            ],
                          ),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Opacity(opacity: .25, child: Text("🎵")),
                              Opacity(opacity: .25, child: Text("📖")),
                              Opacity(opacity: .25, child: Text("🙏")),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    DateTime firstDayOfYear = DateTime(selectedDay.year, 1, 1);
                    debugPrint("first day is ${firstDayOfYear.toString()}");
                    DateTime selectedDayWithoutTime = DateTime(
                        selectedDay.year, selectedDay.month, selectedDay.day);
                    debugPrint(
                        "selectedDay is ${selectedDayWithoutTime.toString()}");
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
                ))
          ]),
        ]));
  }
}
