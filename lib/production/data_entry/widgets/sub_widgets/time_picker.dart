import 'package:flutter/material.dart';

class TimePickBtn extends StatelessWidget {
  final Function timePicker;
  final IconData icon;
  final Function getter;
  final TimeOfDay? initValue;
  final String hintText;
  final String? placeHolder;
  const TimePickBtn({
    super.key,
    required this.timePicker,
    required this.icon,
    required this.getter,
    required this.hintText,
    this.initValue,
    this.placeHolder,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        timePicker(context, getter, initValue, hintText);
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18,
          ),
          const SizedBox(width: 6),
          initValue != null ? Text("${initValue?.hour}:${initValue?.minute}") : Text(placeHolder ?? "--:--")
        ],
      ),
    );
  }
}
