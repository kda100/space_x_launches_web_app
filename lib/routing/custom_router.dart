import 'package:flutter/material.dart';
import 'package:js/js.dart';
import '../models/route_data.dart';
import '../pages/next_launch_countdown_page.dart';
import '../pages/upcoming_launches_page.dart';
import 'routes.dart';

@JS("navigateBack")
external void navigateBack();

///custom router that controls how the app navigates between screens.

class CustomRouter {
  final List<String> _navigationStack = [nextLaunchCountdownPageRoute];
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

  String get currentRoute => _navigationStack.last;

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
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
      transitionDuration: const Duration(milliseconds: 400),
      settings: RouteSettings(
        name: routeName,
      ),
    );
  }

  ///function to navigate to next page
  void pushNamed(String routeName) async {
    _navigationStack.add(routeName);
    navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  ///function to navigate to page before.
  void pop() {
    if (_navigationStack.length > 1) {
      _navigationStack.removeLast();
      navigatorKey.currentState?.pushReplacementNamed(_navigationStack.last);
    } else {
      navigateBack();
    }
  }
}
