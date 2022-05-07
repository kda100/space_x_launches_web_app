import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_web_project/constants/colors.dart';
import 'package:spacex_web_project/pages/next_launch_countdown_page.dart';
import 'package:spacex_web_project/pages/page_decoration.dart';
import 'package:spacex_web_project/widgets/next_launch_countdown/next_launch_countdown.dart';
import 'package:flutter/material.dart';
import '../helpers_for_tests/functions/page_tests_helper_functions.dart';
import '../helpers_for_tests/wrappers/loaded_launches_widget_tester_wrapper.dart';

void main() {
  group("Next Launch Page tests - ", () {
    testWidgets("Page decoration is built and colors used are correct",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        LoadedLaunchesWidgetTesterWrapper(
          widget: const NextLaunchCountdownPage(),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(PageDecoration), findsOneWidget);
      final PageDecoration pageDecoration =
          tester.widget(find.byType(PageDecoration));
      PageTestsHelperFunctions.testPageDecorationColors(
        pageDecoration,
        backgroundLightColor: nextLaunchCountdownBackgroundLightColor,
        backgroundDarkColor: nextLaunchCountdownBackgroundDarkColor,
        foregroundLightColor: nextLaunchCountdownForegroundLightColor,
        foregroundDarkColor: nextLaunchCountdownForegroundDarkColor,
        transitionShadowColor: nextLaunchCountdownTransitionShadowColor,
      );
    });

    testWidgets("next launch countdown widget and share button are visible",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        LoadedLaunchesWidgetTesterWrapper(
          widget: const NextLaunchCountdownPage(),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(
        find.byType(NextLaunchCountdown),
        findsOneWidget,
      );
      expect(
          find.byKey(
            const Key(NextLaunchCountdown.shareButtonId),
          ),
          findsOneWidget);
    });
  });
}
