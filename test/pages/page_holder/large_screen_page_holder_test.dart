import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_web_project/pages/page_holder/large_screen_width_page_holder.dart';
import 'package:spacex_web_project/widgets/navigation_side_bar.dart';

import '../../helpers_for_tests/wrappers/widget_tester_wrapper.dart';

void main() {
  group(
    "large screen page holder tests - ",
    () {
      testWidgets(
        "navigation side bar is visible",
        (WidgetTester tester) async {
          await tester.pumpWidget(
            WidgetTesterWrapper(
              widget: LargeScreenWidthPageHolder(
                child: const SizedBox(),
              ),
            ),
          );
          expect(find.byType(NavigationSideBar), findsOneWidget);
        },
      );
    },
  );
}
