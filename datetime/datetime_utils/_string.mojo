
fn __(s: String) -> String:
  """
  Shortcut for ensuring a string is at least 2 characters long.
  If the string is less than 2 characters long, a "0" is prepended to the string.

  This is useful for ensuring that a valid time component is added to a string.
  """
  if s.__len__() < 2:
    return "0" + s
  else:
    return s
