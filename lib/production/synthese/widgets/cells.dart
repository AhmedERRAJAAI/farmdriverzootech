import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../performaces_table/widgets/days_table.dart';

class TitleCell extends StatefulWidget {
  final String value;
  final double width;
  final double height;
  final int? highlight;
  final int lotId;
  final int age;
  final String lot_code;
  const TitleCell({super.key, required this.value, required this.width, required this.height, this.highlight, required this.lotId, required this.age, required this.lot_code});

  @override
  State<TitleCell> createState() => _TitleCellState();
}

class _TitleCellState extends State<TitleCell> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      enableFeedback: true,
      height: 20,
      showDuration: const Duration(seconds: 3),
      triggerMode: TooltipTriggerMode.tap,
      message: widget.value,
      child: Container(
        decoration: BoxDecoration(
          color: widget.highlight == 1 ? Colors.blue : null,
          border: Border(
            bottom: const BorderSide(color: Colors.grey),
            right: Theme.of(context).brightness == Brightness.light ? const BorderSide(color: Colors.black) : const BorderSide(color: Colors.white, width: 1.2),
          ),
        ),
        width: widget.width,
        height: widget.height,
        child: Center(
          child: FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.value,
                  overflow: TextOverflow.ellipsis,
                  style: widget.highlight == 1 ? const TextStyle(color: Colors.white, fontWeight: FontWeight.bold) : Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  width: 5,
                ),
                if (widget.highlight == 1)
                  InkWell(
                    child: const Icon(
                      Icons.info,
                      size: 19,
                      color: Colors.white,
                    ),
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: 460,
                            child: TableDays(
                              lotId: widget.lotId,
                              age: widget.age,
                              lotCode: widget.lot_code,
                            ),
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UnoCell extends StatelessWidget {
  final String value;
  final double width;
  final double? height;
  final bool isImage;
  final bool? showLable;
  const UnoCell({super.key, required this.value, required this.width, this.height, required this.isImage, this.showLable});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: const BorderSide(color: Colors.grey),
        right: Theme.of(context).brightness == Brightness.light ? const BorderSide(color: Colors.black) : const BorderSide(color: Colors.white, width: 1.2),
      )),
      width: width,
      height: height,
      child: Center(
        child: isImage
            ? SizedBox(
                height: height,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(width: 60, child: Image(image: AssetImage("assets/images/$value.png"))),
                    if (showLable ?? false)
                      Text(
                        value,
                        style: const TextStyle(color: Colors.black),
                      ),
                  ],
                ),
              )
            : Text(
                value,
                style: Theme.of(context).textTheme.bodySmall,
              ),
      ),
    );
  }
}

class ParamCell extends StatelessWidget {
  final String value;
  final double width;
  final double height;
  final int? highlight;
  const ParamCell({super.key, required this.value, required this.width, required this.height, this.highlight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 6),
      decoration: BoxDecoration(
        color: highlight == 1 ? Colors.blue : Theme.of(context).canvasColor,
        border: const Border(
          bottom: BorderSide(color: Colors.grey),
          right: BorderSide(color: Colors.grey),
        ),
      ),
      width: width,
      height: height,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          value,
          style: highlight == 1 ? const TextStyle(color: Colors.white, fontWeight: FontWeight.bold) : Theme.of(context).textTheme.bodySmall,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class DuoCell extends StatelessWidget {
  final Map value;
  final double width;
  final double height;
  DuoCell({super.key, required this.value, required this.width, required this.height});

  final Map<String, Color> ecartColors = {
    "red": Colors.deepOrange.shade600,
    "green": Colors.green.shade700,
    "orange": Colors.orange,
    "blue": Colors.blue.shade700
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
              child: Center(
                child: Text(
                  value["reel"],
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: ecartColors[value["color"] ?? "blue"]!.withOpacity(0.1),
              border: Border(
                right: Theme.of(context).brightness == Brightness.light ? const BorderSide(color: Colors.black) : const BorderSide(color: Colors.white, width: 1.2),
              ),
            ),
            height: height,
            width: width / 2,
            child: Center(
              child: Text(
                "${value["ecart"]}",
                style: TextStyle(color: ecartColors[value["color"] ?? "blue"], fontWeight: FontWeight.bold, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TwoCell extends StatelessWidget {
  final String value;
  final String secValue;
  final String? color;
  final double width;
  final double height;
  TwoCell({super.key, required this.value, required this.width, required this.height, required this.secValue, this.color});

  final Map<String, Color> ecartColors = {
    "red": Colors.deepOrange.shade600,
    "green": Colors.green.shade700,
    "orange": Colors.orange,
    "blue": Colors.blue.shade700
  };
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          border: Border(
        bottom: const BorderSide(color: Colors.grey),
        right: Theme.of(context).brightness == Brightness.light ? const BorderSide(color: Colors.black) : const BorderSide(color: Colors.white, width: 1.2),
      )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.grey))),
              child: Center(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          ),
          Container(
            height: height,
            width: width / 2,
            color: color != null ? ecartColors[color]!.withOpacity(0.3) : null,
            child: Center(
              child: Text(
                secValue,
                style: color != null ? TextStyle(color: ecartColors[color], fontSize: 12) : Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ObservCell extends StatelessWidget {
  final List observs;
  final double width;
  const ObservCell({super.key, required this.observs, required this.width});

  String observTheme(int obTheme) {
    switch (1) {
      case 1:
        return 'sanitaire';
      case 2:
        return 'services généraux';
      case 3:
        return 'météo';
      case 5:
        return "usine d'aliment";
      case 6:
        return "MP & FP";
      case 7:
        return "Formulation";
      default:
        return "";
    }
  }

  Color observThemeColor(int obTheme) {
    switch (1) {
      case 1:
        return Colors.indigo;
      case 2:
        return Colors.green;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.purple;
      case 5:
        return Colors.red;
      case 6:
        return Colors.lime;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          // bottom: const BorderSide(color: Colors.grey),
          right: Theme.of(context).brightness == Brightness.light ? const BorderSide(color: Colors.grey) : const BorderSide(color: Colors.white, width: 0.7),
          left: Theme.of(context).brightness == Brightness.light ? const BorderSide(color: Colors.grey) : const BorderSide(color: Colors.white, width: 0.7),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      width: width,
      child: Column(
        children: observs.map((value) {
          return Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: observThemeColor(value["observ_theme"])))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value["date"],
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      value["time"],
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                Text(
                  observTheme(value["observ_theme"]),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: observThemeColor(value["observ_theme"])),
                ),
                Text(
                  value["observ_text"],
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  value["other"],
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
