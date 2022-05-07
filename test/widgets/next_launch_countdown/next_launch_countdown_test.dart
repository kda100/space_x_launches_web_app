import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_web_project/providers/next_launch_countdown_provider.dart';
import 'package:spacex_web_project/widgets/next_launch_countdown/countdown_tile.dart';
import 'package:spacex_web_project/widgets/next_launch_countdown/next_launch_countdown.dart';

import '../../helpers_for_tests/functions/upcoming_launches_helper_functions.dart';
import '../../helpers_for_tests/wrappers/loaded_launches_widget_tester_wrapper.dart';

void main() {
  CountdownTile getTextWidget(
      {required Key key, required WidgetTester tester}) {
    //getter for each countdown tile.
    return tester.widget(find.byKey(key)) as CountdownTile;
  }

  ///function to test countdown tile widget values are equal to Next Launch Provider values.
  testWidgetsUnitValuesToProviderValues(
      {required NextLaunchCountdownProvider nextLaunchCountdownProvider,
      required WidgetTester tester}) {
    expect(
      getTextWidget(
              key: const Key(NextLaunchCountdown.daysUnitTitle), tester: tester)
          .unitValue,
      nextLaunchCountdownProvider.daysLeft,
    );
    expect(
      getTextWidget(
              key: const Key(NextLaunchCountdown.hoursUnitTitle),
              tester: tester)
          .unitValue,
      nextLaunchCountdownProvider.hoursLeft,
    );
    expect(
      getTextWidget(
              key: const Key(NextLaunchCountdown.minutesUnitTitle),
              tester: tester)
          .unitValue,
      nextLaunchCountdownProvider.minutesLeft,
    );
    expect(
      getTextWidget(
              key: const Key(NextLaunchCountdown.secondsUnitTitle),
              tester: tester)
          .unitValue,
      nextLaunchCountdownProvider.secondsLeft,
    );
  }

  ///function to test countdown tile widget values to 0.
  testWidgetsUnitValuesAreZero({required WidgetTester tester}) {
    expect(
      getTextWidget(
              key: const Key(NextLaunchCountdown.daysUnitTitle), tester: tester)
          .unitValue,
      0,
    );
    expect(
      getTextWidget(
              key: const Key(NextLaunchCountdown.hoursUnitTitle),
              tester: tester)
          .unitValue,
      0,
    );
    expect(
        getTextWidget(
                key: const Key(NextLaunchCountdown.minutesUnitTitle),
                tester: tester)
            .unitValue,
        0);
    expect(
        getTextWidget(
                key: const Key(NextLaunchCountdown.secondsUnitTitle),
                tester: tester)
            .unitValue,
        0);
  }

  Future<void> _testWidgetDuration({
    required Duration elapsedTime,
    required int numIterations,
    required WidgetTester tester,
    required NextLaunchCountdownProvider nextLaunchCountdownProvider,
    required FakeAsync async,
  }) async {
    //recursive function for testing duration changes are reflected in the UI on each change
    testWidgetsUnitValuesToProviderValues(
        tester: tester,
        nextLaunchCountdownProvider: nextLaunchCountdownProvider);
    if (numIterations == 0) {
      //base case
      return;
    } else {
      async.elapse(elapsedTime);
      await tester.pump();
      await _testWidgetDuration(
        elapsedTime: elapsedTime,
        numIterations: numIterations - 1,
        tester: tester,
        nextLaunchCountdownProvider: nextLaunchCountdownProvider,
        async: async,
      );
    }
  }

  group("next launch countdown widget tests", () {
    testWidgets(
        "Countdown Tiles display correct days, hours, minutes and seconds as different duration unit (secs, mins, hours, days) values change",
        (WidgetTester tester) async {
      const numIterations = 61;
      const durationAdded = Duration(days: 100);
      final fakeAsync = FakeAsync(initialTime: mockNow);
      fakeAsync.run((async) async {
        final NextLaunchCountdownProvider nextLaunchCountdownProvider =
            NextLaunchCountdownProvider(
          nextLaunchDateTime: mockNow.add(
            durationAdded,
          ),
        );
        await tester.pumpWidget(
          LoadedLaunchesWidgetTesterWrapper(
            nextLaunchCountdownProvider: nextLaunchCountdownProvider,
            widget: NextLaunchCountdown(),
          ),
        );
        //tests for seconds changing
        await _testWidgetDuration(
          numIterations: numIterations,
          async: async,
          nextLaunchCountdownProvider: nextLaunchCountdownProvider,
          tester: tester,
          elapsedTime: const Duration(seconds: 1),
        );
        //test for minutes changing
        await _testWidgetDuration(
          numIterations: numIterations,
          async: async,
          nextLaunchCountdownProvider: nextLaunchCountdownProvider,
          tester: tester,
          elapsedTime: const Duration(minutes: 1),
        );
        //test for hours changing.
        await _testWidgetDuration(
          numIterations: numIterations,
          async: async,
          nextLaunchCountdownProvider: nextLaunchCountdownProvider,
          tester: tester,
          elapsedTime: const Duration(hours: 1),
        );
        //test for days changing.
        await _testWidgetDuration(
          numIterations: numIterations,
          async: async,
          nextLaunchCountdownProvider: nextLaunchCountdownProvider,
          tester: tester,
          elapsedTime: const Duration(days: 1),
        );
      });
      fakeAsync.flushMicrotasks();
    });

    testWidgets(
        "Countdown Tiles display correct days, hours, minutes and seconds",
        (WidgetTester tester) async {
      final fakeAsync = FakeAsync(initialTime: mockNow);
      fakeAsync.run((async) async {
        final NextLaunchCountdownProvider nextLaunchCountdownProvider =
            NextLaunchCountdownProvider(
          nextLaunchDateTime: mockNow.add(
            const Duration(days: 2),
          ),
        );
        await tester.pumpWidget(
          LoadedLaunchesWidgetTesterWrapper(
            nextLaunchCountdownProvider: nextLaunchCountdownProvider,
            widget: NextLaunchCountdown(),
          ),
        );

        List<Duration> durations = [
          //list of consecutive durations to be tested for.
          const Duration(seconds: 1),
          const Duration(minutes: 1),
          const Duration(hours: 1),
          const Duration(days: 1)
        ];

        //iterates over durations list then elapses time and ensures widgets updates and present right data.
        for (Duration duration in durations) {
          async.elapse(duration);
          await tester.pump();
          testWidgetsUnitValuesToProviderValues(
              nextLaunchCountdownProvider: nextLaunchCountdownProvider,
              tester: tester);
        }
      });
      fakeAsync.flushMicrotasks();
    });
  });

  testWidgets(
      "When duration to next launch is 0, all unit values (days, hours, minutes and seconds) are 0",
      (WidgetTester tester) async {
    final fakeAsync = FakeAsync(initialTime: mockNow);
    fakeAsync.run((async) async {
      final NextLaunchCountdownProvider nextLaunchCountdownProvider =
          NextLaunchCountdownProvider(
        nextLaunchDateTime: mockNow,
      );
      await tester.pumpWidget(LoadedLaunchesWidgetTesterWrapper(
        nextLaunchCountdownProvider: nextLaunchCountdownProvider,
        widget: NextLaunchCountdown(),
      ));
      expect(nextLaunchCountdownProvider.durationToNextLaunch.inSeconds, 0);
      testWidgetsUnitValuesAreZero(tester: tester);
    });
    fakeAsync.flushMicrotasks();
  });

  testWidgets(
      "When duration to next launch is less than 0, all unit values (days, hours, minutes and seconds) are 0",
      (WidgetTester tester) async {
    final fakeAsync = FakeAsync(initialTime: mockNow);
    fakeAsync.run((async) async {
      final NextLaunchCountdownProvider nextLaunchCountdownProvider =
          NextLaunchCountdownProvider(
        nextLaunchDateTime: mockNow.subtract(
          const Duration(days: 20),
        ),
      );
      await tester.pumpWidget(
        LoadedLaunchesWidgetTesterWrapper(
          nextLaunchCountdownProvider: nextLaunchCountdownProvider,
          widget: NextLaunchCountdown(),
        ),
      );
      // await tester.pump(Duration(seconds: 1));
      expect(nextLaunchCountdownProvider.durationToNextLaunch.inSeconds, 0);
      testWidgetsUnitValuesAreZero(tester: tester);
    });
    fakeAsync.flushMicrotasks();
  });
}
