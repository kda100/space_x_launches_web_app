import 'package:flutter/material.dart';
import 'package:spacex_web_project/models/api_response.dart';
import 'package:spacex_web_project/providers/navigation_provider.dart';
import 'package:spacex_web_project/providers/next_launch_countdown_provider.dart';
import 'package:spacex_web_project/providers/upcoming_launches_provider.dart';

import '../functions/upcoming_launches_helper_functions.dart';
import '../mocks/custom_upcoming_launches_provider.dart';
import 'widget_tester_wrapper.dart';

///wrapper used to tests widgets, it uses a custom UpcomingLaunchesProvider to mock some Upcoming Launch data.
///that can be used to widget test UI components to make sure they are presenting the correct data in the right places.

class LoadedLaunchesWidgetTesterWrapper extends StatelessWidget {
  final Widget widget;
  final double? screenWidth;
  final NavigationProvider? navigationProvider;
  final NextLaunchCountdownProvider? nextLaunchCountdownProvider;

  LoadedLaunchesWidgetTesterWrapper({
    required this.widget,
    this.navigationProvider,
    this.screenWidth,
    this.nextLaunchCountdownProvider,
  });

  @override
  Widget build(BuildContext context) {
    final UpcomingLaunchesProvider upcomingLaunchesProvider =
        CustomUpcomingLaunchesProvider();
    upcomingLaunchesProvider.upcomingLaunches =
        UpcomingLaunchesHelperFunctions.genMockUpcomingLaunchesList();
    upcomingLaunchesProvider.favouriteUpcomingLaunchesIds =
        UpcomingLaunchesHelperFunctions.genMockFavouriteUpcomingLaunchIds();
    upcomingLaunchesProvider.apiResponse = ApiResponse.success();

    return WidgetTesterWrapper(
      upcomingLaunchesProvider: upcomingLaunchesProvider,
      nextLaunchCountdownProvider: nextLaunchCountdownProvider,
      navigationProvider: navigationProvider,
      screenWidth: screenWidth,
      widget: Scaffold(
        body: widget,
      ),
    );
  }
}
