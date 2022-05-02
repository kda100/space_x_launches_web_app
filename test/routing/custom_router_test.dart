import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_web_project/routing/custom_router.dart';
import 'package:spacex_web_project/routing/routes.dart';

void main() {
  group("CustomRouter tests initialisation tests", () {
    final CustomRouter router = CustomRouter();
    test(
      "Is a singleton",
      () {
        expect(router == CustomRouter(), true);
      },
    );

    test(
      "contains a global key of type navigator state",
      () {
        expect(router.navigatorKey is GlobalKey<NavigatorState>, true);
      },
    );

    test("length of routes are correct", () {
      final routes = router.routes;
      expect(routes.length, routesLen);
    });

    test(
        "next launch countdown route data is the first route in list of routes",
        () {
      final routes = router.routes;
      expect(routes[0].pageRoute, nextLaunchCountdownPageRoute);
      expect(routes[0].pageName, nextLaunchCountdownPageName);
    });
  });
}
