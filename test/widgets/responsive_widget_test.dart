import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_web_project/constants/sizes.dart';
import 'package:spacex_web_project/widgets/responsive_widget.dart';

import '../helpers_for_tests/wrappers/widget_tester_wrapper.dart';

void main() {
  group(
    "Testing ResponsiveWidget",
    () {
      const String largeScreenText = "This is large screen";
      const String smallScreenText = "This is small screen";

      testWidgets(
        "when screen is large, only large screen widget is built",
        (WidgetTester tester) async {
          await tester.pumpWidget(
            WidgetTesterWrapper(
              screenWidth: kLargeScreenWidth + 1,
              widget: ResponsiveWidget(
                largeScreenWidget: const Text(largeScreenText),
                smallScreenWidget: const Text(smallScreenText),
              ),
            ),
          );
          expect(find.text(largeScreenText), findsOneWidget);
          expect(find.text(smallScreenText), findsNothing);
        },
      );

      testWidgets(
        "when screen is large, only large screen widget is built",
        (WidgetTester tester) async {
          await tester.pumpWidget(
            WidgetTesterWrapper(
              screenWidth: kLargeScreenWidth - 1,
              widget: ResponsiveWidget(
                largeScreenWidget: const Text(largeScreenText),
                smallScreenWidget: const Text(smallScreenText),
              ),
            ),
          );
          expect(find.text(largeScreenText), findsNothing);
          expect(find.text(smallScreenText), findsOneWidget);
        },
      );

      testWidgets(
        "When no small screen argument made into responsive widget large screen is produced when screen width is small",
        (WidgetTester tester) async {
          await tester.pumpWidget(
            WidgetTesterWrapper(
              screenWidth: kLargeScreenWidth - 1,
              widget: ResponsiveWidget(
                largeScreenWidget: const Text(largeScreenText),
              ),
            ),
          );
          expect(find.text(largeScreenText), findsOneWidget);
        },
      );
    },
  );
}
