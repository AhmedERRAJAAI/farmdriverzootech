import 'package:farmdriverzootech/production/dashboard/provider/init_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MortaliteDashChart extends StatefulWidget {
  const MortaliteDashChart({super.key});

  @override
  State<MortaliteDashChart> createState() => _MortaliteDashChartState();
}

class _MortaliteDashChartState extends State<MortaliteDashChart> {
  @override
  Widget build(BuildContext context) {
    List<MortDashChart> mortChart = Provider.of<InitProvider>(context).mortChart;
    return SfCartesianChart(
      title: const ChartTitle(text: "Mortalité (%)", textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.w800)),
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
      tooltipBehavior: TooltipBehavior(
        enable: true,
        shared: true,
        duration: 4000,
        activationMode: ActivationMode.singleTap,
      ),
      series: <CartesianSeries>[
        AreaSeries<MortDashChart, DateTime>(
          name: "Mortalité (%)",
          dataSource: mortChart,
          xValueMapper: (MortDashChart data, _) => data.date,
          yValueMapper: (MortDashChart data, _) => data.mort,
          borderWidth: 1,
          color: Colors.blue.withOpacity(0.3),
          borderColor: Colors.blue.shade600,
        )
      ],
    );
  }
}
