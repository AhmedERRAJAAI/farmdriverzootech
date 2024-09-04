import 'package:farmdriverzootech/farmdriver_base/provider/auth_provider.dart';
import 'package:farmdriverzootech/farmdriver_base/widgets/info_dialog.dart';
import 'package:farmdriverzootech/production/dashboard/provider/init_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'provider.dart';

class PieDashChart extends StatefulWidget {
  const PieDashChart({super.key});

  @override
  State<PieDashChart> createState() => _PieDashChartState();
}

class _PieDashChartState extends State<PieDashChart> {
  bool isLoading = false;
  bool failedToFetch = false;
  int siteId = 0;
  String siteName = "-- ALL --";

  @override
  void initState() {
    fetchPieChartData(context);
    super.initState();
  }

// switch sites
  void _showSiteFilterLotActionSheet(BuildContext context) {
    final List<SliderItem> sites = Provider.of<InitProvider>(context, listen: false).slidesData;
    sites.insert(0, SliderItem(siteId: 0, siteName: "--  ALL  --"));
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('changer de site'),
        actions: sites.map((site) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                siteId = site.siteId;
                siteName = site.siteName;
              });
              fetchPieChartData(context);
              Navigator.pop(context);
            },
            child: Text(site.siteName),
          );
        }).toList(),
      ),
    );
  }

//
  void fetchPieChartData(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<DashChartProvider>(context, listen: false).getAgePieChartData(siteId).then((_) {
        setState(() {
          isLoading = false;
          failedToFetch = false;
        });
      });
    } catch (e) {
      int? statusCode = int.tryParse(e.toString().replaceAll('Exception:', '').trim());
      if (statusCode == 401) {
        try {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.tryAutoLogin().then((_) {
            fetchPieChartData(context);
          });
        } catch (e) {
          Navigator.of(context).pushNamed("auth-screen/");
        }
      } else {
        AlertsDialog.doUreallyWant(
          context,
          "Echec",
          "échec de récupération des données status: $statusCode",
          "Réessayer",
          true,
          fetchPieChartData,
        );
      }
      setState(() {
        isLoading = false;
        failedToFetch = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = Provider.of<DashChartProvider>(context, listen: true).pieAgeChartData;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: Colors.orange,
                    size: 13,
                  ),
                  Text(
                    " Repartition effectif",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                  ),
                ],
              ),
              GestureDetector(
                  child: Text(
                    siteName,
                    style: TextStyle(color: Theme.of(context).primaryColor, decoration: TextDecoration.underline),
                  ),
                  onTap: () => _showSiteFilterLotActionSheet(context))
            ],
          ),
        ),
        SfCircularChart(
          tooltipBehavior: TooltipBehavior(enable: true, shared: true, duration: 1000),
          legend: const Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.scroll,
            alignment: ChartAlignment.center,
            isResponsive: true,
            position: LegendPosition.right,
          ),
          palette: [
            Colors.deepOrange.shade300,
            Colors.purple.shade300,
            Colors.lime.shade300,
            Colors.blue.shade300,
            Colors.pink.shade300,
            Colors.blueGrey.shade300
          ],
          series: <CircularSeries>[
            PieSeries<ChartData, String>(
              enableTooltip: true,
              dataSource: chartData,
              explode: true,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              pointRadiusMapper: (ChartData data, _) => data.size,
              dataLabelSettings: const DataLabelSettings(isVisible: true, color: Colors.white),
              animationDuration: 1000,
              // explodeAll: true,
            )
          ],
        ),
      ],
    );
  }
}
