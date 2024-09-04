import 'package:farmdriverzootech/production/charts/blue_print.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MortChart extends StatefulWidget {
  final List<MortChartData> reels;
  final List<GmortChartData> normes;
  final double? minAge;
  final double? maxAge;
  final String? title;
  const MortChart({
    super.key,
    required this.reels,
    required this.normes,
    this.minAge,
    this.maxAge,
    this.title,
  });

  @override
  State<MortChart> createState() => _MortChartState();
}

class _MortChartState extends State<MortChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Orientation orientation = MediaQuery.of(context).orientation;

    final List<Color> color = <Color>[];
    color.add(const Color(0xFFe8f0f5));
    color.add(const Color(0xFFE2F4FF));
    color.add(const Color.fromARGB(255, 210, 237, 254));

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);
    stops.add(1.0);

    final Map<String, Color> paramColors = {
      "mortSem": Colors.deepOrange.shade400,
      "mortCuml": Colors.green.shade800,
      "bar1": Colors.lightGreen,
      "bar2": Colors.orange,
      "bar3": Colors.red,
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
          name: "Mortalité hebdo (%)",
          borderColor: paramColors["mortSem"],
          labelStyle: const TextStyle(
            fontSize: 9,
          ),
        ),
        enableAxisAnimation: true,
        tooltipBehavior: TooltipBehavior(enable: true, shared: true, duration: 4000),
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        title: ChartTitle(text: widget.title ?? "Mortalité", textStyle: Theme.of(context).textTheme.bodySmall),
        series: <CartesianSeries>[
          LineSeries<GmortChartData, int>(
            name: "bar1",
            dataSource: widget.normes,
            legendIconType: LegendIconType.diamond,
            xValueMapper: (GmortChartData data, _) => data.age,
            yValueMapper: (GmortChartData data, _) => data.bar1,
            width: 2,
            color: paramColors["bar1"],
            dashArray: const <double>[
              2,
              5
            ],
          ),
          LineSeries<GmortChartData, int>(
            name: "bar2",
            dataSource: widget.normes,
            legendIconType: LegendIconType.diamond,
            xValueMapper: (GmortChartData data, _) => data.age,
            yValueMapper: (GmortChartData data, _) => data.bar2,
            width: 2,
            color: paramColors["bar2"],
            dashArray: const <double>[
              2,
              5
            ],
          ),
          LineSeries<GmortChartData, int>(
            name: "bar3",
            dataSource: widget.normes,
            legendIconType: LegendIconType.diamond,
            xValueMapper: (GmortChartData data, _) => data.age,
            yValueMapper: (GmortChartData data, _) => data.bar3,
            width: 2,
            color: paramColors["bar3"],
            dashArray: const <double>[
              2,
              5
            ],
          ),
          ColumnSeries<MortChartData, int>(
            name: "Mortalité hebdo (%)",
            dataSource: widget.reels,
            legendIconType: LegendIconType.diamond,
            xValueMapper: (MortChartData data, _) => data.age,
            yValueMapper: (MortChartData data, _) => data.mortSem,
            color: paramColors["mortSem"],
          ),
          LineSeries<MortChartData, int>(
            name: "Σ Mortalité (%)",
            dataSource: widget.reels,
            legendIconType: LegendIconType.diamond,
            xValueMapper: (MortChartData data, _) => data.age,
            yValueMapper: (MortChartData data, _) => data.mortCuml,
            color: paramColors["mortCuml"],
            yAxisName: "mortCuml",
          ),
          LineSeries<GmortChartData, int>(
            name: "Guide: Σ Mortalité (%)",
            dataSource: widget.normes,
            legendIconType: LegendIconType.diamond,
            xValueMapper: (GmortChartData data, _) => data.age,
            yValueMapper: (GmortChartData data, _) => data.gMortCuml,
            width: 2.4,
            color: paramColors["mortCuml"]!.withOpacity(0.4),
            yAxisName: "mortCuml",
          ),
        ],
        axes: [
          NumericAxis(
            majorGridLines: const MajorGridLines(width: 0), // Set width to 0 to remove major grid lines
            minorGridLines: const MinorGridLines(width: 0),
            decimalPlaces: 0,
            name: 'mortCuml',
            labelStyle: TextStyle(fontSize: 9, color: paramColors["mortCuml"]),
            majorTickLines: MajorTickLines(size: 3, width: 0.3, color: paramColors["mortCuml"]),
            borderColor: paramColors["mortCuml"],
            opposedPosition: true,
            axisLine: AxisLine(
              color: paramColors["mortCuml"],
              width: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
