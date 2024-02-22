from datetime import utc_now, Duration


fn main():
  let now = utc_now()
  print("Current time in UTC", now.toRfc3339())

  let local_time = now.add(Duration.hours(5.5))
  print("Current time in IST", local_time.toRfc3339())

  let tomorrow = now.add(Duration.days(1))
  print("Tomorrow in UTC", tomorrow.toRfc3339())