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

    def in_range(from_time : Time, to_time : Time) : Time::Span
      if @date >= from_time && @date < to_time
        Time::Span.new(hours: @hours, minutes: 0, seconds: 0)
      else
        Time::Span.zero
      end
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

    def in_range(from_time : Time, to_time : Time) : Time::Span
      if finished?
        in_range_finished from_time, to_time
      else
        in_range_not_finished from_time, to_time
      end
    end

    private def in_range_finished(from_time : Time, to_time : Time) : Time::Span
      if @start <= to_time && finish! >= from_time
        normalized_start = Math.max(@start, from_time)
        normalized_finish = Math.min(finish!, to_time)
        normalized_finish - normalized_start
      else
        Time::Span.zero
      end
    end

    private def in_range_not_finished(from_time : Time, to_time : Time) : Time::Span
      if @start <= to_time
        normalized_start = Math.max(@start, from_time)
        to_time - normalized_start
      else
        Time::Span.zero
      end
    end
  end
end
