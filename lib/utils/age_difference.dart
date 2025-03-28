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
    Unit unit,
    DateTime anotherDate,
  ) {
    var now = DateTime.now();
    return Jiffy.parseFromList([
      now.year,
      now.month,
      now.day,
    ])
        .diff(
          Jiffy.parseFromList([
            anotherDate.year,
            anotherDate.month,
            anotherDate.day,
          ]),
          unit: unit,
        )
        .toInt();
  }

  static AgeDifference fromNow(DateTime? anotherDate) {
    if (anotherDate != null) {
      int years = _getDifferenceInUnits(Unit.year, anotherDate);
      int months = _getDifferenceInUnits(Unit.month, anotherDate);
      int days = _getDifferenceInUnits(Unit.day, anotherDate);
      return AgeDifference(
        years: years,
        months: months,
        days: days,
      );
    }
    return AgeDifference();
  }
}
