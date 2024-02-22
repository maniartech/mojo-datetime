
@value
struct TimeZone:
  """
  A structure representing a time zone.

  Attributes:
    identifier (String): The identifier of the time zone.
    secondsFromGMT (Int): The offset from GMT in seconds.
  """
  var identifier: String
  var secondsFromGMT: Int

  @staticmethod
  fn UTC() -> TimeZone:
    """
    Static method that returns a TimeZone object representing UTC.

    Returns:
      A TimeZone object with identifier "UTC" and secondsFromGMT 0.
    """
    return TimeZone("UTC", 0)

  fn to_iso8601(self) -> String:
    """
    Converts the TimeZone to an ISO 8601 formatted string.

    Returns:
      A string representing the TimeZone in ISO 8601 format. If the time zone is UTC,
      it returns "Z". If the time zone is ahead of UTC, it returns a string in the
      format "+HH:MM". If the time zone is behind UTC, it returns a string in the
      format "-HH:MM".
    """
    if self.secondsFromGMT == 0:
      return "Z"
    elif self.secondsFromGMT > 0:
      return "+" + str(self.secondsFromGMT / 3600) + ":" + (self.secondsFromGMT % 3600) / 60
    else:
      return "-" + str(-self.secondsFromGMT / 3600) + ":" + (-self.secondsFromGMT % 3600) / 60

  fn to_rfc3339(self) -> String:
    """
    Converts the TimeZone to an RFC 3339 formatted string.

    Returns:
      A string representing the TimeZone in RFC 3339 format. This is currently
      identical to the ISO 8601 format.
    """
    return self.to_iso8601()
