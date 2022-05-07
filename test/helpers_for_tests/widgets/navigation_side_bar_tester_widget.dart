import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_web_project/providers/navigation_provider.dart';
import 'package:spacex_web_project/widgets/navigation_side_bar.dart';

import '../wrappers/loaded_launches_widget_tester_wrapper.dart';

///helper widget used to test the navigation side bar, to ensure correct screens are shown on navigation.
///Uses Navigator object to test this.
class NavigationSideBarTesterWidget extends StatelessWidget {
  final NavigationProvider? navigationProvider;

  NavigationSideBarTesterWidget({
    this.navigationProvider,
  });

  @override
  Widget build(BuildContext context) {
    return LoadedLaunchesWidgetTesterWrapper(
      navigationProvider: navigationProvider,
      widget: Builder(
        builder: (context) {
          final NavigationProvider navigationProvider =
              Provider.of<NavigationProvider>(context);
          return Row(
            children: [
              SizedBox(width: 300, child: NavigationSideBar()),
              Expanded(
                child: Navigator(
                  initialRoute: navigationProvider.currentRoute,
                  onGenerateRoute: navigationProvider.onGenerateRoute,
                  onGenerateInitialRoutes: (_, __) =>
                      [navigationProvider.onGenerateInitialRoute()],
                  key: navigationProvider.navigatorKey,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
