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

    def get_planned_hours
      sum = 0
      @pdates.each do |wd|
        sum += wd.hours
      end
      sum
    end

    def get_work_hours
      @wrecords.reduce 0 do |acc, wr|
        diff = wr.finish_time - wr.start_time
        acc + diff.total_hours.to_i32
      end
    end

    def start(time : Time)
      @wrecords.each do |wr|
        if time <= wr.start_time || time <= wr.finish_time
          raise CrossedTimeSpan.new
        end
      end
      new_record = WorkRecord.new time
      @wrecords.push(new_record)
      @storage.set_work_records @wrecords
    end

    def finish(time : Time)
      started = @wrecords.find { |x| x.started? }
      if started.nil?
        raise StartedRecordNotFound.new
      end
      started.finish_time = time
      @storage.set_work_records @wrecords
    end
  end
end
