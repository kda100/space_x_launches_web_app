import 'package:flutter/material.dart';
import 'package:spacex_web_project/constants/font_sizes.dart';

import '../../helpers/screen_size_helper.dart';

///Ui for presenting the tiles for each unit of duration to the next space x launch.

class CountdownTile extends StatelessWidget {
  final int unitValue;
  final String? unitTitle;

  CountdownTile({required this.unitValue, this.unitTitle, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreenHeight =
        ScreenSizeHelper.isSmallScreenHeight(context);
    return Column(
      children: [
        Text(
          "$unitValue",
          style: TextStyle(
            fontSize: isSmallScreenHeight
                ? kMinCountdownTileUnitValueFontSize
                : kMaxCountdownTileUnitValueFontSize,
            color: Colors.white,
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              unitTitle?.toUpperCase() ?? "",
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreenHeight
                    ? kMinCountdownTileUnitTitleFontSize
                    : kMaxCountdownTileUnitTitleFontSize,
              ),
            ),
          ),
        )
      ],
    );
  }
}
