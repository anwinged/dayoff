module Dayoff
  struct ProfileId
    def initialize(@id : String)
    end

    def empty? : Bool
      @id.empty?
    end

    def to_s : String
      @id
    end
  end

  class DayStatRecord
    getter date
    getter planned
    getter worked

    def initialize(@date : Time, @planned : Time::Span, @worked : Time::Span)
    end

    def add_planned(v : Time::Span)
      @planned += v
    end

    def add_worked(v : Time::Span)
      @worked += v
    end
  end

  class Profile
    @pdates = [] of PlannedDate
    @wrecords = [] of WorkRecord

    def initialize(@storage : Storage)
      @pdates = @storage.get_planned_dates
      @wrecords = @storage.get_work_records
    end

    private def started_point
      @wrecords.find { |x| x.started? }
    end

    def started? : Bool
      !started_point.nil?
    end

    def start(time : Time) : Nil
      if started?
        raise AlreadyStarted.new
      end
      @wrecords.each do |wr|
        if time <= wr.start || time <= wr.finish!
          raise CrossedTimeSpan.new
        end
      end
      new_record = WorkRecord.new time
      @wrecords.push(new_record)
      @storage.set_work_records @wrecords
    end

    def finish(time : Time) : Nil
      started = started_point
      if started.nil?
        raise StartedRecordNotFound.new
      end
      started.finish = time
      @storage.set_work_records @wrecords
    end

    def get_planned(from_time : Time, to_time : Time) : Time::Span
      @pdates.reduce(Time::Span.zero) do |acc, pd|
        acc + pd.in_range(from_time, to_time)
      end
    end

    def get_worked(from_time : Time, to_time : Time) : Time::Span
      @wrecords.reduce(Time::Span.zero) do |acc, wr|
        acc + wr.in_range(from_time, to_time)
      end
    end

    def total_status(on_time : Time) : Time::Span
      planned = get_planned Helpers.zero_time, on_time
      worked = get_worked Helpers.zero_time, on_time
      planned - worked
    end

    def date_status(on_time : Time) : Time::Span
      planned = get_planned on_time.at_beginning_of_day, on_time.at_end_of_day
      worked = get_worked on_time.at_beginning_of_day, on_time
      planned - worked
    end

    def statistics(on_time : Time) : Array(DayStatRecord)
      dates = {} of String => DayStatRecord

      @pdates.each do |pd|
        key = pd.date.to_s("%Y-%m-%d")
        dates[key] = DayStatRecord.new(
          pd.date,
          pd.hours_as_span,
          Time::Span.zero
        )
      end

      @wrecords.each do |wr|
        key = wr.start.to_s("%Y-%m-%d")
        if dates.has_key? key
          dates[key].add_worked wr.in_range(Helpers.zero_time, on_time)
        else
          dates[key] = DayStatRecord.new(
            wr.start,
            Time::Span.zero,
            wr.in_range(Helpers.zero_time, on_time)
          )
        end
      end

      date_keys = dates.keys.sort!.reverse!

      result = [] of DayStatRecord
      date_keys.each do |k|
        result.push dates[k]
      end

      result
    end
  end
end
