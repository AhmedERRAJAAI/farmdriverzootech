import 'package:farmdriverzootech/production/bilan_partiel/widgets/full_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ChartBox extends StatelessWidget {
  final Widget chart;
  const ChartBox({super.key, required this.chart});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        chart,
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            child: const Icon(
              Icons.fullscreen,
              size: 30,
            ),
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.bottomToTop,
                  curve: Curves.bounceIn,
                  child: FullScreenCharts(
                    chart: chart,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
