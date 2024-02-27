from collections.vector import InlinedFixedVector

from ..core.datetime import DateTime
from ..core.timezone import TimeZone

fn is_leap_year(year: Int) -> Bool:
    # Leap year logic
    return year % 4 == 0 and (year % 100 != 0 or year % 400 == 0)

fn get_days_in_month(year: Int, month: Int) -> Int:
    var days_in_month = InlinedFixedVector[Int, 12](12)
    let is_leap = is_leap_year(year)
    days_in_month[0] = 31
    days_in_month[1] = 29 if is_leap else 28
    days_in_month[2] = 31
    days_in_month[3] = 30
    days_in_month[4] = 31
    days_in_month[5] = 30
    days_in_month[6] = 31
    days_in_month[7] = 31
    days_in_month[8] = 30
    days_in_month[9] = 31
    days_in_month[10] = 30
    days_in_month[11] = 31

    return days_in_month[month]

fn to_epoch(year: Int, month: Int, day: Int, hour: Int=0, minute: Int=0, second: Int=0) -> Int64:
  """
  Converts the DateTime to a Unix timestamp.

  Returns:
    An integer representing the number of seconds since the Unix epoch (January 1, 1970, 00:00:00 UTC).
  """
  let seconds_in_minute = 60
  let seconds_in_hour = 3600
  let seconds_in_day = 86400

  var days = 0
  for y in range(1970, year):  # Corrected variable name to avoid confusion
    if is_leap_year(y):
      days += 366
    else:
      days += 365

  for m in range(1, month):  # Using the month directly
    days += get_days_in_month(year, m - 1)

  days += day - 1  # Adding the days of the current month

  return Int64((days * seconds_in_day) + (hour * seconds_in_hour) + (minute * seconds_in_minute) + second)
