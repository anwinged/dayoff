module Dayoff
  struct ProfileId
    def initialize(@id : String)
    end

    getter id

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

    def get_planned_hours(on_time : Time) : Time::Span
      check_date = on_time.at_beginning_of_day
      @pdates.reduce(Time::Span.zero) do |acc, wd|
        if wd.date_time <= check_date
          acc + wd.time_span
        else
          acc
        end
      end
    end

    def get_work_hours(on_time : Time) : Time::Span
      @wrecords.reduce(Time::Span.zero) do |acc, wr|
        acc + wr.calc_span on_time
      end
    end

    def start(time : Time) : Nil
      @wrecords.each do |wr|
        if time <= wr.start_time || time <= wr.finish_time
          raise CrossedTimeSpan.new
        end
      end
      new_record = WorkRecord.new time
      @wrecords.push(new_record)
      @storage.set_work_records @wrecords
    end

    def finish(time : Time) : Nil
      started = @wrecords.find { |x| x.started? }
      if started.nil?
        raise StartedRecordNotFound.new
      end
      started.finish_time = time
      @storage.set_work_records @wrecords
    end

    def remaining_time(on_time : Time) : Time::Span
      planned = get_planned_hours on_time
      worked = get_work_hours on_time
      planned - worked
    end
  end
end
