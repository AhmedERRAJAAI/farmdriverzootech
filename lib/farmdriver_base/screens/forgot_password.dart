import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:vibration/vibration.dart';

class ForgotPwdScreen extends StatefulWidget {
  const ForgotPwdScreen({super.key});

  @override
  State<ForgotPwdScreen> createState() => _ForgotPwdScreenState();
}

class _ForgotPwdScreenState extends State<ForgotPwdScreen> {
  final TextEditingController identifiant = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool isLoading = false;

  void forgetPassword(context, data) async {
    // setState(() {
    //   isLoading = true;
    // });
    // try {
    //   await Provider.of<AuthProvider>(context, listen: false).login(data['username'] ?? '', data['password'] ?? '');
    // } catch (e) {
    //   await showDialog(
    //     context: context,
    //     builder: (ctx) => CupertinoAlertDialog(
    //       title: const Text('Erreur'),
    //       content: Text(e.toString().split(": ")[1]),
    //       actions: <Widget>[
    //         TextButton(
    //           child: const Text('OK'),
    //           onPressed: () {
    //             Navigator.of(ctx).pop();
    //           },
    //         )
    //       ],
    //     ),
    //   );
    // } finally {
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Réinitialisation", style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 45)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Mot de passe", style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 40, color: Colors.blue)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 30),
                    child: Text(
                      "Entrez votre adresse e-mail",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 43,
                          child: CupertinoTextField(
                            keyboardType: TextInputType.emailAddress,
                            cursorHeight: 23,
                            controller: identifiant,
                            clearButtonMode: OverlayVisibilityMode.always,
                            cursorOpacityAnimates: true,
                            style: TextStyle(color: Theme.of(context).primaryColorDark),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            placeholder: "E-mail",
                            placeholderStyle: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color),
                          ),
                        ),
                        const SizedBox(height: 42),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(backgroundColor: Colors.blue),
                            onPressed: () {
                              forgetPassword(context, {
                                "username": identifiant.text,
                                "password": password.text
                              });
                            },
                            child: isLoading
                                ? const CupertinoActivityIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Soumettre",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "SAVAS POULTRY ADVISING",
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  Icon(
                    Icons.copyright,
                    color: Theme.of(context).primaryColor,
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
