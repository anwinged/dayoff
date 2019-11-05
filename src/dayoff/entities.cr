require "json"

module Dayoff
  # Fix for timezone
  struct Time::Format
    def from_json(pull : JSON::PullParser)
      string = pull.read_string
      parse(string)
    end
  end

  class PlannedDate
    FORMAT = "%Y-%m-%d"

    JSON.mapping(
      date: {
        type:      Time,
        converter: Time::Format.new(FORMAT, Time::Location.load("Europe/Moscow")),
      },
      hours: Int32,
    )

    def initialize(@date : Time, @hours : Int32)
    end

    def time_span : Time::Span
      Time::Span.new(hours: hours, minutes: 0, seconds: 0)
    end
  end

  class WorkRecord
    FORMAT = "%Y-%m-%d %H:%M:%S"

    JSON.mapping(
      start: {
        type:      Time,
        converter: Time::Format.new(FORMAT, Time::Location.load("Europe/Moscow")),
      },
      finish: {
        type:      Time | Nil,
        converter: Time::Format.new(FORMAT, Time::Location.load("Europe/Moscow")),
      }
    )

    def initialize(@start : Time, @finish : Time | Nil = nil)
    end

    def finish! : Time
      @finish.as(Time)
    end

    def started? : Bool
      @finish.nil?
    end

    def finished? : Bool
      !@finish.nil?
    end

    def finished_to_time?(time : Time) : Bool
      @finish && @finish <= time
    end

    def calc_span(time : Time) : Time::Span
      if @finish.nil?
        if @start <= time
          time - @start
        else
          Time::Span.zero
        end
      else
        if time > finish!
          finish! - @start
        elsif time > @start
          time - @start
        else
          Time::Span.zero
        end
      end
    end
  end
end
