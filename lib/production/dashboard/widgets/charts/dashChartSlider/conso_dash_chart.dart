import 'package:farmdriverzootech/production/dashboard/provider/init_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ConsoDashChart extends StatefulWidget {
  const ConsoDashChart({super.key});

  @override
  State<ConsoDashChart> createState() => _ConsoDashChartState();
}

class _ConsoDashChartState extends State<ConsoDashChart> {
  @override
  Widget build(BuildContext context) {
    List<AltDashChart> altChart = Provider.of<InitProvider>(context).altChart;
    return SfCartesianChart(
      title: const ChartTitle(text: "Aliment consomé (Tonne)", textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.w800)),
      primaryXAxis: const DateTimeAxis(
        labelStyle: TextStyle(
          fontSize: 9.5,
        ),
      ),
      primaryYAxis: const NumericAxis(
        labelStyle: TextStyle(
          fontSize: 9.5,
        ),
      ),
      enableAxisAnimation: true,
      tooltipBehavior: TooltipBehavior(enable: true, shared: true, duration: 4000),
      series: <CartesianSeries>[
        AreaSeries<AltDashChart, DateTime>(
          name: "Alt (Tonne)",
          dataSource: altChart,
          xValueMapper: (AltDashChart data, _) => data.date,
          yValueMapper: (AltDashChart data, _) => data.alt,
          borderWidth: 1,
          color: Colors.blue.withOpacity(0.3),
          borderColor: Colors.blue.shade600,
        )
      ],
    );
  }
}
