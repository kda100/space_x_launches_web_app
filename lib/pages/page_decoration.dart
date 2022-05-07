import 'package:flutter/material.dart';
import 'package:spacex_web_project/constants/sizes.dart';
import 'package:spacex_web_project/helpers/screen_size_helper.dart';

import '../constants/font_sizes.dart';

///background decoration used for all the pages in the app

class PageDecoration extends StatelessWidget {
  final String? title;
  final Color backgroundLightColor;
  final Color backgroundDarkColor;
  final Color foregroundLightColor;
  final Color foregroundDarkColor;
  final Color transitionShadowColor;
  final Widget? child;

  PageDecoration({
    this.title,
    required this.backgroundLightColor,
    required this.backgroundDarkColor,
    required this.foregroundLightColor,
    required this.foregroundDarkColor,
    required this.transitionShadowColor,
    this.child,
  });

  static const String backgroundDecorationWidgetId =
      "background_decoration"; //used for testing.
  static const String foregroundDecorationWidgetId = "foreground_decoration";

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreenWidth =
        ScreenSizeHelper.isSmallScreenWidth(context);
    final double spacing = isSmallScreenWidth ? kMinSpacing : kMaxSpacing;
    return DecoratedBox(
      key: const Key(backgroundDecorationWidgetId),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [backgroundLightColor, backgroundDarkColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: spacing,
              left: spacing,
              top: spacing,
            ),
            child: SizedBox(
              width: isSmallScreenWidth ? kSmallScreenTitleWidth : null,
              child: Text(
                title ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreenWidth
                      ? kMinPageTitleFontSize
                      : kMaxPageTitleFontSize,
                  letterSpacing: 1.5,
                  shadows: const [
                    Shadow(color: Colors.black, offset: Offset(0.5, 0.5))
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(spacing),
              child: Container(
                width: double.infinity,
                key: const Key(foregroundDecorationWidgetId),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: transitionShadowColor,
                      blurRadius: 10,
                    )
                  ],
                  gradient: LinearGradient(
                    colors: [foregroundLightColor, foregroundDarkColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                constraints: const BoxConstraints(
                  maxWidth: kMaxForegroundPageDecorationWidth,
                ),
                child: RawScrollbar(
                  thumbColor: Colors.white,
                  shape: const StadiumBorder(),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(spacing),
                    physics: const BouncingScrollPhysics(),
                    child: child ?? Container(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
