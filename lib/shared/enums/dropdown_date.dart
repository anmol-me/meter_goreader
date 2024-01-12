enum DropdownDate {
  thisWeek('This Week'),
  lastWeek('Last Week'),
  thisMonth('This Month'),
  lastMonth('Last Month'),
  thisYear('This Year'),
  custom('Custom');

  const DropdownDate(this.value);

  final String value;
}