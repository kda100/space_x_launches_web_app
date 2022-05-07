import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spacex_web_project/models/upcoming_launch.dart';

import '../constants/json_keys.dart';

///Space X Api service it make http requests to get data on Space X's upcoming launches.

class SpaceXApiService {
  static final SpaceXApiService _instance = SpaceXApiService._();

  SpaceXApiService._();

  factory SpaceXApiService() {
    return _instance;
  }

  static const _baseUrl = "https://api.spacexdata.com";
  static const timeoutDuration = Duration(seconds: 5);

  @visibleForTesting
  static const upcomingLaunchesUrl = "$_baseUrl/v4/launches/upcoming";

  @visibleForTesting
  static const launchPadsUrl = "$_baseUrl/v4/launchpads";

  @visibleForTesting
  http.Client client = http.Client();

  ///function makes a http call to fetch data on upcoming spacex launches.
  Future<List<UpcomingLaunch>> fetchUpcomingLaunches() async {
    final http.Response upcomingLaunchesResponse = await client
        .get(
          Uri.parse(upcomingLaunchesUrl),
        )
        .timeout(timeoutDuration);
    if (upcomingLaunchesResponse.statusCode == 200) {
      final List<UpcomingLaunch> upcomingLaunches = [];
      final List<dynamic> upcomingLaunchesJson =
          jsonDecode(upcomingLaunchesResponse.body);
      for (var upcomingLaunchJson in upcomingLaunchesJson) {
        final String launchPadName = await fetchLaunchPadName(
          //fetch lad pad data.
          launchPadId: upcomingLaunchJson[JsonKeys.launchPadId],
        );
        upcomingLaunches.add(
          UpcomingLaunch(
            id: upcomingLaunchJson[JsonKeys.id],
            missionName: upcomingLaunchJson[JsonKeys.name],
            dateTime: DateTime.parse(upcomingLaunchJson[JsonKeys.dateUTCKey]),
            launchPad: launchPadName,
          ),
        );
      }
      return upcomingLaunches;
    }
    throw Exception("Failed to fetch upcoming launches");
  }

  ///function to fetch launch pad name using the id of the launch pad.
  @visibleForTesting
  Future<String> fetchLaunchPadName({
    required String launchPadId,
  }) async {
    final http.Response launchPadResponse = await client
        .get(
          Uri.parse("$launchPadsUrl/$launchPadId"),
        )
        .timeout(timeoutDuration);
    if (launchPadResponse.statusCode == 200) {
      return jsonDecode(launchPadResponse.body)[JsonKeys.name];
    } else {
      throw Exception("Failed to fetch launch pad name");
    }
  }
}
