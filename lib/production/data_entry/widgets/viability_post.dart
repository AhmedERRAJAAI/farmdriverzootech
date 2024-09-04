import 'package:farmdriverzootech/farmdriver_base/widgets/info_dialog.dart';
import 'package:flutter/material.dart';

import 'sub_widgets/input_field.dart';

// ignore: must_be_immutable
class ViabilityPost extends StatefulWidget {
  final Color color;
  final TextEditingController mortController;
  final TextEditingController sujetElimController;
  final TextEditingController poidsVifController;
  final TextEditingController homogController;
  final Function viabiliteValidator;
  final bool validateViabilite;
  const ViabilityPost({
    super.key,
    required this.color,
    required this.mortController,
    required this.sujetElimController,
    required this.poidsVifController,
    required this.homogController,
    required this.viabiliteValidator,
    required this.validateViabilite,
  });

  @override
  State<ViabilityPost> createState() => _ViabilityPostState();
}

class _ViabilityPostState extends State<ViabilityPost> {
  bool validateViabilite = false;
  @override
  void initState() {
    validateViabilite = widget.validateViabilite;
    super.initState();
  }

  Map mortErrors = {
    "isError": null,
    "errorMsg": null,
  };

  Map triageErrors = {
    "isError": null,
    "errorMsg": null,
  };

  Map pvErrors = {
    "isError": null,
    "errorMsg": null,
  };

  Map homogErrors = {
    "isError": null,
    "errorMsg": null,
  };

// input validator
  bool validateInputs() {
    bool checker = true;
    // Validate mmortalité
    if (widget.mortController.text.isNotEmpty) {
      try {
        int.parse(widget.mortController.text);
        mortErrors.clear();
      } catch (e) {
        checker = false;
        setState(() {
          mortErrors["isError"] = true;
          mortErrors["errorMsg"] = "la valeur du champ doit être un nombre entier";
        });
      }
    }

    // Validate triage
    if (widget.sujetElimController.text.isNotEmpty) {
      try {
        int.parse(widget.sujetElimController.text);
        triageErrors.clear();
      } catch (e) {
        checker = false;
        setState(() {
          triageErrors["isError"] = true;
          triageErrors["errorMsg"] = "la valeur du champ doit être un nombre entier";
        });
      }
    }

    // Validate poidsVif
    if (widget.poidsVifController.text.isNotEmpty) {
      var number = num.tryParse(widget.poidsVifController.text);
      if (number != null) {
        pvErrors.clear();
      } else {
        checker = false;
        setState(() {
          pvErrors["isError"] = true;
          pvErrors["errorMsg"] = "la valeur du champ doit être un nombre";
        });
      }
    }

    // Validate homogenieté
    if (widget.homogController.text.isNotEmpty) {
      var number = num.tryParse(widget.homogController.text);
      if (number != null) {
        homogErrors.clear();
      } else {
        checker = false;
        setState(() {
          homogErrors["isError"] = true;
          homogErrors["errorMsg"] = "la valeur du champ doit être un nombre";
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
              const Padding(
                padding: EdgeInsets.only(bottom: 18, top: 12),
                child: Text(
                  "Viabilité",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.purple, fontSize: 18),
                ),
              ),
              InputFieldItem(
                inputWidth: deviceSize.width,
                inputType: TextInputType.number,
                inputAction: TextInputAction.next,
                color: widget.color,
                inputController: widget.mortController,
                label: "Mortalité (Nombre)",
                isError: mortErrors["isError"],
                errorMsg: mortErrors["errorMsg"],
              ),
              const SizedBox(height: 8),
              InputFieldItem(
                inputWidth: deviceSize.width,
                inputType: TextInputType.number,
                inputAction: TextInputAction.next,
                color: widget.color,
                inputController: widget.sujetElimController,
                label: "Triage (Nombre)",
                isError: triageErrors["isError"],
                errorMsg: triageErrors["errorMsg"],
              ),
              const SizedBox(height: 8),
              InputFieldItem(
                inputWidth: deviceSize.width,
                inputType: const TextInputType.numberWithOptions(decimal: true),
                inputAction: TextInputAction.next,
                color: widget.color,
                inputController: widget.poidsVifController,
                label: "Poids corporel (g)",
                isError: pvErrors["isError"],
                errorMsg: pvErrors["errorMsg"],
              ),
              const SizedBox(height: 8),
              InputFieldItem(
                inputWidth: deviceSize.width,
                inputType: const TextInputType.numberWithOptions(decimal: true),
                inputAction: TextInputAction.next,
                color: widget.color,
                inputController: widget.homogController,
                label: "Homogéniété (%)",
                isError: homogErrors["isError"],
                errorMsg: homogErrors["errorMsg"],
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
                            validateViabilite = false;
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
                        backgroundColor: Colors.purple,
                      ),
                      onPressed: () {
                        setState(() {
                          if (validateInputs()) {
                            validateViabilite = !validateViabilite;
                            widget.viabiliteValidator(validateViabilite);
                          } else {
                            validateViabilite = false;
                            widget.viabiliteValidator(false);
                          }
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Verfier & Valider",
                            style: TextStyle(color: Colors.white),
                          ),
                          Checkbox.adaptive(
                            value: validateViabilite,
                            onChanged: (val) {
                              setState(() {
                                if (validateInputs()) {
                                  validateViabilite = val ?? false;
                                  widget.viabiliteValidator(val ?? false);
                                } else {
                                  validateViabilite = false;
                                  widget.viabiliteValidator(false);
                                }
                              });
                            },
                            activeColor: Colors.white,
                            checkColor: Colors.purple,
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
      ),
    );
  }
}
