import 'package:farmdriverzootech/farmdriver_base/provider/auth_provider.dart';
import 'package:farmdriverzootech/farmdriver_base/widgets/info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'provider.dart';
import 'widget/supp_list_item.dart';

class SupplimentationScreen extends StatefulWidget {
  final String lotCode;
  final int lotId;
  const SupplimentationScreen({
    super.key,
    required this.lotCode,
    required this.lotId,
  });

  @override
  State<SupplimentationScreen> createState() => _SupplimentationScreenState();
}

class _SupplimentationScreenState extends State<SupplimentationScreen> {
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
      await Provider.of<SupplimentatioProvider>(context, listen: false).getSupplimentations(widget.lotId).then((_) {
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
          "échec de récupération des données",
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
          children: supplimentations.map((e) {
            return SuppListItem(
              product: e["suppliment"],
              familly: SuppliConstabt.families[e["family"]],
              date: e["date"],
              suppItem: e,
            );
          }).toList(),
        ),
      ),
    );
  }
}
