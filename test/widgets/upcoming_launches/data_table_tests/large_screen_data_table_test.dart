import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_web_project/constants/data_column_headers.dart';
import 'package:spacex_web_project/constants/sizes.dart';
import 'package:spacex_web_project/models/custom_key.dart';
import 'package:spacex_web_project/models/upcoming_launch.dart';
import 'package:spacex_web_project/widgets/upcoming_launches/custom_data_table.dart';
import 'package:spacex_web_project/widgets/upcoming_launches/upcoming_launches_data_table.dart';

import '../../../helpers_for_tests/functions/upcoming_launches_helper_functions.dart';
import '../../../helpers_for_tests/mocks/custom_upcoming_launches_provider.dart';
import '../../../helpers_for_tests/wrappers/loaded_launches_widget_tester_wrapper.dart';
import '../../../helpers_for_tests/wrappers/widget_tester_wrapper.dart';

void main() {
  group("Large screen data table tests - ", () {
    const testUpcomingLaunchIndex = 0;
    late CustomUpcomingLaunchesProvider customUpcomingLaunchesProvider;
    setUp(() {
      customUpcomingLaunchesProvider = CustomUpcomingLaunchesProvider();
    });
    testWidgets("correct headings for data is used",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        LoadedLaunchesWidgetTesterWrapper(
          screenWidth: kLargeScreenWidth + 1,
          widget: UpcomingLaunchesDataTable(),
        ),
      );
      await tester.pump(const Duration(seconds: 1));

      //gets the Custom Table widget and checks the data columns contain the correct information.
      final CustomDataTable customDataTable =
          tester.widget(find.byType(CustomDataTable));
      expect(customDataTable.dataColumns.length,
          largeScreenWidthDataColumnHeaders.length);
      for (int i = 0; i < largeScreenWidthDataColumnHeaders.length; i++) {
        final Text textWidget = customDataTable.dataColumns[i].label as Text;
        expect(textWidget.data, largeScreenWidthDataColumnHeaders[i]);
      }
    });

    testWidgets(
        "when isFavourite = false for upcoming launch, on tap of favourite icon, ONLY for that upcoming launch, the icon changes from one icon to another",
        (WidgetTester tester) async {
      customUpcomingLaunchesProvider.upcomingLaunches =
          UpcomingLaunchesHelperFunctions.genMockUpcomingLaunchesList(
              numUpcomingLaunches: 5);

      await tester.pumpWidget(
        WidgetTesterWrapper(
          screenWidth: kLargeScreenWidth + 1,
          upcomingLaunchesProvider: customUpcomingLaunchesProvider,
          widget: Scaffold(body: UpcomingLaunchesDataTable()),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      final UpcomingLaunch testUpcomingLaunch = customUpcomingLaunchesProvider
          .getUpcomingLaunch(testUpcomingLaunchIndex);

      await tester.tap(find.byKey(customKey(
          testUpcomingLaunch.missionName, testUpcomingLaunch.isFavourite)));
      await tester.pump();

      //iterates over all upcoming launches and ensures only icon for right data row has been changed and others remained the same.
      for (int i = 0;
          i < customUpcomingLaunchesProvider.getUpcomingLaunchesLen;
          i++) {
        final UpcomingLaunch upcomingLaunch =
            customUpcomingLaunchesProvider.upcomingLaunches[i];
        if (i == testUpcomingLaunchIndex) {
          expect(find.byKey(customKey(upcomingLaunch.missionName, true)),
              findsOneWidget);
          expect(upcomingLaunch.isFavourite, true);
        } else {
          expect(find.byKey(customKey(upcomingLaunch.missionName, false)),
              findsOneWidget);
          expect(upcomingLaunch.isFavourite, false);
        }
      }
    });

    testWidgets(
        "when isFavourite = true for upcoming launch, on tap of favourite icon, ONLY for that upcoming launch, data row the icon changes to another",
        (WidgetTester tester) async {
      customUpcomingLaunchesProvider.upcomingLaunches =
          UpcomingLaunchesHelperFunctions.genMockUpcomingLaunchesList(
              numUpcomingLaunches: 5, isFavourite: true);
      customUpcomingLaunchesProvider.favouriteUpcomingLaunchesIds =
          UpcomingLaunchesHelperFunctions.genMockFavouriteUpcomingLaunchIds(
              numFavouriteLaunchIds: 5);

      await tester.pumpWidget(
        WidgetTesterWrapper(
          screenWidth: kLargeScreenWidth + 1,
          upcomingLaunchesProvider: customUpcomingLaunchesProvider,
          widget: Scaffold(body: UpcomingLaunchesDataTable()),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      final UpcomingLaunch testUpcomingLaunch = customUpcomingLaunchesProvider
          .getUpcomingLaunch(testUpcomingLaunchIndex);

      await tester.tap(find.byKey(customKey(
          testUpcomingLaunch.missionName, testUpcomingLaunch.isFavourite)));
      await tester.pump();

      //iterates over all upcoming launches and ensures only icon for right data row has been changed and others remained the same.
      for (int i = 0;
          i < customUpcomingLaunchesProvider.getUpcomingLaunchesLen;
          i++) {
        final UpcomingLaunch upcomingLaunch =
            customUpcomingLaunchesProvider.upcomingLaunches[i];
        if (i == testUpcomingLaunchIndex) {
          expect(
              find.byKey(customKey(upcomingLaunch.missionName,
                  false)), //use custom key to check visibility of widget.
              findsOneWidget);
          expect(upcomingLaunch.isFavourite, false);
        } else {
          expect(find.byKey(customKey(upcomingLaunch.missionName, true)),
              findsOneWidget);
          expect(upcomingLaunch.isFavourite, true);
        }
      }
    });
  });
}
