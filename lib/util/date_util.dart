enum LastActionDates { yesterday, today, date }

checkDatesAreEquals(DateTime value, DateTime other) {
  int valueSum = value.day + value.month + value.year;
  int otherSum = other.day + other.month + other.year;
  return otherSum - valueSum == 0 ? true : false;
}
