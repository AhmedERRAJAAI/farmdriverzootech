import 'package:farmdriverzootech/production/charts/blue_print.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ConsoChart extends StatefulWidget {
  final List<ConsoChartData> reels;
  final List<GconsoChartData> normes;
  final double? minAge;
  final double? maxAge;
  final String? title;
  const ConsoChart({
    super.key,
    required this.reels,
    required this.normes,
    this.minAge,
    this.maxAge,
    this.title,
  });

  @override
  State<ConsoChart> createState() => _ConsoChartState();
}

class _ConsoChartState extends State<ConsoChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> color = <Color>[];
    color.add(const Color(0xFFe8f0f5));
    color.add(const Color(0xFFE2F4FF));
    color.add(const Color.fromARGB(255, 210, 237, 254));

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);
    stops.add(1.0);

    final Map<String, Color> paramColors = {
      "apsCuml": Colors.green,
      "eps": Colors.blue,
      "ratio": Colors.lightBlue,
      "aps": Colors.blueGrey,
    };

    return SizedBox(
      child: SfCartesianChart(
        primaryXAxis: NumericAxis(
          decimalPlaces: 0,
          maximum: widget.minAge,
          minimum: widget.maxAge,
          title: const AxisTitle(
            text: "Age(sem)",
            textStyle: TextStyle(fontSize: 10),
          ),
        ),
        primaryYAxis: NumericAxis(
          decimalPlaces: 0,
          name: "aps",
          borderColor: paramColors["aps"],
          maximum: 170,
          minimum: 0,
          labelStyle: const TextStyle(
            fontSize: 9,
          ),
        ),
        enableAxisAnimation: true,
        tooltipBehavior: TooltipBehavior(enable: true, shared: true, duration: 4000),
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        title: ChartTitle(text: widget.title ?? "Consommation", textStyle: Theme.of(context).textTheme.bodySmall),
        series: <CartesianSeries>[
          LineSeries<ConsoChartData, int>(
            name: "APS (g)",
            dataSource: widget.reels,
            legendIconType: LegendIconType.diamond,
            xValueMapper: (ConsoChartData data, _) => data.age,
            yValueMapper: (ConsoChartData data, _) => data.aps,
            color: paramColors["aps"],
          ),
          LineSeries<GconsoChartData, int>(
            name: "Guide: APS",
            dataSource: widget.normes,
            legendIconType: LegendIconType.diamond,
            xValueMapper: (GconsoChartData data, _) => data.age,
            yValueMapper: (GconsoChartData data, _) => data.gAps,
            width: 2,
            color: paramColors["aps"]!.withOpacity(0.6),
          ),
          LineSeries<ConsoChartData, int>(
            name: "Σ APS (kg)",
            dataSource: widget.reels,
            legendIconType: LegendIconType.diamond,
            xValueMapper: (ConsoChartData data, _) => data.age,
            yValueMapper: (ConsoChartData data, _) => data.apsCuml,
            color: paramColors["apsCuml"],
            yAxisName: "altCml",
          ),
          LineSeries<GconsoChartData, int>(
            name: "Guide: APS Cuml",
            dataSource: widget.normes,
            legendIconType: LegendIconType.diamond,
            xValueMapper: (GconsoChartData data, _) => data.age,
            yValueMapper: (GconsoChartData data, _) => data.gApsCuml,
            width: 2,
            color: paramColors["apsCuml"]!.withOpacity(0.6),
            yAxisName: "altCml",
          ),
          LineSeries<ConsoChartData, int>(
            name: "EPS(ml)",
            dataSource: widget.reels,
            legendIconType: LegendIconType.diamond,
            xValueMapper: (ConsoChartData data, _) => data.age,
            yValueMapper: (ConsoChartData data, _) => data.eps,
            color: paramColors["eps"]!.withOpacity(0.8),
            yAxisName: "eps",
            dashArray: const <double>[
              3,
              3
            ],
          ),
          AreaSeries<ConsoChartData, int>(
            name: "Ratio",
            dataSource: widget.reels,
            legendIconType: LegendIconType.diamond,
            xValueMapper: (ConsoChartData data, _) => data.age,
            yValueMapper: (ConsoChartData data, _) => data.ratio,
            yAxisName: "ratio",
            color: paramColors["ratio"]!.withOpacity(0.2),
            borderWidth: 1.5,
            borderColor: paramColors["ratio"]!.withOpacity(0.5),
          ),
        ],
        axes: [
          NumericAxis(
            majorGridLines: const MajorGridLines(width: 0), // Set width to 0 to remove major grid lines
            minorGridLines: const MinorGridLines(width: 0),
            decimalPlaces: 0,
            name: 'altCml',
            labelStyle: TextStyle(fontSize: 9, color: paramColors["apsCuml"]),
            majorTickLines: MajorTickLines(size: 3, width: 0.3, color: paramColors["apsCuml"]),
            borderColor: paramColors["apsCuml"],
            opposedPosition: true,
            axisLine: AxisLine(
              color: paramColors["apsCuml"],
              width: 0.3,
            ),
          ),
          NumericAxis(
            majorGridLines: const MajorGridLines(width: 0), // Set width to 0 to remove major grid lines
            minorGridLines: const MinorGridLines(width: 0),
            decimalPlaces: 0,
            name: 'eps',
            labelStyle: TextStyle(fontSize: 9, color: paramColors["eps"]),
            majorTickLines: MajorTickLines(size: 3, width: 0.3, color: paramColors["eps"]),
            borderColor: paramColors["eps"],
            axisLine: AxisLine(
              color: paramColors["eps"],
              width: 0.3,
              dashArray: <double>[
                5,
                5
              ],
            ),
          ),
          NumericAxis(
            majorGridLines: const MajorGridLines(width: 0), // Set width to 0 to remove major grid lines
            minorGridLines: const MinorGridLines(width: 0),
            opposedPosition: true,
            decimalPlaces: 0,
            name: 'ratio',
            maximum: 10,
            labelStyle: TextStyle(fontSize: 9, color: paramColors["ratio"]),
            majorTickLines: MajorTickLines(size: 3, width: 0.3, color: paramColors["ratio"]),
            borderColor: paramColors["ratio"],
            axisLine: AxisLine(
              color: paramColors["ratio"],
              width: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
