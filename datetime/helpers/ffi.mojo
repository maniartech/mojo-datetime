from memory.unsafe import Pointer

alias _CLOCK_REALTIME = 0

@value
struct _CTimeSpec:
    var sec: Int64
    var nsec: Int64

@always_inline
fn _clock_gettime() -> _CTimeSpec:
    """Low-level call to the clock_gettime libc function."""

    var ts = _CTimeSpec(0, 0)
    let ts_pointer = Pointer[_CTimeSpec].address_of(ts)

    let clockid_si32: Int32 = _CLOCK_REALTIME

    external_call["clock_gettime", NoneType, Int32, Pointer[_CTimeSpec]](
        clockid_si32, ts_pointer
    )

    return ts

@always_inline
fn _get_time_of_day() -> _CTimeSpec:
    var tspec = _CTimeSpec(0, 0)
    let p_tspec = Pointer[_CTimeSpec].address_of(tspec)
    external_call["gettimeofday", NoneType, Pointer[_CTimeSpec], Int32](p_tspec, 0)
    return tspec

@value
@register_passable("trivial")
struct _CTM:
    var tm_sec: Int32
    var tm_min: Int32
    var tm_hour: Int32
    var tm_mday: Int32
    var tm_mon: Int32
    var tm_year: Int32
    var tm_wday: Int32
    var tm_yday: Int32
    var tm_isdst: Int32
    var tm_gmtoff: Int64

    fn __init__() -> Self:
        return Self {
            tm_sec: 0,
            tm_min: 0,
            tm_hour: 0,
            tm_mday: 0,
            tm_mon: 0,
            tm_year: 0,
            tm_wday: 0,
            tm_yday: 0,
            tm_isdst: 0,
            tm_gmtoff: 0,
        }

@always_inline
fn local_time(owned tv_sec: Int) -> _CTM:
  """Low-level call to the localtime libc function."""

  let p_tv_sec = Pointer[Int].address_of(tv_sec)
  let tm = external_call["localtime", Pointer[_CTM], Pointer[Int]](p_tv_sec).load()
  return tm

@always_inline
fn gm_time(owned tv_sec: Int) -> _CTM:
  """Low-level call to the gmtime libc function."""

  let p_tv_sec = Pointer[Int].address_of(tv_sec)
  let tm = external_call["gmtime", Pointer[_CTM], Pointer[Int]](p_tv_sec).load()
  return tm

@always_inline
fn now() -> _CTM:
  var t = _get_time_of_day().sec
  return local_time(t.to_int())

@always_inline
fn gm_now() -> _CTM:
  var t = _get_time_of_day().sec
  return gm_time(t.to_int())

fn main():
  print("time of day >>>", _get_time_of_day().sec, _get_time_of_day().nsec)
  print("clock get time >>>", _clock_gettime().sec, _clock_gettime().nsec)
  let tm = now()
  print("local time >>>",
    tm.tm_year + 1900,
    tm.tm_mon + 1,
    tm.tm_mday,
    tm.tm_hour,
    tm.tm_min,
    tm.tm_sec,
    tm.tm_wday,
  )
