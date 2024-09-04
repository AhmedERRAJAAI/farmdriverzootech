import 'package:farmdriverzootech/production/performaces_table/model.dart';
import 'package:flutter/material.dart';

class OneValueCell extends StatelessWidget {
  final dynamic value;

  const OneValueCell({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Center(
        child: Text(
          "$value",
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class ValueEcartCell extends StatelessWidget {
  final Ordinary data;
  ValueEcartCell({super.key, required this.data});

  final Map<String, Color> ecartColors = {
    "red": Colors.deepOrange.shade600,
    "green": Colors.green.shade700,
    "orange": Colors.orange,
    "blue": Colors.blue.shade700
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Text(
                "${data.reel}",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (data.ecart != null)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 1),
              color: ecartColors[data.color ?? "blue"]!.withOpacity(0.2),
              child: Center(
                child: Text(
                  "${data.ecart}",
                  style: TextStyle(color: ecartColors[data.color ?? "blue"], fontWeight: FontWeight.bold, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TempCell extends StatelessWidget {
  final Temperature temp;
  const TempCell({super.key, required this.temp});

  @override
  Widget build(BuildContext context) {
    Color colorTemperature(double value) {
      if (value < 20) {
        return Colors.blue;
      } else if (value > 20 && value <= 25) {
        return Colors.green;
      } else if (value > 25 && value <= 30) {
        return Colors.orange;
      } else {
        return Colors.red;
      }
    }

    return Center(
        child: RichText(
      text: TextSpan(
        text: '${temp.min}',
        style: TextStyle(color: colorTemperature(temp.min)),
        children: <TextSpan>[
          const TextSpan(text: ' / ', style: TextStyle(color: Colors.black)),
          TextSpan(text: '${temp.max}', style: TextStyle(fontWeight: FontWeight.bold, color: colorTemperature(temp.max))),
        ],
      ),
    ));
  }
}

class OneColorCell extends StatelessWidget {
  final WithVariation data;
  OneColorCell({super.key, required this.data});

  final Map<String, Color> ecartColors = {
    "red": Colors.deepOrange,
    "green": Colors.green.shade700,
    "orange": Colors.orange,
    "grey": Colors.grey.shade700,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Text(
                "${data.reel}",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (data.variat != null) const Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Center(
              child: Text(
                "${data.variat}",
                style: TextStyle(color: ecartColors[data.color ?? "blue"], fontWeight: FontWeight.bold, fontSize: 12, decoration: TextDecoration.underline),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TwoValueCell extends StatelessWidget {
  final TwoValues data;
  const TwoValueCell({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Text(
                "${data.reel}",
                overflow: TextOverflow.visible,
              ),
            ),
          ),
          if (data.variat != null) const Divider(height: 1),
          if (data.variat != null)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 1),
              color: data.hasColor ?? false ? Colors.grey.shade300 : null,
              child: Center(
                child: Text(
                  "${data.variat}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: data.hasColor ?? false ? Colors.grey.shade800 : null),
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class LightCell extends StatelessWidget {
  final Light data;
  const LightCell({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(child: data.isFlash ? Text(data.durration ?? 'Néant') : Text(data.durration ?? '--:--'));
  }
}

class ReelColorCell extends StatelessWidget {
  final ReelColor data;
  ReelColorCell({super.key, required this.data});

  final Map<String, Color> ecartColors = {
    "red": Colors.deepOrange,
    "green": Colors.green.shade700,
    "orange": Colors.orange,
    "blue": Colors.blue.shade700,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ecartColors[data.color ?? "blue"]!.withOpacity(0.6),
      child: Center(
        child: Text(
          data.reel.toString(),
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
