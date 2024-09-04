import 'package:farmdriverzootech/production/dashboard/provider/init_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProductionDashChart extends StatefulWidget {
  const ProductionDashChart({super.key});

  @override
  State<ProductionDashChart> createState() => _ProductionDashChartState();
}

class _ProductionDashChartState extends State<ProductionDashChart> {
  @override
  Widget build(BuildContext context) {
    List<ProdDashChart> prodData = Provider.of<InitProvider>(context).prodChart;
    return SfCartesianChart(
      title: const ChartTitle(text: "Production (milliers)", textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.w800)),
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
        AreaSeries<ProdDashChart, DateTime>(
          name: "Production (milliers)",
          dataSource: prodData,
          xValueMapper: (ProdDashChart data, _) => data.date,
          yValueMapper: (ProdDashChart data, _) => data.prod,
          borderWidth: 1.5,
          color: Colors.blue.withOpacity(0.3),
          borderColor: Colors.blue.shade600,
        )
      ],
    );
  }
}
