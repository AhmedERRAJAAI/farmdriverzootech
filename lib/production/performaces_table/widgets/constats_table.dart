import 'package:farmdriverzootech/production/performaces_table/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConstatsTable extends StatefulWidget {
  final int lotId;
  final int age;
  const ConstatsTable({super.key, required this.lotId, required this.age});

  @override
  State<ConstatsTable> createState() => _ConstatsTableState();
}

class _ConstatsTableState extends State<ConstatsTable> {
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
      await Provider.of<TableProvider>(context, listen: false).getRowSecondaryData(widget.lotId, widget.age).then((_) {
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

  final eggColors = [
    0,
    70,
    80,
    90,
    100,
    110
  ];

  @override
  Widget build(BuildContext context) {
    List constats = Provider.of<TableProvider>(context).weekConstats;
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.95 / 2,
        width: MediaQuery.of(context).size.width * 0.95,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                headingTextStyle: const TextStyle(fontStyle: FontStyle.normal, fontSize: 15, fontWeight: FontWeight.w600),
                headingRowHeight: 26,
                columnSpacing: 23,
                dataTextStyle: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 13,
                ),
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey.shade200),
                  verticalInside: BorderSide(color: Colors.grey.shade200),
                ),
                columns: const <DataColumn>[
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Date',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Coloration oeuf',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Qté coquille',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Double jaune',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Sale',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Triage',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Blancs',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Cassé',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Éliminés kg',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Σ déclassé	',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Observations',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
                rows: <DataRow>[
                  for (int i = 0; i < constats.length; i++)
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(constats[i]["date"]),
                            Text(constats[i]["day"])
                          ],
                        )),
                        DataCell(
                          Center(
                            child: FittedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 60, child: Image(image: AssetImage("assets/images/${eggColors[constats[i]["coloration"] ?? 0]}.png"))),
                                  Text(eggColors[constats[i]["coloration"] ?? 0].toString())
                                ],
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: FittedBox(
                              child: SizedBox(width: 60, child: Image(image: AssetImage("assets/images/${constats[i]["coquille"]}.png"))),
                            ),
                          ),
                        ),
                        DataCell(Text(constats[i]["dj"].toString())),
                        DataCell(Text(constats[i]["sale"].toString())),
                        DataCell(Text(constats[i]["triage"].toString())),
                        DataCell(Text(constats[i]["blancs"].toString())),
                        DataCell(Text(constats[i]["casse"].toString())),
                        DataCell(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(constats[i]["liquide_egg"].toString()),
                            Text(constats[i]["liquide_kg"].toString()),
                          ],
                        )),
                        DataCell(Text(constats[i]["sum_declassed"].toString())),
                        DataCell(Column(
                          children: constats[i]["observation"].map<Widget>((e) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e['text']),
                                Text(
                                  e['other'],
                                  style: Theme.of(context).textTheme.bodySmall,
                                )
                              ],
                            );
                          }).toList(),
                        )),
                        // DataCell(Text(constats[i]["observation"].toString())),
                      ],
                    ),
                ],
              )),
        ),
      ),
    );
  }
}
