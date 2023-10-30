import 'package:jiffy/jiffy.dart';

class AgeDifference {
  int years;
  int months;
  int days;
  AgeDifference({
    this.years = 0,
    this.months = 0,
    this.days = 0,
  });

  static int _getDifferenceInUnits(
    Units units,
    DateTime anotherDate,
  ) {
    var now = DateTime.now();
    return Jiffy([
      now.year,
      now.month,
      now.day,
    ])
        .diff(
          Jiffy([
            anotherDate.year,
            anotherDate.month,
            anotherDate.day,
          ]),
          units,
        )
        .toInt();
  }

  static AgeDifference fromNow(DateTime? anotherDate) {
    if (anotherDate != null) {
      int years = _getDifferenceInUnits(Units.YEAR, anotherDate);
      int months = _getDifferenceInUnits(Units.MONTH, anotherDate);
      int days = _getDifferenceInUnits(Units.DAY, anotherDate);
      return AgeDifference(
        years: years,
        months: months,
        days: days,
      );
    }
    return AgeDifference();
  }
}
