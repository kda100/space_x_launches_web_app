import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:spacex_web_project/models/upcoming_launch.dart';
import 'package:spacex_web_project/services/spacex_api_service.dart';
import 'package:collection/collection.dart';

import '../models/api_response.dart';
import '../services/local_storage_api_service.dart';

///manages the state of the UI while spacex_api_service and local_api_storage_service attempts to fetch data,
///then processes the data then feed data to UI.

class UpcomingLaunchesProvider with ChangeNotifier {
  @visibleForTesting
  List<UpcomingLaunch> upcomingLaunches = [];

  @visibleForTesting
  List<String> favouriteUpcomingLaunchesIds = [];

  @visibleForTesting
  ApiResponse apiResponse = ApiResponse.loading();

  @visibleForTesting
  SpaceXApiService spaceXApiService = SpaceXApiService();

  @visibleForTesting
  LocalStorageApiService localStorageApiService = LocalStorageApiService();

  ApiResponse get getApiResponse => apiResponse;

  int get getUpcomingLaunchesLen => upcomingLaunches.length;

  UpcomingLaunch getUpcomingLaunch(int index) {
    return upcomingLaunches[index];
  }

  ///function used to get space x's upcoming launches and users favourite upcoming launches.
  Future<void> initialiseUpcomingLaunches() async {
    try {
      upcomingLaunches = await spaceXApiService.fetchUpcomingLaunches();
      favouriteUpcomingLaunchesIds =
          await localStorageApiService.getFavouriteLaunchIds();
      initialiseFavouriteUpcomingLaunches();
      apiResponse = ApiResponse.success();
    } catch (e) {
      //any errors during initialisation get caught and the UI gets notified.
      print(e.toString());
      apiResponse = ApiResponse.error();
    }
    notifyListeners();
  }

  ///function used to compare favourite upcoming launch ids with upcoming, then change the upcoming launches
  ///isFavourite boolean to true.
  void initialiseFavouriteUpcomingLaunches() {
    List<String> favouriteIdsToDelete =
        []; //any favourite ids not in upcoming launches are removed from local storage.
    for (String favouriteId in favouriteUpcomingLaunchesIds) {
      final UpcomingLaunch? upcomingLaunch = upcomingLaunches.firstWhereOrNull(
        (upcomingLaunch) => upcomingLaunch.id == favouriteId,
      );
      if (upcomingLaunch != null) {
        upcomingLaunch.isFavourite = true;
      } else {
        favouriteIdsToDelete.add(favouriteId);
      }
    }

    if (favouriteIdsToDelete.isNotEmpty) {
      //deletes obsolete launches and updates local storage, so data is keep low and efficient.
      for (String id in favouriteIdsToDelete) {
        favouriteUpcomingLaunchesIds.remove(id);
      }
      localStorageApiService
          .setFavouriteLaunchIds(favouriteUpcomingLaunchesIds);
    }
  }

  ///function to set upcoming launch as favourite launch after user make an event.
  void setFavourite(int index) {
    final UpcomingLaunch upcomingLaunch = upcomingLaunches[index];
    //updates favourite launches in local storage
    if (!favouriteUpcomingLaunchesIds.contains(upcomingLaunch.id)) {
      favouriteUpcomingLaunchesIds.add(upcomingLaunch.id);
      localStorageApiService
          .setFavouriteLaunchIds(favouriteUpcomingLaunchesIds);
    }
    //updates upcoming launch object and notifies ui.
    if (!upcomingLaunch.isFavourite) {
      upcomingLaunch.isFavourite = true;
      notifyListeners();
    }
  }

  ///function used to remove upcoming launch as favourite launch
  void removeFavourite(int index) {
    final UpcomingLaunch upcomingLaunch = upcomingLaunches[index];
    //updates favourite launches in local storage
    if (favouriteUpcomingLaunchesIds.contains(upcomingLaunch.id)) {
      favouriteUpcomingLaunchesIds.removeWhere((id) => id == upcomingLaunch.id);
      localStorageApiService
          .setFavouriteLaunchIds(favouriteUpcomingLaunchesIds);
    }
    //updates upcoming launch object and notifies ui.
    if (upcomingLaunch.isFavourite) {
      upcomingLaunch.isFavourite = false;
      notifyListeners();
    }
  }
}
