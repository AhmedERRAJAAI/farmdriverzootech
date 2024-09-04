// ignore: file_names
import 'package:farmdriverzootech/production/dashboard/provider/init_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ApoeufDashChart extends StatefulWidget {
  const ApoeufDashChart({super.key});

  @override
  State<ApoeufDashChart> createState() => _ApoeufDashChartState();
}

class _ApoeufDashChartState extends State<ApoeufDashChart> {
  @override
  Widget build(BuildContext context) {
    List<ApoDashChart> apoChart = Provider.of<InitProvider>(context).apoChart;
    return SfCartesianChart(
      title: const ChartTitle(text: "Aliment par oeuf (g)", textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.w800)),
      primaryXAxis: const DateTimeAxis(
        labelStyle: TextStyle(
          fontSize: 9.5,
        ),
      ),
      primaryYAxis: const NumericAxis(
        minimum: 0,
        maximum: 300,
        decimalPlaces: 0,
        labelStyle: TextStyle(
          fontSize: 9.5,
        ),
      ),
      enableAxisAnimation: true,
      tooltipBehavior: TooltipBehavior(enable: true, shared: true, duration: 4000),
      series: <CartesianSeries>[
        AreaSeries<ApoDashChart, DateTime>(
          name: "APO (g)",
          dataSource: apoChart,
          xValueMapper: (ApoDashChart data, _) => data.date,
          yValueMapper: (ApoDashChart data, _) => data.apo,
          borderWidth: 1,
          color: Colors.blue.withOpacity(0.3),
          borderColor: Colors.blue.shade600,
        )
      ],
    );
  }
}
