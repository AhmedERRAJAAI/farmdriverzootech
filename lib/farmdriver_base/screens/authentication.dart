import 'package:farmdriverzootech/farmdriver_base/provider/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'forgot_password.dart';
import '../widgets/poppup_serfaces.dart';
// import 'package:vibration/vibration.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = 'auth-screen/';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController identifiant = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool isLoading = false;
  bool _obscureText = true;
  // final bool _shouldPaintSurface = true;

  @override
  void initState() {
    Provider.of<AuthProvider>(context, listen: false).logout();
    super.initState();
  }

  void loginFunc(context, data) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false).login(data['username'], data['password']).then((_) {
        Navigator.of(context).pushNamed("auth-check/");
      });
    } catch (e) {
      await showDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text(
            'Échec de connexion',
            style: TextStyle(color: Colors.deepOrange),
          ),
          content: Text(e.toString().split(": ")[1]),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget getForgetPwdPage() {
    return const ForgotPwdScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                    Text("Farmdriver", style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 45)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Layer", style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 40, color: Colors.blue)),
                        Icon(
                          Icons.egg,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 30),
                      child: Text(
                        "Connectez-vous pour continuer",
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
                              keyboardType: TextInputType.text,
                              cursorHeight: 23,
                              controller: identifiant,
                              clearButtonMode: OverlayVisibilityMode.always,
                              cursorOpacityAnimates: true,
                              style: TextStyle(color: Theme.of(context).primaryColorDark),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Theme.of(context).primaryColorLight,
                              ),
                              placeholder: "identifiant",
                              placeholderStyle: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            height: 43,
                            child: CupertinoTextField(
                              keyboardType: TextInputType.visiblePassword,
                              cursorHeight: 23,
                              controller: password,
                              clearButtonMode: OverlayVisibilityMode.always,
                              cursorOpacityAnimates: true,
                              style: TextStyle(color: Theme.of(context).primaryColorDark),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              placeholder: "********",
                              placeholderStyle: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color),
                              obscureText: _obscureText,
                              suffix: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5, right: 8),
                                  child: Icon(
                                    _obscureText ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                                    size: 19,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 42),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(backgroundColor: Colors.blue),
                              onPressed: () {
                                loginFunc(context, {
                                  "username": identifiant.text,
                                  "password": password.text
                                });
                              },
                              child: isLoading
                                  ? const CupertinoActivityIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Se connecter",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                                    ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              PoppupSerfaces.showPopupSurface(context, getForgetPwdPage, MediaQuery.of(context).size.height - 100, false);
                            },
                            child: Text(
                              "Mot de passe oublié ?",
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 12,
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
      ),
    );
  }
}
