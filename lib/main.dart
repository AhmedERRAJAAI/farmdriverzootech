import 'dart:io';

import 'core/provider/theme_provider.dart';
import 'farmdriver_base/provider/auth_provider.dart';
import 'production/analyses/provider.dart';
import 'production/bilan_partiel/bilan_provider.dart';
import 'production/charts/provider.dart';
import 'production/dashboard/provider/init_provider.dart';
import 'production/etat_production/provider.dart';
import 'production/performaces_table/provider.dart';
import 'production/supplimentation/provider.dart';
import 'production/synthese/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
// Providers
import 'package:provider/provider.dart';
import 'farmdriver_base/screens/auth_check.dart';
// Authentication
import 'farmdriver_base/screens/authentication.dart';
import 'farmdriver_base/src/edit_notification/provider.dart';
import 'farmdriver_base/src/memento/boxes.dart';
import 'farmdriver_base/src/memento/provider.dart';
import 'farmdriver_base/src/memento/reminder.dart';
import 'production/compare_lots_charts.dart/provider.dart';
import 'production/dashboard/provider/feed_provider.dart';
import 'production/dashboard/widgets/charts/provider.dart';
import 'production/data_entry/provider.dart';

// // ZOO-TECH POUSSINIERE SCREENS

void main() async {
  await Hive.initFlutter();
  // Hive.deleteFromDisk();

  Hive.registerAdapter(ReminderAdapter());
  boxReminders = await Hive.openBox<Reminder>('reminderBox');
  HttpOverrides.global = MyHttpOverrides();
  initializeDateFormatting().then((_) {
    runApp(const MainApp());
  });
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => StatisticsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ChartsTableProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => InitProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ProdStatusProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SyntheseProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => TableProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ComparaisionProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => DataEntryProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SupplimentatioProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AnalysesProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ReminderProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => DashChartProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => EditNotificationProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FeedProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => Consumer<ThemeProvider>(
          builder: (ctx, themeProvider, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('fr'), // french
            ],
            home: const AuthCheck(),
            theme: themeProvider.themeData,
            routes: {
              AuthScreen.routeName: (ctx) => const AuthScreen(),
              AuthCheck.routeName: (ctx) => const AuthCheck(),
            },
          ),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
