
alias DURATION_SECOND: Float32  = 1
alias DURATION_MINUTE: Float32  = 60 * DURATION_SECOND
alias DURATION_HOUR: Float32    = 60 * DURATION_MINUTE
alias DURATION_DAY: Float32     = 24 * DURATION_HOUR
alias DURATION_WEEK: Float32    = 7 * DURATION_DAY

@value
struct Duration:
  var seconds: Int

  fn __init__(inout self, seconds: Int):
    self.seconds = seconds

  fn __add__(self, other: Duration) -> Duration:
    return Duration(self.seconds + other.seconds)

  fn __sub__(self, other: Duration) -> Duration:
    return Duration(self.seconds - other.seconds)

  @staticmethod
  fn days(days:Float32) -> Duration:
    return Duration((DURATION_DAY * days).to_int())

  @staticmethod
  fn weeks(weeks:Int) -> Duration:
    return Duration((DURATION_WEEK * weeks).to_int())

  @staticmethod
  fn hours(hours:Float32) -> Duration:
    return Duration((DURATION_HOUR * hours).to_int())

  @staticmethod
  fn minutes(minutes:Int) -> Duration:
    return Duration((DURATION_MINUTE * minutes).to_int())


