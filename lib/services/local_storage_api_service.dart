import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';

///service used to communicate with local storage and make changes directly to it.
///primarily used to store ids of favourite upcoming launches.
///provides the functionality view models need to manage its UI data.

class LocalStorageApiService {
  static final LocalStorageApiService _instance = LocalStorageApiService._();

  LocalStorageApiService._();

  factory LocalStorageApiService() {
    return _instance;
  }

  static const upcomingLaunchesStorageKey = "upcoming_launches";
  static const favouriteUpcomingLaunchesIdsItemKey =
      "favourite_upcoming_launches";

  @visibleForTesting
  LocalStorage upcomingLaunchesStorage =
      LocalStorage(upcomingLaunchesStorageKey);

  ///gets List<String> favourite launch ids from local storage.
  Future<List<String>> getFavouriteLaunchIds() async {
    if (await upcomingLaunchesStorage.ready) {
      final List<dynamic>? favouriteUpcomingLaunchesIds =
          upcomingLaunchesStorage.getItem(favouriteUpcomingLaunchesIdsItemKey);
      if (favouriteUpcomingLaunchesIds != null) {
        return favouriteUpcomingLaunchesIds.map((id) => id as String).toList();
      }
    }
    return [];
  }

  ///sets favourite launch ids to local storage
  setFavouriteLaunchIds(List<String> favouriteUpcomingLaunchIds) async {
    if (await upcomingLaunchesStorage.ready) {
      await upcomingLaunchesStorage.setItem(
        favouriteUpcomingLaunchesIdsItemKey,
        favouriteUpcomingLaunchIds,
      );
    }
  }
}
