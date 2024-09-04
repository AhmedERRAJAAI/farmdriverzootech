import 'package:farmdriverzootech/farmdriver_base/provider/auth_provider.dart';
import 'package:farmdriverzootech/production/data_entry/widgets/ambiance_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../farmdriver_base/widgets/pickers.dart';
import '../../farmdriver_base/widgets/poppup_serfaces.dart';
import '../compare_lots_charts.dart/model.dart';
import '../dashboard/provider/init_provider.dart';
import 'provider.dart';
import 'widgets/conso_post.dart';
import 'widgets/livraison_post.dart';
import 'widgets/prod_post.dart';
import 'widgets/reform_post.dart';
import 'widgets/viability_post.dart';

class ProdFormScreen extends StatefulWidget {
  final String lotCode;
  final int lotId;
  static const routeName = 'data-entry-screen/';
  const ProdFormScreen({super.key, required this.lotCode, required this.lotId});

  @override
  State<ProdFormScreen> createState() => _ProdFormScreenState();
}

class _ProdFormScreenState extends State<ProdFormScreen> {
  final prodFormKey = GlobalKey<FormState>();
  bool _nextIsFetched = false; //used to fill the default values only once
  bool isLoading = false;
  bool failedToFetch = false;
  Map repData = {};
  late String lotCode;
  late int lotId;
  String? reportDate;
  int? reportId;
  Map? datePrevData;

  @override
  void initState() {
    getNextSend(context, widget.lotId);
    lotCode = widget.lotCode;
    lotId = widget.lotId;
    super.initState();
  }

  void _showLotsFilterActionSheet(BuildContext context) {
    final List<Lot> lots = Provider.of<InitProvider>(context, listen: false).lots;
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('changer de lot'),
        actions: lots.map((lot) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                lotId = lot.lotId;
                lotCode = lot.code;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Durations.long3,
                  backgroundColor: Colors.lightGreen,
                  content: Text('Lot: ${lot.code}'),
                ),
              );
            },
            child: Text(lot.code),
          );
        }).toList(),
      ),
    );
  }

  // start API CALLS ===========

  Future<void> getNextSend(context, lotId) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<DataEntryProvider>(context, listen: false).getNextSend(lotId).then((_) {
        setState(() {
          isLoading = false;
          failedToFetch = false;
          _nextIsFetched = true;
        });
      });
    } catch (e) {
      int? statusCode = int.tryParse(e.toString().replaceAll('Exception:', '').trim());
      if (statusCode == 401) {
        try {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.tryAutoLogin().then((_) {
            getNextSend(context, lotId);
          });
        } catch (e) {
          Navigator.of(context).pushNamed("auth-screen/");
        }
      }
      setState(() {
        isLoading = false;
        failedToFetch = true;
        _nextIsFetched = false;
      });
    }
  }

  Future<void> saveReport(context, data) async {
    try {
      await Provider.of<DataEntryProvider>(context, listen: false).sendProdReport(data).then((_) {
        getNextSend(context, lotId);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.green, duration: Duration(seconds: 3), content: Text('Rapport envoyé')),
        );
      });
    } catch (e) {
      int? statusCode = int.tryParse(e.toString().replaceAll('Exception:', '').trim());
      if (statusCode == 401) {
        try {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.tryAutoLogin().then((_) {
            saveReport(context, data);
          });
        } catch (e) {
          Navigator.of(context).pushNamed("auth-screen/");
        }
      }
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.deepOrange, duration: Duration(seconds: 3), content: Text("Echec d'envoi")),
      );
    }
  }

  Future<void> updateReport(context, data) async {
    try {
      getNextSend(context, lotId);
      await Provider.of<DataEntryProvider>(context, listen: false).updateProdReport(data).then((_) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.green, duration: Duration(seconds: 3), content: Text('Rapport modifié')),
        );
      });
    } catch (e) {
      int? statusCode = int.tryParse(e.toString().replaceAll('Exception:', '').trim());
      if (statusCode == 401) {
        try {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.tryAutoLogin().then((_) {
            updateReport(context, data);
          });
        } catch (e) {
          Navigator.of(context).pushNamed("auth-screen/");
        }
      }
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.deepOrange, duration: Duration(seconds: 3), content: Text("Echec d'envoi")),
      );
    }
  }

  // end API CALLS ===========

// viabilité fields
  final TextEditingController mortController = TextEditingController();
  final TextEditingController sujetElimController = TextEditingController();
  final TextEditingController poidsVifController = TextEditingController();
  final TextEditingController homogController = TextEditingController();
  bool validateViabilite = false;
  void setViabiliteValidator(bool val) {
    setState(() {
      validateViabilite = val;
    });
  }

// Production fields
  final TextEditingController prodNormController = TextEditingController();
  final TextEditingController prodDjController = TextEditingController();
  final TextEditingController prodBlancController = TextEditingController();
  final TextEditingController prodCasseController = TextEditingController();
  final TextEditingController prodFelesController = TextEditingController();
  final TextEditingController prodElimnController = TextEditingController();
  final TextEditingController liquidController = TextEditingController();
  final TextEditingController pmoController = TextEditingController();
  TextEditingController startPick = TextEditingController();
  TextEditingController endPick = TextEditingController();
  TextEditingController eggColor = TextEditingController();
  TextEditingController eggShell = TextEditingController();
  bool validateProduction = false;
  void setProductionValidator(bool val) {
    setState(() {
      validateProduction = val;
    });
  }

// consommation fields
  final TextEditingController consoAltController = TextEditingController();
  final TextEditingController consoEauController = TextEditingController();
  bool validateConsommation = false;
  void setConsommationValidator(bool val) {
    setState(() {
      validateConsommation = val;
    });
  }

// Livraison fields
  final TextEditingController altLivreeController = TextEditingController();
  final TextEditingController altPriceController = TextEditingController();
  TextEditingController consoFormuleController = TextEditingController();
  bool validateLivraison = false;
  void setLivraisonValidator(bool val) {
    setState(() {
      validateLivraison = val;
    });
  }

// ambiance fields
  TextEditingController humidityController = TextEditingController();
  TextEditingController lightOn = TextEditingController();
  TextEditingController lightOff = TextEditingController();
  TextEditingController lightDurr = TextEditingController();
  TextEditingController flashOn = TextEditingController();
  TextEditingController flashOff = TextEditingController();
  TextEditingController flashDurr = TextEditingController();
  TextEditingController intensite = TextEditingController();
  TextEditingController intensIsLux = TextEditingController();
  TextEditingController tempMinInt = TextEditingController();
  TextEditingController tempMaxInt = TextEditingController();
  TextEditingController tempMinExt = TextEditingController();
  TextEditingController tempMaxExt = TextEditingController();
  bool validateAmbiance = false;
  void setAmbianceValidator(bool val) {
    setState(() {
      validateAmbiance = val;
    });
  }

// Reform fields
  TextEditingController hensNormalRef = TextEditingController();
  TextEditingController hensNormalRefPrice = TextEditingController();
  TextEditingController hensTriageRef = TextEditingController();
  TextEditingController hensTriageRefPrice = TextEditingController();
  TextEditingController hensFreeRef = TextEditingController();
  bool normalHensIsKg = true; //0 || 1
  bool triageHensIsKg = true; //0 || 1
  bool validateReforme = false;
  void setReformeValidator(bool val) {
    setState(() {
      validateReforme = val;
    });
  }

  void setTriageHensIsKg(bool val) {
    setState(() {
      triageHensIsKg = val;
    });
  }

  void setNormalHensIsKg(bool val) {
    setState(() {
      normalHensIsKg = val;
    });
  }

// START POSTES GETTERS ==============
  Widget getViabilite() {
    return ViabilityPost(
      color: Colors.deepPurple,
      homogController: homogController,
      mortController: mortController,
      poidsVifController: poidsVifController,
      sujetElimController: sujetElimController,
      viabiliteValidator: setViabiliteValidator,
      validateViabilite: validateViabilite,
    );
  }

  Widget getProduction() {
    return ProdPost(
      color: const Color.fromARGB(255, 191, 109, 80),
      liquidController: liquidController,
      pmoController: pmoController,
      prodBlancController: prodBlancController,
      prodCasseController: prodCasseController,
      prodDjController: prodDjController,
      prodElimnController: prodElimnController,
      prodFelesController: prodFelesController,
      prodNormController: prodNormController,
      startPick: startPick,
      endPick: endPick,
      eggColor: eggColor,
      eggShell: eggShell,
      validateProduction: validateProduction,
      productionValidator: setProductionValidator,
    );
  }

  Widget getConsommation() {
    return ConsoPost(
      color: Colors.green,
      consoAltController: consoAltController,
      consoEauController: consoEauController,
      validateConsommation: validateConsommation,
      consoValidator: setConsommationValidator,
    );
  }

  Widget getLivraison() {
    return LivraisonPost(
      color: Colors.lime.shade700,
      altLivreeController: altLivreeController,
      altPriceController: altPriceController,
      consoFormuleController: consoFormuleController,
      validateLivraison: validateLivraison,
      livraisonValidator: setLivraisonValidator,
    );
  }

  Widget getAmbiance() {
    return AmbiancePost(
      color: const Color(0xFFFFD000),
      tempMinExt: tempMinExt,
      tempMaxExt: tempMaxExt,
      tempMaxInt: tempMaxInt,
      tempMinInt: tempMinInt,
      lightOn: lightOn,
      lightOff: lightOff,
      lightDurr: lightDurr,
      intensite: intensite,
      intensIsLux: intensIsLux,
      flashOn: flashOn,
      flashOff: flashOff,
      flashDurr: flashDurr,
      humidityController: humidityController,
      validateAmbiance: validateAmbiance,
      ambianceValidator: setAmbianceValidator,
    );
  }

  Widget getReform() {
    return ReformPost(
      color: Colors.blueGrey,
      hensNormalRef: hensNormalRef,
      hensNormalRefPrice: hensNormalRefPrice,
      hensTriageRef: hensTriageRef,
      hensTriageRefPrice: hensTriageRefPrice,
      hensFreeRef: hensFreeRef,
      normalHensIsKg: normalHensIsKg,
      triageHensIsKg: triageHensIsKg,
      reformValidator: setReformeValidator,
      setNormalUnit: setNormalHensIsKg,
      setTriageUnit: setTriageHensIsKg,
      validateReforme: validateReforme,
    );
  }
// END GET POSTS

  Map ambianceDefaults = {};
  Map constatDefaults = {};
  List<SelectOption> lotsOptions = [];
  List<SelectOption> sitesOptions = [];

  @override
  Widget build(BuildContext context) {
    Map next = Provider.of<DataEntryProvider>(context).nextData;

    void getDate(dateIndex) {
      setState(() {
        reportDate = next["dates"][dateIndex]["date"];
        reportId = next["dates"][dateIndex]["id"];
        datePrevData = next["dates"][dateIndex]["data"];
      });
    }

    if (_nextIsFetched) {
      setState(() {
        reportDate = next["dates"][0]["date"];
        datePrevData = next["dates"][0]["data"];
        consoFormuleController = TextEditingController(text: datePrevData!["formule"] ?? "");
        // lightOn = TextEditingController(text: next["last_rep"]["lumiere_alum"]);
        // lightOff = TextEditingController(text: next["last_rep"]["lumiere_extin"]);
        // lightDurr = TextEditingController(text: next["last_rep"]["lumiere_durr"]);

        // flashOn = TextEditingController(text: next["last_rep"]["flash_alum"]);
        // flashOff = TextEditingController(text: next["last_rep"]["flash_extin"]);
        // flashDurr = TextEditingController(text: next["last_rep"]["flash_durr"]);

        // intensite = TextEditingController(text: next["last_rep"]["intensite"].toString());
        // intensIsLux = TextEditingController(text: next["last_rep"]["intensIsLux"] ? "1" : "0");

        // eggColor = TextEditingController(text: next["last_rep"]["coloration"].toString());
        // eggShell = TextEditingController(text: next["last_rep"]["qty_coquille"].toString());
        _nextIsFetched = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Saisie de données", style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
        actions: [
          isLoading
              ? const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: CupertinoActivityIndicator(),
                )
              : const SizedBox(),
          IconButton(onPressed: () => _showLotsFilterActionSheet(context), icon: const Icon(Icons.scatter_plot))
        ],
      ),
      body: isLoading
          ? const CupertinoAlertDialog(
              content: CupertinoActivityIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Form(
                    key: prodFormKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4, left: 4, top: 18),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Code lot",
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    lotCode,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Date",
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  isLoading
                                      ? const Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: CupertinoActivityIndicator(),
                                        )
                                      : OutlinedButton(
                                          onPressed: () {
                                            MaterialPicker.getActionsOptionsPicker(context, 0, getDate, next);
                                          },
                                          child: Text(
                                            reportDate ?? "--/--/----",
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // VIABILITÉ =============
                        if (next["posts"]["viabilite"] && datePrevData!["show_validate_viability"])
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(backgroundColor: Colors.purple, fixedSize: const Size(double.infinity, 60)),
                            onPressed: () {
                              PoppupSerfaces.showPopupSurface(context, getViabilite, MediaQuery.of(context).size.height - 100, true);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      "Viabilité",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.spa_outlined,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                                Icon(
                                  validateViabilite ? Icons.check_circle : Icons.circle_outlined,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        const SizedBox(height: 10),
                        // PRODUCTION =============
                        if (next["posts"]["production"] && datePrevData!["show_validate_prod"])
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 191, 109, 80), fixedSize: const Size(double.infinity, 60)),
                            onPressed: () {
                              PoppupSerfaces.showPopupSurface(context, getProduction, MediaQuery.of(context).size.height - 100, true);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      "Production",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    Icon(
                                      Icons.egg_outlined,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                Icon(
                                  validateProduction ? Icons.check_circle : Icons.circle_outlined,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        const SizedBox(height: 10),
                        // Consommation =============
                        if (next["posts"]["consommation"] && datePrevData!["show_validate_conso"])
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(backgroundColor: Colors.green, fixedSize: const Size(double.infinity, 60)),
                            onPressed: () {
                              PoppupSerfaces.showPopupSurface(context, getConsommation, MediaQuery.of(context).size.height - 100, true);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Consommation ",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    Icon(
                                      MdiIcons.barley,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                                Icon(
                                  validateConsommation ? Icons.check_circle : Icons.circle_outlined,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        const SizedBox(height: 10),
                        // Livraison =============
                        if (next["posts"]["livraison"] && datePrevData!["show_validate_livraison"])
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(backgroundColor: Colors.lime.shade700, fixedSize: const Size(double.infinity, 60)),
                            onPressed: () {
                              PoppupSerfaces.showPopupSurface(context, getLivraison, MediaQuery.of(context).size.height - 100, true);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      "Livraison d'aliment ",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    Icon(
                                      Icons.local_shipping,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                                Icon(
                                  validateLivraison ? Icons.check_circle : Icons.circle_outlined,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        const SizedBox(height: 10),
                        // Ambiance =============
                        if (next["posts"]["ambiance"] && datePrevData!["show_validate_ambiance"])
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(backgroundColor: Colors.yellow.shade700, fixedSize: const Size(double.infinity, 60)),
                            onPressed: () {
                              PoppupSerfaces.showPopupSurface(context, getAmbiance, MediaQuery.of(context).size.height - 100, true);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      "Ambiance ",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    Icon(
                                      Icons.emoji_objects,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                                Icon(
                                  validateAmbiance ? Icons.check_circle : Icons.circle_outlined,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        const SizedBox(height: 10),
                        // Reforme =============
                        if (next["posts"]["reforme"] && datePrevData!["show_validate_reform"])
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(backgroundColor: Colors.blueGrey, fixedSize: const Size(double.infinity, 60)),
                            onPressed: () {
                              PoppupSerfaces.showPopupSurface(context, getReform, MediaQuery.of(context).size.height - 100, true);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      "Réforme ",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                                Icon(
                                  validateReforme ? Icons.check_circle : Icons.circle_outlined,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        const SizedBox(height: 20),
                        OutlinedButton(
                          onPressed: () {
                            if (prodFormKey.currentState!.validate()) {
                              repData["lot"] = lotId;
                              repData["id"] = reportId;
                              // Start viabilité
                              if (mortController.text.isNotEmpty) {
                                repData["mort"] = mortController.text;
                              }
                              if (poidsVifController.text.isNotEmpty) {
                                repData["poidVif"] = poidsVifController.text;
                              }
                              if (homogController.text.isNotEmpty) {
                                repData["homog"] = homogController.text;
                              }
                              if (sujetElimController.text.isNotEmpty) {
                                repData["sjt_elm"] = sujetElimController.text;
                              }
                              repData["validate_viability"] = validateViabilite;
                              // End viabilité
                              // --------------------
                              // start production
                              if (prodNormController.text.isNotEmpty) {
                                repData["prod_normal"] = prodNormController.text;
                              }
                              if (prodDjController.text.isNotEmpty) {
                                repData["prod_dj"] = prodDjController.text;
                              }
                              if (prodBlancController.text.isNotEmpty) {
                                repData["prod_blanc"] = prodBlancController.text;
                              }
                              if (prodCasseController.text.isNotEmpty) {
                                repData["prod_casse"] = prodCasseController.text;
                              }
                              if (prodFelesController.text.isNotEmpty) {
                                repData["prod_feles"] = prodFelesController.text;
                              }
                              if (prodElimnController.text.isNotEmpty) {
                                repData["prod_elimne"] = prodElimnController.text;
                              }
                              if (liquidController.text.isNotEmpty) {
                                repData["prod_liquide"] = liquidController.text;
                              }
                              if (pmoController.text.isNotEmpty) {
                                repData["pmo"] = pmoController.text;
                              }
                              if (startPick.text.isNotEmpty) {
                                repData["start_picking"] = startPick.text;
                              }
                              if (endPick.text.isNotEmpty) {
                                repData["end_picking"] = endPick.text;
                              }
                              if (eggColor.text.isNotEmpty) {
                                repData["coloration"] = eggColor.text;
                              }
                              if (eggShell.text.isNotEmpty) {
                                repData["qty_shell"] = eggShell.text;
                              }
                              repData["validate_prod"] = validateProduction;
                              // End production
                              // =======================
                              // start Consommation
                              if (consoAltController.text.isNotEmpty) {
                                repData["alimentDist"] = consoAltController.text;
                              }
                              if (consoEauController.text.isNotEmpty) {
                                repData["eauDist"] = consoEauController.text;
                              }
                              if (altPriceController.text.isNotEmpty) {
                                repData["alt_unit_price"] = altPriceController.text;
                              }
                              if (altLivreeController.text.isNotEmpty) {
                                repData["delivered_alt"] = altLivreeController.text;
                              }
                              if (consoFormuleController.text.isNotEmpty) {
                                repData["formule"] = consoFormuleController.text;
                              }
                              repData["validate_conso"] = validateConsommation;
                              // End consommation
                              // =======================
                              // Start Ambiance
                              if (lightOn.text.isNotEmpty) {
                                repData["lightOn"] = lightOn.text;
                              }
                              if (lightOff.text.isNotEmpty) {
                                repData["lightOff"] = lightOff.text;
                              }
                              if (flashOn.text.isNotEmpty) {
                                repData["flashOn"] = flashOn.text;
                              }
                              if (flashOff.text.isNotEmpty) {
                                repData["flashOff"] = flashOff.text;
                              }
                              if (lightDurr.text.isNotEmpty) {
                                repData["lightDuration"] = lightDurr.text;
                              }
                              if (flashDurr.text.isNotEmpty) {
                                repData["flashDuration"] = flashDurr.text;
                              }
                              if (intensite.text.isNotEmpty) {
                                repData["intensite"] = intensite.text;
                              }
                              if (intensIsLux.text.isNotEmpty) {
                                repData["intensIsLux"] = intensIsLux.text;
                              }
                              if (tempMinInt.text.isNotEmpty) {
                                repData["temperatureMin"] = tempMinInt.text;
                              }
                              if (tempMaxInt.text.isNotEmpty) {
                                repData["temperatureMax"] = tempMaxInt.text;
                              }
                              if (tempMinExt.text.isNotEmpty) {
                                repData["temperatureMinExt"] = tempMinExt.text;
                              }
                              if (tempMaxExt.text.isNotEmpty) {
                                repData["temperatureMaxExt"] = tempMaxExt.text;
                              }
                              if (humidityController.text.isNotEmpty) {
                                repData["humidity"] = humidityController.text;
                              }
                              repData["validate_ambiance"] = validateAmbiance;
                              // End ambiance
                              // ==============
                              // Start reforme
                              if (hensNormalRef.text.isNotEmpty) {
                                repData["hensReformedNormal"] = hensNormalRef.text;
                              }
                              if (hensFreeRef.text.isNotEmpty) {
                                repData["hensReformedFree"] = hensFreeRef.text;
                              }
                              if (hensTriageRef.text.isNotEmpty) {
                                repData["hensReformedTriage"] = hensTriageRef.text;
                              }
                              if (humidityController.text.isNotEmpty) {
                                repData["hensTriageRefPrice"] = hensNormalRefPrice.text;
                              }
                              if (humidityController.text.isNotEmpty) {
                                repData["triage_price"] = hensTriageRefPrice.text;
                              }
                              repData["reform_is_kg"] = normalHensIsKg ? 1 : 0;
                              repData["triage_is_kg"] = triageHensIsKg ? 1 : 0;
                              repData["validate_reform"] = validateReforme;
                              // end reforme
                              if (reportId == null) {
                                showDialog(
                                  // add new report
                                  context: context,
                                  builder: (ctx) => CupertinoAlertDialog(
                                    title: const Text("CONFIRMATION"),
                                    content: const Text("Voulez-vous envoyer des données"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("Envoyer"),
                                        onPressed: () {
                                          saveReport(context, repData);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                //Update existing report
                                showDialog(
                                  context: context,
                                  builder: (ctx) => CupertinoAlertDialog(
                                    title: const Text("CONFIRMATION"),
                                    content: Text("Voulez-vous modifier le rapport de $reportDate"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("Modifier"),
                                        onPressed: () {
                                          updateReport(context, repData);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 2,
                            backgroundColor: Theme.of(context).primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Soumettre",
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                              ),
                              Transform.rotate(
                                angle: (-90 * 3.141592653589793) / 180,
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    )),
              ),
            ),
    );
  }
}
