import 'package:farmdriverzootech/farmdriver_base/src/age_disk/age_disk_calc.dart';
import 'package:farmdriverzootech/farmdriver_base/src/memento/memento_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class AppsScreen extends StatelessWidget {
  const AppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 110,
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back_ios),
                    Text(
                      "Accueil",
                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            );
          },
        ),
        title: Text(
          "Outils",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: GridView(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns
          crossAxisSpacing: 14.0, // Space between columns
          mainAxisSpacing: 14.0, // Space between rows
        ),
        children: <Widget>[
          const GridTile(
            child: AppItem(
              icon: Icons.timelapse,
              color: Colors.green,
              text: "Disque Age",
              page: AgeDiskCalc(),
            ),
          ),
          GridTile(
            child: AppItem(
              icon: Icons.event,
              color: Colors.amber.shade700,
              text: "Mémento",
              page: const MementoScreen(),
            ),
          ),
          // GridTile(
          //   child: AppItem(
          //     icon: Icons.checklist,
          //     color: Colors.blue.shade400,
          //     text: "To Do",
          //   ),
          // ),
        ],
      ),
    );
  }
}

class AppItem extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;
  final Widget page;
  const AppItem({super.key, required this.text, required this.color, required this.icon, required this.page});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            curve: Curves.bounceIn,
            child: page,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(height: 6),
              Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
