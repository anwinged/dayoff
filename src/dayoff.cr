require "json"

module Dayoff
  VERSION = "0.1.0"

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

  abstract class Storage
    abstract def get_planned_dates : Array(PlannedDate)
    abstract def set_planned_dates(items : Array(PlannedDate))
    abstract def get_work_records : Array(WorkRecord)
    abstract def set_work_records(items : Array(WorkRecord))
  end

  class MemoryStorage < Storage
    @planned_dates = [] of PlannedDate
    @work_records = [] of WorkRecord

    def get_planned_dates : Array(PlannedDate)
      @planned_dates
    end

    def set_planned_dates(items : Array(PlannedDate))
      @planned_dates = items
    end

    def get_work_records : Array(WorkRecord)
      @work_records
    end

    def set_work_records(items : Array(WorkRecord))
      @work_records = items
    end
  end

  class Collection(T)
    def initialize(@path : String)
    end

    def get_all : Array(T)
      if File.file? @path
        content = File.read @path
        Array(T).from_json(content)
      else
        [] of T
      end
    end

    def write(items : Array(T))
      content = items.to_pretty_json indent: " "
      File.write @path, content
    end
  end

  class CrossedTimeSpan < Exception
  end

  class StartedRecordNotFound < Exception
  end

  struct ProfileId
    def initialize(@id : String)
    end

    getter id

    def to_s : String
      @id
    end
  end

  class Profile
    PLANNED_DATES = "planned-dates.json"
    WORK_RECORDS  = "work-records.json"

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

  class App
    def profile(profile_id : ProfileId)
      Profile.new(profile_id.to_s)
    end
  end
end
