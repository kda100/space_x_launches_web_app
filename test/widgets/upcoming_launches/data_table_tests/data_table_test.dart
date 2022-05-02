import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_web_project/models/api_response.dart';
import 'package:spacex_web_project/models/upcoming_launch.dart';
import 'package:spacex_web_project/widgets/upcoming_launches/custom_data_table.dart';
import 'package:spacex_web_project/widgets/upcoming_launches/upcoming_launches_data_table.dart';

import '../../../helpers_for_tests/functions/upcoming_launches_helper_functions.dart';
import '../../../helpers_for_tests/mocks/custom_upcoming_launches_provider.dart';
import '../../../helpers_for_tests/wrappers/loaded_launches_widget_tester_wrapper.dart';
import '../../../helpers_for_tests/wrappers/widget_tester_wrapper.dart';

void main() {
  group("Upcoming Launches Data Table Tests - ", () {
    testWidgets("Custom Data Table widget is visible",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        LoadedLaunchesWidgetTesterWrapper(widget: UpcomingLaunchesDataTable()),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(CustomDataTable), findsOneWidget);
    });
    testWidgets(
      "Data Table contains all relevant data for each upcoming launch as text data",
      (WidgetTester tester) async {
        final CustomUpcomingLaunchesProvider customUpcomingLaunchesProvider =
            CustomUpcomingLaunchesProvider();
        customUpcomingLaunchesProvider.upcomingLaunches =
            UpcomingLaunchesHelperFunctions.genMockUpcomingLaunchesList(
                numUpcomingLaunches: 100);
        customUpcomingLaunchesProvider.apiResponse = ApiResponse.success();
        await tester.pumpWidget(
          WidgetTesterWrapper(
            upcomingLaunchesProvider: customUpcomingLaunchesProvider,
            widget: Scaffold(
              body: UpcomingLaunchesDataTable(),
            ),
          ),
        );
        await tester.pump(const Duration(seconds: 1));
        //iterates over all upcoming launches to ensure the data/widgets is presented in the data table.
        for (UpcomingLaunch upcomingLaunch
            in customUpcomingLaunchesProvider.upcomingLaunches) {
          expect(find.byKey(Key(upcomingLaunch.missionName)), findsOneWidget);
          expect(find.byKey(Key(upcomingLaunch.dateTime.toString())),
              findsOneWidget);
          expect(find.byKey(Key(upcomingLaunch.launchPad)), findsOneWidget);
        }
      },
    );
  });
}
