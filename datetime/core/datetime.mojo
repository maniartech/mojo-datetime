from math                 import math
from collections          import CollectionElement
from collections.optional import Optional

from .timezone import TimeZone
from .duration import Duration

from ..helpers.time   import is_leap_year, get_days_in_month, to_epoch
from ..helpers.string import __
from ..helpers.ffi    import _CTM, gm_time, local_time

@value
struct DateTime (Stringable, CollectionElement):
  """
  A structure representing a date and time.

  Attributes:
    year (Int): The year component of the date.
    month (Int): The month component of the date.
    day (Int): The day component of the date.
    hour (Int): The hour component of the time.
    minute (Int): The minute component of the time.
    second (Int): The second component of the time.
    nanosecond (Int): The nanosecond component of the time.
    timeZone (TimeZone): The time zone of the date and time.

    epoch_sec (Int64): The number of seconds since the Unix epoch (January 1, 1970, 00:00:00 UTC).
  """

  var year: Int
  var month: Int
  var day: Int
  var hour: Int
  var minute: Int
  var second: Int
  var nanosecond: Int
  var timeZone: Optional[TimeZone]

  var epoch_sec: Int64

  fn __init__(inout self, year: Int, month: Int, day: Int, hour: Int=0, minute: Int=0, second: Int=0, timeZone: Optional[TimeZone]=None):
    """
    Initializes a new DateTime. It resets the date components to its valid range
    if they are out of range. For example, if the month is less than 1, it will be
    set to 1. If the month is greater than 12, it will be set to 12. The same applies
    to the day, hour, minute, and second components.

    Args:
      year: The year component of the date.
      month: The month component of the date.
      day: The day component of the date.
      hour: The hour component of the time.
      minute: The minute component of the time.
      second: The second component of the time.
      timeZone: The time zone of the date and time.
    """
    let m = math.min(math.max(1, month), 12)
    let d = math.min(math.max(1, day), get_days_in_month(year, month))
    let h = math.min(math.max(0, hour), 23)
    let i = math.min(math.max(0, minute), 59)
    let s = math.min(math.max(0, second), 59)

    self.year = year
    self.month = month
    self.day = day
    self.hour = hour
    self.minute = minute
    self.second = second
    self.nanosecond = 0

    self.epoch_sec = to_epoch(year, month, day, hour, minute, second)
    self.timeZone = timeZone

  @staticmethod
  fn from_unix(epoch_sec:Int64, tz:Optional[TimeZone]=None) -> DateTime:
    var seconds = epoch_sec
    if tz:
      seconds += tz.value().secondsFromGMT

    let ctm = gm_time(seconds.to_int())
    return DateTime(
      ctm.tm_year.to_int(), ctm.tm_mon.to_int(), ctm.tm_mday.to_int(),
      ctm.tm_hour.to_int(), ctm.tm_min.to_int(), ctm.tm_sec.to_int(),
      tz
      )

  fn __str__(self) -> String:
    """
    Returns a string representation of the DateTime.

    Returns:
      A string representing the DateTime.
    """
    return self.to_iso8601()

  fn __repr__(self) -> String:
    """
    Returns a string representation of the DateTime.

    Returns:
      A string representing the DateTime.
    """
    return self.to_iso8601()

  fn to_iso8601(self) -> String:
    """
    Converts the DateTime to an ISO 8601 formatted string.

    Returns:
      A string representing the DateTime in ISO 8601 format.
    """
    let tz = self.timeZone.value().to_iso8601() if self.timeZone else "Z"
    return (
      str(self.year) + "-" + __(self.month) + "-" + __(self.day) + "T"
      + __(self.hour) + ":" + __(self.minute) + ":" + __(self.second)
      + tz
    )

  fn to_rfc3339(self) -> String:
    """
    Converts the DateTime to an RFC 3339 formatted string.

    Returns:
      A string representing the DateTime in RFC 3339 format.
    """
    return self.to_iso8601()

  fn add(self, other: Duration) -> DateTime:
    """
    Adds a duration to the DateTime.

    Args:
      other: The duration to add to the DateTime.

    Example:
      from datetime import DateTime, Duration
      dt = DateTime(1617222494, "UTC")
      tomorrow = dt.add(Duration(DURATION_DAY))


    Returns:
      A new DateTime representing the result of adding the duration to the DateTime.
    """
    let sec = self.epoch_sec + other.seconds

    return DateTime.from_unix(sec.to_int())

  fn sub(self, other: Duration) -> DateTime:
    """
    Subtracts a duration from the DateTime.

    Args:
      other: The duration to subtract from the DateTime.

    Example:
      from datetime import DateTime, Duration
      dt = DateTime(1617222494, "UTC")
      yesterday = dt.sub(Duration(DURATION_DAY))

    Returns:
      A new DateTime representing the result of subtracting the duration from the DateTime.
    """
    let sec = self.epoch_sec - other.seconds
    return DateTime.from_unix(sec.to_int())

  fn __sub__(self, other: DateTime) -> Duration:
    """
    Calculates the difference between two DateTimes.

    Args:
      other: The DateTime to calculate the difference with.

    Example:
      from datetime import DateTime
      dt1 = DateTime(1617222494, "UTC")
      dt2 = DateTime(1617222494, "UTC")
      diff = dt1 - dt2

    Returns:
      A Duration representing the difference between the two DateTimes.
    """
    let diff = self.epoch_sec - other.epoch_sec
    return Duration(diff.to_int())

  # Private helper function to convert a date and time to a Unix timestamp.

  fn to_int(self) -> Int64:
    return to_epoch(self.year, self.month, self.day, self.hour, self.minute, self.second)
