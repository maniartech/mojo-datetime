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


fn _epoch_to_datetime(epoch_seconds: Int) -> DateTime:
    # Constants for calculation
    let seconds_in_minute = 60
    let seconds_in_hour = 3600
    let seconds_in_day = 86400

    # Calculate time components
    var hour = (epoch_seconds / seconds_in_hour) % 24
    var minute = (epoch_seconds / seconds_in_minute) % 60
    var second = epoch_seconds % 60

    # Days since epoch
    var days:Float64 = epoch_seconds / seconds_in_day

    # Calculate year, starting from 1970
    var year = 1970
    while days >= 365:
        if is_leap_year(year):
            if days > 366:
                days -= 366
                year += 1
            else:
                break
        else:
            days -= 365
            year += 1

    # Calculate month and day
    var month = 0
    let days_in_month = get_days_in_month(year, month)
    while days > days_in_month:
        days -= days_in_month
        month += 1
        if month == 2 and is_leap_year(year):  # Adjust for leap year in February
            if days > 29:
              days -= 1
            else:
                break

    for i in range(12):
      let day_in_month = get_days_in_month(year, i)
      if days > day_in_month:
        days -= Float64(day_in_month)
        month += 1
        if month == 2 and is_leap_year(year):  # Adjust for leap year in February
          if days > 29:
            days -= 1
          else:
            break
      else:
        break

    var day = days

    let dt = DateTime(year, month + 1, day.to_int() + 1, hour.to_int(), minute.to_int(), second, 0, TimeZone.UTC())
    return dt

    # var date_vector = InlinedFixedVector[Int, 12](7)
    # date_vector[0] = year
    # date_vector[1] = month + 1
    # date_vector[2] = day.to_int() + 1
    # date_vector[3] = hour.to_int()
    # date_vector[4] = minute.to_int()
    # date_vector[5] = second

    # return date_vector