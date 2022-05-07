import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_web_project/providers/navigation_provider.dart';

import '../constants/titles.dart';
import '../models/route_data.dart';

class NavigationSideBar extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  NavigationSideBar({this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final NavigationProvider navigationProvider =
        Provider.of<NavigationProvider>(context);
    return ListView(
      children: List.generate(
        navigationProvider.routes.length + 1,
        (index) {
          if (index == 0) {
            return const SizedBox(
              height: 120,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.black),
                child: Text(
                  webPageTitle,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              ),
            );
          } else {
            final RouteData routeData = navigationProvider.routes[index - 1];
            return ListTile(
              key: Key(routeData.pageName),
              title: Text(
                routeData.pageName,
                style: TextStyle(
                  color: navigationProvider.isCurrentRoute(routeData.pageRoute)
                      ? Colors.black
                      : Colors.grey,
                  fontWeight:
                      navigationProvider.isCurrentRoute(routeData.pageRoute)
                          ? FontWeight.bold
                          : FontWeight.normal,
                ),
              ),
              onTap: () {
                scaffoldKey?.currentState?.openEndDrawer();
                if (!navigationProvider.isCurrentRoute(routeData.pageRoute)) {
                  navigationProvider.navigateTo(routeData.pageRoute);
                }
              },
            );
          }
        },
      ),
    );
  }
}
