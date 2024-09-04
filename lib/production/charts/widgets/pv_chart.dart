import 'package:farmdriverzootech/production/charts/blue_print.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PvChart extends StatefulWidget {
  final List<PvChartData> reels;
  final List<GpvChartData> normes;
  final double? minAge;
  final double? maxAge;
  final String? title;
  const PvChart({
    super.key,
    required this.reels,
    required this.normes,
    this.minAge,
    this.maxAge,
    this.title,
  });

  @override
  State<PvChart> createState() => _PvChartState();
}

class _PvChartState extends State<PvChart> {
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
      "pv": Colors.blue.shade700,
      "homog": Colors.lightGreen,
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
          maximum: 100,
          name: "homog",
          labelStyle: TextStyle(fontSize: 9, color: paramColors["homog"]),
          majorTickLines: MajorTickLines(size: 3, width: 0.3, color: paramColors["homog"]),
          borderColor: paramColors["homog"],
          axisLine: AxisLine(
            color: paramColors["homog"],
            width: 0.3,
          ),
        ),
        enableAxisAnimation: true,
        tooltipBehavior: TooltipBehavior(enable: true, shared: true, duration: 4000),
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        title: ChartTitle(text: widget.title ?? "Poids corporel & homogéniété", textStyle: Theme.of(context).textTheme.bodySmall),
        series: <CartesianSeries>[
          AreaSeries<PvChartData, int>(
            name: "Homogéniété",
            dataSource: widget.reels,
            xValueMapper: (PvChartData data, _) => data.age,
            yValueMapper: (PvChartData data, _) => data.homog,
            color: paramColors["homog"]!.withOpacity(0.2),
            borderColor: paramColors["homog"]!,
            borderWidth: 2,
          ),
          LineSeries<PvChartData, int>(
            name: "Poids vif(g)",
            dataSource: widget.reels,
            xValueMapper: (PvChartData data, _) => data.age,
            yValueMapper: (PvChartData data, _) => data.poids,
            yAxisName: "pv",
            color: paramColors["pv"],
          ),
          LineSeries<GpvChartData, int>(
            name: "Guide: P. vif",
            dataSource: widget.normes,
            xValueMapper: (GpvChartData data, _) => data.age,
            yValueMapper: (GpvChartData data, _) => data.pv,
            width: 2.4,
            color: paramColors["pv"]!.withOpacity(0.4),
            yAxisName: "pv",
          ),
        ],
        axes: [
          NumericAxis(
            majorGridLines: const MajorGridLines(width: 0), // Set width to 0 to remove major grid lines
            minorGridLines: const MinorGridLines(width: 0),
            name: 'pv',
            labelStyle: TextStyle(fontSize: 9, color: paramColors["pv"]),
            majorTickLines: MajorTickLines(size: 3, width: 0.3, color: paramColors["pv"]),
            borderColor: paramColors["pv"],
            opposedPosition: true,
            axisLine: AxisLine(
              color: paramColors["pv"],
              width: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
