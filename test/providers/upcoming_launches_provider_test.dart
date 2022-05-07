import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spacex_web_project/models/api_response.dart';
import 'package:spacex_web_project/models/upcoming_launch.dart';
import 'package:spacex_web_project/providers/upcoming_launches_provider.dart';
import 'package:spacex_web_project/services/local_storage_api_service.dart';
import 'package:spacex_web_project/services/spacex_api_service.dart';
import '../helpers_for_tests/functions/upcoming_launches_helper_functions.dart';
import '../helpers_for_tests/mocks/mock_local_storage_api_service.dart';
import '../helpers_for_tests/mocks/mock_spacex_api_service.dart';

///tests for UpcomingLaunchesProvider.

@GenerateMocks([SpaceXApiService, LocalStorageApiService])
void main() {
  final MockLocalStorageApiService mockLocalStorageApiService =
      MockLocalStorageApiService();
  final MockSpaceXApiService mockSpaceXApiService = MockSpaceXApiService();

  group(
    "UpcomingLaunchesProvider initialisation tests - ",
    () {
      final UpcomingLaunchesProvider upcomingLaunchesProvider =
          UpcomingLaunchesProvider();
      test(
        "upcoming launches list is empty",
        () {
          expect(upcomingLaunchesProvider.getUpcomingLaunchesLen, 0);
        },
      );

      test(
        "favourite launch ids list is empty",
        () {
          expect(
              upcomingLaunchesProvider.favouriteUpcomingLaunchesIds.length, 0);
        },
      );

      test("test ApiResponseType is of Loading", () {
        expect(
            upcomingLaunchesProvider.apiResponse.responseType ==
                ApiResponseType.loading,
            true);
      });
    },
  );

  group(
    "UpcomingLaunchesProvider initialiseUpcomingLaunches function tests - ",
    () {
      test(
        "When initialiseUpcomingLaunches catches a error from spaceXApiService, ApiResponse is of type error and listeners are notified",
        () async {
          bool listenerNotified = false;
          final UpcomingLaunchesProvider upcomingLaunchesProvider =
              UpcomingLaunchesProvider()
                ..addListener(() {
                  listenerNotified = true;
                });
          upcomingLaunchesProvider.spaceXApiService = mockSpaceXApiService;
          when(
            mockSpaceXApiService.fetchUpcomingLaunches(),
          ).thenAnswer(
            (_) => throw Exception(), //causes an error in function
          );
          await upcomingLaunchesProvider
              .initialiseUpcomingLaunches(); //call function
          expect(
            upcomingLaunchesProvider.getUpcomingLaunchesLen,
            0,
          );
          expect(upcomingLaunchesProvider.apiResponse.responseType,
              ApiResponseType.error);
          expect(
            listenerNotified,
            true,
          );
        },
      );

      test(
        "When initialiseUpcomingLaunches catches a error from localStorageApiService, ApiResponse is of type error and listeners are notified",
        () async {
          bool listenerNotified = false;
          final UpcomingLaunchesProvider upcomingLaunchesProvider =
              UpcomingLaunchesProvider()
                ..addListener(() {
                  listenerNotified = true;
                });
          upcomingLaunchesProvider.spaceXApiService = mockSpaceXApiService;
          upcomingLaunchesProvider.localStorageApiService =
              mockLocalStorageApiService;
          when(
            mockSpaceXApiService.fetchUpcomingLaunches(),
          ).thenAnswer(
            (_) async =>
                UpcomingLaunchesHelperFunctions.genMockUpcomingLaunchesList(),
          );
          when(
            mockLocalStorageApiService.getFavouriteLaunchIds(),
          ).thenAnswer(
            (_) async => throw Exception(),
          );
          await upcomingLaunchesProvider.initialiseUpcomingLaunches();
          expect(
            upcomingLaunchesProvider.favouriteUpcomingLaunchesIds.length,
            0,
          );
          expect(upcomingLaunchesProvider.apiResponse.responseType,
              ApiResponseType.error);
          expect(
            listenerNotified,
            true,
          );
        },
      );

      test(
        "When initialiseUpcomingLaunches is successful, ApiResponse is of type success and listeners are notified",
        () async {
          bool listenerNotified = false;
          final UpcomingLaunchesProvider upcomingLaunchesProvider =
              UpcomingLaunchesProvider()
                ..addListener(() {
                  listenerNotified = true;
                });
          upcomingLaunchesProvider.spaceXApiService = mockSpaceXApiService;
          upcomingLaunchesProvider.localStorageApiService =
              mockLocalStorageApiService;
          final List<UpcomingLaunch> upcomingLaunches =
              UpcomingLaunchesHelperFunctions.genMockUpcomingLaunchesList();
          final List<String> favouriteUpcomingLaunchIds =
              UpcomingLaunchesHelperFunctions
                  .genMockFavouriteUpcomingLaunchIds();
          when(
            mockSpaceXApiService.fetchUpcomingLaunches(),
          ).thenAnswer(
            (_) async => upcomingLaunches,
          );
          when(
            mockLocalStorageApiService.getFavouriteLaunchIds(),
          ).thenAnswer(
            (_) async => favouriteUpcomingLaunchIds,
          );
          await upcomingLaunchesProvider.initialiseUpcomingLaunches();
          expect(
            upcomingLaunchesProvider.apiResponse.responseType,
            ApiResponseType.success,
          );
          expect(
            upcomingLaunchesProvider.upcomingLaunches,
            upcomingLaunches,
          );
          expect(
              listEquals(upcomingLaunchesProvider.favouriteUpcomingLaunchesIds,
                  favouriteUpcomingLaunchIds),
              true);
          expect(
            listenerNotified,
            true,
          );
        },
      );
    },
  );

  group("initialiseFavouriteUpcomingLaunches function tests - ", () {
    late UpcomingLaunchesProvider upcomingLaunchesProvider;
    setUp(() {
      upcomingLaunchesProvider = UpcomingLaunchesProvider();
      upcomingLaunchesProvider.localStorageApiService =
          mockLocalStorageApiService;
    });

    test(
      "only the isFavourite boolean of upcoming launches whose id is contained in the favourite upcoming launch ids list, is changed to true",
      () {
        const int numUpcomingLaunches = 8;
        const int numFavouriteLaunchIds = 5;
        upcomingLaunchesProvider.upcomingLaunches =
            UpcomingLaunchesHelperFunctions.genMockUpcomingLaunchesList(
                numUpcomingLaunches: numUpcomingLaunches);
        upcomingLaunchesProvider.favouriteUpcomingLaunchesIds =
            UpcomingLaunchesHelperFunctions.genMockFavouriteUpcomingLaunchIds(
                numFavouriteLaunchIds: numFavouriteLaunchIds);
        upcomingLaunchesProvider.initialiseFavouriteUpcomingLaunches();
        //iterates over all upcoming launches then checks only the correct upcoming launch isFavourite = true
        for (int i = 0;
            i < upcomingLaunchesProvider.upcomingLaunches.length;
            i++) {
          final UpcomingLaunch upcomingLaunch =
              upcomingLaunchesProvider.upcomingLaunches[i];
          if (i < numFavouriteLaunchIds) {
            expect(upcomingLaunchesProvider.favouriteUpcomingLaunchesIds[i],
                upcomingLaunch.id);
            expect(upcomingLaunch.isFavourite, true);
          } else {
            expect(upcomingLaunch.isFavourite, false);
          }
        }
      },
    );

    test(
        "If there is a favourite launch id in favourite launches that is not contained in the ids of upcoming launches it is accurately removed and favourites list is updated in local storage api",
        () {
      const int numUpcomingLaunches = 5;
      const int numFavouriteLaunchIds = 8;

      bool setFavouriteLaunchIdsApiCall = false;

      upcomingLaunchesProvider.upcomingLaunches =
          UpcomingLaunchesHelperFunctions.genMockUpcomingLaunchesList(
              numUpcomingLaunches: numUpcomingLaunches);
      upcomingLaunchesProvider.favouriteUpcomingLaunchesIds =
          UpcomingLaunchesHelperFunctions.genMockFavouriteUpcomingLaunchIds(
              numFavouriteLaunchIds: numFavouriteLaunchIds);

      when(mockLocalStorageApiService.setFavouriteLaunchIds(
              upcomingLaunchesProvider.favouriteUpcomingLaunchesIds))
          .thenAnswer(
        (_) => setFavouriteLaunchIdsApiCall = true,
      );

      upcomingLaunchesProvider.initialiseFavouriteUpcomingLaunches();

      expect(upcomingLaunchesProvider.favouriteUpcomingLaunchesIds.length,
          numUpcomingLaunches);
      expect(
          listEquals(
              upcomingLaunchesProvider.favouriteUpcomingLaunchesIds,
              upcomingLaunchesProvider.upcomingLaunches
                  .map((e) => e.id)
                  .toList()),
          true);
      expect(setFavouriteLaunchIdsApiCall, true);
    });

    test(
        "If no favourite id is removed from list, call to LocalStorageApi to set favourite list is not made",
        () {
      bool setFavouriteLaunchIdsApiCall = false;

      upcomingLaunchesProvider.upcomingLaunches =
          UpcomingLaunchesHelperFunctions.genMockUpcomingLaunchesList();
      upcomingLaunchesProvider.favouriteUpcomingLaunchesIds =
          UpcomingLaunchesHelperFunctions.genMockFavouriteUpcomingLaunchIds();

      when(mockLocalStorageApiService.setFavouriteLaunchIds(
              upcomingLaunchesProvider.favouriteUpcomingLaunchesIds))
          .thenAnswer(
        (_) => setFavouriteLaunchIdsApiCall = true,
      );

      upcomingLaunchesProvider.initialiseFavouriteUpcomingLaunches();

      expect(setFavouriteLaunchIdsApiCall, false);
    });
  });

  group("setFavourite function tests - ", () {
    late UpcomingLaunchesProvider upcomingLaunchesProvider;
    setUp(() {
      upcomingLaunchesProvider = UpcomingLaunchesProvider();
      upcomingLaunchesProvider.localStorageApiService =
          mockLocalStorageApiService;
    });

    test(
        "when set favourite is called correct upcoming launch isFavourite boolean is updated, listeners are notified and favourites list is set to local storage via LocalStorageApiService",
        () {
      upcomingLaunchesProvider.upcomingLaunches =
          UpcomingLaunchesHelperFunctions.genMockUpcomingLaunchesList();

      bool listenersNotified = false;
      bool setFavouriteLaunchIdsApiCall = false;

      when(mockLocalStorageApiService.setFavouriteLaunchIds(
              upcomingLaunchesProvider.favouriteUpcomingLaunchesIds))
          .thenAnswer(
        (_) => setFavouriteLaunchIdsApiCall = true,
      );

      upcomingLaunchesProvider.addListener(() {
        listenersNotified = true;
      });

      upcomingLaunchesProvider.setFavourite(0);

      expect(listenersNotified, true);
      expect(setFavouriteLaunchIdsApiCall, true);
      for (int i = 0;
          i < upcomingLaunchesProvider.upcomingLaunches.length;
          i++) {
        if (i == 0) {
          expect(
              upcomingLaunchesProvider.getUpcomingLaunch(i).isFavourite, true);
        } else {
          expect(
              upcomingLaunchesProvider.getUpcomingLaunch(i).isFavourite, false);
        }
      }
    });
  });

  group("removeFavourite function tests - ", () {
    late UpcomingLaunchesProvider upcomingLaunchesProvider;
    setUp(() {
      upcomingLaunchesProvider = UpcomingLaunchesProvider();
      upcomingLaunchesProvider.localStorageApiService =
          mockLocalStorageApiService;
    });
    test(
        "when set favourite is called correct upcoming launch isFavourite boolean is updated, listeners are notified and favourites list is set to local storage via LocalStorageApiService",
        () {
      upcomingLaunchesProvider.upcomingLaunches =
          UpcomingLaunchesHelperFunctions.genMockUpcomingLaunchesList(
              isFavourite: true);
      upcomingLaunchesProvider.favouriteUpcomingLaunchesIds =
          UpcomingLaunchesHelperFunctions.genMockFavouriteUpcomingLaunchIds();

      bool listenersNotified = false;
      bool setFavouriteLaunchIdsApiCall = false;

      when(mockLocalStorageApiService.setFavouriteLaunchIds(
              upcomingLaunchesProvider.favouriteUpcomingLaunchesIds))
          .thenAnswer(
        (_) => setFavouriteLaunchIdsApiCall = true,
      );

      upcomingLaunchesProvider.addListener(() {
        listenersNotified = true;
      });

      upcomingLaunchesProvider.removeFavourite(0);

      expect(listenersNotified, true);
      expect(setFavouriteLaunchIdsApiCall, true);
      for (int i = 0;
          i < upcomingLaunchesProvider.upcomingLaunches.length;
          i++) {
        if (i == 0) {
          expect(
              upcomingLaunchesProvider.getUpcomingLaunch(i).isFavourite, false);
        } else {
          expect(
              upcomingLaunchesProvider.getUpcomingLaunch(i).isFavourite, true);
        }
      }
    });
  });
}
