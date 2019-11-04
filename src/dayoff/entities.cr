require "json"

module Dayoff
  class PlannedDate
    JSON.mapping(
      date: String,
      hours: Int32,
    )

    FORMAT = "%Y-%m-%d"

    def initialize(date : Time, hours : Int32)
      @date = date.to_s FORMAT
      @hours = hours
    end

    def date_time : Time
      location = Time::Location.load("Europe/Moscow")
      Time.parse(@date, FORMAT, location)
    end

    def time_span : Time::Span
      Time::Span.new(hours: hours, minutes: 0, seconds: 0)
    end
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
      Time.parse(@start, FORMAT, location)
    end

    def finish_time : Time
      location = Time::Location.load("Europe/Moscow")
      Time.parse(@finish.as(String), FORMAT, location)
    end

    def finish_time=(v : Time)
      @finish = v.to_s FORMAT
    end

    def started? : Bool
      @finish.nil?
    end

    def finished? : Bool
      !@finish.nil?
    end

    def finished_to_time?(time : Time) : Bool
      @finish && finish_time <= time
    end

    def calc_span(time : Time) : Time::Span
      if @finish.nil?
        if start_time <= time
          time - start_time
        else
          Time::Span.zero
        end
      else
        if time > finish_time
          finish_time - start_time
        elsif time > start_time
          time - start_time
        else
          Time::Span.zero
        end
      end
    end
  end
end
