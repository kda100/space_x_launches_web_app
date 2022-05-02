import 'package:flutter/material.dart';
import '../../constants/sizes.dart';
import '../../widgets/navigation_side_bar.dart';

///UI for large screens, the scaffold will not contain a drawer but a side bar instead.

class LargeScreenWidthPageHolder extends StatelessWidget {
  final Widget child;

  LargeScreenWidthPageHolder({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: kSideBarWidth,
            child: NavigationSideBar(),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
