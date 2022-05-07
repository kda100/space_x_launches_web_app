import 'package:flutter/material.dart';
import '../models/route_data.dart';
import '../routing/custom_router.dart';

///this provider serves as a communicator between the router and the navigation elements of the app.

class NavigationProvider with ChangeNotifier {
  final CustomRouter _router = CustomRouter();
  @visibleForTesting
  List<RouteData> get routes => _router.routes;
  GlobalKey<NavigatorState> get navigatorKey => _router.navigatorKey;

  ///navigates to a different page.
  void navigateTo(String routeName) async {
    _router.pushNamed(routeName);
  }

  ///navigate back.
  void pop() {
    _router.pop();
  }

  @visibleForTesting
  String get currentRoute => _router.currentRoute;

  ///checks if a route is a current route.
  bool isCurrentRoute(String route) {
    return _router.currentRoute == route;
  }

  ///when a new page is generated listeners are notified and updated.. ie. the navigation side bar.
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    notifyListeners();
    return _router.onGenerateRoute(settings);
  }

  ///only called when app first starts and has an initial route.
  onGenerateInitialRoute() {
    return _router.onGenerateRoute(RouteSettings(name: _router.currentRoute));
  }
}
