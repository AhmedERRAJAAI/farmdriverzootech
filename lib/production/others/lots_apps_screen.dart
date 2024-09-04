import 'package:farmdriverzootech/production/analyses/analyses_screen.dart';
import 'package:farmdriverzootech/production/bilan_partiel/bilan_partiel_screen.dart';
import 'package:farmdriverzootech/production/charts/charts_screen.dart';
import 'package:farmdriverzootech/production/data_entry/data_entry_screen.dart';
import 'package:farmdriverzootech/production/performaces_table/performaces_table.dart';
import 'package:farmdriverzootech/production/supplimentation/supplimentation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../dashboard/provider/init_provider.dart';

class LotsAppsScreen extends StatefulWidget {
  final int lotId;
  final String lotCode;
  const LotsAppsScreen({super.key, required this.lotId, required this.lotCode});

  @override
  State<LotsAppsScreen> createState() => _LotsAppsScreenState();
}

class _LotsAppsScreenState extends State<LotsAppsScreen> {
  late String lotCode;
  late int lotId;

  @override
  void initState() {
    lotCode = widget.lotCode;
    lotId = widget.lotId;
    super.initState();
  }

  // Switch sites
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 110,
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back_ios),
                    Text(
                      "Accueil",
                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            );
          },
        ),
        title: Text(
          lotCode,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(onPressed: () => _showLotsFilterActionSheet(context), icon: const Icon(Icons.scatter_plot))
        ],
      ),
      body: GridView(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns
          crossAxisSpacing: 14.0, // Space between columns
          mainAxisSpacing: 14.0, // Space between rows
        ),
        children: <Widget>[
          GridTile(
            child: AppItem(
              icon: Icons.summarize,
              color1: Colors.indigo,
              color2: Colors.indigo.shade300,
              text: "Saisie de données",
              page: ProdFormScreen(
                lotCode: widget.lotCode,
                lotId: widget.lotId,
              ),
            ),
          ),
          GridTile(
            child: AppItem(
              icon: Icons.space_dashboard,
              color1: Colors.green,
              color2: Colors.green.shade300,
              text: "Bilan partiel",
              page: BilanPartiel(lotCode: lotCode, lotId: lotId),
            ),
          ),
          GridTile(
            child: AppItem(
              icon: Icons.view_column,
              color1: Colors.blue,
              color2: Colors.blue.shade300,
              text: "Performances chiffres",
              page: TableScreen(
                lotId: lotId,
                lotCode: lotCode,
              ),
            ),
          ),
          GridTile(
            child: AppItem(
              icon: Icons.analytics,
              color1: Colors.purple,
              color2: Colors.purple.shade300,
              text: "Performances courbes",
              page: ChartsScreen(lotCode: lotCode, lotId: lotId),
            ),
          ),
          GridTile(
            child: AppItem(
              icon: Icons.vaccines,
              color1: Colors.teal,
              color2: Colors.teal.shade300,
              text: "Supplimentation",
              page: SupplimentationScreen(lotCode: lotCode, lotId: lotId),
            ),
          ),
          GridTile(
            child: AppItem(
              icon: Icons.summarize,
              color1: Colors.orange,
              color2: Colors.orange.shade300,
              text: "Analyses",
              page: AnalyseScreen(lotCode: lotCode, lotId: lotId),
            ),
          ),
        ],
      ),
    );
  }
}

class AppItem extends StatelessWidget {
  final String text;
  final Color color1;
  final Color color2;
  final IconData icon;
  final Widget page;
  const AppItem({super.key, required this.text, required this.icon, required this.color1, required this.color2, required this.page});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 300),
            child: page,
          ),
        );
      },
      child: ClipOval(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color1,
                color2,
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 30,
                ),
                const SizedBox(height: 6),
                Text(
                  text,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
