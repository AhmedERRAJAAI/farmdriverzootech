import 'package:farmdriverzootech/farmdriver_base/widgets/info_dialog.dart';
import 'package:flutter/material.dart';

import 'sub_widgets/input_field.dart';

class LivraisonPost extends StatefulWidget {
  final TextEditingController altLivreeController;
  final TextEditingController altPriceController;
  final TextEditingController consoFormuleController;
  final bool validateLivraison;
  final Color color;
  final Function livraisonValidator;
  const LivraisonPost({
    super.key,
    required this.color,
    required this.altLivreeController,
    required this.consoFormuleController,
    required this.validateLivraison,
    required this.altPriceController,
    required this.livraisonValidator,
  });

  @override
  State<LivraisonPost> createState() => _LivraisonPostState();
}

class _LivraisonPostState extends State<LivraisonPost> {
  late bool validateLivraison;
  @override
  void initState() {
    validateLivraison = widget.validateLivraison;
    super.initState();
  }

  Map altErrors = {
    "isError": null,
    "errorMsg": null,
  };
  Map altPriceErrors = {
    "isError": null,
    "errorMsg": null,
  };

  bool validateInputs() {
    bool checker = true;
    if (widget.altLivreeController.text.isNotEmpty) {
      var number = num.tryParse(widget.altLivreeController.text);
      if (number != null) {
        altErrors.clear();
      } else {
        checker = false;
        setState(() {
          altErrors["isError"] = true;
          altErrors["errorMsg"] = "la valeur du champ doit être un nombre";
        });
      }
    } else {
      altErrors.clear();
    }

    if (widget.altPriceController.text.isNotEmpty) {
      var number = num.tryParse(widget.altPriceController.text);
      if (number != null) {
        altPriceErrors.clear();
      } else {
        checker = false;
        setState(() {
          altPriceErrors["isError"] = true;
          altPriceErrors["errorMsg"] = "la valeur du champ doit être un nombre";
        });
      }
    } else {
      altPriceErrors.clear();
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
                "livraison d'aliment",
                textAlign: TextAlign.center,
                style: TextStyle(color: widget.color, fontSize: 18),
              ),
            ),
            InputFieldItem(
              inputWidth: deviceSize.width,
              inputType: TextInputType.number,
              inputAction: TextInputAction.next,
              color: widget.color,
              inputController: widget.altLivreeController,
              label: "Aliment reçu",
              isError: altErrors["isError"],
              errorMsg: altErrors["errorMsg"],
            ),
            const SizedBox(height: 8),
            InputFieldItem(
              inputWidth: deviceSize.width,
              inputType: TextInputType.number,
              inputAction: TextInputAction.next,
              color: widget.color,
              inputController: widget.altPriceController,
              label: "P.U (MAD/Kg)",
              isError: altPriceErrors["isError"],
              errorMsg: altPriceErrors["errorMsg"],
            ),
            const SizedBox(height: 8),
            InputFieldItem(
              inputWidth: deviceSize.width,
              inputType: TextInputType.text,
              inputAction: TextInputAction.next,
              color: widget.color,
              inputController: widget.consoFormuleController,
              label: "Référence d'aliment",
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
                          validateLivraison = false;
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
                          validateLivraison = !validateLivraison;
                          widget.livraisonValidator(validateLivraison);
                        } else {
                          validateLivraison = false;
                          widget.livraisonValidator(false);
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
                          value: validateLivraison,
                          onChanged: (val) {
                            setState(() {
                              if (validateInputs()) {
                                validateLivraison = val ?? false;
                                widget.livraisonValidator(val ?? false);
                              } else {
                                validateLivraison = false;
                                widget.livraisonValidator(false);
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
