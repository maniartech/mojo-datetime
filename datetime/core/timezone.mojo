
alias _UTC = TimeZone(0, "UTC")

@value
struct TimeZone(Stringable):
  """
  A structure representing a time zone.

  Attributes:
    secondsFromGMT (Int): The offset from GMT in seconds.
    identifier (String): The identifier of the time zone.
  """
  var secondsFromGMT: Int
  var identifier: String

  fn is_utc(self) -> Bool:
    """
    Returns whether the time zone is UTC.

    Returns:
      True if the time zone is UTC, False otherwise.
    """
    return self.secondsFromGMT == 0

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

    if self.secondsFromGMT > 0:
      return "+"
        + str(self.secondsFromGMT / 3600) + ":" + (self.secondsFromGMT % 3600) / 60
        + self.identifier if self.identifier != "local" else ""

    return "-"
      + str(-self.secondsFromGMT / 3600) + ":" + (-self.secondsFromGMT % 3600) / 60
      + self.identifier if self.identifier != "local" else ""

  fn to_rfc3339(self) -> String:
    """
    Converts the TimeZone to an RFC 3339 formatted string.

    Returns:
      A string representing the TimeZone in RFC 3339 format. This is currently
      identical to the ISO 8601 format.
    """
    return self.to_iso8601()

  fn __str__(self) -> String:
    """
    Converts the TimeZone to a string.

    Returns:
      A string representing the TimeZone in the format "TimeZone(identifier, secondsFromGMT)".
    """
    return self.to_iso8601()

  fn __repr__(self) -> String:
    """
    Converts the TimeZone to a string.

    Returns:
      A string representing the TimeZone in the format "TimeZone(identifier, secondsFromGMT)".
    """
    return self.to_iso8601()

  fn __hash__(self) -> Int:
    """
    Returns the hash value of the time zone.

    Returns:
      The hash value of the time zone.
    """
    return self.secondsFromGMT ^ hash(self.identifier)

  fn __eq__(self, other: TimeZone) -> Bool:
    """
    Compares the time zone to another time zone.

    Args:
      other: The time zone to compare to.

    Returns:
      True if the time zones are equal, False otherwise.
    """
    return self.secondsFromGMT == other.secondsFromGMT  and self.identifier == other.identifier

  fn __ne__(self, other: TimeZone) -> Bool:
    """
    Compares the time zone to another time zone.

    Args:
      other: The time zone to compare to.

    Returns:
      True if the time zones are not equal, False otherwise.
    """
    return self.secondsFromGMT != other.secondsFromGMT or self.identifier != other.identifier

  @staticmethod
  fn local() -> TimeZone:
    """
    Returns the local time zone.

    Returns:
      The local time zone.
    """
    return TimeZone(0, "local")

  @staticmethod
  fn utc() -> TimeZone:
    """
    Returns the UTC time zone.

    Returns:
      The UTC time zone.
    """
    return _UTC