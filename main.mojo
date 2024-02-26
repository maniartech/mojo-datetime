from datetime import utc_now, Duration, DateTime, TimeZone
from datetime.datetime_utils.time import to_epoch


fn main():
  let now = utc_now()
  print("Current time in UTC", now)

  let local_time = now.add(Duration.hours(5.5))
  print("Current time in IST", local_time)

  let tomorrow = now.add(Duration.days(1) + 132)
  print("Tomorrow in UTC", tomorrow)

  print("Difference between tomorrow and now", now - tomorrow)

  let epoch:Int64 = to_epoch(2024, 5, 30, 13, 30, 45)
  print("Epoch time for 2024-05-30T13:30:45", epoch)

  print("Current time in UTC", DateTime(epoch.to_int(), TimeZone.utc()))
