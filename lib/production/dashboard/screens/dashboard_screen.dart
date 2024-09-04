import 'package:farmdriverzootech/production/dashboard/widgets/charts/pie_dash_chart.dart';
import 'package:farmdriverzootech/production/dashboard/widgets/dash_btn_slider.dart';
import 'package:farmdriverzootech/production/dashboard/widgets/recent_analyses.dart';
import 'package:farmdriverzootech/production/dashboard/widgets/recent_supplimentation.dart';
import 'package:farmdriverzootech/production/dashboard/widgets/site_dash_slider.dart';
import 'package:flutter/material.dart';

import '../widgets/charts/dashChartSlider/dash_chart_slider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<SitesDashSliderState> _refreshSliderkey = GlobalKey<SitesDashSliderState>();
  void childFunction() {
    _refreshSliderkey.currentState?.refreshSlider();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 14),
          SitesDashSlider(key: _refreshSliderkey),
          const SizedBox(height: 14),
          const DashBtnSlider(),
          const SizedBox(height: 20),
          const Divider(),
          const ChartDashSlider(),
          const SizedBox(height: 20),
          const Divider(),
          const PieDashChart(),
          const RecentAnalysesSection(),
          const SizedBox(height: 14),
          const RecentSuppSection(),
        ],
      ),
    );
  }
}
