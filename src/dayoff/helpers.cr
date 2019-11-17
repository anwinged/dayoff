module Dayoff::Helpers
  extend self

  def zero_time : Time
    location = Time::Location.load("Europe/Moscow")
    Time.local(1, 1, 1, 0, 0, location: location)
  end

  def crossed?(s1 : Time, f1 : Time, s2 : Time, f2 : Time) : Bool
    s1 <= f2 && f1 >= s2
  end
end
