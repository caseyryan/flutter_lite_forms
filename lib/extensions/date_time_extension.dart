extension DateTimeExtension on DateTime {
  DateTime clamp(DateTime? min, DateTime? max) {
    if (min != null && max != null) {
      if (isBefore(min)) {
        return min.add(const Duration(microseconds: 1));
      } else if (isAfter(max)) {
        return max.subtract(const Duration(microseconds: 1));
      }
    }
    return this;
  }
}
