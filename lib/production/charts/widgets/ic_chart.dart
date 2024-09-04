import 'package:farmdriverzootech/production/charts/blue_print.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class IcChart extends StatefulWidget {
  final List<IcChartData> reels;
  final List<GicChartData> normes;
  final double? minAge;
  final double? maxAge;

  const IcChart({
    super.key,
    required this.reels,
    required this.normes,
    this.minAge,
    this.maxAge,
  });

  @override
  State<IcChart> createState() => _IcChartState();
}

class _IcChartState extends State<IcChart> {
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
      "ic": Colors.green,
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
          labelStyle: TextStyle(fontSize: 9, color: paramColors["ic"]),
          majorTickLines: MajorTickLines(size: 3, width: 0.3, color: paramColors["ic"]),
          borderColor: paramColors["ic"],
          axisLine: AxisLine(
            color: paramColors["ic"],
            width: 0.3,
          ),
        ),
        enableAxisAnimation: true,
        tooltipBehavior: TooltipBehavior(enable: true, shared: true, duration: 4000),
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        title: ChartTitle(text: "Indice de conversion", textStyle: Theme.of(context).textTheme.bodySmall),
        series: <CartesianSeries>[
          LineSeries<IcChartData, int>(
            name: "I.C",
            dataSource: widget.reels,
            xValueMapper: (IcChartData data, _) => data.age,
            yValueMapper: (IcChartData data, _) => data.icCuml,
            color: paramColors["ic"],
          ),
          LineSeries<GicChartData, int>(
            name: "Guide: I.C",
            dataSource: widget.normes,
            xValueMapper: (GicChartData data, _) => data.age,
            yValueMapper: (GicChartData data, _) => data.gIcCuml,
            width: 2.6,
            color: paramColors["ic"]!.withOpacity(0.4),
          ),
        ],
      ),
    );
  }
}
