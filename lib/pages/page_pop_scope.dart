import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_web_project/providers/navigation_provider.dart';

class PagePopScope extends StatelessWidget {
  final Widget child;
  const PagePopScope({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NavigationProvider navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    return WillPopScope(
        child: child,
        onWillPop: () async {
          navigationProvider.pop();
          return false;
        });
  }
}
