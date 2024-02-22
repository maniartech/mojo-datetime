from .timezone import TimeZone
from .duration import Duration
from ..datetime_utils.time import is_leap_year, get_days_in_month

struct DateTime:
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

    self._epoch_to_datetime(epoch_sec.to_int())



  fn toIso8601(self) -> String:
    """
    Converts the DateTime to an ISO 8601 formatted string.

    Returns:
      A string representing the DateTime in ISO 8601 format.
    """
    return (
      str(self.year) + "-" + self.month + "-" + self.day + "T"
      + self.hour + ":" + self.minute + ":" + self.second
      + self.timeZone.toIso8601()
    )

  fn toRfc3339(self) -> String:
    """
    Converts the DateTime to an RFC 3339 formatted string.

    Returns:
      A string representing the DateTime in RFC 3339 format.
    """
    return (
      str(self.year) + "-" + self.month + "-" + self.day + "T"
      + self.hour + ":" + self.minute + ":" + self.second
      + self.timeZone.toRfc3339()
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



  # Private helper function to convert a date and time to a Unix timestamp.


  fn _epoch_to_datetime(inout self, epoch_seconds: Int):
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

      self.year = year
      self.month = month
      self.day = day.to_int()
      self.hour = hour.to_int()
      self.minute = minute.to_int()
      self.second = second
      self.nanosecond = 0
