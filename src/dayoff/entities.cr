require "json"

module Dayoff
  class PlannedDate
    JSON.mapping(
      date: String,
      hours: Int32,
    )
  end

  class WorkRecord
    JSON.mapping(
      start: String,
      finish: String | Nil,
    )

    FORMAT = "%Y-%m-%d %H:%M:%S"

    def initialize(start : Time, finish : Time | Nil = nil)
      @start = start.to_s FORMAT
      @finish = nil
      if finish
        @finish = finish.to_s FORMAT
      end
    end

    def start_time : Time
      location = Time::Location.load("Europe/Moscow")
      Time.parse(start, FORMAT, location)
    end

    def finish_time : Time
      location = Time::Location.load("Europe/Moscow")
      Time.parse(finish.as(String), FORMAT, location)
    end

    def finish_time=(v : Time)
      @finish = v.to_s FORMAT
    end

    def started? : Bool
      @finish.nil?
    end
  end
end
