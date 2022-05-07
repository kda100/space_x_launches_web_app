import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_web_project/constants/sizes.dart';
import 'package:spacex_web_project/helpers/screen_size_helper.dart';
import 'package:spacex_web_project/helpers/screen_size_helper.dart';

import '../../providers/next_launch_countdown_provider.dart';
import 'countdown_tile.dart';

///widget for presenting the ui for the next space x launch countdown

class NextLaunchCountdown extends StatelessWidget {
  static const daysUnitTitle = "days";
  static const hoursUnitTitle = "hours";
  static const minutesUnitTitle = "minutes";
  static const secondsUnitTitle = "seconds";
  static const shareButtonId = "share";

  @override
  Widget build(BuildContext context) {
    Provider.of<NextLaunchCountdownProvider>(context, listen: false)
        .startCountdown();
    final double spacing = ScreenSizeHelper.isSmallScreenHeight(context)
        ? kMinSpacing
        : kMaxSpacing;
    return Stack(
      children: [
        Center(
          child: Column(
            children: [
              Selector<NextLaunchCountdownProvider, int>(
                selector: (_, nextLaunchCountDownProvider) =>
                    nextLaunchCountDownProvider.daysLeft,
                builder: (_, days, __) => CountdownTile(
                  unitValue: days,
                  unitTitle: daysUnitTitle,
                  key: const Key(daysUnitTitle),
                ),
              ),
              SizedBox(
                height: spacing,
              ),
              Selector<NextLaunchCountdownProvider, int>(
                selector: (_, nextLaunchCountDownProvider) =>
                    nextLaunchCountDownProvider.hoursLeft,
                builder: (_, hours, __) => CountdownTile(
                  unitValue: hours,
                  unitTitle: hoursUnitTitle,
                  key: const Key(hoursUnitTitle),
                ),
              ),
              SizedBox(
                height: spacing,
              ),
              Selector<NextLaunchCountdownProvider, int>(
                selector: (_, nextLaunchCountDownProvider) =>
                    nextLaunchCountDownProvider.minutesLeft,
                builder: (_, minutes, __) => CountdownTile(
                  unitValue: minutes,
                  unitTitle: minutesUnitTitle,
                  key: const Key(minutesUnitTitle),
                ),
              ),
              SizedBox(
                height: spacing,
              ),
              Selector<NextLaunchCountdownProvider, int>(
                selector: (_, nextLaunchCountDownProvider) =>
                    nextLaunchCountDownProvider.secondsLeft,
                builder: (_, hours, __) => CountdownTile(
                  unitValue: hours,
                  unitTitle: secondsUnitTitle,
                  key: const Key(secondsUnitTitle),
                ),
              )
            ],
          ),
        ),
        Positioned(
          right: 0,
          child: IconButton(
            key: const Key(shareButtonId),
            onPressed: () {
              print("share");
            },
            padding: EdgeInsets.zero,
            iconSize: ScreenSizeHelper.isSmallScreenWidth(context)
                ? kMinShareIconSize
                : kMaxShareIconSize,
            icon: const Icon(
              Icons.share,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
