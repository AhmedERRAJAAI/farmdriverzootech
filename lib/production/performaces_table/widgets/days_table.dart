import 'dart:async';

import 'package:farmdriverzootech/farmdriver_base/widgets/poppup_serfaces.dart';
import 'package:farmdriverzootech/production/performaces_table/model.dart';
import 'package:farmdriverzootech/production/performaces_table/provider.dart';
import 'package:farmdriverzootech/production/performaces_table/widgets/cells.dart';
import 'package:farmdriverzootech/production/performaces_table/widgets/constats_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TableDays extends StatefulWidget {
  final int lotId;
  final String lotCode;
  final int age;
  const TableDays({super.key, required this.lotId, required this.age, required this.lotCode});

  @override
  State<TableDays> createState() => _TableDaysState();
}

class _TableDaysState extends State<TableDays> {
  bool _isInit = true;
  bool isLoading = false;
  bool deleting = false;
  bool downloading = false;
  bool failedToFetch = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      fetchWeekTableData();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void fetchWeekTableData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<TableProvider>(context, listen: false).getOneWeekData(widget.lotId, widget.age).then((_) {
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

  void deleteTableRow(repId) async {
    setState(() {
      deleting = true;
    });
    try {
      await Provider.of<TableProvider>(context, listen: false).deleteReport(repId).then((_) {
        setState(() {
          deleting = false;
          failedToFetch = false;
        });
        Navigator.of(context).pop();
        // widget.refresher();
      });
    } catch (e) {
      setState(() {
        deleting = false;
        failedToFetch = true;
      });
    }
  }

  void shareWeekPdf(lotId, age) async {
    setState(() {
      downloading = true;
    });
    try {
      await Provider.of<TableProvider>(context, listen: false).shareWeekReport(lotId, age).then((_) {
        setState(() {
          downloading = false;
          failedToFetch = false;
        });
      });
    } catch (e) {
      setState(() {
        downloading = false;
        failedToFetch = true;
      });
    }
  }

  Map<String, dynamic> reportIdGetter(List<TblRow> reports, sem, date) {
    TblRow report = reports.firstWhere((row) => row.semCivil == sem && row.date == date);
    return {
      "deletable": report.deletable,
      "id": report.id,
      "date": report.date,
    };
  }

  late TableDataSource _tabelDataSource;

  Widget getConstatsTable() {
    return ConstatsTable(
      lotId: widget.lotId,
      age: widget.age,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<TblRow> tableData = Provider.of<TableProvider>(context).oneWeekReps;
    List<TableTitle> titles = Provider.of<TableProvider>(context).titles;
    List<GridColumn> columnsItems = titles.map((e) {
      return GridColumn(
          visible: e.isActive,
          columnName: e.name,
          label: Tooltip(
            message: e.title,
            triggerMode: TooltipTriggerMode.tap,
            showDuration: const Duration(seconds: 3),
            child: Container(
                color: e.color,
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                alignment: Alignment.center,
                child: Text(
                  e.title,
                  style: const TextStyle(color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                )),
          ));
    }).toList();
    _tabelDataSource = TableDataSource(
      tableData: tableData,
    );
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: Text(
          "${widget.age} sem - ${widget.lotCode}",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        actions: [
          IconButton(
              onPressed: () {
                PoppupSerfaces.showPopupSurface(context, getConstatsTable, MediaQuery.of(context).size.height / 2, false);
              },
              icon: const Icon(Icons.visibility)),
          downloading
              ? const Padding(
                  padding: EdgeInsets.all(3),
                  child: CupertinoActivityIndicator(),
                )
              : InkWell(
                  onTap: () {
                    shareWeekPdf(widget.lotId, widget.age);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Icon(Icons.ios_share),
                  ),
                ),
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: isLoading
            ? const CupertinoAlertDialog(
                content: CupertinoActivityIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: SfDataGridTheme(
                      data: SfDataGridThemeData(headerColor: Colors.grey.shade600),
                      child: SfDataGrid(
                        rowHeight: 40,
                        headerRowHeight: 40,
                        frozenColumnsCount: 1,
                        defaultColumnWidth: 80,
                        source: _tabelDataSource,
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        selectionMode: SelectionMode.single,
                        columns: columnsItems,
                        onCellLongPress: (details) {
                          HapticFeedback.mediumImpact();
                          final rowData = _tabelDataSource[details.rowColumnIndex.rowIndex - 2];
                          Map rep = reportIdGetter(tableData, rowData.getCells()[1].value, rowData.getCells()[2].value);

                          showDialog(
                            context: context,
                            builder: (ctx) => CupertinoAlertDialog(
                              title: const Text("CHOIX D'ACTION"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'Supprimer',
                                    style: TextStyle(color: rep["deletable"] ? Colors.deepOrange : Colors.grey),
                                  ),
                                  onPressed: () {
                                    if (rep["deletable"]) {
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.deepOrange,
                                          duration: const Duration(seconds: 3),
                                          content: const Text("Supprimer ce rapport ?"),
                                          action: SnackBarAction(
                                              label: "Confirmer",
                                              textColor: Colors.deepOrange,
                                              backgroundColor: Colors.white,
                                              onPressed: () {
                                                deleteTableRow(rep["id"]);
                                              }),
                                        ),
                                      );
                                    } else {
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.amber,
                                          duration: const Duration(seconds: 3),
                                          content: const Text("Rapport ne peut pas être supprimé"),
                                          action: SnackBarAction(
                                              label: "OK",
                                              textColor: Colors.amber,
                                              backgroundColor: Colors.white,
                                              onPressed: () {
                                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                              }),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                // TextButton(
                                //   child: const Text(
                                //     'Modifier',
                                //     style: TextStyle(color: Colors.blue),
                                //   ),
                                //   onPressed: () {
                                //     Navigator.push(
                                //       context,
                                //       PageTransition(
                                //         type: PageTransitionType.rightToLeft,
                                //         curve: Curves.bounceIn,
                                //         child: ShowReportScreen(repId: rep["id"], lotCode: widget.lotCode, date: rep["date"]),
                                //       ),
                                //     );
                                //   },
                                // ),
                                TextButton(
                                  child: const Text(
                                    'Anuller',
                                    style: TextStyle(color: Colors.lightGreen),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        stackedHeaderRows: <StackedHeaderRow>[
                          StackedHeaderRow(cells: [
                            StackedHeaderCell(
                              columnNames: [
                                'age',
                                'semCvl',
                                'date',
                              ],
                              child: Container(
                                decoration: const BoxDecoration(color: Colors.blueGrey, border: Border(right: BorderSide(width: 1, color: Colors.black))),
                                child: const Center(
                                  child: Text(
                                    'Calendrier  ',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            StackedHeaderCell(
                              columnNames: [
                                'lum',
                                'flsh',
                                'intens',
                                'temp',
                                'humidity',
                              ],
                              child: Container(
                                color: Colors.blue.shade400,
                                child: const Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Ambiance',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      Icon(
                                        Icons.light_mode,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            StackedHeaderCell(
                              columnNames: [
                                'efp',
                                'homog',
                                'pv',
                                'vblty',
                                'mortSem',
                                'mortCuml',
                              ],
                              child: Container(
                                color: Colors.cyan,
                                child: const Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Viabilité  ',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      Icon(
                                        Icons.spa,
                                        color: Colors.white,
                                        size: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            StackedHeaderCell(
                              columnNames: [
                                'eau',
                                'alt',
                                'eps',
                                'aps',
                                'apsCuml',
                                'rtio',
                                'refAlt',
                                'altLiv',
                                'altPrice',
                                'apsAltLiv',
                              ],
                              child: Container(
                                color: Colors.green,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Consommation  ',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      Icon(
                                        MdiIcons.barley,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            StackedHeaderCell(
                              columnNames: [
                                'prod',
                                'ponte',
                                'pmo',
                                'noppp',
                                'noppp_cml',
                                'noppd',
                                'noppd_cml',
                                'declass',
                              ],
                              child: Container(
                                color: Colors.brown.shade300,
                                child: const Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Production  ',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      Icon(
                                        Icons.egg,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            StackedHeaderCell(
                              columnNames: [
                                'massSemPP',
                                'massCumlPP',
                                'massSemPD',
                                'massCumlPD',
                              ],
                              child: Container(
                                color: Colors.teal,
                                child: const Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Masse d'oeuf",
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      Icon(
                                        Icons.scale,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            StackedHeaderCell(
                              columnNames: [
                                'apo',
                                'apoCuml',
                                'ic',
                              ],
                              child: Container(
                                color: Colors.indigo,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Indices de conversion  ',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      Icon(
                                        MdiIcons.syncIcon,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ])
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class TableDataSource extends DataGridSource {
  List<TblRow> tableData = [];
  TableDataSource({required this.tableData}) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = tableData
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell(columnName: 'age', value: dataGridRow.age),
              DataGridCell(columnName: 'semCvl', value: dataGridRow.semCivil),
              DataGridCell(columnName: 'date', value: dataGridRow.date),
              DataGridCell(columnName: 'lum', value: dataGridRow.light),
              DataGridCell(columnName: 'flsh', value: dataGridRow.flash),
              DataGridCell(columnName: 'intens', value: "${dataGridRow.intensite} ${dataGridRow.intensUnit}"),
              DataGridCell(columnName: 'temp', value: dataGridRow.temp),
              DataGridCell(columnName: 'humidity', value: dataGridRow.humidity),
              DataGridCell(columnName: 'efp', value: dataGridRow.effectif),
              DataGridCell(columnName: 'homog', value: dataGridRow.homog),
              DataGridCell(columnName: 'pv', value: dataGridRow.pv),
              DataGridCell(columnName: 'vblty', value: dataGridRow.viability),
              DataGridCell(columnName: 'mortSem', value: dataGridRow.mortSem),
              DataGridCell(columnName: 'mortCuml', value: dataGridRow.mortCuml),
              DataGridCell(columnName: 'altLiv', value: dataGridRow.deliveredAlt),
              DataGridCell(columnName: 'refAlt', value: dataGridRow.refAlt ?? "-"),
              DataGridCell(columnName: 'apsAltLiv', value: dataGridRow.deliveredAltPerHen),
              DataGridCell(columnName: 'altPrice', value: dataGridRow.deliveredAltPrice),
              DataGridCell(columnName: 'eau', value: dataGridRow.eauDist),
              DataGridCell(columnName: 'alt', value: dataGridRow.altDist),
              DataGridCell(columnName: 'eps', value: dataGridRow.eps),
              DataGridCell(columnName: 'aps', value: dataGridRow.aps),
              DataGridCell(columnName: 'apsCuml', value: dataGridRow.altCuml),
              DataGridCell(columnName: 'rtio', value: dataGridRow.ratio),
              DataGridCell(columnName: 'prod', value: dataGridRow.ponteNbr),
              DataGridCell(columnName: 'ponte', value: dataGridRow.ponteCent),
              DataGridCell(columnName: 'pmo', value: dataGridRow.pmo),
              DataGridCell(columnName: 'noppp_cml', value: dataGridRow.noppp),
              DataGridCell(columnName: 'noppp', value: dataGridRow.nopppSem),
              DataGridCell(columnName: 'noppd_cml', value: dataGridRow.noppd),
              DataGridCell(columnName: 'noppd', value: dataGridRow.noppdSem),
              DataGridCell(columnName: 'declass', value: dataGridRow.declasse),
              DataGridCell(columnName: 'massSemPP', value: dataGridRow.massOeufSemPP),
              DataGridCell(columnName: 'massCumlPP', value: dataGridRow.massOeufPP),
              DataGridCell(columnName: 'massSemPD', value: dataGridRow.massOeufSemPD),
              DataGridCell(columnName: 'massCumlPD', value: dataGridRow.massOeufPD),
              DataGridCell(columnName: 'apo', value: dataGridRow.altOeuf),
              DataGridCell(columnName: 'apoCuml', value: dataGridRow.altOeufCuml),
              DataGridCell(columnName: 'ic', value: dataGridRow.icCuml),
            ]))
        .toList();
  }

  // List<TblRow> tableData = [];
  List<DataGridRow> dataGridRows = [];
  List<GridColumn> columnsItems = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      switch (dataGridCell.value.runtimeType) {
        case Ordinary:
          return ValueEcartCell(
            data: dataGridCell.value,
          );
        case Light:
          return LightCell(data: dataGridCell.value);

        case Temperature:
          return TempCell(temp: dataGridCell.value);

        case ReelColor:
          return ReelColorCell(data: dataGridCell.value);

        case WithVariation:
          return OneColorCell(data: dataGridCell.value);

        case TwoValues:
          return TwoValueCell(data: dataGridCell.value);

        default:
          return OneValueCell(value: dataGridCell.value);
      }
    }).toList());
  }
}
