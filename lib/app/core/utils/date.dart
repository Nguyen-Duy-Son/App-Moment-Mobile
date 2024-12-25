// ignore_for_file: constant_identifier_names

import 'package:intl/intl.dart';

const String DAY_MONTH_YEAR = 'dd/MM/yyyy hh:mm:ss';
const String YEAR_MONTH_DAY = 'yyyy-MM-dd hh:mm:ss';
const String DAY_MONTH_YEAR_HOURS_MIN = 'dd/MM/yyyy HH:mm';
const String DAY_MONTH_YEAR_HOURS_MIN_COLON = 'dd/MM/yyyy - HH:mm';
const String DATE_FORMAT_TRANSACTION = 'dd/MM/yyyy - HH:mm:ss';
const String DAY_MONTH_YEAR_ONLY = 'dd/MM/yyyy';
const String YEAR_MONTH_DAY_ONLY = "yyyy/MM/dd";
const String DATE_FORMAT_STATUS = 'HH:mm, EEEE dd/MM/yyyy';
const String DATE_FORMAT_DETAIL = 'hh:mm a';
const String HOUR_FORMAT = 'HH:mm';
const String DAY_MONTH_YEAR_24H = 'dd/MM/yyyy HH:mm:ss';
const String DAY_MONTH_YEAR_NEW = 'dd/MM/yy - HH:mm';
const String DAY_MONTH_YEAR_NEW_2 = 'dd MMM yyyy';

String formatTimestampDayMonth({int? time}) {
  final parsedDate = DateTime.fromMillisecondsSinceEpoch(time ?? 1);
  final formatter = DateFormat(DAY_MONTH_YEAR);
  final String formatted = formatter.format(parsedDate);
  return formatted;
}

String formatTimestampDayMonthOnly(DateTime? dateTime, {DateFormat? dateFormat}) {
  if (dateTime == null) return '';

  // Convert dateTime to local time zone
  final localDateTime = dateTime.toLocal();

  // Use provided date format or default to DAY_MONTH_YEAR_ONLY
  final formatter = dateFormat ?? DateFormat(DAY_MONTH_YEAR_ONLY);
  final String formatted = formatter.format(localDateTime);

  return formatted;
}

/// getDateRangeStr
/// @startTime
/// @endTime
String getDateRangeStr(DateTime? startTime, DateTime? endTime, {DateFormat? dateFormat}) {
  return '${formatTimestampDayMonthOnly(startTime, dateFormat: dateFormat)} - ${formatTimestampDayMonthOnly(endTime, dateFormat: dateFormat)}';
}

String formatTimeFromString(String dateTime) {
  return DateFormat(DAY_MONTH_YEAR_HOURS_MIN_COLON).format(DateTime.parse(dateTime));
}

String formatTimeFromDateTime(DateTime? dateTime) {
  if (dateTime == null) return '';
  final formatter = DateFormat(DAY_MONTH_YEAR_HOURS_MIN_COLON);
  final String formatted = formatter.format(dateTime);
  return formatted;
}

String formatTimeFromStringWithFormat(String dateTime, String format) {
  return DateFormat(format).format(DateTime.parse(dateTime));
}

String convertTime(String dateTime, String beginFormat, String toFormat) {
  final date = DateFormat(beginFormat).parse(dateTime);
  return DateFormat(toFormat).format(date);
}

String formatTime(DateTime? datetime) => datetime != null ? DateFormat(HOUR_FORMAT).format(datetime) : '';

String convertDateToISO(DateTime? date) {
  if (date == null) return '';
  return date.toUtc().toIso8601String();
}

DateTime? convertISOToDate(String? isoString) {
  if (isoString == null) return DateTime.now();
  return DateTime.parse(isoString).toLocal(); // Convert ISO to DateTime
}

DateTime combineDateAndTime(DateTime? date, DateTime? time) {
  if (date != null && time != null) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
      time.second,
    );
  }
  if (date == null && time != null) {
    return DateTime(
      time.year,
      time.month,
      time.day,
      time.hour,
      time.minute,
      time.second,
    );
  }
  if (date != null && time == null) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      0,
      0,
      0,
    );
  }
  return DateTime.now();
}

DateTime combineDate(DateTime? date, int hour, int minute, int second) {
  if (date == null) {
    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      hour,
      minute,
      second,
    );
  }
  return DateTime(
    date.year,
    date.month,
    date.day,
    hour,
    minute,
    second,
  );
}

String formatTime24h(DateTime? dateTime, {DateFormat? dateFormat}) {
  if (dateTime == null) return '';

  // Convert dateTime to local time zone
  final localDateTime = dateTime.toLocal();
  // chuyển sang thành giờ 24h
  final String formattedTime = DateFormat(HOUR_FORMAT).format(localDateTime);

  return formattedTime;
}
