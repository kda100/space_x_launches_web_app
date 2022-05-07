import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_web_project/providers/navigation_provider.dart';
import 'package:spacex_web_project/providers/next_launch_countdown_provider.dart';
import 'package:spacex_web_project/providers/upcoming_launches_provider.dart';

import '../mocks/custom_upcoming_launches_provider.dart';

/// A wrapper that can be used on different UI elements so tests can be made. It can take in as arguments provider classes and screen width.
/// To test how changes to those values can affect the UI when widget testing.

class WidgetTesterWrapper extends StatelessWidget {
  final double? screenWidth;
  final UpcomingLaunchesProvider? upcomingLaunchesProvider;
  final NavigationProvider? navigationProvider;
  final NextLaunchCountdownProvider? nextLaunchCountdownProvider;
  final Widget widget;

  WidgetTesterWrapper({
    required this.widget,
    this.screenWidth,
    this.upcomingLaunchesProvider,
    this.navigationProvider,
    this.nextLaunchCountdownProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NavigationProvider>(
          create: (context) => navigationProvider ?? NavigationProvider(),
        ),
        ChangeNotifierProvider<UpcomingLaunchesProvider>(
          create: (context) =>
              upcomingLaunchesProvider ?? CustomUpcomingLaunchesProvider(),
        ),
        ChangeNotifierProvider<NextLaunchCountdownProvider>(
          create: (context) =>
              nextLaunchCountdownProvider ??
              NextLaunchCountdownProvider(
                nextLaunchDateTime: DateTime(2022),
              ),
        )
      ],
      child: MaterialApp(
        builder: (BuildContext context, Widget? widget) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              size: Size.fromWidth(screenWidth ?? 1280),
            ),
            child: widget!,
          );
        },
        home: widget,
      ),
    );
  }
}
