import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../const.dart';
import '../../widgets/poppup_serfaces.dart';
import 'widgets/init_age_picker.dart';

/// Flutter code sample for [CupertinoPicker].

const double _kItemExtent = 32.0;

class AgeDiskCalc extends StatefulWidget {
  const AgeDiskCalc({super.key});

  @override
  State<AgeDiskCalc> createState() => _AgeDiskCalcState();
}

class _AgeDiskCalcState extends State<AgeDiskCalc> {
  late FixedExtentScrollController _ageSelectScrollController;
  late FixedExtentScrollController _daySelectScrollController;
  List<int> ages = FarmdriverConst.generateWeekAges();
  List<int> daysOnAge = FarmdriverConst.days;
  int? initAge;
  int? initAgeDays;
  int _selectedAge = 0;
  int _selectedDay = 0;
  DateTime _selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime birthdate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  // Show date picker
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
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

  // calc age in weeks and days
  void calculateAgeInWeeksAndDays(DateTime birthdate, DateTime otherDate) {
    try {
      int differenceInDays = otherDate.difference(birthdate).inDays;
      int ageInWeeks = (differenceInDays / 7).floor();
      int remainingDays = differenceInDays % 7;
      setState(() {
        _selectedAge = ageInWeeks;
        _selectedDay = remainingDays;
        _ageSelectScrollController.jumpToItem(_selectedAge); // Update the picker to reflect the new value
        _daySelectScrollController.jumpToItem(_selectedDay); // Update the picker to reflect the new value
      });
    } catch (e) {
      return;
    }
  }

  // calc date based on age
  void calculateDateFromAgeInWeeksAndDays(DateTime birthdate, int ageInWeeks, int dayInWeek) {
    if (dayInWeek < 1 || dayInWeek > 7) {
      throw ArgumentError('dayInWeek must be between 1 and 7');
    }
    int totalDays = ((ageInWeeks) * 7) + dayInWeek;
    DateTime finalDate = birthdate.add(Duration(days: totalDays));
    if (finalDate.isAfter(birthdate)) {
      setState(() {
        _selectedDate = finalDate;
      });
    }
  }

  void calcBirthdate(int ageInWeeks, int daysOnWeek) {
    int totalDays = (ageInWeeks * 7) + daysOnWeek;
    DateTime today = DateTime.now();
    setState(() {
      birthdate = today.subtract(Duration(days: totalDays));
    });
  }

  @override
  void initState() {
    super.initState();
    _ageSelectScrollController = FixedExtentScrollController(initialItem: _selectedAge);
    _daySelectScrollController = FixedExtentScrollController(initialItem: _selectedDay);
  }

  void getter(int ageWeeks, int ageDays) {
    ageWeeks = ageWeeks >= 0 ? ageWeeks : 0;
    setState(() {
      initAge = ageWeeks;
      initAgeDays = ageDays;
      _selectedDay = ageDays;
      _selectedAge = ageWeeks;
    });
    calcBirthdate(ageWeeks, ageDays);
  }

  Widget getInitAgePicker() {
    return InitAgePicker(initAge: initAge ?? 1, initAgeDays: initAgeDays ?? 1, ageGetter: getter);
  }

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 110,
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: Colors.green,
                    ),
                    Text(
                      "Outils",
                      style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
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
          "Disque Age",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),

      // Page Body
      body: SafeArea(
        child: DefaultTextStyle(
          style: TextStyle(
            color: CupertinoColors.label.resolveFrom(context),
            fontSize: 22.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // INITIALISATION
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).primaryColorLight.withAlpha(95),
                        Theme.of(context).primaryColorLight.withAlpha(90),
                      ],
                    ),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 12),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Initialisation",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Age actuel",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.normal),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              PoppupSerfaces.showPopupSurface(context, getInitAgePicker, MediaQuery.of(context).size.height / 2, false);
                            },
                            child: Text(
                              "${initAge ?? 0} sem + ${initAgeDays ?? 1} jours",
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                      // Choose date of birth
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Date de naissance",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.normal),
                          ),
                          OutlinedButton(
                            onPressed: () => _showDialog(
                              CupertinoDatePicker(
                                initialDateTime: birthdate,
                                mode: CupertinoDatePickerMode.date,
                                use24hFormat: true,
                                showDayOfWeek: false,
                                onDateTimeChanged: (DateTime newDate) {
                                  setState(() => birthdate = newDate);
                                  calculateAgeInWeeksAndDays(birthdate, _selectedDate);
                                },
                              ),
                            ),
                            child: Text(
                              DateFormat('dd/MM/yyyy').format(birthdate),
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // RESULT
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.green,
                        Colors.green.withAlpha(150),
                      ],
                    ),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 12, top: 12),
                  child: Column(
                    children: [
                      // Age picker
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Age",
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          Text(
                            "${ages[_selectedAge]} sem + ${daysOnAge[_selectedDay]} jours ",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Date",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 18),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy').format(_selectedDate),
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 18),
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                // AGE PICKERS
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Age in weeks ======
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Age (sem)",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Theme.of(context).primaryColorLight.withAlpha(95),
                                    Theme.of(context).primaryColorLight.withAlpha(90),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15)),
                            height: 165,
                            width: screensize.width / 2 - 20,
                            child: CupertinoPicker(
                              magnification: 1.22,
                              squeeze: 1.2,
                              useMagnifier: true,
                              itemExtent: _kItemExtent,
                              // This sets the initial item.
                              scrollController: _ageSelectScrollController,
                              onSelectedItemChanged: (int selectedAge) {
                                setState(
                                  () {
                                    _selectedAge = selectedAge;
                                    calculateDateFromAgeInWeeksAndDays(birthdate, ages[_selectedAge], daysOnAge[_selectedDay]);
                                  },
                                );
                              },
                              children: List<Widget>.generate(
                                ages.length,
                                (int index) {
                                  return Center(child: Text(ages[index].toString()));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      // days on age ========
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Jour/Age",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Theme.of(context).primaryColorLight.withAlpha(95),
                                    Theme.of(context).primaryColorLight.withAlpha(90),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15)),
                            height: 165,
                            width: screensize.width / 2 - 20,
                            child: CupertinoPicker(
                              magnification: 1.22,
                              squeeze: 1.2,
                              useMagnifier: true,
                              itemExtent: _kItemExtent,
                              // This sets the initial item.
                              scrollController: _daySelectScrollController,
                              // This is called when selected item is changed.
                              onSelectedItemChanged: (int selectedDay) {
                                setState(() {
                                  _selectedDay = selectedDay;
                                  calculateDateFromAgeInWeeksAndDays(birthdate, ages[_selectedAge], daysOnAge[_selectedDay]);
                                });
                              },
                              children: List<Widget>.generate(daysOnAge.length, (int index) {
                                return Center(child: Text(daysOnAge[index].toString()));
                              }),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Date picker
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Text(
                        "Date",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Theme.of(context).primaryColorLight.withAlpha(95),
                                Theme.of(context).primaryColorLight.withAlpha(90),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        height: 200,
                        child: CupertinoDatePicker(
                          key: ValueKey(_selectedDate), // Add a key to force rebuild
                          minimumDate: birthdate,
                          initialDateTime: _selectedDate,
                          mode: CupertinoDatePickerMode.date,
                          use24hFormat: true,
                          showDayOfWeek: false,
                          dateOrder: DatePickerDateOrder.dmy,
                          onDateTimeChanged: (DateTime newDate) {
                            if (newDate.isAfter(birthdate)) {
                              setState(() => _selectedDate = newDate);
                              calculateAgeInWeeksAndDays(birthdate, _selectedDate);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Schedule a reminder
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Planifier un rappel",
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.notification_add,
                            color: Colors.white,
                          )
                        ],
                      ),
                      onPressed: () {
                        // PoppupSerfaces.showPopupSurface(context, getReminderPlanifier, MediaQuery.of(context).size.height - 100, false);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
