import 'package:farmdriverzootech/farmdriver_base/widgets/info_dialog.dart';
import 'package:flutter/material.dart';

import 'sub_widgets/input_field.dart';

class ConsoPost extends StatefulWidget {
  final TextEditingController consoAltController;
  final TextEditingController consoEauController;
  final bool validateConsommation;
  final Color color;
  final Function consoValidator;
  const ConsoPost({
    super.key,
    required this.color,
    required this.consoAltController,
    required this.consoEauController,
    required this.validateConsommation,
    required this.consoValidator,
  });

  @override
  State<ConsoPost> createState() => _ConsoPostState();
}

class _ConsoPostState extends State<ConsoPost> {
  late bool validateConsommation;
  @override
  void initState() {
    validateConsommation = widget.validateConsommation;
    super.initState();
  }

  Map altErrors = {
    "isError": null,
    "errorMsg": null,
  };

  Map eauErrors = {
    "isError": null,
    "errorMsg": null,
  };

  bool validateInputs() {
    bool checker = true;
    if (widget.consoAltController.text.isNotEmpty) {
      var number = num.tryParse(widget.consoAltController.text);
      if (number != null) {
        altErrors.clear();
      } else {
        checker = false;
        setState(() {
          altErrors["isError"] = true;
          altErrors["errorMsg"] = "la valeur du champ doit être un nombre";
        });
      }
    }

    if (widget.consoEauController.text.isNotEmpty) {
      var number = num.tryParse(widget.consoEauController.text);
      if (number != null) {
        eauErrors.clear();
      } else {
        checker = false;
        setState(() {
          eauErrors["isError"] = true;
          eauErrors["errorMsg"] = "la valeur du champ doit être un nombre";
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 18, top: 12),
              child: Text(
                "Consommation",
                textAlign: TextAlign.center,
                style: TextStyle(color: widget.color, fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            InputFieldItem(
              inputWidth: deviceSize.width,
              inputType: TextInputType.number,
              inputAction: TextInputAction.next,
              color: widget.color,
              inputController: widget.consoAltController,
              label: "Aliment (Kg)",
              isError: altErrors["isError"],
              errorMsg: altErrors["errorMsg"],
            ),
            const SizedBox(height: 8),
            InputFieldItem(
              inputWidth: deviceSize.width,
              inputType: TextInputType.number,
              inputAction: TextInputAction.next,
              color: widget.color,
              inputController: widget.consoEauController,
              label: "Eau (litre)",
              isError: eauErrors["isError"],
              errorMsg: eauErrors["errorMsg"],
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
                          validateConsommation = false;
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
                          validateConsommation = !validateConsommation;
                          widget.consoValidator(validateConsommation);
                        } else {
                          validateConsommation = false;
                          widget.consoValidator(false);
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
                          value: validateConsommation,
                          onChanged: (val) {
                            setState(() {
                              if (validateInputs()) {
                                validateConsommation = val ?? false;
                                widget.consoValidator(val ?? false);
                              } else {
                                validateConsommation = false;
                                widget.consoValidator(false);
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
    );
  }
}
