
@value
struct TimeZone:
  var identifier: String
  var secondsFromGMT: Int

  @staticmethod
  fn UTC() -> TimeZone:
    return TimeZone("UTC", 0)

  fn toIso8601(self) -> String:
    if self.secondsFromGMT == 0:
      return "Z"
    elif self.secondsFromGMT > 0:
      return "+" + str(self.secondsFromGMT / 3600) + ":" + (self.secondsFromGMT % 3600) / 60
    else:
      return "-" + str(-self.secondsFromGMT / 3600) + ":" + (-self.secondsFromGMT % 3600) / 60

  fn toRfc3339(self) -> String:
    return self.toIso8601()