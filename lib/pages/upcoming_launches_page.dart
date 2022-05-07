import 'package:flutter/material.dart';
import 'package:spacex_web_project/constants/colors.dart';
import 'package:spacex_web_project/pages/page_decoration.dart';
import 'package:spacex_web_project/pages/page_pop_scope.dart';
import 'package:spacex_web_project/routing/routes.dart';

import '../constants/titles.dart';
import '../widgets/upcoming_launches/upcoming_launches_data_table.dart';

///page to hold all UI elements for upcoming launches page, surrounded by a page decoration.

class UpcomingLaunchesPage extends StatelessWidget {
  const UpcomingLaunchesPage({Key? key})
      : super(key: const Key(upcomingLaunchesPageRoute));

  @override
  Widget build(BuildContext context) {
    return PagePopScope(
      child: PageDecoration(
        backgroundLightColor: upcomingLaunchesBackgroundLightColor,
        backgroundDarkColor: upcomingLaunchesBackgroundDarkColor,
        foregroundLightColor: upcomingLaunchesForegroundLightColor,
        foregroundDarkColor: upcomingLaunchesForegroundDarkColor,
        title: upcomingLaunchesTitle,
        transitionShadowColor: upcomingLaunchesTransitionShadowColor,
        child: UpcomingLaunchesDataTable(),
      ),
    );
  }
}
