from .datetime_utils.ffi import _clock_gettime
from .datetime_utils.time import epoch_to_datetime
from .core.datetime import DateTime

fn utc_now() -> DateTime:
    """Returns the current UTC time."""
    return epoch_to_datetime(time().to_int())

fn time() -> Int64:
    """Returns the number of seconds since the epoch in utc."""
    let ts = _clock_gettime().sec
    return ts

fn time_ns() -> Int64:
    """Returns the number of nanoseconds since the epoch."""
    let time_struct = _clock_gettime()

    return time_struct.sec * 1_000_000_000 + time_struct.nsec
