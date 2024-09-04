import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) => const CupertinoModalWithNavigation(),
            );
          },
          child: const Text('Show Modal Popup'),
        ),
      ),
    );
  }
}

class CupertinoModalWithNavigation extends StatelessWidget {
  const CupertinoModalWithNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      color: Colors.white,
      child: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          return CupertinoPageRoute(
            builder: (context) => const ModalFirstPage(),
            settings: settings,
          );
        },
      ),
    );
  }
}

class ModalFirstPage extends StatelessWidget {
  const ModalFirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text('First Page'),
      ),
      body: Center(
        child: CupertinoButton(
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => const ModalSecondPage(),
              ),
            );
          },
          child: const Text('Go to Second Page'),
        ),
      ),
    );
  }
}

class ModalSecondPage extends StatelessWidget {
  const ModalSecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text('Second Page'),
      ),
      body: Center(
        child: CupertinoButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Go Back'),
        ),
      ),
    );
  }
}
