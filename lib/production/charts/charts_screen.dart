import 'package:farmdriverzootech/farmdriver_base/provider/auth_provider.dart';
import 'package:farmdriverzootech/production/bilan_partiel/widgets/chart_box.dart';
import 'package:farmdriverzootech/production/charts/blue_print.dart';
import 'package:farmdriverzootech/production/charts/provider.dart';
import 'package:farmdriverzootech/production/charts/widgets/conso_chart.dart';
import 'package:farmdriverzootech/production/charts/widgets/ic_chart.dart';
import 'package:farmdriverzootech/production/charts/widgets/masse_chart.dart';
import 'package:farmdriverzootech/production/charts/widgets/mort_chart.dart';
import 'package:farmdriverzootech/production/charts/widgets/prod_chart.dart';
import 'package:farmdriverzootech/production/charts/widgets/pv_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ChartsScreen extends StatefulWidget {
  final int lotId;
  final String lotCode;
  const ChartsScreen({super.key, required this.lotId, required this.lotCode});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  bool _isInit = true;
  bool isLoading = false;
  bool failedToFetch = false;
  bool showAgesSlider = false;
  RangeValues _currentRangeValues = const RangeValues(18, 100);
  List<Widget> chartsList = [];

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  List<String> chartsApis = [
    "table-prod-chart-new",
    "table-conso-chart-new",
    "table-mort-chart-new",
    "homog-pv-chart-new",
    "table-massoeuf-chart-new",
    "table-ic-chart-new",
    // "table-light-chart",
  ];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      for (var i = 0; i < chartsApis.length; i++) {
        fetchCharts(context, chartsApis[i], i);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void fetchCharts(context, api, index) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<ChartsTableProvider>(context, listen: false).getCharts(lot: widget.lotId, uri: api, index: index).then((_) {
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
            fetchCharts(context, api, index);
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

  int selectedPage = 7;
  @override
  Widget build(BuildContext context) {
    final providerInst = Provider.of<ChartsTableProvider>(context);
    // production
    List<ProdChartData> prodData = providerInst.prodData;
    List<GprodChartData> guideProdData = providerInst.guideProdData;
    // Consommation
    List<ConsoChartData> consoData = providerInst.consoData;
    List<GconsoChartData> guideConsoData = providerInst.guideConsoData;
    // Mortalité
    List<MortChartData> mortData = providerInst.mortData;
    List<GmortChartData> guideMortData = providerInst.guideMortData;
    // PV
    List<PvChartData> pvData = providerInst.pvdata;
    List<GpvChartData> guidePvData = providerInst.guidePvData;
    // MASSE
    List<MasseChartData> masseData = providerInst.massedata;
    List<GmasseChartData> guideMasseData = providerInst.guideMasseData;
    // IC
    List<IcChartData> icData = providerInst.icdata;
    List<GicChartData> guideIcData = providerInst.guideIcData;

    chartsList = isLoading
        ? []
        : [
            ChartBox(
                chart: ProdChart(
              reels: prodData,
              normes: guideProdData,
              minAge: _currentRangeValues.start,
              maxAge: _currentRangeValues.end,
            )),
            ChartBox(
                chart: ConsoChart(
              reels: consoData,
              normes: guideConsoData,
              minAge: _currentRangeValues.start,
              maxAge: _currentRangeValues.end,
            )),
            ChartBox(
                chart: MortChart(
              reels: mortData,
              normes: guideMortData,
              minAge: _currentRangeValues.start,
              maxAge: _currentRangeValues.end,
            )),
            ChartBox(
                chart: PvChart(
              reels: pvData,
              normes: guidePvData,
              minAge: _currentRangeValues.start,
              maxAge: _currentRangeValues.end,
            )),
            ChartBox(
                chart: MasseChart(
              reels: masseData,
              normes: guideMasseData,
              minAge: _currentRangeValues.start,
              maxAge: _currentRangeValues.end,
            )),
            ChartBox(
                chart: IcChart(
              reels: icData,
              normes: guideIcData,
              minAge: _currentRangeValues.start,
              maxAge: _currentRangeValues.end,
            )),
          ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.lotCode,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  showAgesSlider = !showAgesSlider;
                });
              },
              icon: const Icon(Icons.swipe)),
          isLoading
              ? const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: CupertinoActivityIndicator(),
                )
              : const SizedBox()
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: !isLoading
            ? SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max, // This ensures the Column has a minimum height

                  children: [
                    if (showAgesSlider)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
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
                      ),
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
                    for (int index = 0; index < chartsList.length; index += 1) chartsList[index],
                  ],
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}
