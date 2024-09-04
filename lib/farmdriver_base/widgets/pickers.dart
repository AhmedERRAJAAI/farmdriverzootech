import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MaterialPicker {
  static void muiTimePicker(BuildContext context, getter, TimeOfDay? initValue, String hintText) async {
    await showTimePicker(
      context: context,
      cancelText: 'Annuler',
      initialTime: initValue ?? TimeOfDay.now(),
      confirmText: "OK",
      helpText: hintText,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const Text(''),
        );
      },
    ).then((value) {
      if (value != null) {
        getter(value);
      }
    });
  }

  static void muiDatePicker(BuildContext context, getter, DateTime? initDate) async {
    await showDatePicker(
      context: context,
      cancelText: 'Annuler',
      // initialDate: initDate ?? DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      // locale: const Locale("fr", "FR"),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const Text(''),
        );
      },
    ).then((value) {
      getter(value);
    });
  }

  static void cupertinoPicker(BuildContext context, getter, DateTime? initDate, Widget child) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  static void getActionsOptionsPicker(context, initItem, getter, listItems) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoPicker(
          magnification: 1.22,
          squeeze: 1,
          useMagnifier: true,
          itemExtent: 40.5,
          scrollController: FixedExtentScrollController(
            initialItem: initItem,
          ),
          onSelectedItemChanged: (int selectedItem) {
            getter(selectedItem);
          },
          children: List<Widget>.generate(listItems["dates"].length, (int index) {
            return Center(child: Text(listItems["dates"][index]["date"]));
          }),
        ),
      ),
    );
  }
}
