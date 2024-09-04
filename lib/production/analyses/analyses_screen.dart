import 'package:farmdriverzootech/farmdriver_base/widgets/info_dialog.dart';
import 'package:farmdriverzootech/production/analyses/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../farmdriver_base/provider/auth_provider.dart';
import 'widget/analyse_list_item.dart';

class AnalyseScreen extends StatefulWidget {
  final String lotCode;
  final int lotId;
  const AnalyseScreen({super.key, required this.lotCode, required this.lotId});

  @override
  State<AnalyseScreen> createState() => _AnalyseScreenState();
}

class _AnalyseScreenState extends State<AnalyseScreen> {
  bool isLoading = false;
  bool downloading = false;
  bool failedToFetch = false;

  @override
  void initState() {
    fetchAnalyses(context);
    super.initState();
  }

  void fetchAnalyses(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<AnalysesProvider>(context, listen: false).getAnalyses(widget.lotId).then((_) {
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
            fetchAnalyses(context);
          });
        } catch (e) {
          Navigator.of(context).pushNamed("auth-screen/");
        }
      } else {
        AlertsDialog.doUreallyWant(
          context,
          "Echec",
          "échec de récupération des données status: $statusCode",
          "Réessayer",
          true,
          fetchAnalyses,
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
    List analyses = Provider.of<AnalysesProvider>(context, listen: true).analyses;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.lotCode,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: analyses.map((e) {
            return AnalyseListItem(
              analyse: e,
            );
          }).toList(),
        ),
      ),
    );
  }
}
