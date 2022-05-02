import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_web_project/constants/colors.dart';
import 'package:spacex_web_project/pages/page_decoration.dart';
import 'package:spacex_web_project/pages/upcoming_launches_page.dart';
import 'package:spacex_web_project/widgets/upcoming_launches/upcoming_launches_data_table.dart';
import '../helpers_for_tests/functions/page_tests_helper_functions.dart';
import '../helpers_for_tests/wrappers/loaded_launches_widget_tester_wrapper.dart';

void main() {
  group("Upcoming Launches Page tests - ", () {
    testWidgets("Page decoration is built and colors used are correct",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        LoadedLaunchesWidgetTesterWrapper(
          widget: const UpcomingLaunchesPage(),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(PageDecoration), findsOneWidget);
      final PageDecoration pageDecoration =
          tester.widget(find.byType(PageDecoration));
      PageTestsHelperFunctions.testPageDecorationColors(
        pageDecoration,
        backgroundLightColor: upcomingLaunchesBackgroundLightColor,
        backgroundDarkColor: upcomingLaunchesBackgroundDarkColor,
        foregroundLightColor: upcomingLaunchesForegroundLightColor,
        foregroundDarkColor: upcomingLaunchesForegroundDarkColor,
        transitionShadowColor: upcomingLaunchesTransitionShadowColor,
      );
    });

    testWidgets("upcoming launches data table widget is visible",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        LoadedLaunchesWidgetTesterWrapper(
          widget: const UpcomingLaunchesPage(),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(UpcomingLaunchesDataTable), findsOneWidget);
    });
  });
}
