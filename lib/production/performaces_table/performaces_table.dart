import 'package:farmdriverzootech/farmdriver_base/provider/auth_provider.dart';
import 'package:farmdriverzootech/production/performaces_table/model.dart';
import 'package:farmdriverzootech/production/performaces_table/provider.dart';
import 'package:farmdriverzootech/production/performaces_table/widgets/cells.dart';
import 'package:farmdriverzootech/production/performaces_table/widgets/days_table.dart';
import 'package:farmdriverzootech/production/performaces_table/widgets/toggle_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TableScreen extends StatefulWidget {
  final int lotId;
  final String lotCode;
  const TableScreen({super.key, required this.lotId, required this.lotCode});
  static const routeName = 'performances-table/';

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  bool _isInit = true;
  bool isLoading = false;
  bool failedToFetch = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      fetchTableData(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void fetchTableData(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<TableProvider>(context, listen: false).getTableReports(widget.lotId).then((_) {
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
            fetchTableData(context);
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

  late TableDataSource _tabelDataSource;

  @override
  Widget build(BuildContext context) {
    List<TblRow> tableData = Provider.of<TableProvider>(context).reports;
    List<TableTitle> titles = Provider.of<TableProvider>(context).titles;
    List<GridColumn> columnsItems = titles.map((e) {
      return GridColumn(
          columnWidthMode: e == titles[0] ? ColumnWidthMode.fitByColumnName : ColumnWidthMode.none,
          visible: e.isActive,
          columnName: e.name,
          label: Tooltip(
            message: e.fullName,
            triggerMode: TooltipTriggerMode.tap,
            showDuration: const Duration(seconds: 4),
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
        title: Text(
          widget.lotCode,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: ToggleTableColumns(
                      titles: titles,
                      toggleActive: Provider.of<TableProvider>(context).toggleActiveStatus,
                    ),
                  );
                },
              );
            },
            icon: const Icon(
              Icons.tune,
              size: 25,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? const CupertinoAlertDialog(
                content: CupertinoActivityIndicator(),
              )
            : SfDataGridTheme(
                data: SfDataGridThemeData(headerColor: Colors.grey.shade600),
                child: SfDataGrid(
                  rowHeight: 40,
                  headerRowHeight: 40,
                  frozenColumnsCount: 1,
                  defaultColumnWidth: 80,
                  source: _tabelDataSource,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  selectionMode: SelectionMode.singleDeselect,
                  onCellLongPress: (details) {
                    HapticFeedback.mediumImpact();
                    final rowData = _tabelDataSource[details.rowColumnIndex.rowIndex - 2];
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 560,
                          child: TableDays(
                            lotId: widget.lotId,
                            age: rowData.getCells()[0].value,
                            lotCode: widget.lotCode,
                          ),
                        );
                      },
                    );
                  },
                  columns: columnsItems,
                  stackedHeaderRows: <StackedHeaderRow>[
                    StackedHeaderRow(cells: [
                      StackedHeaderCell(
                        columnNames: [
                          'age',
                          'semCvl',
                          'date',
                        ],
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.blueGrey,
                            border: Border(
                              right: BorderSide(width: 1, color: Colors.black),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Calendrier',
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
                          'altLiv',
                          'refAlt',
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

  // refreshDataGrid() {
  //   notifyListeners();
  // }
}
