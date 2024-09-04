import 'package:farmdriverzootech/farmdriver_base/provider/auth_provider.dart';
import 'package:farmdriverzootech/farmdriver_base/widgets/poppup_serfaces.dart';
import 'package:farmdriverzootech/production/performaces_table/constants.dart';
import 'package:farmdriverzootech/production/synthese/provider.dart';
import 'package:farmdriverzootech/production/synthese/widgets/cells.dart';
import 'package:farmdriverzootech/production/synthese/widgets/filters.dart';
import 'package:farmdriverzootech/production/synthese/widgets/sites_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SyntheseScreen extends StatefulWidget {
  static const routeName = 'synthese-screen/';
  const SyntheseScreen({super.key});

  @override
  State<SyntheseScreen> createState() => _SyntheseScreenState();
}

class _SyntheseScreenState extends State<SyntheseScreen> {
  bool failedToFetch = false;
  bool _isInit = true;
  bool isLoading = false;
  bool downloading = false;
  int isFinished = 1;
  int fixedAge = 0;
  // get sites
  List<int> sites = [];
  void getSites(ids) {
    sites = ids;
    fecthSyntheseData(context, isFinished, fixedAge);
  }

  void showAgePicker(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      fecthSyntheseData(context, isFinished, fixedAge);
                    },
                  )),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }

  void toggleIsFinished(int value) {
    setState(() {
      fixedAge = 0;
      isFinished = value;
      fecthSyntheseData(context, isFinished, 0);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      fecthSyntheseData(context, isFinished, 0);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void fecthSyntheseData(context, finished, age) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<SyntheseProvider>(context, listen: false).fetchSyntheseData(finished, age, sites).then((_) {
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
            fecthSyntheseData(context, finished, age);
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

  void downloadSynthese(context, finished, age) async {
    setState(() {
      downloading = true;
    });
    try {
      await Provider.of<SyntheseProvider>(context, listen: false).shareDownloadedPdf(finished, age, sites).then((_) {
        setState(() {
          failedToFetch = false;
          downloading = false;
        });
      });
    } catch (e) {
      int? statusCode = int.tryParse(e.toString().replaceAll('Exception:', '').trim());
      if (statusCode == 401) {
        try {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.tryAutoLogin().then((_) {
            downloadSynthese(context, finished, age);
          });
        } catch (e) {
          Navigator.of(context).pushNamed("auth-screen/");
        }
      }
      setState(() {
        failedToFetch = true;
        downloading = true;
      });
    }
  }

  final double paramsWidth = 120;
  final double paramsHeight = 27;

  final double dtWidth = 120;
  final double dtHeight = 27;

  Widget getSitesPicker() {
    return SitesPicker(
      getSites: getSites,
    );
  }

  @override
  Widget build(BuildContext context) {
    List tdt = Provider.of<SyntheseProvider>(context).data;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Synthèse hebdomadaire",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Filters.toggleTwoOptions(
                    context,
                    [
                      {
                        "val": 1,
                        "text": "Semaine achevée"
                      },
                      {
                        "val": 0,
                        "text": "Semaine en cours"
                      },
                    ],
                    toggleIsFinished);
              },
              icon: isFinished == 1
                  ? Icon(
                      Icons.task_alt,
                      size: 18,
                      color: Theme.of(context).primaryColorDark,
                    )
                  : Icon(
                      Icons.history_toggle_off,
                      size: 18,
                      color: Theme.of(context).primaryColorDark,
                    ),
            ),
            IconButton(
                onPressed: () {
                  downloadSynthese(context, isFinished, fixedAge);
                },
                icon: downloading
                    ? const CupertinoActivityIndicator()
                    : Icon(
                        Icons.ios_share,
                        size: 18,
                        color: Theme.of(context).primaryColorDark,
                      )),
            TextButton(
              onPressed: () {
                showAgePicker(
                  CupertinoPicker(
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: 32.0,
                    scrollController: FixedExtentScrollController(
                      initialItem: 18,
                    ),
                    onSelectedItemChanged: (int selectedItem) {
                      setState(() {
                        fixedAge = selectedItem;
                      });
                    },
                    children: List<Widget>.generate(100, (int index) {
                      return Center(child: Text(index.toString()));
                    }),
                  ),
                );
              },
              child: fixedAge != 0
                  ? Text(fixedAge.toString())
                  : Icon(
                      Icons.event,
                      color: Theme.of(context).primaryColorDark,
                      size: 18,
                    ),
            ),
            IconButton(
              onPressed: () {
                PoppupSerfaces.showPopupSurface(context, getSitesPicker, MediaQuery.of(context).size.height / 3, false);
              },
              icon: Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Theme.of(context).primaryColorDark,
              ),
            )
          ]),
      body: isLoading
          ? const CupertinoAlertDialog(
              content: CupertinoActivityIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      "Synthèse hebdomadaire des performances ${isFinished == 1 ? '(semaine achevée)' : fixedAge == 0 ? '(semaine en cours)' : '(age=$fixedAge)'}",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Column(
                            children: syntheseParams.map((e) {
                              return ParamCell(
                                value: e,
                                height: e == "Coloration d'oeuf" ? paramsHeight * 3.5 : paramsHeight,
                                width: paramsWidth,
                                highlight: e == "Paramètre/Site" ? 1 : null,
                              );
                            }).toList(),
                          ),
                          for (int i = 0; i < tdt.length; i++)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleCell(
                                  height: paramsHeight,
                                  width: paramsWidth,
                                  value: tdt[i]["site"].toString(),
                                  highlight: 1,
                                  age: tdt[i]["age"],
                                  lotId: tdt[i]["lot_id"],
                                  lot_code: tdt[i]["lot"],
                                ),
                                TitleCell(
                                  height: paramsHeight,
                                  width: paramsWidth,
                                  value: tdt[i]["batiment"].toString(),
                                  highlight: 2,
                                  age: tdt[i]["age"],
                                  lotId: tdt[i]["lot_id"],
                                  lot_code: tdt[i]["lot"],
                                ),
                                TitleCell(
                                  height: paramsHeight,
                                  width: paramsWidth,
                                  value: tdt[i]["lot"].toString(),
                                  age: tdt[i]["age"],
                                  lotId: tdt[i]["lot_id"],
                                  lot_code: tdt[i]["lot"],
                                ),
                                TitleCell(
                                  height: paramsHeight,
                                  width: paramsWidth,
                                  value: tdt[i]["date"].toString(),
                                  age: tdt[i]["age"],
                                  lotId: tdt[i]["lot_id"],
                                  lot_code: tdt[i]["lot"],
                                ),
                                TitleCell(
                                  height: paramsHeight,
                                  width: paramsWidth,
                                  value: "${tdt[i]["age"]}/${tdt[i]["daysOnAge"]}",
                                  age: tdt[i]["age"],
                                  lotId: tdt[i]["lot_id"],
                                  lot_code: tdt[i]["lot"],
                                ),
                                TitleCell(
                                  height: paramsHeight,
                                  width: paramsWidth,
                                  value: tdt[i]["souche"].toString(),
                                  age: tdt[i]["age"],
                                  lotId: tdt[i]["lot_id"],
                                  lot_code: tdt[i]["lot"],
                                ),
                                TitleCell(
                                  height: paramsHeight,
                                  width: paramsWidth,
                                  value: tdt[i]["effectif"].toString(),
                                  age: tdt[i]["age"],
                                  lotId: tdt[i]["lot_id"],
                                  lot_code: tdt[i]["lot"],
                                ),
                                Container(
                                  width: paramsWidth,
                                  height: paramsHeight,
                                  decoration: BoxDecoration(
                                      border: Border(
                                    bottom: const BorderSide(color: Colors.deepOrange),
                                    right: Theme.of(context).brightness == Brightness.light ? const BorderSide(color: Colors.black) : const BorderSide(color: Colors.white, width: 1.2),
                                  )),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("Réel", style: Theme.of(context).textTheme.bodySmall),
                                      Text("|", style: Theme.of(context).textTheme.bodySmall),
                                      Text("Ecart", style: Theme.of(context).textTheme.bodySmall)
                                    ],
                                  ),
                                ),
                                DuoCell(
                                  value: tdt[i]["mort"],
                                  height: dtHeight,
                                  width: dtWidth,
                                ),
                                DuoCell(
                                  value: tdt[i]["mort_cuml"],
                                  height: dtHeight,
                                  width: dtWidth,
                                ),
                                DuoCell(
                                  value: tdt[i]["cent_ponte"],
                                  height: dtHeight,
                                  width: dtWidth,
                                ),
                                DuoCell(
                                  value: tdt[i]["aps"],
                                  height: dtHeight,
                                  width: dtWidth,
                                ),
                                DuoCell(
                                  value: tdt[i]["noppd"],
                                  height: dtHeight,
                                  width: dtWidth,
                                ),
                                DuoCell(
                                  value: tdt[i]["pv"],
                                  height: dtHeight,
                                  width: dtWidth,
                                ),
                                DuoCell(
                                  value: tdt[i]["homog"],
                                  height: dtHeight,
                                  width: dtWidth,
                                ),
                                DuoCell(
                                  value: tdt[i]["pmo"],
                                  height: dtHeight,
                                  width: dtWidth,
                                ),
                                DuoCell(
                                  value: tdt[i]["alt_cuml"],
                                  height: dtHeight,
                                  width: dtWidth,
                                ),
                                DuoCell(
                                  value: tdt[i]["alt_oeuf_cuml"],
                                  height: dtHeight,
                                  width: dtWidth,
                                ),
                                DuoCell(
                                  value: tdt[i]["mass_sem"],
                                  height: dtHeight,
                                  width: dtWidth,
                                ),
                                DuoCell(
                                  value: tdt[i]["mass_oeuf_pd"],
                                  height: dtHeight,
                                  width: dtWidth,
                                ),
                                DuoCell(
                                  value: tdt[i]["ic_cuml"],
                                  height: dtHeight,
                                  width: dtWidth,
                                ),
                                TwoCell(
                                  height: dtHeight,
                                  width: dtWidth,
                                  value: tdt[i]["eps"].toString(),
                                  secValue: tdt[i]["ratio"]["reel"].toString(),
                                  color: tdt[i]["ratio"]["color"],
                                ),
                                TwoCell(
                                  height: dtHeight,
                                  width: dtWidth,
                                  value: tdt[i]["light"].toString(),
                                  secValue: tdt[i]["flash"].toString(),
                                ),
                                UnoCell(
                                  height: dtHeight,
                                  width: dtWidth,
                                  value: tdt[i]["formuleAlt"],
                                  isImage: false,
                                ),
                                UnoCell(
                                  height: dtHeight,
                                  width: dtWidth,
                                  value: tdt[i]["shell"].toString(),
                                  isImage: true,
                                ),
                                UnoCell(
                                  height: dtHeight * 3.5,
                                  width: dtWidth,
                                  value: tdt[i]["coloration"].toString(),
                                  isImage: true,
                                  showLable: true,
                                ),
                                ObservCell(
                                  observs: tdt[i]["observs"],
                                  width: dtWidth,
                                ),
                              ],
                            ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
