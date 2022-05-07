import 'package:spacex_web_project/providers/upcoming_launches_provider.dart';

///custom upcoming launches provider to hides initialisation of upcoming launches so test
///so tests can be varied and responses for widget to different parameters can be explored.
class CustomUpcomingLaunchesProvider extends UpcomingLaunchesProvider {
  @override
  Future<void> initialiseUpcomingLaunches() async {
    return;
  }
}
