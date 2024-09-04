import 'package:flutter/cupertino.dart';

class PoppupSerfaces {
  static void showPopupSurface(BuildContext context, Widget Function() child, height, bool avoidKeyBoard) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoPopupSurface(
          isSurfacePainted: true,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 0, // avoidKeyBoard ? MediaQuery.of(context).viewInsets.bottom : 0,
            ),
            child: SizedBox(
              height: height,
              child: child(),
            ),
          ),
        );
      },
    );
  }
}
