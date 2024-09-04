import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IosAlertDialog {
  Future<void> showIosAlertDialog(context, content) {
    return showDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Erreur'),
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
}
