import 'package:flutter/material.dart';
import '../models/route_data.dart';
import '../routing/custom_router.dart';
import '../routing/routes.dart';

///this provider serves as a communicator between the router and the navigation elements of the app.

class NavigationProvider with ChangeNotifier {
  final CustomRouter _router = CustomRouter();
  @visibleForTesting
  String currentRoute = nextLaunchCountdownPageRoute;

  List<RouteData> get routes => _router.routes;
  GlobalKey<NavigatorState> get navigatorKey => _router.navigatorKey;
  String get getCurrentPage => currentRoute;

  ///navigates to a different page.
  void navigateTo(String routeName) async {
    _router.pushNamed(routeName);
  }

  ///checks if a route is a current route.
  bool isCurrentRoute(String route) {
    return currentRoute == route;
  }

  ///when a new page is generated listeners are notified and updated.. ie. the navigation side bar.
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    currentRoute = settings.name!;
    notifyListeners();
    return _router.onGenerateRoute(settings);
  }

  ///only called when app first starts and has an initial route.
  onGenerateInitialRoute() {
    return _router.onGenerateRoute(RouteSettings(name: currentRoute));
  }
}
