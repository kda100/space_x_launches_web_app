import 'package:flutter/material.dart';

import '../models/route_data.dart';
import '../pages/next_launch_countdown_page.dart';
import '../pages/upcoming_launches_page.dart';
import 'routes.dart';

///custom router that controls how the app navigates between screens.

class CustomRouter {
  static final CustomRouter _instance = CustomRouter._(); //singleton.

  CustomRouter._();

  factory CustomRouter() {
    return _instance;
  }

  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>(); //global navigator key for material app.

  final List<RouteData> routes = [
    //route data should reflect the pages available.
    RouteData(
      pageName: nextLaunchCountdownPageName,
      pageRoute: nextLaunchCountdownPageRoute,
    ),
    RouteData(
      pageName: upcomingLaunchesPageName,
      pageRoute: upcomingLaunchesPageRoute,
    ),
  ];

  ///function serves to generate the required screen when user interacts with navigation bar.
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case upcomingLaunchesPageRoute:
        return _getPageRoute(
            const UpcomingLaunchesPage(), upcomingLaunchesPageRoute);
      case nextLaunchCountdownPageRoute:
        return _getPageRoute(
            const NextLaunchCountdownPage(), nextLaunchCountdownPageRoute);
      default:
        return _getPageRoute(
            const NextLaunchCountdownPage(), upcomingLaunchesPageRoute);
    }
  }

  PageRoute _getPageRoute(Widget child, String routeName) {
    return MaterialPageRoute(
        builder: (context) => child,
        settings: RouteSettings(
          name: routeName,
        ));
  }

  ///there is no navigation stack for this app hence...
  void pushNamed(String routeName) async {
    navigatorKey.currentState?.pushReplacementNamed(routeName);
  }
}
