import 'package:farmdriverzootech/production/dashboard/provider/init_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model.dart';
import '../provider.dart';
import 'operation_select.dart';

//
//
// BOTTOM SHEET
//
//
// ignore: must_be_immutable
class SelectMultiLots extends StatefulWidget {
  List<SelectOption> idsList;
  final Function getCharts;
  final Function getter;
  final int? currentValue;
  SelectMultiLots({
    super.key,
    required this.idsList,
    required this.getCharts,
    required this.getter,
    required this.currentValue,
  });

  @override
  State<SelectMultiLots> createState() => _SelectMultiLotsState();
}

class _SelectMultiLotsState extends State<SelectMultiLots> {
  bool isLoading = false;
  bool failedToFetch = false;
  List<SelectOption> sitesOptions = [];
  List<SelectOption> lotOptions = [];
  List<SelectOption> selectedLots = [];
  int? site;
  List<int> lots = [];
  void getSite(int value) {
    setState(() {
      site = value;
    });
    fetchLotBySiteId();
  }

  void getChart(int value) {
    setState(() {
      Provider.of<ComparaisionProvider>(context, listen: false).comparedCharts.clear();
      widget.getter(value);
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {});
    selectedLots.clear();
    sitesOptions.clear();
    lotOptions.clear();
    super.initState();
  }

  void fetchLotBySiteId() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<InitProvider>(context, listen: false).getLotList(site, 0).then((_) {
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

  List<SelectOption> chartsNames = [
    SelectOption(value: "Production", id: 0),
    SelectOption(value: "Mortalité", id: 1),
    SelectOption(value: "Consommations", id: 2),
    SelectOption(value: "Poids corporel & homog", id: 3),
    SelectOption(value: "Masse d'oeufs", id: 4),
  ];

  @override
  Widget build(BuildContext context) {
    final List<SliderItem> sites = Provider.of<InitProvider>(context, listen: false).slidesData;
    final List<Lot> lots = Provider.of<InitProvider>(context).lots;
    sitesOptions = sites.map((e) => SelectOption(id: e.siteId, value: e.siteName)).toList();
    lotOptions = lots.map((e) => SelectOption(id: e.lotId, value: "${e.batiment}(${e.code})")).toList();
    return SingleChildScrollView(
      child: Column(
        children: [
          OperationSelect(
            inputsOptions: sitesOptions,
            borderColor: Theme.of(context).primaryColor,
            name: "Sites",
            initValue: site,
            getter: getSite,
          ),
          OperationSelect(
            inputsOptions: chartsNames,
            borderColor: Theme.of(context).primaryColor,
            name: "Courbes",
            initValue: widget.currentValue ?? 0,
            getter: getChart,
          ),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          textAlign: TextAlign.center,
                          'Cocher les lots à comparer',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        content: SizedBox(
                          height: 500,
                          width: MediaQuery.of(context).size.width,
                          child: SelectLotDialog(
                            lots: lotOptions,
                            selectedLots: widget.idsList,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('Annuler'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('Ok'),
                            onPressed: () {
                              setState(() {});
                              widget.getCharts(context);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text("Selectionner les lots")),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: selectedLots.map((e) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    e.value,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

//
//
// SELECT LOTS DIALOG
//
//

class SelectLotDialog extends StatefulWidget {
  final List<SelectOption> lots;
  final List<SelectOption> selectedLots;
  const SelectLotDialog({super.key, required this.lots, required this.selectedLots});

  @override
  State<SelectLotDialog> createState() => _SelectLotDialogState();
}

class _SelectLotDialogState extends State<SelectLotDialog> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: GridView.count(
                primary: false,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                children: widget.lots.map((lot) {
                  return Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            widget.selectedLots.add(lot);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.lightGreen,
                              )),
                          padding: const EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              lot.value,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                      ),
                      if (widget.selectedLots.where((element) => element.id == lot.id).isNotEmpty)
                        InkWell(
                          onTap: () {
                            setState(() {
                              widget.selectedLots.remove(lot);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.lightGreen.shade100,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.lightGreen,
                                )),
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                lot.value,
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }).toList()),
          ),
          const Divider(),
          Text(
            "Lots séléctionnés",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(
            height: 200,
            child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                children: widget.selectedLots.map((lot) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.amber,
                            )),
                        padding: const EdgeInsets.all(8),
                        child: Center(
                            child: Text(
                          lot.value,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.visible,
                        )),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            widget.selectedLots.remove(lot);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.amber.withOpacity(0.2),
                              border: Border.all(
                                color: Colors.amber,
                              )),
                          padding: const EdgeInsets.all(8),
                          child: Center(
                              child: Icon(
                            Icons.check_circle,
                            color: Colors.amber.withOpacity(0.8),
                          )),
                        ),
                      ),
                    ],
                  );
                }).toList()),
          ),
        ],
      ),
    );
  }
}
