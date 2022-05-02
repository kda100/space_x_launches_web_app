import 'dart:async';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

///provider to handle the live timer for next launch. It uses a duration object and a timer
///to present different duration elements as they change in real time.

class NextLaunchCountdownProvider with ChangeNotifier {
  DateTime nextLaunchDateTime;
  @visibleForTesting
  Duration durationToNextLaunch;
  @visibleForTesting
  Timer? timer; //timer to handle changes in duration

  NextLaunchCountdownProvider._({
    required this.nextLaunchDateTime,
    required this.durationToNextLaunch,
  });

  factory NextLaunchCountdownProvider({
    required DateTime nextLaunchDateTime,
  }) {
    final now = clock.now().toUtc();
    if (now.isBefore(nextLaunchDateTime)) { //when date of next launch is upcoming a duration > 0 is created.
      return NextLaunchCountdownProvider._(
        nextLaunchDateTime: nextLaunchDateTime,
        durationToNextLaunch: nextLaunchDateTime.difference(now),
      );
    }
    return NextLaunchCountdownProvider._( //when next launch is in past duration = 0.
      nextLaunchDateTime: nextLaunchDateTime,
      durationToNextLaunch: const Duration(),
    );
  }

  //different duration elements
  int get daysLeft => durationToNextLaunch.inDays;
  int get hoursLeft => durationToNextLaunch.inHours.remainder(24);
  int get minutesLeft => durationToNextLaunch.inMinutes.remainder(60);
  int get secondsLeft => durationToNextLaunch.inSeconds.remainder(60);

  void startCountdown() {
    //starts countdown to next launch
    if (durationToNextLaunch.inSeconds > 0 && timer == null) {
      timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) {
          final now = clock.now().toUtc(); //more accurate to constantly find the current time then find duration difference to next launch.
          if (now.isBefore(nextLaunchDateTime)) { //as long as date of next launch is before current time duration keeps changing.
            durationToNextLaunch = nextLaunchDateTime.difference(now);
            notifyListeners(); //widgets rebuild.
          } else { //when date of next launch is after current time, duration to next launch is 0 & timer cancelled.
            durationToNextLaunch = const Duration();
            notifyListeners();
            timer?.cancel();
            timer = null;
          }
        },
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
  }
}
