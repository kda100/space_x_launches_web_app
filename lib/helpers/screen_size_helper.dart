import 'dart:io';

import 'package:flutter/material.dart';

import '../constants/sizes.dart';

///helper functions used to check screen sizes.

class ScreenSizeHelper {
  ///returns boolean on whether current viewport has a small width.
  static bool isSmallScreenWidth(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return width <= kLargeScreenWidth;
  }

  ///returns boolean on whether current viewport has a small height.
  static bool isSmallScreenHeight(BuildContext context) {
    final double width = MediaQuery.of(context).size.height;
    return width <= kLargeScreenHeight;
  }
}
