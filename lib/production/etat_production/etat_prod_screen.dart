import 'package:farmdriverzootech/farmdriver_base/provider/auth_provider.dart';
import 'package:farmdriverzootech/farmdriver_base/widgets/info_dialog.dart';
import 'package:farmdriverzootech/farmdriver_base/widgets/pickers.dart';
import 'package:farmdriverzootech/farmdriver_base/widgets/poppup_serfaces.dart';
import 'package:farmdriverzootech/production/etat_production/provider.dart';
import 'package:farmdriverzootech/production/synthese/widgets/sites_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ProdStatusScreen extends StatefulWidget {
  const ProdStatusScreen({super.key});
  static const routeName = "etat-prod/";

  @override
  _ProdStatusScreenState createState() => _ProdStatusScreenState();
}

class _ProdStatusScreenState extends State<ProdStatusScreen> {
  List<ProdStatusData> reports = <ProdStatusData>[];
  late ProdStatusDataSource employeeDataSource;
  bool _isInit = true;
  bool isLoading = false;
  bool downloading = false;
  bool failedToFetch = false;
  DateTime etatDate = DateTime.now().subtract(const Duration(days: 1));
  // get sites
  List<int> sites = [];
  void getSites(ids) {
    sites = ids;
    fetchProdStatus(context);
  }

  Widget getSitesPicker() {
    return SitesPicker(
      getSites: getSites,
    );
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      fetchProdStatus(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void fetchProdStatus(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<ProdStatusProvider>(context, listen: false).getProdStatus("${etatDate.year}-${etatDate.month}-${etatDate.day}", sites).then((_) {
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
            fetchProdStatus(context);
          });
        } catch (e) {
          Navigator.of(context).pushNamed("auth-screen/");
        }
      }
      setState(() {
        isLoading = false;
        failedToFetch = true;
        AlertsDialog.doUreallyWant(
          context,
          "Echec",
          "échec de récupération des données",
          "Réessayer",
          true,
          fetchProdStatus,
        );
      });
    }
  }

  void downloadProdStatus(context) async {
    setState(() {
      downloading = true;
    });
    try {
      await Provider.of<ProdStatusProvider>(context, listen: false).shareProdStatus("${etatDate.year}-${etatDate.month}-${etatDate.day}", sites).then((_) {
        setState(() {
          downloading = false;
          failedToFetch = false;
        });
      });
    } catch (e) {
      int? statusCode = int.tryParse(e.toString().replaceAll('Exception:', '').trim());
      if (statusCode == 401) {
        try {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.tryAutoLogin().then((_) {
            downloadProdStatus(context);
          });
        } catch (e) {
          Navigator.of(context).pushNamed("auth-screen/");
        }
      }
      setState(() {
        downloading = false;
        failedToFetch = true;
        AlertsDialog.doUreallyWant(
          context,
          "Echec",
          "échec de récupération des données",
          "Réessayer",
          true,
          fetchProdStatus,
        );
      });
    }
  }

  void getDate(DateTime? date) {
    if (date != null) {
      setState(() {
        etatDate = date;
      });
      fetchProdStatus(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var providerInst = Provider.of<ProdStatusProvider>(context);
    List<ProdStatusTableTitles> titles = providerInst.titles;
    employeeDataSource = ProdStatusDataSource(reportsData: providerInst.reports);
    List<GridColumn> columnsItems = titles.map((e) {
      return GridColumn(
        width: 80,
        visible: true,
        columnName: e.name,
        label: Container(
          color: Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          alignment: Alignment.center,
          child: Text(
            e.title,
            style: const TextStyle(color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("${etatDate.day}/${etatDate.month}/${etatDate.year}", style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              MaterialPicker.muiDatePicker(context, getDate, etatDate);
            },
            icon: Icon(
              Icons.calendar_month,
              size: 18,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          downloading
              ? Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CupertinoActivityIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    downloadProdStatus(context);
                  },
                  icon: Icon(
                    Icons.ios_share,
                    size: 18,
                    color: Theme.of(context).primaryColorDark,
                  )),
          IconButton(
            onPressed: () {
              PoppupSerfaces.showPopupSurface(context, getSitesPicker, MediaQuery.of(context).size.height / 3, false);
            },
            icon: Icon(
              Icons.location_on_outlined,
              size: 18,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ],
      ),
      body: SfDataGridTheme(
        data: const SfDataGridThemeData(),
        child: isLoading
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : SfDataGrid(
                source: employeeDataSource,
                headerRowHeight: 40,
                frozenColumnsCount: 1,
                defaultColumnWidth: 80,
                rowHeight: 34,
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                columns: columnsItems,
                stackedHeaderRows: <StackedHeaderRow>[
                  StackedHeaderRow(
                    cells: [
                      StackedHeaderCell(
                        columnNames: [
                          'site',
                          'bat',
                          'age',
                        ],
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.indigo,
                            border: Border(
                              right: BorderSide(width: 1, color: Colors.white),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '---',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      StackedHeaderCell(
                        columnNames: [
                          'light',
                          'flash',
                          'intens',
                          'temp_min',
                          'temp_max',
                        ],
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.indigo,
                            border: Border(
                              right: BorderSide(width: 1, color: Colors.white),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Ambiance',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      StackedHeaderCell(
                        columnNames: [
                          'effectif',
                          'pv',
                          'homog',
                          'mort',
                        ],
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.indigo,
                            border: Border(
                              right: BorderSide(width: 1, color: Colors.white),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Viabilité',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      StackedHeaderCell(
                        columnNames: [
                          'eau',
                          'alt',
                          'aps',
                          'ratio',
                        ],
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.indigo,
                            border: Border(
                              right: BorderSide(width: 1, color: Colors.white),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Consommations',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      StackedHeaderCell(
                        columnNames: [
                          'ponte',
                          'ponte_cent',
                          'pmo',
                          'ratio',
                        ],
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.indigo,
                            border: Border(
                              right: BorderSide(width: 1, color: Colors.white),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Production',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      StackedHeaderCell(
                        columnNames: [
                          'mass_jour',
                          'mass_cuml',
                        ],
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.indigo,
                            border: Border(
                              right: BorderSide(width: 1, color: Colors.white),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Masse d'oeuf",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      StackedHeaderCell(
                        columnNames: [
                          'apo_jour',
                          'apo_cuml',
                        ],
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.indigo,
                            border: Border(
                              right: BorderSide(width: 1, color: Colors.white),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Aliment/oeuf",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      StackedHeaderCell(
                        columnNames: [
                          'ic_jour',
                          'ic_cuml',
                        ],
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.indigo,
                            border: Border(
                              right: BorderSide(width: 1, color: Colors.white),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Indice de convers",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class ProdStatusDataSource extends DataGridSource {
  ProdStatusDataSource({required List<ProdStatusData> reportsData}) {
    _reportsData = reportsData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell(columnName: 'site', value: e.site),
              DataGridCell(columnName: 'bat', value: e.batName),
              DataGridCell(columnName: 'age', value: e.age != null ? "${e.age}/${e.dayOnAge}" : ""),
              DataGridCell(columnName: 'light', value: e.light),
              DataGridCell(columnName: 'flash', value: e.flash),
              DataGridCell(columnName: 'intens', value: e.intens),
              DataGridCell(columnName: 'temp_min', value: e.tempMin),
              DataGridCell(columnName: 'temp_max', value: e.tempMax),
              DataGridCell(columnName: 'effectif', value: e.effectif),
              DataGridCell(columnName: 'pv', value: e.pv),
              DataGridCell(columnName: 'homog', value: e.homog),
              DataGridCell(columnName: 'mort', value: e.mort),
              DataGridCell(columnName: 'eau', value: e.eau),
              DataGridCell(columnName: 'alt', value: e.aliment),
              DataGridCell(columnName: 'aps', value: e.aps),
              DataGridCell(columnName: 'ratio', value: e.ratio),
              DataGridCell(columnName: 'ponte', value: e.ponte),
              DataGridCell(columnName: 'ponte_cent', value: e.centPonte),
              DataGridCell(columnName: 'pmo', value: e.pmo),
              DataGridCell(columnName: 'mass_jour', value: e.massSem),
              DataGridCell(columnName: 'mass_cuml', value: e.massCuml),
              DataGridCell(columnName: 'apo_jour', value: e.apoSem),
              DataGridCell(columnName: 'apo_cuml', value: e.apoCuml),
              DataGridCell(columnName: 'ic_jour', value: e.icSem),
              DataGridCell(columnName: 'ic_cuml', value: e.icCuml),
            ]))
        .toList();
  }

  List<DataGridRow> _reportsData = [];

  @override
  List<DataGridRow> get rows => _reportsData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      bool globTot = row.getCells()[0].value == null;
      bool siteTot = row.getCells()[1].value == null;
      return Container(
          color: globTot
              ? Colors.yellow.shade200
              : siteTot
                  ? Colors.blue.shade50
                  : null,
          alignment: Alignment.center,
          child: e.value is Map
              ? CellContent(
                  value: e.value,
                  isGlobTot: globTot,
                  isSiteTot: siteTot,
                )
              : Text(
                  e.value != null
                      ? e.value.toString()
                      : globTot
                          ? e == row.getCells()[0]
                              ? "Σ SITES"
                              : ""
                          : "",
                  style: TextStyle(fontWeight: siteTot ? FontWeight.bold : null, color: siteTot || globTot ? Colors.black : null),
                ));
    }).toList());
  }
}

class CellContent extends StatelessWidget {
  final value;
  final bool isGlobTot;
  final bool isSiteTot;

  const CellContent({super.key, required this.value, required this.isGlobTot, required this.isSiteTot});

  @override
  Widget build(BuildContext context) {
    final Map<String, Color> ecartColors = {
      "red": Colors.deepOrange.shade600,
      "green": Colors.green.shade700,
      "orange": Colors.orange,
      "blue": Colors.blue.shade700
    };
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Text(
                "${value["reel"]}",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: isSiteTot ? FontWeight.w500 : null, color: isSiteTot || isGlobTot ? Colors.black : null),
              ),
            ),
          ),
          if (value["ecart"] != null)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 1),
              color: ecartColors[value["color"] ?? "blue"]!.withOpacity(0.2),
              child: Center(
                child: Text(
                  "${value["ecart"]}",
                  style: TextStyle(color: ecartColors[value["color"] ?? "blue"], fontWeight: FontWeight.bold, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          if (value["variation"] != null)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Center(
                child: Text(
                  "${value["variation"]}",
                  style: TextStyle(color: ecartColors[value["color"] ?? "blue"], fontWeight: FontWeight.bold, fontSize: 12, decoration: TextDecoration.underline),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
