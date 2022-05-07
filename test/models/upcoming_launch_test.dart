import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_web_project/models/upcoming_launch.dart';

import '../helpers_for_tests/functions/upcoming_launches_helper_functions.dart';

void main() {
  group("Upcoming Launch Model initialisation tests", () {
    test("isFavourite boolean is false", () {
      final UpcomingLaunch upcomingLaunch = UpcomingLaunch(
        id: "mockId",
        missionName: "mockMissionName",
        dateTime: mockNow,
        launchPad: "mockLaunchPad",
      );
      expect(upcomingLaunch.isFavourite, false);
    });
  });
}
