import 'package:farmdriverzootech/farmdriver_base/provider/auth_provider.dart';
import 'package:farmdriverzootech/farmdriver_base/widgets/info_dialog.dart';
import 'package:farmdriverzootech/production/analyses/provider.dart';
import 'package:farmdriverzootech/production/analyses/widget/analyse_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentAnalysesSection extends StatefulWidget {
  const RecentAnalysesSection({super.key});

  @override
  State<RecentAnalysesSection> createState() => _RecentAnalysesSectionState();
}

class _RecentAnalysesSectionState extends State<RecentAnalysesSection> {
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
      await Provider.of<AnalysesProvider>(context, listen: false).getLastTwoAnalyses().then((_) {
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
          "échec de récupération des données",
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
    List analyses = Provider.of<AnalysesProvider>(context, listen: true).lastTwoAnalyses;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.circle,
                color: Colors.amber,
                size: 13,
              ),
              Text(
                " Analyses récentes",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Column(
            children: analyses.map((e) {
              return AnalyseListItem(
                analyse: e,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
