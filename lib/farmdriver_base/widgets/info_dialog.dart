import 'dart:io';

import '../../production/performaces_table/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertsDialog {
  static void colorInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text("INFO"),
        content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: Contants.eggColors.map((colorNbr) {
              return Column(
                children: [
                  SizedBox(
                    height: 43,
                    width: 43,
                    child: Image(
                      image: AssetImage('assets/images/$colorNbr.png'),
                    ),
                  ),
                  Text(
                    "$colorNbr",
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              );
            }).toList()),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  static void verifyInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text("INFO"),
        content: const Text("Cliquez sur le 'Vérifier' pour voir si le format des données est correct"),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  static void showReminderDetails(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  static void callSnackBars(context, String msg, bool isGood) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Durations.long3,
        backgroundColor: isGood ? Colors.lightGreen : Colors.deepOrange,
        content: Text(msg),
      ),
    );
  }

  static void verifyAndValidInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text("INFO"),
        content: const Text("cliquez sur 'vérifier et valider' pour verrouiller les champs afin qu'ils ne puissent pas être modifiés par accident. Les données resteront modifiables depuis la page de modification, les champs ne sont verrouillés que dans la page de saisie des données"),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  static void iosLoader(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const CupertinoAlertDialog(
        content: SizedBox(
          height: 30,
          width: 30,
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }

  static doUreallyWant(BuildContext context, String title, String text, String okBtn, bool isSingle, Function function) {
    showDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(text),
        actions: <Widget>[
          if (!isSingle)
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          TextButton(
            child: Text(okBtn),
            onPressed: () {
              Navigator.of(ctx).pop();
              function(context);
            },
          ),
        ],
      ),
    );
  }

  static void imageViewModal(File? img, context, Function clear) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: img != null
            ? Image.file(
                img,
                fit: BoxFit.fill,
              )
            : null,
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Supprimer',
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
            onPressed: () {
              clear();
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text(
              'Fermer',
              style: TextStyle(fontSize: 14, color: Colors.blue),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
