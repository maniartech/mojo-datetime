
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

