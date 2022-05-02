import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_web_project/models/route_data.dart';
import 'package:spacex_web_project/pages/page_holder/small_screen_width_page_holder.dart';
import 'package:spacex_web_project/routing/custom_router.dart';
import 'package:spacex_web_project/widgets/navigation_side_bar.dart';

import '../../helpers_for_tests/wrappers/widget_tester_wrapper.dart';

void main() {
  group("small screen page holder tests - ", () {
    testWidgets("navigation side bar is not visible",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        WidgetTesterWrapper(
          widget: SmallScreenWidthPageHolder(
            child: const SizedBox(),
          ),
        ),
      );
      expect(find.byType(NavigationSideBar), findsNothing);
    });

    testWidgets(
        "On tap icon button for drawer opens scaffold drawer to show navigation side bar, then tapping one of items closes scaffold",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        WidgetTesterWrapper(
          widget: SmallScreenWidthPageHolder(
            child: const SizedBox(),
          ),
        ),
      );
      final ScaffoldState state = tester.firstState(find.byType(Scaffold));
      expect(find.byType(NavigationSideBar), findsNothing);

      //for each route in drawer test if tapping closes the drawer.
      for (RouteData routeData in CustomRouter().routes) {
        //iterates over routes in custom routes.
        await tester.tap(find.byType(IconButton));
        await tester.pump();
        expect(state.isDrawerOpen, true);
        expect(find.byType(NavigationSideBar), findsOneWidget);
        await tester.ensureVisible(find.byKey(Key(routeData.pageName)));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(Key(routeData.pageName)));
        await tester.pumpAndSettle();
        expect(state.isDrawerOpen, false);
        expect(find.byType(NavigationSideBar), findsNothing);
      }
    });
  });
}
