import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:farmdriverzootech/core/notification_controller.dart';
import 'package:farmdriverzootech/core/provider/theme_provider.dart';
import 'package:farmdriverzootech/farmdriver_base/provider/auth_provider.dart';
import 'package:farmdriverzootech/farmdriver_base/screens/weather_screen.dart';
import 'package:farmdriverzootech/farmdriver_base/src/edit_notification/edit_notification_screen.dart';
import 'package:farmdriverzootech/farmdriver_base/src/notifier/firebase_api.dart';
import 'package:farmdriverzootech/farmdriver_base/widgets/poppup_serfaces.dart';
import 'package:farmdriverzootech/firebase_options.dart';
import 'package:farmdriverzootech/production/dashboard/widgets/add_post.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/side_drawer.dart';
// consts
import 'prod_consts.dart';
import 'screens/dashboard_screen.dart';
import 'screens/news_feed_screen.dart';
import 'widgets/segmented_tabs.dart';
// widgets
import 'widgets/sub-wigets/circular_image.dart';

class PorductionDashboard extends StatefulWidget {
  const PorductionDashboard({super.key});

  @override
  State<PorductionDashboard> createState() => _PorductionDashboardState();
}

class _PorductionDashboardState extends State<PorductionDashboard> {
  final GlobalKey<DashboardScreenState> _childKey = GlobalKey<DashboardScreenState>();
  int pageIndex = 0;
  void switchScreens(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  // Refresh
  Future<void> refresh() async {
    _childKey.currentState?.childFunction(); // Access and call the child's function
  }

  @override
  void initState() {
    initializeNotification();
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceived,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
    );
    super.initState();
  }

  void initializeNotification() async {
    await AwesomeNotifications().initialize('resource://drawable/res_app_icon', [
      NotificationChannel(
        channelKey: "reminder_channel_key",
        channelName: "reminder_channel",
        channelDescription: "sends local reminders notifications",
        channelGroupKey: "weather_channel_group_key",
      ),
      NotificationChannel(
        channelKey: "weather_channel_key",
        channelName: "weather_channel",
        channelDescription: "Weather notification channel",
        channelGroupKey: "weather_channel_group_key",
        enableLights: true,
      ),
    ], channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: "reminder_channel_group_key",
        channelGroupName: "Reminders Group",
      )
    ]);
    bool isAllowedToSendNotifications = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowedToSendNotifications) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await Future.delayed(const Duration(seconds: 1));
    await FirebaseApi().initNotification(context);

  }

  Widget getAddPostPage() {
    return const AddPost();
  }

  @override
  Widget build(BuildContext context) {
    final initData = Provider.of<AuthProvider>(context).initData;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        title: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              child: Row(
                children: [
                  const Icon(Icons.arrow_forward_ios),
                  Text(
                    initData["eleveur_name"] ?? "...",
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    curve: Curves.bounceIn,
                    child: const WeatherScreen(),
                  ),
                );
              },
              icon: Icon(
                Icons.sunny_snowing,
                color: Theme.of(context).primaryColorDark,
              )),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  curve: Curves.bounceIn,
                  child: const EditNotificationScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.notifications_outlined,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 12, bottom: 12, right: 9),
            child: CircularImageWidget(
              width: 31,
              height: 28,
              isAssetImage: true,
              imagePath: 'assets/images/man.png',
            ),
          ),
        ],
      ),
      drawer: SideDrawer(
        isPouss: false,
        toggleLightMode: Provider.of<ThemeProvider>(context, listen: false).toggleTheme,
        routes: const [
          // RouteMenuItem(route: ProdForm.routeName, name: "Enregistrement de données", icon: Icons.edit_note),
        ],
      ),
      body: SafeArea(
        bottom: true,
        top: false,
        right: false,
        left: false,
        child: RefreshIndicator(
          onRefresh: refresh,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SegmentedTabs(children: ProdConsts.children, pageIndex: pageIndex, switchPage: switchScreens),
                ),
                pageIndex == 0 ? DashboardScreen(key: _childKey) : const NewsFeedScreen(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: pageIndex == 1
          ? FloatingActionButton(
              backgroundColor: Colors.amber,
              onPressed: () {
                PoppupSerfaces.showPopupSurface(context, getAddPostPage, MediaQuery.of(context).size.height - 100, false);
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
