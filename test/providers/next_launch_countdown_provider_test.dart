import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_web_project/providers/next_launch_countdown_provider.dart';
import 'package:fake_async/fake_async.dart';

import '../helpers_for_tests/functions/upcoming_launches_helper_functions.dart';

void main() {
  const durationDiff = Duration(days: 30);
  group("Initialisation Tests - ", () {
    test("timer object is null", () {
      fakeAsync(
        (async) {
          final NextLaunchCountdownProvider nextLaunchCountdownProvider =
              NextLaunchCountdownProvider(
                  nextLaunchDateTime: mockNow.add(durationDiff));
          expect(nextLaunchCountdownProvider.timer, null);
        },
        initialTime: mockNow,
      );
    });
    test("Next Launch DateTime is initialised", () {
      final DateTime nextLaunchDateTime = mockNow.add(durationDiff);
      final NextLaunchCountdownProvider nextLaunchCountdownProvider =
          NextLaunchCountdownProvider(nextLaunchDateTime: nextLaunchDateTime);
      fakeAsync(
        (async) {
          expect(
              nextLaunchCountdownProvider.nextLaunchDateTime
                  .isAtSameMomentAs(nextLaunchDateTime),
              true);
        },
        initialTime: mockNow,
      );
    });
    test(
        "If date for next launch is after current date then duration to next launch has an accurate value greater than 0",
        () {
      fakeAsync(
        (async) {
          final NextLaunchCountdownProvider nextLaunchCountdownProvider =
              NextLaunchCountdownProvider(
            nextLaunchDateTime: mockNow.add(
              durationDiff,
            ),
          );
          expect(nextLaunchCountdownProvider.durationToNextLaunch.inSeconds,
              durationDiff.inSeconds);
        },
        initialTime: mockNow,
      );
    });
    test(
        "If date for next launch is before current date then duration to next launch is 0",
        () {
      fakeAsync(
        (async) {
          final NextLaunchCountdownProvider nextLaunchCountdownProvider =
              NextLaunchCountdownProvider(
            nextLaunchDateTime: mockNow.subtract(
              durationDiff,
            ),
          );
          expect(
            nextLaunchCountdownProvider.durationToNextLaunch.inSeconds,
            0,
          );
        },
        initialTime: mockNow,
      );
    });
  });

  group("Start Countdown Function tests - ", () {
    test(
        "on start countdown duration decrements by one second every second and listeners are notified each time",
        () {
      fakeAsync(
        (async) {
          const seconds = 100;
          final NextLaunchCountdownProvider nextLaunchCountdownProvider =
              NextLaunchCountdownProvider(
                  nextLaunchDateTime:
                      mockNow.add(const Duration(seconds: seconds)));
          int notifyListenersCalled = 0;
          nextLaunchCountdownProvider.addListener(() {
            notifyListenersCalled++;
          });
          nextLaunchCountdownProvider.startCountdown();

          ///function keeps adding seconds and tests the provider values are correct.
          _testDuration(int seconds) {
            //recursive function to test duration to next launch changes.
            expect(nextLaunchCountdownProvider.durationToNextLaunch.inSeconds,
                seconds);
            if (seconds == 0) {
              //base case
              return;
            } else {
              async.elapse(const Duration(seconds: 1));
              _testDuration(seconds - 1);
            }
          }

          _testDuration(seconds);
          expect(notifyListenersCalled, seconds);
        },
        initialTime: mockNow,
      );
    });

    test("when duration is 0 and start countdown is called, timer stays null",
        () {
      final NextLaunchCountdownProvider nextLaunchCountdownProvider =
          NextLaunchCountdownProvider(nextLaunchDateTime: mockNow);
      nextLaunchCountdownProvider.startCountdown();
      expect(nextLaunchCountdownProvider.timer, null);
    });
    test("when timer goes to 0, timer stops and becomes null", () {
      fakeAsync(
        (async) {
          const int secondsDuration = 3;
          final NextLaunchCountdownProvider nextLaunchCountdownProvider =
              NextLaunchCountdownProvider(
            nextLaunchDateTime:
                mockNow.add(const Duration(seconds: secondsDuration)),
          );
          nextLaunchCountdownProvider.startCountdown();
          async.elapse(const Duration(seconds: secondsDuration + 1));
          expect(nextLaunchCountdownProvider.timer, null);
          expect(nextLaunchCountdownProvider.durationToNextLaunch.inSeconds, 0);
        },
        initialTime: mockNow,
      );
    });
  });

  test("returns correct days, hours, minutes and seconds", () {
    fakeAsync(
      (async) {
        final NextLaunchCountdownProvider nextLaunchCountdownProvider =
            NextLaunchCountdownProvider(
          nextLaunchDateTime: mockNow.add(const Duration(days: 2)),
        );
        nextLaunchCountdownProvider.startCountdown();

        testGetters(
          int expectedDays,
          int expectedHours,
          int expectedMinutes,
          int expectedSeconds,
        ) {
          expect(nextLaunchCountdownProvider.daysLeft, expectedDays);
          expect(nextLaunchCountdownProvider.hoursLeft, expectedHours);
          expect(nextLaunchCountdownProvider.minutesLeft, expectedMinutes);
          expect(nextLaunchCountdownProvider.secondsLeft, expectedSeconds);
        }

        async.elapse(const Duration(seconds: 1));
        testGetters(1, 23, 59, 59);
        async.elapse(const Duration(minutes: 1));
        testGetters(1, 23, 58, 59);
        async.elapse(const Duration(hours: 1));
        testGetters(1, 22, 58, 59);
        async.elapse(const Duration(days: 1));
        testGetters(0, 22, 58, 59);
      },
      initialTime: mockNow,
    );
  });
}
