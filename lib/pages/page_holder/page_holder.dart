import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_web_project/pages/page_holder/small_screen_width_page_holder.dart';
import 'package:spacex_web_project/providers/upcoming_launches_provider.dart';
import 'package:spacex_web_project/widgets/responsive_widget.dart';
import '../../models/api_response.dart';
import 'large_screen_width_page_holder.dart';

///holder used to hold different pages.

class PageHolder extends StatefulWidget {
  final Widget child;

  PageHolder({required this.child});
  @override
  State<PageHolder> createState() => _PageHolderState();
}

class _PageHolderState extends State<PageHolder> {
  late UpcomingLaunchesProvider upcomingLaunchesProvider;

  @override
  void initState() {
    upcomingLaunchesProvider =
        Provider.of<UpcomingLaunchesProvider>(context, listen: false);
    upcomingLaunchesProvider
        .initialiseUpcomingLaunches(); //called when page first initialised.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<UpcomingLaunchesProvider, ApiResponse>(
      selector: (context, upcomingLaunchesProvider) =>
          upcomingLaunchesProvider.getApiResponse,
      builder: (context, apiResponse, _) {
        //apiResponse controls ui state of page holder.
        final ApiResponseType apiResponseType = apiResponse.responseType;
        if (apiResponseType == ApiResponseType.loading) {
          return Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        } else if (apiResponseType == ApiResponseType.error) {
          return Container(
            color: Colors.white,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxHeight: 1000, maxWidth: 1000),
            child: Image.asset(
              "assets/images/something_went_wrong.jpg",
            ),
          );
        }
        return ResponsiveWidget(
          largeScreenWidget: LargeScreenWidthPageHolder(child: widget.child),
          smallScreenWidget: SmallScreenWidthPageHolder(child: widget.child),
        );
      },
    );
  }
}
