import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_web_project/providers/navigation_provider.dart';
import 'package:spacex_web_project/routing/custom_router.dart';
import 'package:spacex_web_project/routing/routes.dart';

void main() {
  group(
    "NavigationProvider initialisation tests - ",
    () {
      final NavigationProvider navigationProvider = NavigationProvider();
      final CustomRouter router = CustomRouter();
      test("first page route is Next Launch Countdown Page Route", () {
        expect(navigationProvider.getCurrentPage, nextLaunchCountdownPageRoute);
      });
      test("routes getter is same as routes in Custom Router class", () {
        expect(navigationProvider.routes, router.routes);
      });
      test(
        "GlobalKey<NavigatorState> getter is same as GlobalKey<NavigatorState> in Custom Router class",
        () {
          expect(navigationProvider.navigatorKey, router.navigatorKey);
        },
      );
    },
  );

  group(
    "Navigation Provider functions tests - ",
    () {
      test(
          "isCurrentRoute function returns correct boolean for the current page",
          () {
        final NavigationProvider navigationProvider = NavigationProvider();
        expect(navigationProvider.isCurrentRoute(nextLaunchCountdownPageRoute),
            true);
        expect(navigationProvider.isCurrentRoute(upcomingLaunchesPageRoute),
            false);

        navigationProvider.currentRoute = upcomingLaunchesPageRoute;
        expect(navigationProvider.isCurrentRoute(nextLaunchCountdownPageRoute),
            false);
        expect(
            navigationProvider.isCurrentRoute(upcomingLaunchesPageRoute), true);
      });

      test(
          "onGenerateRoute changes currentRoute variable and notifies listeners of provider",
          () {
        bool listenerNotified = false;
        final NavigationProvider navigationProvider = NavigationProvider()
          ..addListener(() {
            listenerNotified = true;
          });
        navigationProvider.onGenerateRoute(
            const RouteSettings(name: upcomingLaunchesPageRoute));
        expect(listenerNotified, true);
        expect(navigationProvider.currentRoute, upcomingLaunchesPageRoute);
      });

      test("onGenerateInitialRoute does not notify listeners", () {
        bool listenerNotified = false;
        final NavigationProvider navigationProvider = NavigationProvider()
          ..addListener(() {
            listenerNotified = true;
          });
        navigationProvider.onGenerateInitialRoute();
        expect(listenerNotified, false);
      });
    },
  );
}
