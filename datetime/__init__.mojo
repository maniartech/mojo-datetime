from .datetime_utils.ffi import _clock_gettime

from .core.datetime import DateTime
from .core.timezone import TimeZone, _UTC
from .core.duration import Duration



fn utc_now() -> DateTime:
    """
    Returns the `DateTime` object representing the current time in UTC.
    """
    return DateTime(time(), _UTC)

fn time() -> Int64:
    """
    Returns the number of seconds since the epoch in utc.

    Despite the time() function returning an Int64, it is returned as a SIMD[si64, 1].
    Hence, the consumer of this function should convert it to Int64 using the `to_int` method.
    """
    # Despite the time() function returning an Int64, it is returned as a SIMD[si64, 1]
    let epoch_sec:Int64 = _clock_gettime().sec.to_int()
    return epoch_sec

fn time_ns() -> Int64:
    """
    Returns the number of nanoseconds since the epoch.

    Despite the time_ns() function returning an Int64, it is returned as a SIMD[si64, 1].
    Hence, the consumer of this function should convert it to Int64 using the `to_int` method.
    """
    let time_struct = _clock_gettime()

    # Despite the time_ns() function returning an Int64, it is returned as a SIMD[si64, 1]
    let epoch_ns:Int64 = time_struct.sec * 1_000_000_000 + time_struct.nsec
    return epoch_ns
