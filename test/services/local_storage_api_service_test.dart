import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_web_project/services/local_storage_api_service.dart';

import '../helpers_for_tests/functions/upcoming_launches_helper_functions.dart';

void main() {
  group("Local Storage API Service initialisation tests - ", () {
    test("is a Singleton", () {
      final LocalStorageApiService localStorageApiService =
          LocalStorageApiService();
      expect(localStorageApiService == LocalStorageApiService(), true);
    });
  });

  group("Local Storage API Service function tests - ", () {
    test(
        "The favourite launch ids list set using the setFavouriteLaunchIds function is the same as the favouriteLaunchIds list retrieved when calling the getFavouriteLaunchIds function",
        () async {
      final LocalStorageApiService localStorageApiService =
          LocalStorageApiService();
      final List<String> ids =
          UpcomingLaunchesHelperFunctions.genMockFavouriteUpcomingLaunchIds();
      localStorageApiService.setFavouriteLaunchIds(ids);
      expect(await localStorageApiService.getFavouriteLaunchIds(), ids);
    });
  });
}
