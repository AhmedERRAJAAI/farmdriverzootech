import 'package:farmdriverzootech/production/dashboard/provider/init_provider.dart';
import 'package:farmdriverzootech/production/others/lots_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SiteItemSlider extends StatefulWidget {
  final Function refresh;
  final SliderItem slide;
  const SiteItemSlider({super.key, required this.refresh, required this.slide});

  @override
  State<SiteItemSlider> createState() => _SiteItemSliderState();
}

class _SiteItemSliderState extends State<SiteItemSlider> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 45));
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
                  child: LotsListScreen(
                    siteId: widget.slide.siteId,
                    siteName: widget.slide.siteName,
                  ),
                  duration: const Duration(
                    milliseconds: 300,
                  )),
            );
          },
          child: Container(
              padding: const EdgeInsets.all(3),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.blue.shade400,
                    Colors.blue,
                  ],
                  stops: const [
                    0.08,
                    0.4,
                    1.0
                  ],
                  begin: _topAlignmentAnimation.value,
                  end: _bottomAlignmentAnimation.value,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Site + MAJ
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.location_on_outlined, color: Theme.of(context).textTheme.bodyLarge!.color, size: 20),
                            Text(widget.slide.siteName, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 16)),
                          ],
                        ),
                        Text("MAJ: ${widget.slide.lastUpdate}", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10, color: Theme.of(context).textTheme.bodyLarge!.color)),
                      ],
                    ),

                    // PRODUCTION + MORT
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Σ Effectif: ${widget.slide.effectifPresent}",
                                  style: TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).textTheme.bodyLarge!.color),
                                ),
                                const SizedBox(width: 30),
                                Text("Age moyen: ${widget.slide.ageMoy}", style: TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).textTheme.bodyLarge!.color)),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Production: ${widget.slide.prodJour}", style: TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).textTheme.bodyLarge!.color)),
                                    const SizedBox(width: 30),
                                    Text("Mortalité: ${widget.slide.mortJour}", style: TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).textTheme.bodyLarge!.color)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: widget.slide.siteIsGood ?? false ? Colors.lightGreen : Colors.red),
                          Text(
                            widget.slide.statusMsg ?? "-",
                            style: TextStyle(color: Colors.grey.shade800, fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
        );
      },
    );
  }
}
