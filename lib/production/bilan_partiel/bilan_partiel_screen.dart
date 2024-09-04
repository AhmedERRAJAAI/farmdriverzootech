import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:farmdriverzootech/farmdriver_base/provider/auth_provider.dart';
import 'package:farmdriverzootech/production/bilan_partiel/bilan_provider.dart';
import 'package:farmdriverzootech/production/bilan_partiel/widgets/chart_box.dart';
import 'package:farmdriverzootech/production/charts/blue_print.dart';
import 'package:farmdriverzootech/production/charts/charts_screen.dart';
import 'package:farmdriverzootech/production/charts/provider.dart';
// import 'package:farmdriverzootech/production/charts/charts_screen.dart';
import 'package:farmdriverzootech/production/charts/widgets/conso_chart.dart';
import 'package:farmdriverzootech/production/charts/widgets/ic_chart.dart';
import 'package:farmdriverzootech/production/charts/widgets/masse_chart.dart';
import 'package:farmdriverzootech/production/charts/widgets/mort_chart.dart';
import 'package:farmdriverzootech/production/charts/widgets/prod_chart.dart';
import 'package:farmdriverzootech/production/charts/widgets/pv_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:page_transition/page_transition.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

// import 'charts_screen.dart';
// import '../../providers/table_charts_blueprint.dart';
// import 'package:provider/provider.dart';
// import '../../providers/table_charts_provider.dart';
// import '../../providers/statistics_provider.dart';
// import '../../components/chart_box.dart';
// import 'package:farmdriverzootech/zoo-tech/components/tableCharts/mort_chart.dart';
// import 'package:farmdriverzootech/zoo-tech/components/tableCharts/pv_chart.dart';
// import '../../components/tableCharts/prod_chart.dart';
// import '../../components/tableCharts/conso_chart.dart';
// import '../../components/tableCharts/masse_chart.dart';
// import '../../components/tableCharts/ic_chart.dart';

class BilanPartiel extends StatefulWidget {
  final int lotId;
  final String lotCode;
  const BilanPartiel({super.key, required this.lotId, required this.lotCode});

  @override
  State<BilanPartiel> createState() => _BilanPartielState();
}

class _BilanPartielState extends State<BilanPartiel> {
  final bool _stretch = true;
  bool _isInit = true;
  bool isLoading = false;
  bool failedToFetch = false;

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

  String nbrFormater(value) {
    String formattedValue = NumberFormat("#,###").format(value);
    return formattedValue.replaceAll(',', ' ');
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      fetchBilan(context, widget.lotId);
      for (var i = 0; i < chartsApis.length; i++) {
        fetchCharts(chartsApis[i], i, context);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void fetchCharts(api, index, context) async {
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
            fetchCharts(api, index, context);
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

  void fetchBilan(context, lotId) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<StatisticsProvider>(context, listen: false).getPartialBilan(lotId).then((_) {
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
            fetchBilan(context, lotId);
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

  Future<void> refresh() async {}

  @override
  Widget build(BuildContext context) {
    final providerInst = Provider.of<ChartsTableProvider>(context);
    final bilanData = Provider.of<StatisticsProvider>(context).bilanData;
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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Tooltip(
          message: widget.lotCode,
          triggerMode: TooltipTriggerMode.tap,
          child: Text(
            "Bilan partiel",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    curve: Curves.bounceIn,
                    child: ChartsScreen(lotId: widget.lotId, lotCode: widget.lotCode),
                  ),
                );
              },
              icon: const Icon(
                Icons.add_chart,
              )),
          if (isLoading) const Padding(padding: EdgeInsets.only(right: 4), child: CupertinoActivityIndicator())
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                leading: const SizedBox(),
                stretch: _stretch,
                onStretchTrigger: () async {
                  // Triggers when stretching
                },
                stretchTriggerOffset: 300.0,
                expandedHeight: 320.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: SizedBox(
                    height: 320,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        viewportFraction: 0.97,
                        enableInfiniteScroll: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        height: 320,
                      ),
                      items: [
                        Builder(
                          builder: (BuildContext context) {
                            return ChartBox(chart: ProdChart(reels: prodData, normes: guideProdData));
                          },
                        ),
                        Builder(
                          builder: (BuildContext context) {
                            return ChartBox(chart: ConsoChart(reels: consoData, normes: guideConsoData));
                          },
                        ),
                        Builder(
                          builder: (BuildContext context) {
                            return ChartBox(chart: MortChart(reels: mortData, normes: guideMortData));
                          },
                        ),
                        Builder(
                          builder: (BuildContext context) {
                            return ChartBox(chart: PvChart(reels: pvData, normes: guidePvData));
                          },
                        ),
                        Builder(
                          builder: (BuildContext context) {
                            return ChartBox(chart: MasseChart(reels: masseData, normes: guideMasseData));
                          },
                        ),
                        Builder(
                          builder: (BuildContext context) {
                            return ChartBox(chart: IcChart(reels: icData, normes: guideIcData));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int i) {
                    return isLoading
                        ? const CupertinoActivityIndicator()
                        : Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 7),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          widget.lotCode,
                                          style: TextStyle(color: Colors.amber.shade700, letterSpacing: 1.5, fontWeight: FontWeight.w900),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.all(3),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.amber.shade100.withOpacity(0.1),
                                          border: Border.all(color: Colors.amber, width: 0.5),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Récapitulatif (${bilanData["first_age"]}",
                                                  style: const TextStyle(color: Colors.amber),
                                                ),
                                                const Text("/1", style: TextStyle(color: Colors.amber, fontSize: 11)),
                                                const Text(" ∼ ", style: TextStyle(color: Colors.amber)),
                                                Text(
                                                  "${bilanData["age"]}",
                                                  style: const TextStyle(color: Colors.amber),
                                                ),
                                                Text("/${bilanData["day_on_week"]}", style: const TextStyle(color: Colors.amber, fontSize: 11)),
                                                const Text(" sem)", style: TextStyle(color: Colors.amber)),
                                              ],
                                            ),
                                            const SizedBox(height: 7),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  bilanData["souche"].toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context).primaryColor,
                                                    decoration: TextDecoration.none,
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    text: bilanData["age"].toString(),
                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, decoration: TextDecoration.none),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: " sem",
                                                        style: TextStyle(fontWeight: FontWeight.w300, color: Theme.of(context).primaryColor, fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'Né le: ',
                                                    style: TextStyle(color: Theme.of(context).primaryColorDark.withOpacity(0.8), fontWeight: FontWeight.w300, fontSize: 12),
                                                    children: <TextSpan>[
                                                      TextSpan(text: bilanData["birth_date"], style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, decoration: TextDecoration.none)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "Effectif depart",
                                                      style: TextStyle(color: Theme.of(context).primaryColorDark.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w400),
                                                    ),
                                                    Text(
                                                      bilanData["eff_depart"].toString(),
                                                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, decoration: TextDecoration.none),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Mortalité",
                                                      style: TextStyle(color: Theme.of(context).primaryColorDark.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w400),
                                                    ),
                                                    Text(
                                                      nbrFormater(bilanData["mort_nbr"] ?? 0),
                                                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, decoration: TextDecoration.none),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "Effectif présent",
                                                      style: TextStyle(color: Theme.of(context).primaryColorDark.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w400),
                                                    ),
                                                    Text(
                                                      bilanData["eff_present"].toString(),
                                                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, decoration: TextDecoration.none),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const Divider(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "Production totale",
                                                      style: TextStyle(color: Theme.of(context).primaryColorDark.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w400),
                                                    ),
                                                    Text(
                                                      nbrFormater(bilanData["production"]),
                                                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, decoration: TextDecoration.none),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Déclassés", //separateur
                                                      style: TextStyle(color: Theme.of(context).primaryColorDark.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w400),
                                                    ),
                                                    Text(
                                                      "${nbrFormater(bilanData["declassed"])} (${bilanData["declassed_prsnt"]} %)",
                                                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, decoration: TextDecoration.none),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Conso. alt.", //separateur
                                                      style: TextStyle(color: Theme.of(context).primaryColorDark.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w400),
                                                    ),
                                                    Text(
                                                      "${nbrFormater(bilanData["alimentDist"])} Kg",
                                                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, decoration: TextDecoration.none),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(3),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.lightGreen.shade100.withOpacity(0.1),
                                          border: Border.all(color: Colors.green, width: 0.5),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Dernière semaine achevée : ${bilanData["week_data"]["age"]} ",
                                              style: const TextStyle(color: Colors.green),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    "Param",
                                                    style: TextStyle(
                                                      color: Theme.of(context).primaryColorDark,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "Réel",
                                                  style: TextStyle(
                                                    color: Theme.of(context).primaryColorDark,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  "Ecart/std",
                                                  style: TextStyle(
                                                    color: Theme.of(context).primaryColorDark,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  "Progression",
                                                  style: TextStyle(
                                                    color: Theme.of(context).primaryColorDark,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const Divider(
                                              height: 0,
                                            ),
                                            ParamListItem(
                                              paramName: "Ponte (%)",
                                              fullname: "Pourcentage de ponte par poule présente",
                                              data: bilanData["week_data"]["ponte"],
                                              unity: "%",
                                            ),
                                            ParamListItem(
                                              paramName: "Mortalité (%)",
                                              fullname: "Pourcentage de mortalité par semaine",
                                              data: bilanData["week_data"]["mort"],
                                              unity: "%",
                                            ),
                                            ParamListItem(
                                              paramName: "PMO",
                                              fullname: "Poids moyen d'oeuf",
                                              data: bilanData["week_data"]["pmo"],
                                              unity: "g",
                                            ),
                                            ParamListItem(
                                              paramName: "P.V",
                                              fullname: "Poids vif",
                                              data: bilanData["week_data"]["pv"],
                                              unity: "g",
                                            ),
                                            ParamListItem(
                                              paramName: "Homog (%)",
                                              fullname: "Homogéniété",
                                              data: bilanData["week_data"]["homog"],
                                              unity: "%",
                                              noBorder: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Bilan partiel (${bilanData["first_age"]}",
                                                style: const TextStyle(color: Colors.deepPurple),
                                              ),
                                              const Text("/1", style: TextStyle(color: Colors.deepPurple, fontSize: 11)),
                                              const Text(" ∼ ", style: TextStyle(color: Colors.deepPurple)),
                                              Text(
                                                "${bilanData["age"]}",
                                                style: const TextStyle(color: Colors.deepPurple),
                                              ),
                                              Text("/${bilanData["day_on_week"]}", style: const TextStyle(color: Colors.deepPurple, fontSize: 11)),
                                              const Text(" sem)", style: TextStyle(color: Colors.deepPurple)),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          ParamListItem(
                                            paramName: "Σ Mort",
                                            fullname: "Mortalité cumulé",
                                            data: bilanData["mort"],
                                            unity: "%",
                                          ),
                                          ParamListItem(
                                            paramName: "Σ NOPPP",
                                            fullname: "Nombre d'oeuf cumulé par poule présente",
                                            data: bilanData["noppp"],
                                            unity: "oeuf",
                                          ),
                                          ParamListItem(
                                            paramName: "Σ NOPPD",
                                            fullname: "Nombre d'oeuf cumulé par poule départ",
                                            data: bilanData["noppd"],
                                            unity: "oeuf",
                                          ),
                                          ParamListItem(
                                            paramName: "Σ MOPPP",
                                            fullname: "Masse d'oeuf cumulé par poule présente",
                                            data: bilanData["moppp"],
                                            unity: "Kg",
                                          ),
                                          ParamListItem(
                                            paramName: "Σ MOPPD",
                                            fullname: "Masse d'oeuf cumulé par poule départ",
                                            data: bilanData["moppd"],
                                            unity: "Kg",
                                          ),
                                          ParamListItem(
                                            paramName: "Σ APS",
                                            fullname: "Consommation cumulée d'aliment par sujet",
                                            data: bilanData["aps_cuml"],
                                            unity: "Kg",
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                  },
                  childCount: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ParamListItem extends StatelessWidget {
  final String paramName;
  final String? fullname;
  final Map data;
  final bool? noBorder;
  final String unity;

  const ParamListItem({
    super.key,
    required this.paramName,
    required this.data,
    this.fullname,
    this.noBorder,
    required this.unity,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, Color> ecartColors = {
      "red": Colors.deepOrange.shade500,
      "green": Colors.lightGreen.shade600,
      "orange": Colors.orange,
      "blue": Colors.blue,
    };
    return Container(
      decoration: noBorder == null ? BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))) : null,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: 100,
              child: Tooltip(
                enableTapToDismiss: true,
                triggerMode: TooltipTriggerMode.tap,
                message: fullname,
                child: Text(
                  paramName,
                  style: TextStyle(color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.w400, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              )),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Tooltip(
                  message: "${data["reel"]} $unity",
                  triggerMode: TooltipTriggerMode.tap,
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: data["reel"].toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, decoration: TextDecoration.none),
                      children: <TextSpan>[
                        TextSpan(
                          text: " $unity",
                          style: TextStyle(fontWeight: FontWeight.w300, color: Theme.of(context).primaryColor, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  data["ecart"].toString(),
                  style: TextStyle(color: ecartColors[data["color"]], fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          FittedBox(
            child: Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              message: "GUIDE: ${data["guide"]}",
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  SizedBox(
                      height: 20,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: ecartColors[data["color"]] ?? Colors.blue)),
                        child: Row(
                          children: [
                            Text(
                              "${data["ecart_prsnt"]} %",
                              style: TextStyle(color: ecartColors[data["color"]] ?? Colors.blue, fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            Icon(
                              data["isUp"] ? Icons.arrow_upward : Icons.arrow_downward,
                              color: ecartColors[data["color"]] ?? Colors.blue,
                              size: 13,
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
