import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_web_project/pages/page_holder/page_holder.dart';
import 'package:spacex_web_project/providers/navigation_provider.dart';
import 'package:spacex_web_project/providers/upcoming_launches_provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'constants/titles.dart';

void main() {
  setPathUrlStrategy();
  runApp(
    SpaceXLaunchesApp(),
  );
}

class SpaceXLaunchesApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UpcomingLaunchesProvider>(
          create: (context) => UpcomingLaunchesProvider(),
        ),
        ChangeNotifierProvider<NavigationProvider>(
          create: (context) => NavigationProvider(),
        ),
      ],
      child: Builder(builder: (context) {
        final NavigationProvider navigationProvider =
            Provider.of(context, listen: false);
        return MaterialApp(
            title: webPageTitle,
            theme: ThemeData(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              dividerColor: Colors.white,
            ),
            builder: (BuildContext context, Widget? child) =>
                PageHolder(child: child!),
            color: Colors.white,
            navigatorKey: navigationProvider.navigatorKey,
            onGenerateRoute: navigationProvider.onGenerateRoute,
            onGenerateInitialRoutes: (_) {
              return [navigationProvider.onGenerateInitialRoute()];
            });
      }),
    );
  }
}
