import 'package:farmdriverzootech/production/dashboard/provider/init_provider.dart';
import 'package:farmdriverzootech/production/synthese/widgets/filters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'altOeuf_dash_chart.dart';
import 'conso_dash_chart.dart';
import 'mort_dash_chart.dart';
import 'production_dash_chart.dart';

class ChartDashSlider extends StatefulWidget {
  const ChartDashSlider({super.key});

  @override
  State<ChartDashSlider> createState() => _ChartDashSliderState();
}

class _ChartDashSliderState extends State<ChartDashSlider> {
  bool _isInit = true;
  bool isLoading = false;
  bool failedToFetch = false;
  int time = 30;
  String timeName = "mois dernier";
  dynamic site = false;
  String? siteName;
  final List<int> periods = [
    7,
    15,
    30,
    90,
    365,
    0
  ];

  void siteGetter(siteId, siteNm) {
    setState(() {
      site = siteId;
      siteName = siteNm;
    });
    fetchCharts(time, site);
  }

  void periodGetter(value) {
    setState(() {
      time = value;
      switch (value) {
        case 7:
          timeName = "la semaine dernière";
          break;
        case 15:
          timeName = "la quinzaine dernière";
          break;
        case 30:
          timeName = "mois dernier";
          break;
        case 90:
          timeName = "les trois derniers mois";
          break;
        case 365:
          timeName = "l'année dernière";
          break;
        case 0:
          timeName = "MAX";
          break;
      }
    });
    fetchCharts(time, site);
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      fetchCharts(time, site);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void fetchCharts(period, siteId) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<InitProvider>(context, listen: false).getDashCharts(period, siteId).then((_) {
        setState(() {
          isLoading = false;
          failedToFetch = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        failedToFetch = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List sites = Provider.of<InitProvider>(context, listen: false).slidesData.map((e) {
      return {
        "siteId": e.siteId,
        "siteName": e.siteName
      };
    }).toList();
    sites.insert(0, {
      "siteId": false,
      "siteName": "ALL"
    });

    return isLoading
        ? const CupertinoAlertDialog(
            content: CupertinoActivityIndicator(),
          )
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          color: Colors.blue,
                          size: 13,
                        ),
                        const Text(
                          " Évolution sur ",
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                        ),
                        GestureDetector(
                          child: Text(
                            timeName,
                            style: TextStyle(color: Theme.of(context).primaryColor, decoration: TextDecoration.underline, fontSize: 13),
                          ),
                          onTap: () => Filters.showPeriodActionSheet(context, periods, periodGetter),
                        )
                      ],
                    ),
                    GestureDetector(
                      child: Text(
                        siteName ?? "-- ALL --",
                        style: TextStyle(color: Theme.of(context).primaryColor, decoration: TextDecoration.underline),
                      ),
                      onTap: () => Filters.showActionSheet(context, sites, siteGetter),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 200, child: ProductionDashChart()),
              const SizedBox(height: 200, child: MortaliteDashChart()),
              const SizedBox(height: 200, child: ApoeufDashChart()),
              const SizedBox(height: 200, child: ConsoDashChart()),
              // Stack(
              //   children: [
              //     SizedBox(
              //       height: 260,
              //       child: CarouselSlider(
              //         options: CarouselOptions(
              //           autoPlayCurve: Curves.fastOutSlowIn,
              //           enlargeCenterPage: true,
              //           viewportFraction: 0.97,
              //           enableInfiniteScroll: true,
              //           enlargeStrategy: CenterPageEnlargeStrategy.height,
              //           height: 260,
              //         ),
              //         items: [
              //           Builder(
              //             builder: (BuildContext context) {
              //               return const SizedBox(height: 300, child: ProductionDashChart());
              //             },
              //           ),
              //           Builder(
              //             builder: (BuildContext context) {
              //               return const SizedBox(height: 300, child: MortaliteDashChart());
              //             },
              //           ),
              //           Builder(
              //             builder: (BuildContext context) {
              //               return const SizedBox(height: 300, child: ApoeufDashChart());
              //             },
              //           ),
              //           Builder(
              //             builder: (BuildContext context) {
              //               return const SizedBox(height: 300, child: ConsoDashChart());
              //             },
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: 20,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       OutlinedButton(
              //         style: OutlinedButton.styleFrom(backgroundColor: time == 30 ? Theme.of(context).primaryColor : Colors.transparent),
              //         onPressed: () {
              //           setState(() {
              //             time = 30;
              //             fetchCharts(30, site);
              //           });
              //         },
              //         child: Text("1 M", style: TextStyle(color: time == 30 ? Colors.white : Theme.of(context).primaryColor, fontWeight: FontWeight.w400)),
              //       ),
              //       OutlinedButton(
              //         style: OutlinedButton.styleFrom(backgroundColor: time == 365 ? Theme.of(context).primaryColor : Colors.transparent),
              //         onPressed: () {
              //           setState(() {
              //             time = 365;
              //             fetchCharts(365, site);
              //           });
              //         },
              //         child: Text("12 M", style: TextStyle(color: time == 365 ? Colors.white : Theme.of(context).primaryColor, fontWeight: FontWeight.w400)),
              //       ),
              //       OutlinedButton(
              //         style: OutlinedButton.styleFrom(backgroundColor: time == 0 ? Theme.of(context).primaryColor : Colors.transparent),
              //         onPressed: () {
              //           setState(() {
              //             time = 0;
              //             fetchCharts(0, site);
              //           });
              //         },
              //         child: Text("Max", style: TextStyle(color: time == 0 ? Colors.white : Theme.of(context).primaryColor, fontWeight: FontWeight.w400)),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          );
  }
}
