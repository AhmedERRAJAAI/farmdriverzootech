import 'package:farmdriverzootech/farmdriver_base/widgets/info_dialog.dart';
import 'package:farmdriverzootech/farmdriver_base/widgets/pickers.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'sub_widgets/input_field.dart';
import 'sub_widgets/time_picker.dart';

// ignore: must_be_immutable
class AmbiancePost extends StatefulWidget {
  final Color color;
  final TextEditingController tempMinInt;
  final TextEditingController tempMaxInt;
  final TextEditingController tempMinExt;
  final TextEditingController tempMaxExt;
  final TextEditingController humidityController;
  final Function ambianceValidator;

  TextEditingController lightOn;
  TextEditingController lightOff;
  TextEditingController lightDurr;
  TextEditingController flashOn;
  TextEditingController flashOff;
  TextEditingController flashDurr;
  TextEditingController intensite;
  TextEditingController intensIsLux;
  final bool validateAmbiance;
  AmbiancePost({
    super.key,
    required this.color,
    required this.tempMinInt,
    required this.tempMaxInt,
    required this.tempMinExt,
    required this.tempMaxExt,
    required this.lightOn,
    required this.lightOff,
    required this.lightDurr,
    required this.flashOn,
    required this.flashOff,
    required this.flashDurr,
    required this.intensite,
    required this.intensIsLux,
    required this.humidityController,
    required this.validateAmbiance,
    required this.ambianceValidator,
  });

  @override
  State<AmbiancePost> createState() => _AmbiancePostState();
}

class _AmbiancePostState extends State<AmbiancePost> {
  late bool validateAmbiance;

  @override
  void initState() {
    validateAmbiance = widget.validateAmbiance;
    super.initState();
  }

  void getFlashOn(value) {
    setState(() {
      widget.flashOn.text = timeOfDayStringifier(value);
    });
    flashDurSetter(widget.flashOn.text, widget.flashOff.text);
  }

  void getFlashOff(value) {
    setState(() {
      widget.flashOff.text = timeOfDayStringifier(value);
    });
    flashDurSetter(widget.flashOn.text, widget.flashOff.text);
  }

  void getFlashDurr(value) {
    setState(() {
      widget.flashDurr.text = timeOfDayStringifier(value);
    });
  }

  void flashDurSetter(flOn, flOff) {
    if (flOn != null && flOff != null) {
      setState(() {
        widget.flashDurr.text = "${calculateTimeDuration(flOn, flOff).hour}:${calculateTimeDuration(flOn, flOff).minute}";
      });
    }
  }

  void getLightOn(TimeOfDay value) {
    setState(() {
      widget.lightOn.text = timeOfDayStringifier(value);
    });
    lightDurSetter(widget.lightOn.text, widget.lightOff.text);
  }

  void getLightOff(value) {
    setState(() {
      widget.lightOff.text = timeOfDayStringifier(value);
    });
    lightDurSetter(widget.lightOn.text, widget.lightOff.text);
  }

  void getLightDurr(value) {
    setState(() {
      widget.lightDurr.text = timeOfDayStringifier(value);
    });
  }

  void lightDurSetter(String lightOnVal, String lightOffVal) {
    if (lightOnVal.isNotEmpty && lightOffVal.isNotEmpty) {
      setState(() {
        widget.lightDurr.text = "${calculateTimeDuration(lightOnVal, lightOffVal).hour}:${calculateTimeDuration(lightOnVal, lightOffVal).minute}";
      });
    }
  }

  String timeOfDayStringifier(TimeOfDay value) {
    return "${value.hour}:${value.minute}";
  }

  TimeOfDay? timeOfDayParser(String? timeString) {
    if (timeString == null || timeString.isEmpty) {
      return null;
    }
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) {
        throw const FormatException('Invalid time format');
      }

      final int hours = int.parse(parts[0]);
      final int minutes = int.parse(parts[1]);

      if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
        throw const FormatException('Invalid time values');
      }

      return TimeOfDay(hour: hours, minute: minutes);
    } catch (e) {
      print('Error parsing time: $e');
      return null;
    }
  }

  TimeOfDay calculateTimeDuration(String stTime, String ndTime) {
    TimeOfDay startTime = timeOfDayParser(stTime) ?? TimeOfDay.now();
    TimeOfDay endTime = timeOfDayParser(ndTime) ?? TimeOfDay.now();
    final int startMinutes = startTime.hour * 60 + startTime.minute;
    final int endMinutes = endTime.hour * 60 + endTime.minute;
    late TimeOfDay duration;

    if (startMinutes < endMinutes) {
      final int durationMinutes = endMinutes - startMinutes;
      final int hours = durationMinutes ~/ 60;
      final int minutes = durationMinutes % 60;
      duration = TimeOfDay(hour: hours, minute: minutes);
    } else if (startMinutes > endMinutes) {
      final int durationMinutes = (24 * 60 - startMinutes) + endMinutes;
      final int hours = durationMinutes ~/ 60;
      final int minutes = durationMinutes % 60;
      duration = TimeOfDay(hour: hours, minute: minutes);
    } else {
      duration = const TimeOfDay(hour: 0, minute: 0);
    }
    return duration;
  }

  Map minIntErrors = {
    "isError": null,
    "errorMsg": null,
  };
  Map maxIntErrors = {
    "isError": null,
    "errorMsg": null,
  };
  Map minExtErrors = {
    "isError": null,
    "errorMsg": null,
  };
  Map maxExtErrors = {
    "isError": null,
    "errorMsg": null,
  };
  Map humidityErrors = {
    "isError": null,
    "errorMsg": null,
  };

  bool validateInputs() {
    bool checker = true;
    if (widget.tempMinInt.text.isNotEmpty) {
      var number = num.tryParse(widget.tempMinInt.text);
      if (number != null && number < 100) {
        minIntErrors.clear();
      } else {
        checker = false;
        setState(() {
          minIntErrors["isError"] = true;
          minIntErrors["errorMsg"] = "la valeur du champ doit être un nombre < 100";
        });
      }
    } else {
      minIntErrors.clear();
    }
    if (widget.tempMaxInt.text.isNotEmpty) {
      var number = num.tryParse(widget.tempMaxInt.text);
      if (number != null && number < 100) {
        maxIntErrors.clear();
      } else {
        checker = false;
        setState(() {
          maxIntErrors["isError"] = true;
          maxIntErrors["errorMsg"] = "la valeur du champ doit être un nombre < 100";
        });
      }
    } else {
      maxIntErrors.clear();
    }
    if (widget.tempMinExt.text.isNotEmpty) {
      var number = num.tryParse(widget.tempMinExt.text);
      if (number != null && number < 100) {
        minExtErrors.clear();
      } else {
        checker = false;
        setState(() {
          minExtErrors["isError"] = true;
          minExtErrors["errorMsg"] = "la valeur du champ doit être un nombre < 100";
        });
      }
    } else {
      minExtErrors.clear();
    }
    if (widget.tempMaxExt.text.isNotEmpty) {
      var number = num.tryParse(widget.tempMaxExt.text);
      if (number != null && number < 100) {
        maxExtErrors.clear();
      } else {
        checker = false;
        setState(() {
          maxExtErrors["isError"] = true;
          maxExtErrors["errorMsg"] = "la valeur du champ doit être un nombre < 100";
        });
      }
    } else {
      maxExtErrors.clear();
    }
    if (widget.humidityController.text.isNotEmpty) {
      var number = num.tryParse(widget.humidityController.text);
      if (number != null && number < 100) {
        humidityErrors.clear();
      } else {
        checker = false;
        setState(() {
          humidityErrors["isError"] = true;
          humidityErrors["errorMsg"] = "la valeur du champ doit être un nombre < 100";
        });
      }
    } else {
      humidityErrors.clear();
    }
    return checker;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 18, top: 12),
              child: Text(
                "Ambiance",
                textAlign: TextAlign.center,
                style: TextStyle(color: widget.color, fontSize: 18),
              ),
            ),
            const SizedBox(height: 8),
            const Row(children: [
              Text(
                "Températures",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              Icon(
                Icons.thermostat,
                color: Colors.orange,
              )
            ]),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Icon(Icons.exit_to_app, color: Theme.of(context).primaryColor),
                    Text("Intérieur", style: TextStyle(fontSize: 9, color: Theme.of(context).primaryColor))
                  ],
                ),
                InputFieldItem(
                  inputWidth: deviceSize.width * 0.4,
                  inputType: TextInputType.number,
                  inputAction: TextInputAction.next,
                  color: Colors.orange,
                  inputController: widget.tempMinInt,
                  label: "Min (°C)",
                  isError: minIntErrors["isError"],
                  errorMsg: minIntErrors["errorMsg"],
                ),
                InputFieldItem(
                  inputWidth: deviceSize.width * 0.4,
                  inputType: TextInputType.number,
                  inputAction: TextInputAction.next,
                  color: Colors.orange,
                  inputController: widget.tempMaxInt,
                  label: "Max (°C)",
                  isError: maxIntErrors["isError"],
                  errorMsg: maxIntErrors["errorMsg"],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Transform.rotate(
                      angle: (90 * 3.141592653589793) / 180,
                      child: Icon(
                        Icons.ios_share,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text("Extérieur", style: TextStyle(fontSize: 9, color: Theme.of(context).primaryColor))
                  ],
                ),
                InputFieldItem(
                  inputWidth: deviceSize.width * 0.4,
                  inputType: TextInputType.number,
                  inputAction: TextInputAction.next,
                  color: Colors.orange,
                  inputController: widget.tempMinExt,
                  label: "Min (°C)",
                  isError: minExtErrors["isError"],
                  errorMsg: minExtErrors["errorMsg"],
                ),
                InputFieldItem(
                  inputWidth: deviceSize.width * 0.4,
                  inputType: TextInputType.number,
                  inputAction: TextInputAction.next,
                  color: Colors.orange,
                  inputController: widget.tempMaxExt,
                  label: "Max (°C)",
                  isError: maxExtErrors["isError"],
                  errorMsg: maxExtErrors["errorMsg"],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Icon(
                      MdiIcons.waterPercent,
                      color: Theme.of(context).primaryColor,
                    ),
                    Text("Intérieur", style: TextStyle(fontSize: 9, color: Theme.of(context).primaryColor))
                  ],
                ),
                InputFieldItem(
                  inputWidth: deviceSize.width * 0.82,
                  inputType: TextInputType.number,
                  inputAction: TextInputAction.next,
                  color: Colors.orange,
                  inputController: widget.humidityController,
                  label: "Humidité",
                  maxLength: 5,
                  isError: humidityErrors["isError"],
                  errorMsg: humidityErrors["errorMsg"],
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Row(children: [
              Text(
                "Lumiére & Flash  ",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              Icon(
                Icons.sunny,
                color: Colors.orange,
              )
            ]),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: deviceSize.width * 0.1,
                  child: Column(
                    children: [
                      Icon(
                        Icons.emoji_objects,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text("Lumiére", style: TextStyle(fontSize: 9, color: Theme.of(context).primaryColor))
                    ],
                  ),
                ),
                TimePickBtn(icon: MdiIcons.lightbulbOutline, timePicker: MaterialPicker.muiTimePicker, getter: getLightOn, initValue: timeOfDayParser(widget.lightOn.text), hintText: "Allumage lumiére"),
                TimePickBtn(icon: MdiIcons.lightbulbOffOutline, timePicker: MaterialPicker.muiTimePicker, getter: getLightOff, initValue: timeOfDayParser(widget.lightOff.text), hintText: "Extinction lumiére"),
                TimePickBtn(icon: Icons.schedule, timePicker: MaterialPicker.muiTimePicker, getter: getLightDurr, initValue: timeOfDayParser(widget.lightDurr.text), hintText: "Durée lumiére"),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: deviceSize.width * 0.1,
                  child: Column(
                    children: [
                      Icon(
                        Icons.bolt,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      Text("Flash", style: TextStyle(fontSize: 9, color: Theme.of(context).primaryColor))
                    ],
                  ),
                ),
                TimePickBtn(icon: MdiIcons.lightbulbOutline, timePicker: MaterialPicker.muiTimePicker, getter: getFlashOn, initValue: timeOfDayParser(widget.flashOn.text), hintText: "Allumage flash"),
                TimePickBtn(icon: MdiIcons.lightbulbOffOutline, timePicker: MaterialPicker.muiTimePicker, getter: getFlashOff, initValue: timeOfDayParser(widget.flashOff.text), hintText: "Extinction flash"),
                TimePickBtn(icon: Icons.schedule, timePicker: MaterialPicker.muiTimePicker, getter: getFlashDurr, initValue: timeOfDayParser(widget.flashDurr.text), hintText: "Durée Flash"),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Row(children: [
              Text(
                "Intensité  ",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              Icon(
                Icons.sunny,
                color: Colors.orange,
              )
            ]),
            const SizedBox(height: 10),
            SizedBox(
              height: 19,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text("Poucentage", style: TextStyle(color: Colors.lightGreen)),
                  Switch(
                    inactiveThumbColor: Colors.lightGreen,
                    inactiveTrackColor: Colors.lightGreen.shade200,
                    value: widget.intensIsLux.text.isEmpty
                        ? false
                        : widget.intensIsLux.text == "0"
                            ? false
                            : true,
                    activeColor: Colors.deepOrange,
                    onChanged: (bool value) {
                      setState(() {
                        widget.intensite.clear();
                        widget.intensIsLux.text = value ? "1" : "0";
                      });
                    },
                  ),
                  const Text("Lux", style: TextStyle(color: Colors.deepOrange)),
                ],
              ),
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Slider.adaptive(
                    min: 0,
                    max: widget.intensIsLux.text.isEmpty
                        ? 100
                        : widget.intensIsLux.text == "0"
                            ? 100
                            : 65,
                    value: double.parse(widget.intensite.text.isEmpty ? "0.0" : widget.intensite.text),
                    onChanged: (value) {
                      setState(() {
                        widget.intensite.text = value.toStringAsFixed(2);
                      });
                    },
                  ),
                ),
                Text(
                  double.parse(widget.intensite.text.isEmpty ? "0" : widget.intensite.text).toStringAsFixed(2),
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ],
            ),
            const SizedBox(height: 13),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                    ),
                    onPressed: () {
                      setState(() {
                        if (validateInputs()) {
                          AlertsDialog.callSnackBars(context, "succès", true);
                        } else {
                          AlertsDialog.callSnackBars(context, "Echec", false);
                          validateAmbiance = false;
                        }
                      });
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Verifier",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      AlertsDialog.verifyInfoDialog(context);
                    },
                    icon: const Icon(Icons.info, color: Colors.lightBlue))
              ],
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: widget.color,
                    ),
                    onPressed: () {
                      setState(() {
                        if (validateInputs()) {
                          validateAmbiance = !validateAmbiance;
                          widget.ambianceValidator(validateAmbiance);
                        } else {
                          validateAmbiance = false;
                          widget.ambianceValidator(false);
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Valider",
                          style: TextStyle(color: Colors.white),
                        ),
                        Checkbox.adaptive(
                          value: validateAmbiance,
                          onChanged: (val) {
                            setState(() {
                              if (validateInputs()) {
                                validateAmbiance = val ?? false;
                                widget.ambianceValidator(val ?? false);
                              } else {
                                validateAmbiance = false;
                                widget.ambianceValidator(false);
                              }
                            });
                          },
                          activeColor: Colors.white,
                          checkColor: widget.color,
                          fillColor: WidgetStateProperty.all<Color>(Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      AlertsDialog.verifyAndValidInfoDialog(context);
                    },
                    icon: const Icon(Icons.info, color: Colors.lightBlue))
              ],
            )
          ],
        ),
      ),
    );
  }
}
