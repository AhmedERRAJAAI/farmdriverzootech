import 'package:farmdriverzootech/farmdriver_base/provider/auth_provider.dart';
import 'package:farmdriverzootech/farmdriver_base/widgets/info_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'const.dart';
import 'provider.dart';
import 'widgets/details_table_row.dart';

class DifferencesScreen extends StatefulWidget {
  final int modId;
  final String lot;
  final String rapportDate;
  final String modDate;
  final String user;
  final bool isModif;
  const DifferencesScreen({super.key, required this.modId, required this.lot, required this.rapportDate, required this.modDate, required this.user, required this.isModif});

  @override
  State<DifferencesScreen> createState() => _DifferencesScreenState();
}

class _DifferencesScreenState extends State<DifferencesScreen> {
  bool isLoading = false;
  bool failedToFetch = false;
  Map labelsKeys = Const.reportAttrKeys;
  @override
  void initState() {
    fetchEditDetails(context);
    super.initState();
  }

  void fetchEditDetails(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<EditNotificationProvider>(context, listen: false).getEditDetails(widget.modId).then((_) {
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
            fetchEditDetails(context);
          });
        } catch (e) {
          Navigator.of(context).pushNamed("auth-screen/");
        }
      } else {
        AlertsDialog.doUreallyWant(
          context,
          "Echec",
          "échec de récupération des données",
          "Réessayer",
          true,
          fetchEditDetails,
        );
      }
      setState(() {
        isLoading = false;
        failedToFetch = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = Provider.of<EditNotificationProvider>(context, listen: true).modificationDetails;
    List keysList = isLoading ? [] : data["original_version"].keys.toList();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Histrique des modifications",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: isLoading
            ? const CupertinoAlertDialog(
                content: CupertinoActivityIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      DetailsTableRow(label: widget.isModif ? "Modifié par" : "Supprimé par", value: widget.user, color: Colors.grey.shade100),
                      const Divider(height: 0),
                      DetailsTableRow(label: "Date rapport", value: widget.rapportDate),
                      const Divider(height: 0),
                      DetailsTableRow(label: "Date modification", value: widget.modDate, color: Colors.grey.shade100),
                      const Divider(height: 0),
                      DetailsTableRow(label: "Lot", value: widget.lot),
                      const Divider(height: 0),
                      DetailsTableRow(label: "Age", value: data["info"]["age"].toString(), color: Colors.grey.shade100),
                      const Divider(height: 0),
                      const SizedBox(height: 20),
                      DataTable(
                        headingRowColor: WidgetStateProperty.all<Color>(Colors.blue.shade100), // Replace Colors.blue with your desired color

                        headingRowHeight: 30,
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Paramètre',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Center(
                                child: Text(
                                  'Avant',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                '',
                                style: TextStyle(),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Après',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                        rows: keysList.map((key) {
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(Text(
                                labelsKeys[key],
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
                              )),
                              DataCell(Center(
                                  child: Text(
                                data["original_version"][key],
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
                              ))),
                              const DataCell(Center(
                                  child: Icon(
                                Icons.arrow_forward,
                                color: Colors.grey,
                                size: 14,
                              ))),
                              DataCell(Text(
                                data["new_version"][key],
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
                              )),
                            ],
                          );
                        }).toList(), // Make sure to remove 'const' and add a semicolon here
                      ),
                    ],
                  ),
                ),
              ));
  }
}
