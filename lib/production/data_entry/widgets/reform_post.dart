import 'package:farmdriverzootech/farmdriver_base/widgets/info_dialog.dart';
import 'package:flutter/material.dart';

import 'sub_widgets/input_field.dart';

// ignore: must_be_immutable
class ReformPost extends StatefulWidget {
  final Color color;
  final TextEditingController hensNormalRef;
  final TextEditingController hensNormalRefPrice;
  final TextEditingController hensTriageRef;
  final TextEditingController hensTriageRefPrice;
  final TextEditingController hensFreeRef;
  final bool normalHensIsKg; //0 || 1
  final bool triageHensIsKg; //0 || 1
  final bool validateReforme;
  final Function reformValidator;
  final Function setNormalUnit;
  final Function setTriageUnit;
  const ReformPost({
    super.key,
    required this.color,
    required this.hensNormalRef,
    required this.hensNormalRefPrice,
    required this.hensTriageRef,
    required this.hensTriageRefPrice,
    required this.hensFreeRef,
    required this.normalHensIsKg,
    required this.triageHensIsKg,
    required this.reformValidator,
    required this.setNormalUnit,
    required this.setTriageUnit,
    required this.validateReforme,
  });

  @override
  State<ReformPost> createState() => _ReformPostState();
}

class _ReformPostState extends State<ReformPost> {
  late bool validateReforme;
  bool normauxIsKg = false;
  bool triageIsKg = false;
  @override
  void initState() {
    validateReforme = widget.validateReforme;
    normauxIsKg = widget.normalHensIsKg;
    triageIsKg = widget.triageHensIsKg;
    super.initState();
  }

  Map normalErrors = {
    "isError": null,
    "errorMsg": null,
  };

  Map triageErrors = {
    "isError": null,
    "errorMsg": null,
  };

  Map normalPriceErrors = {
    "isError": null,
    "errorMsg": null,
  };

  Map triagePriceErrors = {
    "isError": null,
    "errorMsg": null,
  };

// input validator
  bool validateInputs() {
    bool checker = true;
    // Validate ref normal
    if (widget.hensNormalRef.text.isNotEmpty) {
      try {
        int.parse(widget.hensNormalRef.text);
        normalErrors.clear();
      } catch (e) {
        checker = false;
        setState(() {
          normalErrors["isError"] = true;
          normalErrors["errorMsg"] = "la valeur du champ doit être un nombre entier";
        });
      }
    } else {
      normalErrors.clear();
    }
// Validate ref triage
    if (widget.hensTriageRef.text.isNotEmpty) {
      try {
        int.parse(widget.hensTriageRef.text);
        triageErrors.clear();
      } catch (e) {
        checker = false;
        setState(() {
          triageErrors["isError"] = true;
          triageErrors["errorMsg"] = "la valeur du champ doit être un nombre entier";
        });
      }
    } else {
      triageErrors.clear();
    }
// Validate ref normal price
    if (widget.hensNormalRefPrice.text.isNotEmpty) {
      var number = num.tryParse(widget.hensNormalRefPrice.text);
      if (number != null) {
        normalPriceErrors.clear();
      } else {
        checker = false;
        setState(() {
          normalPriceErrors["isError"] = true;
          normalPriceErrors["errorMsg"] = "la valeur du champ doit être un nombre";
        });
      }
    } else {
      normalPriceErrors.clear();
    }

    if (widget.hensTriageRefPrice.text.isNotEmpty) {
      var number = num.tryParse(widget.hensTriageRefPrice.text);
      if (number != null) {
        triagePriceErrors.clear();
      } else {
        checker = false;
        setState(() {
          triagePriceErrors["isError"] = true;
          triagePriceErrors["errorMsg"] = "la valeur du champ doit être un nombre";
        });
      }
    }
    return checker;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 18, top: 12),
                child: Text(
                  "Réforme",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: widget.color, fontSize: 18),
                ),
              ),
              const Divider(),
              const Text("Sujets normaux"),
              InputFieldItem(
                inputWidth: deviceSize.width,
                inputType: TextInputType.number,
                inputAction: TextInputAction.next,
                color: widget.color,
                inputController: widget.hensNormalRef,
                label: "Sujets normaux (Nombre)",
                isError: normalErrors["isError"],
                errorMsg: normalErrors["errorMsg"],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("poule", style: Theme.of(context).textTheme.bodySmall),
                      Switch(
                        value: normauxIsKg,
                        onChanged: (val) {
                          setState(() {
                            normauxIsKg = val;
                            widget.setNormalUnit(val);
                          });
                        },
                      ),
                      Text("Kg", style: Theme.of(context).textTheme.bodySmall)
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InputFieldItem(
                      inputWidth: deviceSize.width / 2,
                      inputType: const TextInputType.numberWithOptions(decimal: true),
                      inputAction: TextInputAction.next,
                      color: widget.color,
                      inputController: widget.hensNormalRefPrice,
                      label: "Prix unitaire (MAD)",
                      isError: normalPriceErrors["isError"],
                      errorMsg: normalPriceErrors["errorMsg"],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              const Text("Sujets triés"),
              InputFieldItem(
                inputWidth: deviceSize.width,
                inputType: TextInputType.number,
                inputAction: TextInputAction.next,
                color: widget.color,
                inputController: widget.hensTriageRef,
                label: "Sujets triage (Nombre)",
                isError: triageErrors["isError"],
                errorMsg: triageErrors["errorMsg"],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "poule",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Switch(
                        value: triageIsKg,
                        onChanged: (val) {
                          setState(() {
                            triageIsKg = val;
                            widget.setTriageUnit(val);
                          });
                        },
                      ),
                      Text(
                        "Kg",
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InputFieldItem(
                      inputWidth: deviceSize.width,
                      inputType: const TextInputType.numberWithOptions(decimal: true),
                      inputAction: TextInputAction.next,
                      color: widget.color,
                      inputController: widget.hensTriageRefPrice,
                      label: "Prix unitaire (MAD)",
                      isError: triagePriceErrors["isError"],
                      errorMsg: triagePriceErrors["errorMsg"],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              const Text("Sujets gratuits"),
              InputFieldItem(
                inputWidth: deviceSize.width,
                inputType: const TextInputType.numberWithOptions(decimal: true),
                inputAction: TextInputAction.next,
                color: widget.color,
                inputController: widget.hensFreeRef,
                label: "Gratuits (Nombre)",
                isError: triagePriceErrors["isError"],
                errorMsg: triagePriceErrors["errorMsg"],
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
                            validateReforme = false;
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
                            validateReforme = !validateReforme;
                            widget.reformValidator(validateReforme);
                          } else {
                            validateReforme = false;
                            widget.reformValidator(false);
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
                            value: validateReforme,
                            onChanged: (val) {
                              setState(() {
                                if (validateInputs()) {
                                  validateReforme = val ?? false;
                                  widget.reformValidator(val ?? false);
                                } else {
                                  validateReforme = false;
                                  widget.reformValidator(false);
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
    );
  }
}
