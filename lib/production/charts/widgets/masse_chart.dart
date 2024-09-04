import 'package:farmdriverzootech/production/charts/blue_print.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MasseChart extends StatefulWidget {
  final List<MasseChartData> reels;
  final List<GmasseChartData> normes;
  final double? minAge;
  final double? maxAge;
  final String? title;
  const MasseChart({
    super.key,
    required this.reels,
    required this.normes,
    this.minAge,
    this.maxAge,
    this.title,
  });

  @override
  State<MasseChart> createState() => _MasseChartState();
}

class _MasseChartState extends State<MasseChart> {
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
      "massSem": Colors.brown,
      "massCuml": Colors.deepOrangeAccent,
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
          labelStyle: TextStyle(fontSize: 9, color: paramColors["massSem"]),
          majorTickLines: MajorTickLines(size: 3, width: 0.3, color: paramColors["massSem"]),
          borderColor: paramColors["massSem"],
          axisLine: AxisLine(
            color: paramColors["massSem"],
            width: 0.3,
          ),
        ),
        enableAxisAnimation: true,
        tooltipBehavior: TooltipBehavior(enable: true, shared: true, duration: 4000),
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        title: ChartTitle(text: "Masse d'oeuf", textStyle: Theme.of(context).textTheme.bodySmall),
        series: <CartesianSeries>[
          LineSeries<MasseChartData, int>(
            name: "Masse d'oeuf",
            dataSource: widget.reels,
            xValueMapper: (MasseChartData data, _) => data.age,
            yValueMapper: (MasseChartData data, _) => data.massSem,
            color: paramColors["massSem"],
          ),
          LineSeries<MasseChartData, int>(
            name: "Σ Masse d'oeuf",
            dataSource: widget.reels,
            xValueMapper: (MasseChartData data, _) => data.age,
            yValueMapper: (MasseChartData data, _) => data.massCuml,
            yAxisName: "massCuml",
            color: paramColors["massCuml"],
          ),
          LineSeries<GmasseChartData, int>(
            name: "Guide: Masse d'oeuf",
            dataSource: widget.normes,
            xValueMapper: (GmasseChartData data, _) => data.age,
            yValueMapper: (GmasseChartData data, _) => data.gMassSem,
            width: 2.6,
            color: paramColors["massSem"]!.withOpacity(0.4),
          ),
          LineSeries<GmasseChartData, int>(
            name: "Guide: Σ Masse d'oeuf",
            dataSource: widget.normes,
            xValueMapper: (GmasseChartData data, _) => data.age,
            yValueMapper: (GmasseChartData data, _) => data.gMassCuml,
            width: 2.6,
            color: paramColors["massCuml"]!.withOpacity(0.4),
            yAxisName: "massCuml",
          ),
        ],
        axes: [
          NumericAxis(
            majorGridLines: const MajorGridLines(width: 0), // Set width to 0 to remove major grid lines
            minorGridLines: const MinorGridLines(width: 0),
            name: 'massCuml',
            labelStyle: TextStyle(fontSize: 9, color: paramColors["massCuml"]),
            majorTickLines: MajorTickLines(size: 3, width: 0.3, color: paramColors["massCuml"]),
            borderColor: paramColors["massCuml"],
            opposedPosition: true,
            axisLine: AxisLine(
              color: paramColors["massCuml"],
              width: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
