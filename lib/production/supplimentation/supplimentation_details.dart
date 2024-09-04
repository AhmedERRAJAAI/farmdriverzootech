import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'constants.dart';
import 'widget/details_supp_list_item.dart';

class SupplimentaionDetails extends StatelessWidget {
  final Map singleSupplimentation;
  const SupplimentaionDetails({super.key, required this.singleSupplimentation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          singleSupplimentation["suppliment"],
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailsSuppListItem(
              icon: Icons.date_range,
              label: "Date",
              value: singleSupplimentation["date"].toString(),
            ),
            const Divider(),
            DetailsSuppListItem(
              icon: Icons.scatter_plot,
              label: "Famille",
              value: SuppliConstabt.families[singleSupplimentation["family"]].toString(),
            ),
            const Divider(),
            DetailsSuppListItem(
              icon: Icons.sanitizer,
              label: "Produit",
              value: singleSupplimentation["suppliment"].toString(),
            ),
            const Divider(),
            DetailsSuppListItem(
              icon: Icons.payments,
              label: "Prix unitaire",
              value: singleSupplimentation["unit_price"].toString(),
            ),
            const Divider(),
            DetailsSuppListItem(
              icon: Icons.stairs,
              label: "Mode d'administration",
              value: SuppliConstabt.modeAdmins[singleSupplimentation["mode_admin"]],
            ),
            const Divider(),
            DetailsSuppListItem(
              icon: MdiIcons.needle,
              label: "Dose",
              value: singleSupplimentation["dose"].toString(),
            ),
            const Divider(),
            DetailsSuppListItem(
              icon: MdiIcons.cup,
              label: "Qté consommé",
              value: singleSupplimentation["qty_consm"].toString(),
            ),
            const Divider(),
            DetailsSuppListItem(
              icon: Icons.timer,
              label: "Horaire",
              value: "${singleSupplimentation["startTime"]}-${singleSupplimentation["endTime"]}",
            ),
            const Divider(),
            if (singleSupplimentation["observ"].toString().isNotEmpty)
              DetailsSuppListItem(
                icon: Icons.timer,
                label: "Note",
                value: singleSupplimentation["observ"],
              ),
          ],
        ),
      )),
    );
  }
}
