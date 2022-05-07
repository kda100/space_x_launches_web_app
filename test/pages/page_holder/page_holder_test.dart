import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_web_project/constants/sizes.dart';
import 'package:spacex_web_project/models/api_response.dart';
import 'package:spacex_web_project/pages/page_holder/page_holder.dart';

import '../../helpers_for_tests/mocks/custom_upcoming_launches_provider.dart';
import '../../helpers_for_tests/wrappers/widget_tester_wrapper.dart';

void main() {
  group(
    "Page Holder Tests - ",
    () {
      testWidgets(
          "when initialised a circular progress indicator placeholder is shown",
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetTesterWrapper(
            widget: PageHolder(child: const SizedBox()),
          ),
        );
        await tester.pump(const Duration(seconds: 1));
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
      testWidgets(
          "when api response is an error screen rebuilds to show a image",
          (WidgetTester tester) async {
        final CustomUpcomingLaunchesProvider customUpcomingLaunchesProvider =
            CustomUpcomingLaunchesProvider();
        await tester.pumpWidget(
          WidgetTesterWrapper(
            upcomingLaunchesProvider: customUpcomingLaunchesProvider,
            widget: PageHolder(child: const SizedBox()),
          ),
        );
        await tester.pump(const Duration(seconds: 1));
        customUpcomingLaunchesProvider.apiResponse = ApiResponse.error();
        customUpcomingLaunchesProvider
            .notifyListeners(); //rebuild widget after api response is error
        await tester.pump();
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets(
        "when screen size is small and api response becomes a success widget rebuilds to produce a scaffold with the navigation side bar as a drawer",
        (WidgetTester tester) async {
          final CustomUpcomingLaunchesProvider customUpcomingLaunchesProvider =
              CustomUpcomingLaunchesProvider();
          await tester.pumpWidget(
            WidgetTesterWrapper(
                upcomingLaunchesProvider: customUpcomingLaunchesProvider,
                widget: PageHolder(child: const SizedBox()),
                screenWidth: kLargeScreenWidth - 1),
          );
          await tester.pump(const Duration(seconds: 1));
          customUpcomingLaunchesProvider.apiResponse = ApiResponse.success();
          customUpcomingLaunchesProvider.notifyListeners();
          await tester.pump();

          final ScaffoldState state = tester.firstState(find.byType(Scaffold));
          expect(find.byType(Scaffold), findsOneWidget);
          expect(state.hasDrawer, true);
        },
      );

      testWidgets(
        "when screen size is large and api response becomes a success page holder rebuilds to a scaffold without a drawer.",
        (WidgetTester tester) async {
          final CustomUpcomingLaunchesProvider customUpcomingLaunchesProvider =
              CustomUpcomingLaunchesProvider();
          await tester.pumpWidget(
            WidgetTesterWrapper(
                upcomingLaunchesProvider: customUpcomingLaunchesProvider,
                widget: PageHolder(child: const SizedBox()),
                screenWidth: kLargeScreenWidth + 1),
          );
          await tester.pump(const Duration(seconds: 1));
          customUpcomingLaunchesProvider.apiResponse = ApiResponse.success();
          customUpcomingLaunchesProvider.notifyListeners();
          await tester.pump();

          final ScaffoldState state = tester.firstState(find.byType(Scaffold));
          expect(find.byType(Scaffold), findsOneWidget);
          expect(state.hasDrawer, false);
        },
      );
    },
  );
}
