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

    private def zero_time : Time
      location = Time::Location.load("Europe/Moscow")
      Time.local(1, 1, 1, 0, 0, location: location)
    end

    def remaining_time(on_time : Time) : Time::Span
      planned = get_planned zero_time, on_time
      worked = get_worked zero_time, on_time
      planned - worked
    end

    def date_status(date : Time) : Time::Span
      planned = get_planned date.at_beginning_of_day, date.at_end_of_day
      worked = get_worked date.at_beginning_of_day, date
      planned - worked
    end
  end
end
