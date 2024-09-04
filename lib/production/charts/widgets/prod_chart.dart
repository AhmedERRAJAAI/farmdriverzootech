import 'package:farmdriverzootech/production/charts/blue_print.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProdChart extends StatefulWidget {
  final List<ProdChartData> reels;
  final List<GprodChartData> normes;
  final double? minAge;
  final double? maxAge;
  final String? title;
  const ProdChart({
    super.key,
    required this.reels,
    required this.normes,
    this.minAge,
    this.maxAge,
    this.title,
  });

  @override
  State<ProdChart> createState() => _ProdChartState();
}

class _ProdChartState extends State<ProdChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double interval = ((widget.maxAge ?? 0) - (widget.minAge ?? 0)) / 8;
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
      "ponte": const Color(0xFF833500),
      "pmo": const Color(0xFFDCA500),
      "noppd": Colors.deepOrange,
      "declasse": const Color(0xFFf7a892),
    };
    return SizedBox(
      child: SfCartesianChart(
        primaryXAxis: NumericAxis(
          decimalPlaces: 0,
          maximum: widget.minAge,
          minimum: widget.maxAge,
          interval: interval == 0 ? null : interval,
          title: const AxisTitle(
            text: "Age(sem)",
            textStyle: TextStyle(fontSize: 10),
          ),
        ),
        primaryYAxis: const NumericAxis(
          decimalPlaces: 0,
          name: "ponte",
          maximum: 100,
          minimum: 0,
          labelStyle: TextStyle(
            fontSize: 9,
          ),
        ),
        enableAxisAnimation: true,
        tooltipBehavior: TooltipBehavior(enable: true, shared: true, duration: 4000),
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        title: ChartTitle(text: widget.title ?? "Production des oeufs", textStyle: Theme.of(context).textTheme.bodySmall),
        series: <CartesianSeries>[
          LineSeries<ProdChartData, int>(
            name: "Production (%)",
            dataSource: widget.reels,
            legendIconType: LegendIconType.diamond,
            xValueMapper: (ProdChartData data, _) => data.age,
            yValueMapper: (ProdChartData data, _) => data.ponte,
            color: paramColors["ponte"],
          ),
          LineSeries<GprodChartData, int>(
            name: "Guide ponte (%)",
            dataSource: widget.normes,
            legendIconType: LegendIconType.diamond,
            xValueMapper: (GprodChartData data, _) => data.age,
            yValueMapper: (GprodChartData data, _) => data.gPonte,
            yAxisName: "ponte",
            color: paramColors["ponte"]!.withOpacity(0.2),
            width: 4,
          ),
          LineSeries<ProdChartData, int>(
            name: "PMO",
            dataSource: widget.reels,
            legendIconType: LegendIconType.diamond,
            xValueMapper: (ProdChartData data, _) => data.age,
            yValueMapper: (ProdChartData data, _) => data.pmo,
            color: paramColors["pmo"],
          ),
          LineSeries<GprodChartData, int>(
            name: "Guide NOPPD",
            dataSource: widget.normes,
            legendIconType: LegendIconType.diamond,
            xValueMapper: (GprodChartData data, _) => data.age,
            yValueMapper: (GprodChartData data, _) => data.gPmo,
            yAxisName: "ponte",
            color: paramColors["pmo"]!.withOpacity(0.3),
            width: 3,
          ),
          LineSeries<ProdChartData, int>(
            name: "NOPPD",
            dataSource: widget.reels,
            legendIconType: LegendIconType.diamond,
            xValueMapper: (ProdChartData data, _) => data.age,
            yValueMapper: (ProdChartData data, _) => data.noppd,
            yAxisName: "noppd",
            color: paramColors["noppd"],
          ),
          LineSeries<GprodChartData, int>(
            name: "Guide NOPPD",
            dataSource: widget.normes,
            legendIconType: LegendIconType.diamond,
            xValueMapper: (GprodChartData data, _) => data.age,
            yValueMapper: (GprodChartData data, _) => data.gNoppd,
            yAxisName: "noppd",
            color: paramColors["noppd"]!.withOpacity(0.3),
            width: 3,
          ),
          AreaSeries<ProdChartData, int>(
            name: "Declassé",
            dataSource: widget.reels,
            legendIconType: LegendIconType.diamond,
            xValueMapper: (ProdChartData data, _) => data.age,
            yValueMapper: (ProdChartData data, _) => data.declassed,
            borderColor: paramColors["declasse"]!.withOpacity(0.4),
            borderWidth: 1.6,
            yAxisName: "declasse",
            color: paramColors["declasse"]!.withOpacity(0.35),
          ),
          AreaSeries<ProdChartData, int>(
            name: "Blancs",
            dataSource: widget.reels,
            legendIconType: LegendIconType.diamond,
            xValueMapper: (ProdChartData data, _) => data.age,
            yValueMapper: (ProdChartData data, _) => data.blancs,
            borderColor: paramColors["declasse"]!.withOpacity(0.8),
            borderWidth: 1.6,
            yAxisName: "declasse",
            color: paramColors["declasse"]!.withOpacity(0.56),
          ),
        ],
        axes: [
          NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            minorGridLines: const MinorGridLines(width: 0),
            maximum: 10,
            decimalPlaces: 0,
            name: 'declasse',
            labelStyle: TextStyle(fontSize: 9, color: paramColors["declasse"]),
            majorTickLines: MajorTickLines(size: 3, width: 0.3, color: paramColors["declasse"]),
            borderColor: paramColors["declasse"],
            opposedPosition: true,
            axisLine: AxisLine(
              color: paramColors["declasse"],
              width: 0.3,
            ),
          ),
          NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            minorGridLines: const MinorGridLines(width: 0),
            decimalPlaces: 0,
            name: 'noppd',
            labelStyle: TextStyle(fontSize: 9, color: paramColors["noppd"]),
            majorTickLines: MajorTickLines(size: 3, width: 0.3, color: paramColors["noppd"]),
            borderColor: paramColors["noppd"],
            axisLine: AxisLine(
              color: paramColors["noppd"],
              width: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
