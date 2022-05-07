import 'package:flutter/cupertino.dart';

///model for upcoming launches.

class UpcomingLaunch {
  final String id;
  final String missionName;
  final DateTime dateTime;
  final String launchPad;
  bool isFavourite;

  UpcomingLaunch({
    required this.id,
    required this.missionName,
    required this.dateTime,
    required this.launchPad,
    @visibleForTesting this.isFavourite = false,
  });
}
