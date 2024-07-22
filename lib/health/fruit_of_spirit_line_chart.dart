import 'package:daily_discipleship/health/fruit_of_spirit_line_chart_page.dart';
import 'package:daily_discipleship/services/models.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FruitOfSpiritLineChart extends StatelessWidget {
  final List<HistoryDay> history;
  final bool isMarkerVisible = true;
  final double markerWidth = 4;
  final double markerHeight = 4;

  const FruitOfSpiritLineChart({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    List<HistoryDay> filledHistory = fillMissingDates(history);

    // for (var day in history) {
    //   debugPrint('Date: ${day.date}, Value: ${day.fruitOfSpiritRunningSum.love}');
    // }

    // for (var day in filledHistory) {
    //   debugPrint(
    //       'Date: ${day.date}, Value: ${day.fruitOfSpiritRunningSum.love}');
    // }
    return Stack(children: [
      SfCartesianChart(
          primaryXAxis: DateTimeAxis(),
          title: ChartTitle(
              text: 'Fruit of the Spirit 🍇',
              textStyle: const TextStyle(fontWeight: FontWeight.bold)),
          legend: const Legend(
              isVisible: true,
              position: LegendPosition.top,
              overflowMode: LegendItemOverflowMode.wrap,
              height: "50%"),
          // tooltipBehavior: TooltipBehavior(
          //     enable: true,
          //     activationMode: ActivationMode.singleTap,
          //     tooltipPosition: TooltipPosition.auto,
          //     opacity: .7),
          primaryYAxis: NumericAxis(
            plotBands: <PlotBand>[
              PlotBand(
                isVisible: true,
                start: -0.01, // Slightly below 0
                end: 0.01, // Slightly above 0
                color: Colors.grey, // Choose your color
                borderWidth: 1, // Width of the line
                borderColor: Colors.grey,
              ),
            ],
          ),
          series: <ChartSeries>[
            LineSeries<HistoryDay, DateTime>(
                name: "Love",
                animationDuration: 0,
                markerSettings: MarkerSettings(
                    isVisible: isMarkerVisible,
                    height: markerWidth,
                    width: markerHeight,
                    shape: DataMarkerType.circle,
                    borderWidth: 3,
                    borderColor: Colors.blue),
                color: Colors.blue,
                dataSource: filledHistory,
                xValueMapper: (HistoryDay day, _) => day.date,
                yValueMapper: (HistoryDay day, _) =>
                    day.fruitOfSpiritRunningSum.love),
            LineSeries<HistoryDay, DateTime>(
                name: "Joy",
                animationDuration: 0,
                markerSettings: MarkerSettings(
                    isVisible: isMarkerVisible,
                    height: markerWidth,
                    width: markerHeight,
                    shape: DataMarkerType.circle,
                    borderWidth: 3,
                    borderColor: Colors.red),
                color: Colors.red,
                dataSource: filledHistory,
                xValueMapper: (HistoryDay day, _) => day.date,
                yValueMapper: (HistoryDay day, _) =>
                    day.fruitOfSpiritRunningSum.joy),
            LineSeries<HistoryDay, DateTime>(
                name: "Peace",
                animationDuration: 0,
                markerSettings: MarkerSettings(
                    isVisible: isMarkerVisible,
                    height: markerWidth,
                    width: markerHeight,
                    shape: DataMarkerType.circle,
                    borderWidth: 3,
                    borderColor: Colors.purple),
                color: Colors.purple,
                dataSource: filledHistory,
                xValueMapper: (HistoryDay day, _) => day.date,
                yValueMapper: (HistoryDay day, _) =>
                    day.fruitOfSpiritRunningSum.peace),
            LineSeries<HistoryDay, DateTime>(
                name: "Patience",
                animationDuration: 0,
                markerSettings: MarkerSettings(
                    isVisible: isMarkerVisible,
                    height: markerWidth,
                    width: markerHeight,
                    shape: DataMarkerType.circle,
                    borderWidth: 3,
                    borderColor: Colors.green),
                color: Colors.green,
                dataSource: filledHistory,
                xValueMapper: (HistoryDay day, _) => day.date,
                yValueMapper: (HistoryDay day, _) =>
                    day.fruitOfSpiritRunningSum.patience),
            LineSeries<HistoryDay, DateTime>(
                name: "Kindness",
                animationDuration: 0,
                markerSettings: MarkerSettings(
                    isVisible: isMarkerVisible,
                    height: markerWidth,
                    width: markerHeight,
                    shape: DataMarkerType.circle,
                    borderWidth: 3,
                    borderColor: Colors.orange),
                color: Colors.orange,
                dataSource: filledHistory,
                xValueMapper: (HistoryDay day, _) => day.date,
                yValueMapper: (HistoryDay day, _) =>
                    day.fruitOfSpiritRunningSum.kindness),
            LineSeries<HistoryDay, DateTime>(
                name: "Goodness",
                animationDuration: 0,
                markerSettings: MarkerSettings(
                    isVisible: isMarkerVisible,
                    height: markerWidth,
                    width: markerHeight,
                    shape: DataMarkerType.circle,
                    borderWidth: 3,
                    borderColor: Colors.indigo),
                color: Colors.indigo,
                dataSource: filledHistory,
                xValueMapper: (HistoryDay day, _) => day.date,
                yValueMapper: (HistoryDay day, _) =>
                    day.fruitOfSpiritRunningSum.goodness),
            LineSeries<HistoryDay, DateTime>(
                name: "Faithfulness",
                animationDuration: 0,
                markerSettings: MarkerSettings(
                    isVisible: isMarkerVisible,
                    height: markerWidth,
                    width: markerHeight,
                    shape: DataMarkerType.circle,
                    borderWidth: 3,
                    borderColor: Colors.brown),
                color: Colors.brown,
                dataSource: filledHistory,
                xValueMapper: (HistoryDay day, _) => day.date,
                yValueMapper: (HistoryDay day, _) =>
                    day.fruitOfSpiritRunningSum.faithfulness),
            LineSeries<HistoryDay, DateTime>(
                name: "Gentleness",
                animationDuration: 0,
                markerSettings: MarkerSettings(
                    isVisible: isMarkerVisible,
                    height: markerWidth,
                    width: markerHeight,
                    shape: DataMarkerType.circle,
                    borderWidth: 3,
                    borderColor: Colors.cyan),
                color: Colors.cyan,
                dataSource: filledHistory,
                xValueMapper: (HistoryDay day, _) => day.date,
                yValueMapper: (HistoryDay day, _) =>
                    day.fruitOfSpiritRunningSum.gentleness),
            LineSeries<HistoryDay, DateTime>(
                name: "Self-Control",
                animationDuration: 0,
                markerSettings: MarkerSettings(
                    isVisible: isMarkerVisible,
                    height: markerWidth,
                    width: markerHeight,
                    shape: DataMarkerType.circle,
                    borderWidth: 3,
                    borderColor: Colors.pink),
                color: Colors.pink,
                dataSource: filledHistory,
                xValueMapper: (HistoryDay day, _) => day.date,
                yValueMapper: (HistoryDay day, _) =>
                    day.fruitOfSpiritRunningSum.selfControl),
          ]),
      Positioned(
        top: 0,
        right: 0,
        child: IconButton(
          icon: const Icon(FontAwesomeIcons.expand),
          onPressed: () {
            debugPrint("Touched!");
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    FruitOfSpiritLineChartPage(filledHistory: filledHistory)));
          },
        ),
      )
    ]);
  }
}

List<DateTime> generateDateRange(DateTime startDate, DateTime endDate) {
  List<DateTime> dates = [];
  for (int i = 1; i <= endDate.difference(startDate).inDays; i++) {
    dates.add(startDate.add(Duration(days: i)));
  }
  return dates;
}

List<HistoryDay> fillMissingDates(List<HistoryDay> history) {
  DateTime startDate = DateTime.now().subtract(const Duration(days: 9));
  DateTime endDate = DateTime.now();

  // Generate the list of dates in the range
  List<DateTime> dateRange = generateDateRange(startDate, endDate);

  // Map to store the existing history entries for quick lookup
  Map<DateTime, FruitOfSpiritRunningSum> historyMap = {
    for (var day in history)
      if (day.date.isAfter(startDate) &&
          day.date.isBefore(
              endDate.add(const Duration(days: 1)))) // +1 day to include today
        DateTime(day.date.year, day.date.month, day.date.day):
            day.fruitOfSpiritRunningSum
  };

  // debugPrint("historyMap: ${historyMap.toString()}");

  // debugPrint("dateRange: ${dateRange.toString()}");

  // Create the filled history list
  List<HistoryDay> filledHistory = [];
  for (var date in dateRange) {
    filledHistory.add(HistoryDay(
        date: DateTime(date.year, date.month, date.day),
        fruitOfSpiritRunningSum:
            historyMap.containsKey(DateTime(date.year, date.month, date.day))
                ? historyMap[DateTime(date.year, date.month, date.day)]
                : FruitOfSpiritRunningSum()));
  }

  return filledHistory;
}
