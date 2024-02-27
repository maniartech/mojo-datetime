alias DURATION_SECOND: Float32  =  1
alias DURATION_MINUTE: Float32  = 60 * DURATION_SECOND
alias DURATION_HOUR: Float32    = 60 * DURATION_MINUTE
alias DURATION_DAY: Float32     = 24 * DURATION_HOUR
alias DURATION_WEEK: Float32    =  7 * DURATION_DAY

@value
struct Duration (Stringable):
  var seconds: Int

  fn __init__(inout self, seconds: Int):
    self.seconds = seconds

  fn __str__(self) -> String:
    let seconds = Float32(self.seconds)
    let days = (seconds / DURATION_DAY).to_int()
    let hours = ((seconds % DURATION_DAY) / DURATION_HOUR).to_int()
    let minutes = ((seconds % DURATION_HOUR) / DURATION_MINUTE).to_int()
    let second = (seconds % DURATION_MINUTE).to_int()

    if days >= 1:
      return str(days) + "d " + str(hours) + "h " + str(minutes) + "m " + str(second) + "s"
    elif hours >= 1:
      return str(hours) + "h " + str(minutes) + "m " + str(second) + "s"
    elif minutes >= 1:
      return str(minutes) + "m " + str(second) + "s"

    return str(second) + "s"

  fn __add__(self, other: Duration) -> Duration:
    return Duration(self.seconds + other.seconds)

  fn __sub__(self, other: Duration) -> Duration:
    return Duration(self.seconds - other.seconds)

  @staticmethod
  fn days(days:Float32) -> Duration:
    """
    Return a duration for the given number of days.

    Args:
      days: The number of days.

    Returns:
      A duration for the given number of days.
    """
    return Duration((DURATION_DAY * days).to_int())

  @staticmethod
  fn weeks(weeks:Int) -> Duration:
    """
    Return a duration for the given number of weeks.

    Args:
      weeks: The number of weeks.

    Returns:
      A duration for the given number of weeks.
    """
    return Duration((DURATION_WEEK * weeks).to_int())

  @staticmethod
  fn hours(hours:Float32) -> Duration:
    return Duration((DURATION_HOUR * hours).to_int())

  @staticmethod
  fn minutes(minutes:Int) -> Duration:
    return Duration((DURATION_MINUTE * minutes).to_int())
