import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_web_project/constants/colors.dart';
import 'package:spacex_web_project/widgets/next_launch_countdown/next_launch_countdown.dart';
import 'package:spacex_web_project/pages/page_decoration.dart';
import 'package:spacex_web_project/providers/next_launch_countdown_provider.dart';
import 'package:spacex_web_project/providers/upcoming_launches_provider.dart';
import 'package:spacex_web_project/routing/routes.dart';

///page that presents and holds the widgets used to present the Next Launch Countdown.

class NextLaunchCountdownPage extends StatelessWidget {
  const NextLaunchCountdownPage()
      : super(key: const Key(nextLaunchCountdownPageRoute));

  @override
  Widget build(BuildContext context) {
    final UpcomingLaunchesProvider upcomingLaunchesProvider =
        Provider.of<UpcomingLaunchesProvider>(context, listen: false);
    return PageDecoration(
      title:
          "Upcoming : ${upcomingLaunchesProvider.getUpcomingLaunch(0).missionName}",
      backgroundLightColor: nextLaunchCountdownBackgroundLightColor,
      backgroundDarkColor: nextLaunchCountdownBackgroundDarkColor,
      foregroundLightColor: nextLaunchCountdownForegroundLightColor,
      foregroundDarkColor: nextLaunchCountdownForegroundDarkColor,
      transitionShadowColor: nextLaunchCountdownTransitionShadowColor,
      child: ChangeNotifierProvider(
        //next launch countdown widget surrounded by provider to control state of its UI.
        create: (_) => NextLaunchCountdownProvider(
            nextLaunchDateTime:
                upcomingLaunchesProvider.getUpcomingLaunch(0).dateTime),
        child: NextLaunchCountdown(),
      ),
    );
  }
}
