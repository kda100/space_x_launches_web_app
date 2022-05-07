import 'package:flutter/material.dart';
import 'package:spacex_web_project/constants/font_sizes.dart';
import 'package:spacex_web_project/constants/sizes.dart';

///custom data table used to present upcoming launches, its uses material data table widget.

class CustomDataTable extends StatelessWidget {
  final EdgeInsets padding;
  final double fontSize;
  final double rowheight;
  final List<DataColumn> dataColumns;
  final List<DataRow> dataRows;

  CustomDataTable({
    required this.dataColumns,
    required this.dataRows,
    this.padding = const EdgeInsets.all(kMinSpacing),
    this.fontSize = kMinDataTableFontSize,
    this.rowheight = kMinDataTableRowHeight,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      dataTextStyle: TextStyle(color: Colors.white, fontSize: fontSize),
      headingTextStyle: TextStyle(color: Colors.white, fontSize: fontSize),
      horizontalMargin: 0,
      columnSpacing: 30,
      dataRowHeight: rowheight,
      headingRowHeight: rowheight,
      columns: dataColumns,
      rows: dataRows,
    );
  }
}
