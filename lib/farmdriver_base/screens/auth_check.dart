import 'package:farmdriverzootech/production/dashboard/production_dashbaord.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import 'authentication.dart';
import 'splash_screen.dart';

class AuthCheck extends StatefulWidget {
  static const routeName = 'auth-check/';
  const AuthCheck({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool _isLoading = true; // To track if the future is still loading

  @override
  void initState() {
    super.initState();
    _tryAutoLogin(); // Call the function to check auth state
  }

  Future<void> _tryAutoLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool isAuthenticated = await authProvider.tryAutoLoginBoolReturn(); // Run your auth check
    if (isAuthenticated) {
      setState(() {
        _isLoading = false; // Stop loading when finished
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen(); // Show SplashScreen while loading
    }

    // After loading, decide which screen to show
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return authProvider.isAuth ? const PorductionDashboard() : const AuthScreen();
  }
}
