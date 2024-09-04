import 'package:farmdriverzootech/farmdriver_base/provider/auth_provider.dart';
import 'package:farmdriverzootech/farmdriver_base/widgets/info_dialog.dart';
import 'package:farmdriverzootech/production/supplimentation/constants.dart';
import 'package:farmdriverzootech/production/supplimentation/provider.dart';
import 'package:farmdriverzootech/production/supplimentation/widget/supp_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentSuppSection extends StatefulWidget {
  const RecentSuppSection({super.key});

  @override
  State<RecentSuppSection> createState() => _RecentSuppSectionState();
}

class _RecentSuppSectionState extends State<RecentSuppSection> {
  bool isLoading = false;
  bool downloading = false;
  bool failedToFetch = false;

  @override
  void initState() {
    fetchSupplimentation(context);
    super.initState();
  }

  void fetchSupplimentation(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<SupplimentatioProvider>(context, listen: false).getLastTwoSupplimentations().then((_) {
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
            fetchSupplimentation(context);
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
          fetchSupplimentation,
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
    List supplimentations = Provider.of<SupplimentatioProvider>(context, listen: true).lastSupplimentations;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.circle,
                color: Colors.teal,
                size: 13,
              ),
              Text(
                " Supplémentations récentes",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              ),
            ],
          ),

          Column(
            children: supplimentations.map((e) {
              return SuppListItem(
                product: e["suppliment"],
                familly: SuppliConstabt.families[e["family"]],
                date: e["date"],
                suppItem: e,
              );
            }).toList(),
          ),
          // const SizedBox(height: 6),
          // RecentSuppAnalyseItem(icon: MdiIcons.medicationOutline, isSupp: true, text: "AVIVIT HEPATO", date: "2024-07-30"),
          // RecentSuppAnalyseItem(icon: MdiIcons.medicationOutline, isSupp: true, text: "Ornibron H 120 +D 274", date: "2024-07-19"),
        ],
      ),
    );
  }
}
