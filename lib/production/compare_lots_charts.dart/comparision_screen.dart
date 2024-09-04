import 'package:farmdriverzootech/farmdriver_base/provider/auth_provider.dart';
import 'package:farmdriverzootech/production/bilan_partiel/widgets/chart_box.dart';
import 'package:farmdriverzootech/production/charts/widgets/conso_chart.dart';
import 'package:farmdriverzootech/production/charts/widgets/masse_chart.dart';
import 'package:farmdriverzootech/production/charts/widgets/mort_chart.dart';
import 'package:farmdriverzootech/production/charts/widgets/prod_chart.dart';
import 'package:farmdriverzootech/production/charts/widgets/pv_chart.dart';
import 'package:farmdriverzootech/production/compare_lots_charts.dart/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model.dart';
import 'widgets/select_multi_lots.dart';

class ComparisionLotsScreen extends StatefulWidget {
  static const routeName = 'comparision-lots-screen/';
  const ComparisionLotsScreen({super.key});

  @override
  State<ComparisionLotsScreen> createState() => _ComparisionLotsScreenState();
}

class _ComparisionLotsScreenState extends State<ComparisionLotsScreen> {
  List<SelectOption> lotIds = [];
  int? selectedChart;
  bool isLoading = false;
  bool failedToFetch = false;
  bool showAgeRange = false;
  RangeValues _currentRangeValues = const RangeValues(18, 100);

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {});
    Provider.of<ComparaisionProvider>(context, listen: false).comparedCharts.clear();
    super.initState();
  }

  void fetchCharts(context) async {
    List<int> idsOfLots = lotIds.map((e) => e.id).toList();
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<ComparaisionProvider>(context, listen: false).getLotsComparaisionCharts(idsOfLots, selectedChart).then((_) {
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
            fetchCharts(context);
          });
        } catch (e) {
          Navigator.of(context).pushNamed("auth-screen/");
        }
      }
      setState(() {
        isLoading = false;
        failedToFetch = true;
      });
    }
  }

  void chartGetter(value) {
    setState(() {
      Provider.of<ComparaisionProvider>(context, listen: false).comparedCharts.clear();
      selectedChart = value;
      fetchCharts(context);
    });
  }

  void selectLotPlusCharts() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: SizedBox(
              height: 500,
              child: SelectMultiLots(
                currentValue: selectedChart,
                idsList: lotIds,
                getter: chartGetter,
                getCharts: fetchCharts,
              ),
            ));
      },
    );
  }

  int selectedPage = 7;
  @override
  Widget build(BuildContext context) {
    List comparedCharts = Provider.of<ComparaisionProvider>(context).comparedCharts;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Comparatif des lots",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          centerTitle: true,
          actions: [
            if (selectedChart != null)
              IconButton(
                  onPressed: () {
                    setState(() {
                      showAgeRange = !showAgeRange;
                    });
                  },
                  icon: const Icon(Icons.swipe)),
            IconButton(
                onPressed: () {
                  selectLotPlusCharts();
                },
                icon: const Icon(Icons.add_chart))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (showAgeRange)
                Row(
                  children: [
                    Text(
                      _currentRangeValues.start.toStringAsFixed(0),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Expanded(
                      child: RangeSlider(
                        values: _currentRangeValues,
                        min: 17,
                        max: 101,
                        divisions: 100,
                        labels: RangeLabels(
                          _currentRangeValues.start.round().toString(),
                          _currentRangeValues.end.round().toString(),
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            _currentRangeValues = values;
                            selectedPage = 7;
                          });
                        },
                      ),
                    ),
                    Text(
                      _currentRangeValues.end.toStringAsFixed(0),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              if (showAgeRange)
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: CupertinoSegmentedControl(
                      padding: EdgeInsets.zero,
                      children: const {
                        7: Text('-', style: TextStyle(fontSize: 11)),
                        0: Text('18 - 40', style: TextStyle(fontSize: 11)),
                        1: Text('41 - 60', style: TextStyle(fontSize: 11)),
                        2: Text('61 - 80', style: TextStyle(fontSize: 11)),
                        3: Text('81 - 100', style: TextStyle(fontSize: 11)),
                      },
                      groupValue: selectedPage,
                      onValueChanged: (value) {
                        setState(() {
                          switch (value) {
                            case 0:
                              _currentRangeValues = const RangeValues(18, 40);
                              break;
                            case 1:
                              _currentRangeValues = const RangeValues(41, 60);
                              break;
                            case 2:
                              _currentRangeValues = const RangeValues(61, 80);
                              break;
                            case 3:
                              _currentRangeValues = const RangeValues(81, 100);
                              break;
                            case 7:
                              _currentRangeValues = const RangeValues(18, 100);
                              break;
                            default:
                          }
                          selectedPage = value;
                        });
                      },
                    ),
                  ),
                ),
              isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : comparedCharts.isEmpty
                      ? const SizedBox(
                          height: 400,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.query_stats,
                                  size: 45,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Aucun lot choisi",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: comparedCharts.map((chart) {
                          return selectedChart == null
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 500,
                                    child: Center(
                                      child: Text(
                                        "utilisez le bouton de filtre ci-dessus pour sélectionner les lots",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.amber),
                                      ),
                                    ),
                                  ),
                                )
                              : switch (selectedChart ?? 0) {
                                  0 => ChartBox(
                                        chart: ProdChart(
                                      normes: chart["guide"],
                                      reels: chart["reel"],
                                      title: chart["title"],
                                      minAge: _currentRangeValues.start,
                                      maxAge: _currentRangeValues.end,
                                    )),
                                  1 => ChartBox(
                                        chart: MortChart(
                                      normes: chart["guide"],
                                      reels: chart["reel"],
                                      title: chart["title"],
                                      minAge: _currentRangeValues.start,
                                      maxAge: _currentRangeValues.end,
                                    )),
                                  2 => ChartBox(
                                        chart: ConsoChart(
                                      normes: chart["guide"],
                                      reels: chart["reel"],
                                      title: chart["title"],
                                      minAge: _currentRangeValues.start,
                                      maxAge: _currentRangeValues.end,
                                    )),
                                  3 => ChartBox(
                                        chart: PvChart(
                                      normes: chart["guide"],
                                      reels: chart["reel"],
                                      title: chart["title"],
                                      minAge: _currentRangeValues.start,
                                      maxAge: _currentRangeValues.end,
                                    )),
                                  4 => ChartBox(
                                        chart: MasseChart(
                                      normes: chart["guide"],
                                      reels: chart["reel"],
                                      title: chart["title"],
                                      minAge: _currentRangeValues.start,
                                      maxAge: _currentRangeValues.end,
                                    )),
                                  int() => throw UnimplementedError(),
                                };
                        }).toList()),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    Provider.of<ComparaisionProvider>(context, listen: false).comparedCharts.clear();
    super.dispose();
  }
}
