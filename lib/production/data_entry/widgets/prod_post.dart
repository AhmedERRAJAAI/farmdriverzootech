// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:farmdriverzootech/production/data_entry/widgets/sub_widgets/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../farmdriver_base/widgets/info_dialog.dart';
import '../../../farmdriver_base/widgets/pickers.dart';
import 'sub_widgets/input_field.dart';

// ignore: must_be_immutable
class ProdPost extends StatefulWidget {
  final Color color;
  final TextEditingController prodNormController;
  final TextEditingController prodDjController;
  final TextEditingController prodBlancController;
  final TextEditingController prodCasseController;
  final TextEditingController prodFelesController;
  final TextEditingController prodElimnController;
  final TextEditingController liquidController;
  final TextEditingController pmoController;
  TextEditingController eggColor;
  TextEditingController eggShell;
  TextEditingController startPick;
  TextEditingController endPick;
  final bool validateProduction;
  final Function productionValidator;
  ProdPost({
    super.key,
    required this.color,
    required this.prodNormController,
    required this.prodDjController,
    required this.prodBlancController,
    required this.prodCasseController,
    required this.prodFelesController,
    required this.prodElimnController,
    required this.liquidController,
    required this.pmoController,
    required this.eggColor,
    required this.eggShell,
    required this.startPick,
    required this.endPick,
    required this.validateProduction,
    required this.productionValidator,
  });

  @override
  State<ProdPost> createState() => _ProdPostState();
}

class _ProdPostState extends State<ProdPost> {
  late bool validateProduction;

  @override
  void initState() {
    validateProduction = widget.validateProduction;
    super.initState();
  }

  void getStartPickingTime(value) {
    setState(() {
      widget.startPick.text = timeOfDayStringifier(value);
    });
  }

  void getEndPickTime(value) {
    setState(() {
      widget.endPick.text = timeOfDayStringifier(value);
    });
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

  Map normauxErrors = {
    "isError": null,
    "errorMsg": null,
  };

  Map djErrors = {
    "isError": null,
    "errorMsg": null,
  };

  Map blancsErrors = {
    "isError": null,
    "errorMsg": null,
  };

  Map casseErrors = {
    "isError": null,
    "errorMsg": null,
  };

  Map felesErrors = {
    "isError": null,
    "errorMsg": null,
  };
  Map eleminesErrors = {
    "isError": null,
    "errorMsg": null,
  };
  Map liquidErrors = {
    "isError": null,
    "errorMsg": null,
  };
  Map pmoErrors = {
    "isError": null,
    "errorMsg": null,
  };

// input validator
  bool validateInputs() {
    bool checker = true;
    // Validate production normaux
    if (widget.prodNormController.text.isNotEmpty) {
      try {
        int.parse(widget.prodNormController.text);
        normauxErrors.clear();
      } catch (e) {
        checker = false;
        setState(() {
          normauxErrors["isError"] = true;
          normauxErrors["errorMsg"] = "la valeur du champ doit être un nombre entier";
        });
      }
    }

    // Validate DJ
    if (widget.prodDjController.text.isNotEmpty) {
      try {
        int.parse(widget.prodDjController.text);
        djErrors.clear();
      } catch (e) {
        checker = false;
        setState(() {
          djErrors["isError"] = true;
          djErrors["errorMsg"] = "la valeur du champ doit être un nombre entier";
        });
      }
    }

    // Validate blancs
    if (widget.prodBlancController.text.isNotEmpty) {
      try {
        int.parse(widget.prodBlancController.text);
        blancsErrors.clear();
      } catch (e) {
        checker = false;
        setState(() {
          blancsErrors["isError"] = true;
          blancsErrors["errorMsg"] = "la valeur du champ doit être un nombre entier";
        });
      }
    }
    // Validate cassé
    if (widget.prodCasseController.text.isNotEmpty) {
      try {
        int.parse(widget.prodCasseController.text);
        casseErrors.clear();
      } catch (e) {
        checker = false;
        setState(() {
          casseErrors["isError"] = true;
          casseErrors["errorMsg"] = "la valeur du champ doit être un nombre entier";
        });
      }
    }
    // Validate feles
    if (widget.prodFelesController.text.isNotEmpty) {
      try {
        int.parse(widget.prodFelesController.text);
        felesErrors.clear();
      } catch (e) {
        checker = false;
        setState(() {
          felesErrors["isError"] = true;
          felesErrors["errorMsg"] = "la valeur du champ doit être un nombre entier";
        });
      }
    }

    // Validate triage
    if (widget.prodElimnController.text.isNotEmpty) {
      try {
        int.parse(widget.prodElimnController.text);
        eleminesErrors.clear();
      } catch (e) {
        checker = false;
        setState(() {
          eleminesErrors["isError"] = true;
          eleminesErrors["errorMsg"] = "la valeur du champ doit être un nombre entier";
        });
      }
    }

    // Validate liquide
    if (widget.liquidController.text.isNotEmpty) {
      var number = num.tryParse(widget.liquidController.text);
      if (number != null) {
        liquidErrors.clear();
      } else {
        checker = false;
        setState(() {
          liquidErrors["isError"] = true;
          liquidErrors["errorMsg"] = "la valeur du champ doit être un nombre";
        });
      }
    }

    // Validate pmo
    if (widget.pmoController.text.isNotEmpty) {
      var number = num.tryParse(widget.pmoController.text);
      if (number != null) {
        pmoErrors.clear();
      } else {
        checker = false;
        setState(() {
          pmoErrors["isError"] = true;
          pmoErrors["errorMsg"] = "la valeur du champ doit être un nombre";
        });
      }
    }
    return checker;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 18, top: 12),
                    child: Text(
                      "Production",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: widget.color, fontSize: 18),
                    )),
                InputFieldItem(
                  inputWidth: deviceSize.width,
                  inputType: TextInputType.number,
                  inputAction: TextInputAction.next,
                  color: widget.color,
                  inputController: widget.prodNormController,
                  label: "Normeaux",
                  isError: normauxErrors["isError"],
                  errorMsg: normauxErrors["errorMsg"],
                ),
                const SizedBox(height: 8),
                InputFieldItem(
                  inputWidth: deviceSize.width,
                  inputType: TextInputType.number,
                  inputAction: TextInputAction.next,
                  color: widget.color,
                  inputController: widget.prodDjController,
                  label: "Double jaune",
                  isError: djErrors["isError"],
                  errorMsg: djErrors["errorMsg"],
                ),
                const SizedBox(height: 8),
                InputFieldItem(
                  inputWidth: deviceSize.width,
                  inputType: TextInputType.number,
                  inputAction: TextInputAction.next,
                  color: widget.color,
                  inputController: widget.prodBlancController,
                  label: "Blancs",
                  isError: blancsErrors["isError"],
                  errorMsg: blancsErrors["errorMsg"],
                ),
                const SizedBox(height: 8),
                InputFieldItem(
                  inputWidth: deviceSize.width,
                  inputType: TextInputType.number,
                  inputAction: TextInputAction.next,
                  color: widget.color,
                  inputController: widget.prodCasseController,
                  label: "Cassés",
                  isError: casseErrors["isError"],
                  errorMsg: casseErrors["errorMsg"],
                ),
                const SizedBox(height: 8),
                InputFieldItem(
                  inputWidth: deviceSize.width,
                  inputType: TextInputType.number,
                  inputAction: TextInputAction.next,
                  color: widget.color,
                  inputController: widget.prodFelesController,
                  label: "Sale",
                  isError: felesErrors["isError"],
                  errorMsg: felesErrors["errorMsg"],
                ),
                const SizedBox(height: 8),
                InputFieldItem(
                  inputWidth: deviceSize.width,
                  inputType: TextInputType.number,
                  inputAction: TextInputAction.next,
                  color: widget.color,
                  inputController: widget.prodElimnController,
                  label: "Triés",
                  isError: eleminesErrors["isError"],
                  errorMsg: eleminesErrors["errorMsg"],
                ),
                const SizedBox(height: 8),
                InputFieldItem(
                  inputWidth: deviceSize.width,
                  inputType: const TextInputType.numberWithOptions(decimal: true),
                  inputAction: TextInputAction.next,
                  color: widget.color,
                  inputController: widget.liquidController,
                  label: "Éliminés (Kg)",
                  isError: liquidErrors["isError"],
                  errorMsg: liquidErrors["errorMsg"],
                ),
                const SizedBox(height: 8),
                InputFieldItem(
                  inputWidth: deviceSize.width,
                  inputType: const TextInputType.numberWithOptions(decimal: true),
                  inputAction: TextInputAction.done,
                  color: widget.color,
                  inputController: widget.pmoController,
                  label: "PMO (g)",
                  isError: pmoErrors["isError"],
                  errorMsg: pmoErrors["errorMsg"],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const Text("Horaire ramassage"),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                        child: TimePickBtn(
                      icon: Icons.play_arrow,
                      timePicker: MaterialPicker.muiTimePicker,
                      getter: getStartPickingTime,
                      initValue: timeOfDayParser(widget.startPick.text),
                      hintText: "Heure début",
                      placeHolder: "Début",
                    )),
                    const SizedBox(width: 10),
                    Expanded(
                        child: TimePickBtn(
                      icon: Icons.pause,
                      timePicker: MaterialPicker.muiTimePicker,
                      getter: getEndPickTime,
                      initValue: timeOfDayParser(widget.endPick.text),
                      hintText: "Heure Fin",
                      placeHolder: "Fin",
                    )),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Qualité coquille",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    RatingBar.builder(
                      initialRating: widget.eggShell.text.isEmpty ? 0 : double.parse(widget.eggShell.text),
                      minRating: 0,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 25,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.egg,
                        color: Colors.orangeAccent,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          widget.eggShell.text = rating.round().toString();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Coloration oeufs",
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                        GestureDetector(
                          onTap: () {
                            AlertsDialog.colorInfoDialog(context);
                          },
                          child: Icon(
                            Icons.info,
                            color: Colors.amberAccent.shade700,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        "70",
                        "80",
                        "90",
                        "100",
                        "110"
                      ]
                          .map(
                            (nbr) => InkWell(
                              onTap: () {
                                setState(() {
                                  widget.eggColor.text = nbr;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 3),
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(color: widget.eggColor.text == nbr ? Colors.green : Colors.grey, borderRadius: BorderRadius.circular(40)),
                                child: Center(child: Text(nbr)),
                              ),
                            ),
                          )
                          .toList(),
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
                              validateProduction = false;
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
                              validateProduction = !validateProduction;
                              widget.productionValidator(validateProduction);
                            } else {
                              validateProduction = false;
                              widget.productionValidator(false);
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Vérifier & Valider",
                              style: TextStyle(color: Colors.white),
                            ),
                            Checkbox.adaptive(
                              value: validateProduction,
                              onChanged: (val) {
                                setState(() {
                                  if (validateInputs()) {
                                    validateProduction = val ?? false;
                                    widget.productionValidator(val ?? false);
                                  } else {
                                    validateProduction = false;
                                    widget.productionValidator(false);
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
                      icon: const Icon(Icons.info, color: Colors.lightBlue),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
