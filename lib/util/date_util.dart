enum LastActionDates { yesterday, today, date }

checkDatesAreEquals(DateTime value, DateTime other) {
  int valueSum = value.day + value.month + value.year;
  int otherSum = other.day + other.month + other.year;
  return otherSum - valueSum == 0 ? true : false;
}

String formatDate(DateTime date) {
  String day = date.day < 10 ? '0' + date.day.toString() : date.day.toString();
  String month = date.month < 10 ? '0' + date.month.toString() : date.month.toString();
  return '$day / $month';
}