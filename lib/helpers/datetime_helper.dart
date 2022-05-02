import 'package:intl/intl.dart';

///helper functions used to turn date time objects into a string format.

class DateTimeHelper {
  /// converts DateTime object to "Thu 17 Feb 2022" format.
  static String formatDateTimeToDayMonthYearString(DateTime? dateTime) {
    if (dateTime != null) {
      return DateFormat('dd MMM yyyy').format(dateTime);
    }
    return "";
  }

  /// converts DateTime object to "Thu 17 Feb 2022, 15:18 PM" format.
  static String formatDateTimeToDayMonthYearTimeString(DateTime? dateTime) {
    if (dateTime != null) {
      return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
    }
    return "";
  }
}
