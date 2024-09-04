import 'package:flutter/cupertino.dart';

class Filters {
  static void showActionSheet(BuildContext context, List sites, getter) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('SITES'),
        message: const Text(''),
        actions: [
          ...sites.map((site) => CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () {
                  getter(site["siteId"], site["siteName"]);
                  Navigator.pop(context);
                },
                child: Text(site["siteName"].toString()),
              )),
        ],
      ),
    );
  }

  static void showPeriodActionSheet(BuildContext context, List<int> periods, getter) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Période'),
        message: const Text(''),
        actions: [
          ...periods.map((period) => CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () {
                  getter(period);
                  Navigator.pop(context);
                },
                child: Text(period == 0 ? "MAX" : "$period jours"),
              )),
        ],
      ),
    );
  }

  static void showObservThemeActionSheet(BuildContext context, List data, getter) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text("Thème d'observation"),
        message: const Text(''),
        actions: [
          ...data.map((item) => CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () {
                  getter(item);
                  Navigator.pop(context);
                },
                child: Text(item["val"].toString()),
              )),
        ],
      ),
    );
  }

  static void showSameValuesActionSheet(BuildContext context, List data, getter) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text("Thème d'observation"),
        message: const Text(''),
        actions: [
          ...data.map((item) => CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () {
                  getter(item);
                  Navigator.pop(context);
                },
                child: Text(item.toString()),
              )),
        ],
      ),
    );
  }

  static void toggleTwoOptions(BuildContext context, List<Map> labels, getter) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Filtre'),
        message: const Text(''),
        actions: [
          ...labels.map((label) => CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () {
                  getter(label["val"]);
                  Navigator.pop(context);
                },
                child: Text(label["text"]),
              )),
        ],
      ),
    );
  }
}
