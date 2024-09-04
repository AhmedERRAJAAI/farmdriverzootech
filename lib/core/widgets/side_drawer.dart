import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../farmdriver_base/provider/auth_provider.dart';

class SideDrawer extends StatelessWidget {
  final Function toggleLightMode;
  final bool isPouss;
  final List<RouteMenuItem> routes;
  const SideDrawer({
    super.key,
    required this.toggleLightMode,
    required this.routes,
    required this.isPouss,
  });

  goToPage(BuildContext ctx, routeName) {
    Navigator.of(ctx).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: 60,
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "FARM DRIVER",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        " by SAVAS",
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  toggleLightMode();
                },
                icon: const Icon(Icons.light_mode),
              )
            ],
          ),
          const SizedBox(height: 15),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: routes.map((route) {
                return RouteWidget(route: route, goToPage: goToPage);
              }).toList(),
            ),
          )),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(
              "LOGOUT",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushNamed("auth-check/");
            },
          ),
        ]),
      ),
    );
  }
}

class RouteMenuItem {
  final String route;
  final String name;
  final IconData icon;

  RouteMenuItem({
    required this.route,
    required this.name,
    required this.icon,
  });
}

class RouteWidget extends StatelessWidget {
  final RouteMenuItem route;
  final Function goToPage;
  const RouteWidget({super.key, required this.route, required this.goToPage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            goToPage(context, route.route);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(children: [
              Icon(
                route.icon,
                size: 25,
              ),
              const SizedBox(width: 16),
              Text(
                route.name,
                style: Theme.of(context).textTheme.headlineSmall,
                overflow: TextOverflow.ellipsis,
              )
            ]),
          ),
        ),
        const Divider()
      ],
    );
  }
}
