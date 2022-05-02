import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_web_project/constants/font_sizes.dart';
import 'package:spacex_web_project/constants/sizes.dart';
import 'package:spacex_web_project/helpers/screen_size_helper.dart';
import 'package:spacex_web_project/models/custom_key.dart';
import 'package:spacex_web_project/models/upcoming_launch.dart';
import 'package:spacex_web_project/providers/upcoming_launches_provider.dart';
import 'package:spacex_web_project/widgets/upcoming_launches/custom_data_table.dart';
import '../../constants/data_column_headers.dart';
import '../../helpers/datetime_helper.dart';

///main UI for presenting the information of the upcoming launches.
///The table responds to different screen sizes.
///The keys for the various elements in the widget are used when conducting test.
///
class UpcomingLaunchesDataTable extends StatelessWidget {
  ///function to create data column headers for the different upcoming launches.
  List<DataColumn> mapColumnHeadersToDataColumns(List<String> columnHeaders) {
    return columnHeaders
        .map((header) => DataColumn(
                label: Text(
              header,
              key: Key(header),
              overflow: TextOverflow.ellipsis,
            )))
        .toList();
  }

  ///builds custom text that responds to overflow. Incase data from api is incorrect.
  Text buildCustomText(String text, {Key? key}) {
    return Text(
      text,
      key: key,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    final UpcomingLaunchesProvider upcomingLaunchesProvider =
        Provider.of<UpcomingLaunchesProvider>(context, listen: false);
    final bool isSmallScreenWidth =
        ScreenSizeHelper.isSmallScreenWidth(context);
    final bool isSmallScreenHeight =
        ScreenSizeHelper.isSmallScreenHeight(context);
    return CustomDataTable(
      dataColumns:
          isSmallScreenWidth //different columns for different screen sizes.
              ? mapColumnHeadersToDataColumns(smallScreenWidthDataColumnHeaders)
              : mapColumnHeadersToDataColumns(
                  largeScreenWidthDataColumnHeaders),
      dataRows: List<DataRow>.generate(
          //data rows generated from upcoming launches list in provider.
          upcomingLaunchesProvider.getUpcomingLaunchesLen, (index) {
        final UpcomingLaunch upcomingLaunch =
            upcomingLaunchesProvider.getUpcomingLaunch(index);
        return DataRow(
          color: MaterialStateProperty.all(Colors.transparent),
          cells: [
            isSmallScreenWidth
                ? DataCell(
                    SizedBox(
                      width: isSmallScreenWidth
                          ? kSmallScreenMissionTitleWidth
                          : null,
                      child: Selector<UpcomingLaunchesProvider, bool>(
                        selector: (_, __) => upcomingLaunch.isFavourite,
                        builder: (_, isFavourite, __) {
                          final Key key = Key(upcomingLaunch.missionName);
                          if (isFavourite) {
                            return Text.rich(
                              //small screen demonstrated user favourited launch by showing an icon next to the mission name
                              TextSpan(children: [
                                WidgetSpan(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 1.5, bottom: 1.5),
                                    child: Icon(
                                      Icons.star,
                                      key: customKey(upcomingLaunch.missionName,
                                          upcomingLaunch.isFavourite),
                                      size: kMinFavouriteIconSize,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                ),
                                TextSpan(
                                    text: upcomingLaunch.missionName,
                                    style: const TextStyle(
                                      fontSize: kMinDataTableFontSize,
                                      color: Colors.white,
                                    )),
                              ]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                          return buildCustomText(upcomingLaunch.missionName,
                              key: key);
                        },
                      ),
                    ), onDoubleTap: () {
                    //user can like and dislike upcoming launch by double tapping mission name.
                    upcomingLaunch.isFavourite
                        ? upcomingLaunchesProvider.removeFavourite(index)
                        : upcomingLaunchesProvider.setFavourite(index);
                  })
                : DataCell(buildCustomText(upcomingLaunch.missionName,
                    key: Key(upcomingLaunch.missionName))),
            DataCell(
              buildCustomText(
                  index == 0
                      ? DateTimeHelper.formatDateTimeToDayMonthYearTimeString(
                          upcomingLaunch.dateTime)
                      : DateTimeHelper.formatDateTimeToDayMonthYearString(
                          upcomingLaunch.dateTime),
                  key: Key(upcomingLaunch.dateTime.toString())),
            ),
            DataCell(buildCustomText(upcomingLaunch.launchPad,
                key: Key(upcomingLaunch.launchPad))),
            if (!isSmallScreenWidth)
              DataCell(
                //extra column on large screen for user 'favouriting' upcoming launch.
                IconButton(
                  icon: Selector<UpcomingLaunchesProvider, bool>(
                    selector: (_, __) => upcomingLaunch.isFavourite,
                    builder: (_, isFavourite, __) => isFavourite
                        ? Icon(
                            Icons.star,
                            key: customKey(upcomingLaunch.missionName,
                                upcomingLaunch.isFavourite),
                            color: Colors.yellow,
                          )
                        : Icon(
                            Icons.star_border,
                            key: customKey(upcomingLaunch.missionName,
                                upcomingLaunch.isFavourite),
                            color: Colors.white,
                          ),
                  ),
                  onPressed: () {
                    //favourite upcoming launch is toggled by clicking on icon button and UI changes to reflect this.
                    upcomingLaunch.isFavourite
                        ? upcomingLaunchesProvider.removeFavourite(index)
                        : upcomingLaunchesProvider.setFavourite(index);
                  },
                  iconSize: kMaxFavouriteIconSize,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
          ],
        );
      }),
      padding: EdgeInsets.all(isSmallScreenWidth ? kMinSpacing : kMaxSpacing),
      fontSize:
          isSmallScreenWidth ? kMinDataTableFontSize : kMaxDataTableFontSize,
      rowheight:
          isSmallScreenHeight ? kMinDataTableRowHeight : kMaxDataTableRowHeight,
    );
  }
}
