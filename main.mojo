from datetime import utc_now


fn main():
  print("Current time in UTC", utc_now().toRfc3339())