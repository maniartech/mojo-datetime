# Mojo DateTime - Work In Progress

`mojo-datetime` is a library for working with date, time, and timezone information in Mojo programming language.

## Example

```py
from datetime import utc_now, Duration

let now = utc_now()
print("Current time in UTC", now) # Current time in UTC 2021-08-15T12:00:00Z

let local_time = now.add(Duration.hours(5.5))
print("Current time in IST", local_time) # Current time in IST 2021-08-15T17:30:00Z

let tomorrow = now.add(Duration.days(1))
print("Tomorrow in UTC", tomorrow) # Tomorrow in UTC 2021-08-16T12:00:00Z
```
