import 'package:flutter/material.dart';
import '../helpers/screen_size_helper.dart';

///Wigdet that acts as a wrapper to help widgets respond to different screen sizes.

class ResponsiveWidget extends StatelessWidget {
  final Widget? smallScreenWidget;
  final Widget largeScreenWidget;

  ResponsiveWidget({
    this.smallScreenWidget,
    required this.largeScreenWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (ScreenSizeHelper.isSmallScreenWidth(context) &&
        smallScreenWidget != null) {
      return smallScreenWidget!;
    } else {
      return largeScreenWidget;
    }
  }
}
