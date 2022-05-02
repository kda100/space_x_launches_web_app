import 'package:spacex_web_project/models/upcoming_launch.dart';

//used for testing timer function of next launch countdown provider and countdown widgets
final mockNow = DateTime(2022, 3, 14);

///class used to develop mock data for upcoming launches to test performance of classes and widgets.
class UpcomingLaunchesHelperFunctions {
  ///gen mock data for favourite launch ids list.
  static List<String> genMockFavouriteUpcomingLaunchIds(
      {int numFavouriteLaunchIds = 5}) {
    return List.generate(numFavouriteLaunchIds, (index) => "mockId$index");
  }

  ///gen mock data for upcoming launch list.
  static List<UpcomingLaunch> genMockUpcomingLaunchesList(
      {int numUpcomingLaunches = 5, isFavourite = false}) {
    return List.generate(
      numUpcomingLaunches,
      (index) => UpcomingLaunch(
        id: "mockId$index",
        missionName: "MissionName$index",
        dateTime: mockNow.add(Duration(days: 30 * index)),
        launchPad: "mockLaunchPadName$index",
        isFavourite: isFavourite,
      ),
    );
  }
}
