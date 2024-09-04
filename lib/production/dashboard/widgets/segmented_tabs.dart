import 'package:flutter/cupertino.dart';

class SegmentedTabs extends StatefulWidget {
  final int pageIndex;
  final Function switchPage;
  final Map<int, Widget> children;
  const SegmentedTabs({super.key, required this.children, required this.pageIndex, required this.switchPage});

  @override
  State<SegmentedTabs> createState() => _SegmentedTabsState();
}

class _SegmentedTabsState extends State<SegmentedTabs> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: CupertinoSlidingSegmentedControl(
        children: widget.children,
        groupValue: widget.pageIndex,
        onValueChanged: (value) {
          widget.switchPage(value);
        },
      ),
    );
  }
}
