import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_web_project/widgets/next_launch_countdown/countdown_tile.dart';

import '../../helpers_for_tests/wrappers/widget_tester_wrapper.dart';

void main() {
  group("Countdown Tile widget tests", () {
    testWidgets("capitalised unit title and unit value are visible",
        (WidgetTester tester) async {
      const String mockUnitTitle = "mockUnitTitle";
      const int mockUnitValue = 0;
      await tester.pumpWidget(
        WidgetTesterWrapper(
          widget: CountdownTile(
            unitValue: mockUnitValue,
            unitTitle: mockUnitTitle,
          ),
        ),
      );
      expect(find.text(mockUnitTitle.toUpperCase()), findsOneWidget);
      expect(find.text("$mockUnitValue"), findsOneWidget);
    });
  });
}
