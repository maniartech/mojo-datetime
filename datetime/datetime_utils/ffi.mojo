# Reference: https://github.com/gabrieldemarmiesse/mojo-stdlib-extensions/
from memory.unsafe import Pointer

alias _CLOCK_REALTIME = 0

@value
struct _CTimeSpec:
    var sec: Int64
    var nsec: Int64

fn _clock_gettime() -> _CTimeSpec:
    """Low-level call to the clock_gettime libc function."""

    var ts = _CTimeSpec(0, 0)
    let ts_pointer = Pointer[_CTimeSpec].address_of(ts)

    let clockid_si32: Int32 = _CLOCK_REALTIME

    external_call["clock_gettime", NoneType, Int32, Pointer[_CTimeSpec]](
        clockid_si32, ts_pointer
    )

    return ts

fn local_time() raises:
  """Low-level call to the localtime_r libc function."""
  raise Error("local time is not implemented yet")
