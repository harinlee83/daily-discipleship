import 'package:daily_discipleship/services/models.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FruitOfSpiritLineChartPage extends StatelessWidget {
  final List<HistoryDay> filledHistory;
  final bool isMarkerVisible = true;
  final double markerWidth = 4;
  final double markerHeight = 4;
  const FruitOfSpiritLineChartPage({super.key, required this.filledHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fruit of the Spirit 🍇')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(title: AxisTitle(text: "Date")),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: "Sum"),
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
            legend: const Legend(
                isVisible: true,
                position: LegendPosition.top,
                overflowMode: LegendItemOverflowMode.wrap,
                height: "50%"),
            tooltipBehavior: TooltipBehavior(
                enable: true,
                activationMode: ActivationMode.singleTap,
                tooltipPosition: TooltipPosition.auto,
                opacity: .7),
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
      ),
    );
  }
}
