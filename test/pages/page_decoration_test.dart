import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_web_project/pages/page_decoration.dart';
import 'package:flutter/material.dart';

import '../helpers_for_tests/wrappers/widget_tester_wrapper.dart';

void main() {
  group("page decoration tests - ", () {
    const String title = "testTitle";
    final Color backgroundLightColor = Colors.blue.shade300;
    final Color backgroundDarkColor = Colors.red.shade300;
    final Color foregroundLightColor = Colors.blue.shade500;
    final Color foregroundDarkColor = Colors.red.shade500;
    const Color transitionShadowColor = Colors.black;

    final testPageDecorationWidget = PageDecoration(
      title: title,
      backgroundLightColor: backgroundLightColor,
      backgroundDarkColor: backgroundDarkColor,
      foregroundLightColor: foregroundLightColor,
      foregroundDarkColor: foregroundDarkColor,
      transitionShadowColor: transitionShadowColor,
    );

    testWidgets("title is displayed when title is given as a input",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        WidgetTesterWrapper(
          widget: testPageDecorationWidget,
        ),
      );
      expect(find.text(title), findsOneWidget);
    });

    testWidgets(
        "Test background gradient colors, foreground gradient colors and transition color is used correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        WidgetTesterWrapper(widget: testPageDecorationWidget),
      );

      testGradientColors(
          List<Color>? colors, Color lightColor, Color darkColor) {
        expect(colors?[0], lightColor);
        expect(colors?[1], darkColor);
      }

      //finds the widgets responsible for gradients, then gets there gradients to check if the correct colors are used.
      //responsible for background gradient.
      final DecoratedBox decoratedBox = tester.widget(find
              .byKey(const Key(PageDecoration.backgroundDecorationWidgetId)))
          as DecoratedBox;
      final BoxDecoration backgroundBoxDecoration =
          decoratedBox.decoration as BoxDecoration;
      testGradientColors(backgroundBoxDecoration.gradient?.colors,
          backgroundLightColor, backgroundDarkColor);

      //responsible for foreground gradient
      final Container container = tester.widget(find.byKey(
          const Key(PageDecoration.foregroundDecorationWidgetId))) as Container;
      final BoxDecoration foregroundBoxDecoration =
          container.decoration as BoxDecoration;
      testGradientColors(foregroundBoxDecoration.gradient?.colors,
          foregroundLightColor, foregroundDarkColor);

      expect(foregroundBoxDecoration.boxShadow?.length, 1);
      expect(
          foregroundBoxDecoration.boxShadow?[0].color, transitionShadowColor);
    });
  });
}
