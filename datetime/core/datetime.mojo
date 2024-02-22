from .timezone import TimeZone

@value
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
  """

  var year: Int
  var month: Int
  var day: Int
  var hour: Int
  var minute: Int
  var second: Int
  var nanosecond: Int
  var timeZone: TimeZone

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