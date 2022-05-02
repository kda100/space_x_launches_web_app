import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_web_project/models/route_data.dart';
import 'package:spacex_web_project/pages/next_launch_countdown_page.dart';
import 'package:spacex_web_project/providers/navigation_provider.dart';
import 'package:spacex_web_project/routing/routes.dart';
import 'package:spacex_web_project/widgets/navigation_side_bar.dart';

import '../helpers_for_tests/widgets/navigation_side_bar_tester_widget.dart';

void testCurrentRouteTextWidget(Text textWidget) {
  expect(textWidget.style?.color, Colors.black);
  expect(textWidget.style?.fontWeight, FontWeight.bold);
}

void testNotCurrentRouteTextWidget(Text textWidget) {
  expect(textWidget.style?.color, Colors.grey);
  expect(textWidget.style?.fontWeight, FontWeight.normal);
}

void main() {
  group("Navigation Side Bar Tests - ", () {
    testWidgets(
        "Initial page shown in navigation is Next Upcoming Launch when widget is built",
        (WidgetTester tester) async {
      await tester.pumpWidget(NavigationSideBarTesterWidget());
      await tester.pump(const Duration(seconds: 1));
      testCurrentRouteTextWidget(
          tester.firstWidget(find.text(nextLaunchCountdownPageName)));
      testNotCurrentRouteTextWidget(
          tester.firstWidget(find.text(upcomingLaunchesPageName)));
      expect(find.byType(NavigationSideBar), findsOneWidget);
      expect(find.byType(NextLaunchCountdownPage), findsOneWidget);
    });

    testWidgets(
        "When list tiles in side navigation bar are tapped screen navigates to right page, then side bar updates to reflect the current page",
        (WidgetTester tester) async {
      final NavigationProvider navigationProvider = NavigationProvider();
      await tester.pumpWidget(
        NavigationSideBarTesterWidget(
          navigationProvider: navigationProvider,
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      //iterates over all routes to check tapping it navigates to right page.
      for (RouteData routeDataMain in navigationProvider.routes.reversed) {
        await tester.tap(
          find.byKey(
            Key(routeDataMain.pageName),
          ),
        );
        await tester.pumpAndSettle();
        testCurrentRouteTextWidget(
            tester.firstWidget(find.text(routeDataMain.pageName)));
        for (RouteData routeDataOther in navigationProvider.routes) {
          if (routeDataMain != routeDataOther) {
            testNotCurrentRouteTextWidget(
                tester.firstWidget(find.text(routeDataOther.pageName)));
          }
        }
        expect(find.byKey(Key(routeDataMain.pageRoute)), findsOneWidget);
        expect(navigationProvider.currentRoute, routeDataMain.pageRoute);
      }
    });
  });
}
