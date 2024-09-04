import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullScreenCharts extends StatefulWidget {
  final Widget chart;
  const FullScreenCharts({super.key, required this.chart});

  @override
  State<FullScreenCharts> createState() => _FullScreenChartsState();
}

class _FullScreenChartsState extends State<FullScreenCharts> {
  @override
  void initState() {
    super.initState();
    // Set landscape orientation when the page is created
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Reset preferred orientations when the page is disposed
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Container(child: widget.chart),
            InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.amber),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).primaryColor,
                      size: 26,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
