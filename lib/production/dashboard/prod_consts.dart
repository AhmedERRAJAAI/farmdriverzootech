import 'package:flutter/material.dart';

import 'screens/dashboard_screen.dart';
import 'screens/news_feed_screen.dart';

class ProdConsts {
  static const Map<int, Widget> children = <int, Widget>{
    0: Text("Tableau de bord"),
    1: Text("Fil d'actualité"),
  };

  static const Map<int, Widget> screens = {
    0: DashboardScreen(),
    1: NewsFeedScreen(),
  };
}
