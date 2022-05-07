import 'package:flutter/material.dart';
import 'package:spacex_web_project/constants/sizes.dart';
import '../../widgets/navigation_side_bar.dart';

///Main page Ui for small screens, scaffold will contain a drawer and a button to open drawer.

class SmallScreenWidthPageHolder extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Widget child;

  SmallScreenWidthPageHolder({required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: [
            child,
            IconButton(
              onPressed: () {
                scaffoldKey.currentState?.openDrawer();
              },
              padding: const EdgeInsets.all(kMinSpacing),
              color: Colors.black,
              icon: const Icon(Icons.menu,
                  color: Colors.black, size: kMinShareIconSize * 0.8),
            ),
          ],
        ),
        drawer: Drawer(
          child: NavigationSideBar(scaffoldKey: scaffoldKey),
        ),
      ),
    );
  }
}
