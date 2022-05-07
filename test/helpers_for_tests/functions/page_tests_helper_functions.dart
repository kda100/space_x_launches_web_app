import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_web_project/pages/page_decoration.dart';

///helper functions to use on pages when they are being widget tested.
class PageTestsHelperFunctions {
  ///helper function used to make sure the correct colors are used in page decorations.
  static void testPageDecorationColors(
    PageDecoration pageDecoration, {
    required Color backgroundLightColor,
    required Color backgroundDarkColor,
    required Color foregroundLightColor,
    required Color foregroundDarkColor,
    required Color transitionShadowColor,
  }) {
    expect(pageDecoration.foregroundLightColor, foregroundLightColor);
    expect(pageDecoration.foregroundDarkColor, foregroundDarkColor);
    expect(pageDecoration.backgroundLightColor, backgroundLightColor);
    expect(pageDecoration.backgroundDarkColor, backgroundDarkColor);
    expect(pageDecoration.transitionShadowColor, transitionShadowColor);
  }
}
