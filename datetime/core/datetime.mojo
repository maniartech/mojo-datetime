from .timezone import TimeZone

@value
struct DateTime:
  var year: Int
  var month: Int
  var day: Int
  var hour: Int
  var minute: Int
  var second: Int
  var nanosecond: Int
  var timeZone: TimeZone

  fn toIso8601(self) -> String:
    return (
      str(self.year) + "-" + self.month + "-" + self.day + "T"
      + self.hour + ":" + self.minute + ":" + self.second
      + self.timeZone.toIso8601()
    )

  fn toRfc3339(self) -> String:
    return (
      str(self.year) + "-" + self.month + "-" + self.day + "T"
      + self.hour + ":" + self.minute + ":" + self.second
      + self.timeZone.toRfc3339()
    )