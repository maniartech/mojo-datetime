from math import math
from .timezone import TimeZone
from .duration import Duration
from ..datetime_utils.time import is_leap_year, get_days_in_month
from ..datetime_utils._string import __
from ..datetime_utils.ffi import _CTM, _gm_time, _local_time
from ..datetime_utils.time import to_epoch

struct DateTime (Stringable):
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
  var timeZone: TimeZone

  var epoch_sec: Int64

  fn __init__(inout self, epoch_sec:Int64, timeZone:TimeZone):
    self.epoch_sec = epoch_sec
    self.timeZone = timeZone

    self.year = 0
    self.month = 0
    self.day = 0
    self.hour = 0
    self.minute = 0
    self.second = 0
    self.nanosecond = 0

    self._from_epoch(epoch_sec.to_int())

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
    return (
      str(self.year) + "-" + __(self.month) + "-" + __(self.day) + "T"
      + __(self.hour) + ":" + __(self.minute) + ":" + __(self.second)
      + self.timeZone.to_rfc3339()
    )

  fn to_rfc3339(self) -> String:
    """
    Converts the DateTime to an RFC 3339 formatted string.

    Returns:
      A string representing the DateTime in RFC 3339 format.
    """
    return (
      str(self.year) + "-" + __(self.month) + "-" + __(self.day) + "T"
      + __(self.hour) + ":" + __(self.minute) + ":" + __(self.second)
      + self.timeZone.to_rfc3339()
    )

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
    return DateTime(sec.to_int(), self.timeZone)

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
    return DateTime(sec.to_int(), self.timeZone)

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

  fn _from_epoch(inout self, epoch_seconds: Int):
    """
    Converts a Unix timestamp to a date and time.

    Args:
      epoch_seconds: The number of seconds since the Unix epoch (January 1, 1970, 00:00:00 UTC).
    """
    var tm: _CTM
    if self.timeZone.is_utc():
      tm = _gm_time(self.epoch_sec.to_int())
    else:
      tm = _local_time(self.epoch_sec.to_int())

    self.year       = tm.tm_year.to_int() + 1900
    self.month      = tm.tm_mon.to_int() + 1
    self.day        = tm.tm_mday.to_int()
    self.hour       = tm.tm_hour.to_int()
    self.minute     = tm.tm_min.to_int()
    self.second     = tm.tm_sec.to_int()
    self.nanosecond = 0

  fn to_int(self) -> Int64:
    return to_epoch(self.year, self.month, self.day, self.hour, self.minute, self.second)
