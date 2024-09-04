import 'package:farmdriverzootech/farmdriver_base/screens/apps_screen.dart';
import 'package:farmdriverzootech/production/compare_lots_charts.dart/comparision_screen.dart';
import 'package:farmdriverzootech/production/etat_production/etat_prod_screen.dart';
import 'package:farmdriverzootech/production/synthese/synthese_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class DashBtnSlider extends StatelessWidget {
  const DashBtnSlider({super.key});

  Widget goToAppsPage() {
    return const AppsScreen();
  }

  Widget goToEtatProdPage() {
    return const ProdStatusScreen();
  }

  Widget goToSynthesePage() {
    return const SyntheseScreen();
  }

  Widget goToComparatifPage() {
    return const ComparisionLotsScreen();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            DashBtn(
              color1: Colors.orange.shade400,
              color2: Colors.orange.shade700,
              label: "Apps",
              icon: Icons.apps,
              screen: goToAppsPage,
            ),
            const SizedBox(width: 17),
            DashBtn(
              color1: Colors.green.shade400,
              color2: Colors.green.shade700,
              label: "Synthèse \nhebdo.",
              icon: Icons.view_timeline,
              screen: goToSynthesePage,
            ),
            const SizedBox(width: 17),
            DashBtn(
              color1: Colors.blue,
              color2: Colors.blue.shade400,
              label: "Etat \nProd.",
              icon: Icons.view_kanban,
              screen: goToEtatProdPage,
            ),
            const SizedBox(width: 17),
            DashBtn(
              color1: Colors.purple.shade400,
              color2: Colors.purple.shade700,
              label: "Comparatifs",
              icon: Icons.compare_arrows,
              screen: goToComparatifPage,
            ),
          ],
        ),
      ),
    );
  }
}

// Dashboard buttons
class DashBtn extends StatefulWidget {
  final Color color1;
  final Color color2;
  final IconData icon;
  final String label;
  final Widget Function() screen;
  const DashBtn({super.key, required this.color1, required this.color2, required this.icon, required this.label, required this.screen});

  @override
  State<DashBtn> createState() => _DashBtnState();
}

class _DashBtnState extends State<DashBtn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _topAlignmentAnimation = TweenSequence<Alignment>(
      [
        TweenSequenceItem(tween: Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight), weight: 1),
        TweenSequenceItem(tween: Tween<Alignment>(begin: Alignment.topRight, end: Alignment.bottomRight), weight: 1),
        TweenSequenceItem(tween: Tween<Alignment>(begin: Alignment.bottomRight, end: Alignment.bottomLeft), weight: 1),
        TweenSequenceItem(tween: Tween<Alignment>(begin: Alignment.bottomLeft, end: Alignment.topLeft), weight: 1),
      ],
    ).animate(_controller);
    _bottomAlignmentAnimation = TweenSequence<Alignment>(
      [
        TweenSequenceItem(tween: Tween<Alignment>(begin: Alignment.bottomRight, end: Alignment.bottomLeft), weight: 1),
        TweenSequenceItem(tween: Tween<Alignment>(begin: Alignment.bottomLeft, end: Alignment.topLeft), weight: 1),
        TweenSequenceItem(tween: Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight), weight: 1),
        TweenSequenceItem(tween: Tween<Alignment>(begin: Alignment.topRight, end: Alignment.bottomRight), weight: 1),
      ],
    ).animate(_controller);
    _controller.repeat();
  }

  // Always dispose of the AnimationController to clean up the resources.
  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  curve: Curves.bounceIn,
                  child: widget.screen(),
                ),
              );
            },
            child: ClipOval(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                    colors: [
                      widget.color1,
                      widget.color2,
                    ],
                    stops: const [
                      0.2,
                      1.0
                    ],
                    begin: _topAlignmentAnimation.value,
                    end: _bottomAlignmentAnimation.value,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 16,
                    ),
                    Text(
                      widget.label,
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
