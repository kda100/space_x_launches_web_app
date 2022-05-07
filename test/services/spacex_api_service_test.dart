import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spacex_web_project/constants/json_keys.dart';
import 'package:spacex_web_project/models/upcoming_launch.dart';
import 'package:spacex_web_project/services/spacex_api_service.dart';

import '../helpers_for_tests/mocks/mock_http_client.dart';

///tests for Space X's Api service.

@GenerateMocks([http.Client])
void main() {
  group("SpaceXApiService initialisation tests", () {
    final SpaceXApiService spaceXApiService = SpaceXApiService();
    test("Is a Singleton", () {
      expect(spaceXApiService == SpaceXApiService(), true);
    });
  });
  group(
    "SpaceXApiService fetchUpcomingLaunches function tests",
    () {
      final SpaceXApiService spaceXApiService = SpaceXApiService();
      const String launchId = "5eb87d42ffd86e000604b384";
      const String launchPadId = "5e9e4501f509094ba4566f84";
      test(
        "returns List<UpcomingLaunches> if fetchUpcomingLaunches and fetchLaunchPadName call completes with status code 200",
        () async {
          final client = MockClient();
          spaceXApiService.client = client;
          const upcomingLaunchesJson =
              '[{"${JsonKeys.id}" : "$launchId", "${JsonKeys.name}" : "CRS-20", "${JsonKeys.dateUTCKey}" : "2020-03-07T04:50:31.000Z", "${JsonKeys.launchPadId}" : "$launchPadId"}, {"${JsonKeys.id}" : "$launchId", "${JsonKeys.name}" : "CRS-20", "${JsonKeys.dateUTCKey}" : "2020-03-07T04:50:31.000Z", "${JsonKeys.launchPadId}" : "$launchPadId"}, {"${JsonKeys.id}" : "$launchId", "${JsonKeys.name}" : "CRS-20", "${JsonKeys.dateUTCKey}" : "2020-03-07T04:50:31.000Z", "${JsonKeys.launchPadId}" : "$launchPadId"}]'; //mock json data
          const launchPadJson = '{"${JsonKeys.name}" : "mockLaunchPadName"}';
          when(
            client.get(
              Uri.parse(SpaceXApiService.upcomingLaunchesUrl),
            ),
          ).thenAnswer(
            (_) async => http.Response(upcomingLaunchesJson, 200),
          );

          when(
            client.get(
              Uri.parse("${SpaceXApiService.launchPadsUrl}/$launchPadId"),
            ),
          ).thenAnswer(
            (_) async => http.Response(
              launchPadJson,
              200,
            ),
          );

          expect(await spaceXApiService.fetchUpcomingLaunches(),
              isA<List<UpcomingLaunch>>());
        },
      );

      test(
          "throws Exception if fetchUpcomingLaunches call completes with a status code not equal to 200",
          () {
        final client = MockClient();
        spaceXApiService.client = client;
        when(
          client.get(
            Uri.parse(SpaceXApiService.upcomingLaunchesUrl),
          ),
        ).thenAnswer(
          (_) async => http.Response("Not found", 404),
        );

        expect(spaceXApiService.fetchUpcomingLaunches(), throwsException);
      });

      test(
          "throws Exception if fetchLaunchPadName call completes with a status code not equal to 200",
          () {
        final client = MockClient();
        spaceXApiService.client = client;
        when(
          client.get(
            Uri.parse("${SpaceXApiService.launchPadsUrl}/$launchPadId"),
          ),
        ).thenAnswer(
          (_) async => http.Response("Not found", 404),
        );

        expect(spaceXApiService.fetchLaunchPadName(launchPadId: launchPadId),
            throwsException);
      });
    },
  );
}
